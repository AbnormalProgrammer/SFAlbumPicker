//
//  LPLibraryViewModel.swift
//  LovelyPet
//
//  Created by Stroman on 2021/6/19.
//

import UIKit
import Photos

protocol SFAlbumPickerViewModelProtocol:NSObjectProtocol {
    func SFAlbumPickerViewModelBeginFetch(_ viewModel:SFAlbumPickerViewModel) -> Void
    func SFAlbumPickerViewModelFinishFetch(_ viewModel:SFAlbumPickerViewModel,_ success:Bool,_ errorType:SFAlbumPickerErrorType) -> Void
    func SFAlbumPickerViewModelRefetch(_ viewModel:SFAlbumPickerViewModel) -> Void
    func SFAlbumPickerViewModelEndFetchCollections(_ viewModel:SFAlbumPickerViewModel,_ success:Bool,_ errorType:SFAlbumPickerErrorType) -> Void
}

/*
 这里面主要用来处理数据和业务逻辑
 不应该有UI参与
 */
class SFAlbumPickerViewModel: NSObject,PHPhotoLibraryChangeObserver {
    // MARK: - lifecycle
    deinit {
        print("\(type(of: self))释放了")
    }
    
    override init() {
        super.init()
        self.customInitilizer()
    }
    // MARK: - custom methods
    private func customInitilizer() -> Void {
        PHPhotoLibrary.shared().register(self)
    }
    
    private func requestAuthorization() -> SFAlbumPickerErrorType {
        var result:SFAlbumPickerErrorType = .NotAuthorized
        let currentStatus:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if currentStatus != .authorized && currentStatus != .limited {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
                if status == .authorized || status == .limited {
                    result = .NoError
                }
            }
        } else {
            result = .NoError
        }
        return result
    }
    // MARK: - public interfaces
    /*
     加载相册中所有的照片资源
     */
    internal func loadAllPhotos() -> Void {
        self.delegate?.SFAlbumPickerViewModelBeginFetch(self)
        let status:SFAlbumPickerErrorType = self.requestAuthorization()
        if status == .NotAuthorized {
            self.delegate?.SFAlbumPickerViewModelFinishFetch(self, true, .NotAuthorized)
            return
        }
        DispatchQueue.global().async {
            let fetchResult:PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: self.fetchOption)
            self.currentFetchResult = fetchResult
            var assets:[PHAsset] = [PHAsset].init()
            fetchResult.enumerateObjects { (asset, index, stop) in
                assets.append(asset)
            }
            self.mediaModels = []
            for iterator in assets {
                PHCachingImageManager.default().requestImage(for: iterator, targetSize: CGSize.init(width: self.itemWidth, height: self.itemWidth), contentMode: .aspectFit, options: self.requestOption) { (image, info) in
                    if image != nil {
                        let newModel:SFAlbumPickerViewMediaModel = SFAlbumPickerViewMediaModel.init()
                        newModel.asset = iterator
                        newModel.thumbnailImage = image
                        self.mediaModels.append(newModel)
                    }
                }
            }
            self.delegate?.SFAlbumPickerViewModelFinishFetch(self, true, .NoError)
        }
    }
    /// 输入从外部输入进来的相册数据
    /// - Parameter assets: 外部数据
    /// - Returns: 空
    internal func inputDataFromOutside(_ assets:[PHAsset]) -> Void {
        self.mediaModels = []
        for iterator in assets {
            PHCachingImageManager.default().requestImage(for: iterator, targetSize: CGSize.init(width: self.itemWidth, height: self.itemWidth), contentMode: .aspectFit, options: self.requestOption) { (image, info) in
                if image != nil {
                    let newModel:SFAlbumPickerViewMediaModel = SFAlbumPickerViewMediaModel.init()
                    newModel.asset = iterator
                    newModel.thumbnailImage = image
                    self.mediaModels.append(newModel)
                }
            }
        }
        self.delegate?.SFAlbumPickerViewModelFinishFetch(self, true, .NoError)
    }
    /// 请求已经选中的数据
    /// - Parameter indexPaths: 选中的索引
    /// - Returns: 相册数据资源
    internal func requestSelectedAssets(_ indexPaths:[IndexPath]) -> [PHAsset] {
        var result:[PHAsset] = []
        for iterator in indexPaths {
            result.append(self.mediaModels[iterator.item].asset!)
        }
        return result
    }
    
    /*
     加载相册APP中的所有相册
     
     */
    internal func loadAllAlbums() -> Void {
        DispatchQueue.global().async {
            self.currentCollectionItems = []
            self.localTableCellModels = []
            let status:SFAlbumPickerErrorType = self.requestAuthorization()
            if status != .NoError {
                self.delegate?.SFAlbumPickerViewModelFinishFetch(self, false, .NotAuthorized)
                return
            }
            let resultCollections:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            resultCollections.enumerateObjects { (someCollection, index, stop) in
                self.currentCollectionItems.append(someCollection)
            }
            /*获取每个相册第一个asset的图像的缩略图*/
            for index in 0..<self.currentCollectionItems.count {
                let thisCollection:PHAssetCollection = self.currentCollectionItems[index]
                let newCellModel:SFAlbumPickerCollectionTableViewCellModel = SFAlbumPickerCollectionTableViewCellModel.init()
                newCellModel.associatedCollection = thisCollection
                newCellModel.displayName = thisCollection.localizedTitle ?? ""
                if thisCollection.canContainAssets == true {
                    var resultAsset:PHAsset?
                    let assets:PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: thisCollection, options: self.fetchOption)
                    newCellModel.assetCount = assets.count
                    assets.enumerateObjects { (asset, index, stop) in
                        if index == 0 {
                            resultAsset = asset
                        } else {
                            stop.pointee = false
                        }
                    }
                    guard resultAsset != nil else {
                        continue
                    }
                    let options:PHImageRequestOptions = PHImageRequestOptions.init()
                    options.deliveryMode = .opportunistic
                    options.isSynchronous = true
                    options.isNetworkAccessAllowed = false
                    options.version = .original
                    PHImageManager.default().requestImage(for: resultAsset!, targetSize: CGSize.init(width: 80, height: 80), contentMode: .aspectFill, options: options) { (image, info) in
                        guard image != nil else {
                            return
                        }
                        newCellModel.thumbnailImage = image!
                    }
                    self.localTableCellModels.append(newCellModel)
                }
            }
            self.delegate?.SFAlbumPickerViewModelEndFetchCollections(self, true, .NoError)
        }
    }
    
    internal func loadSpecificCollection(_ model:SFAlbumPickerCollectionTableViewCellModel) -> Void {
        DispatchQueue.global().async {
            self.mediaModels = []
            let status:SFAlbumPickerErrorType = self.requestAuthorization()
            if status != .NoError {
                self.delegate?.SFAlbumPickerViewModelFinishFetch(self, false, .NotAuthorized)
                return
            }
            let fetchResult:PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: model.associatedCollection!, options: self.fetchOption)
            var assets:[PHAsset] = []
            fetchResult.enumerateObjects { (asset, index, stop) in
                assets.append(asset)
            }
            for iterator in assets {
                PHCachingImageManager.default().requestImage(for: iterator, targetSize: CGSize.init(width: self.itemWidth, height: self.itemWidth), contentMode: .aspectFit, options: self.requestOption) { (image, info) in
                    if image != nil {
                        let newModel:SFAlbumPickerViewMediaModel = SFAlbumPickerViewMediaModel.init()
                        newModel.asset = iterator
                        newModel.thumbnailImage = image
                        self.mediaModels.append(newModel)
                    }
                }
            }
            self.delegate?.SFAlbumPickerViewModelFinishFetch(self, true, .NoError)
        }
    }
    // MARK: - actions
    // MARK: - accessors
    weak internal var delegate:SFAlbumPickerViewModelProtocol?
    
    private var currentFetchResult:PHFetchResult<PHAsset>?
    private var currentCollectionItems:[PHAssetCollection] = []
    private var localTableCellModels:[SFAlbumPickerCollectionTableViewCellModel] = []
    lazy private var fetchOption:PHFetchOptions = {
        let fetchOptions:PHFetchOptions = PHFetchOptions.init()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return fetchOptions
    }()
    lazy private var requestOption:PHImageRequestOptions = {
        let requestOption:PHImageRequestOptions = PHImageRequestOptions.init()
        requestOption.deliveryMode = .highQualityFormat
        requestOption.isSynchronous = true
        requestOption.resizeMode = .fast
        requestOption.isNetworkAccessAllowed = false
        return requestOption
    }()
    
    internal var tableCellModels:[SFAlbumPickerCollectionTableViewCellModel] {
        get {
            return self.localTableCellModels
        }
    }
    internal let itemIdentifier:String = "LPLibraryViewCollectionViewCell"
    internal let ablumCellIdentifier:String = "SFAlbumPickerCollectionTableViewCell"
    internal let ablumCellHeight:CGFloat = 100//相册单元格的高度
    internal var itemGap:CGFloat = 1/*每个展示图片之间的间隔距离*/
    internal var itemNumberOfOneRow:Int = 4/*每行展示的缩略图的个数*/
    internal var pickerBackgroundColor:UIColor = .white/*整个展示页面的背景颜色*/
    internal var maxSelectionNumber:Int = 0/*用户允许选择的最大数目，0代表不限制，其他自然数代表上限*/
    internal var itemWidth:CGFloat {
        get {
            return (UIScreen.main.bounds.width - CGFloat.init(itemNumberOfOneRow - 1) * itemGap) / CGFloat.init(itemNumberOfOneRow)
        }
    }
    internal var isNoLimit:Bool {
        get {
            return self.maxSelectionNumber <= 0
        }
    }/*是否没有限制*/
    internal var mediaModels:[SFAlbumPickerViewMediaModel] = [SFAlbumPickerViewMediaModel].init()
    // MARK: - delegates
    /// 发生了变化就重新fetch
    /// - Parameter changeInstance: 变化的信息
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.delegate?.SFAlbumPickerViewModelRefetch(self)
    }
}
