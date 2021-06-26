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
    func SFAlbumPickerViewModelShouldRefetch(_ viewModel:SFAlbumPickerViewModel) -> Void
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
            let fetchOptions:PHFetchOptions = PHFetchOptions.init()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            let fetchResult:PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: fetchOptions)
            self.currentFetchResult = fetchResult
            var assets:[PHAsset] = [PHAsset].init()
            fetchResult.enumerateObjects { (asset, index, stop) in
                assets.append(asset)
            }
            let requestOption:PHImageRequestOptions = PHImageRequestOptions.init()
            requestOption.deliveryMode = .highQualityFormat
            requestOption.isSynchronous = true
            requestOption.resizeMode = .fast
            requestOption.isNetworkAccessAllowed = false
            self.mediaModels = []
            for iterator in assets {
                PHCachingImageManager.default().requestImage(for: iterator, targetSize: CGSize.init(width: self.itemWidth, height: self.itemWidth), contentMode: .aspectFit, options: requestOption) { (image, info) in
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
    // MARK: - actions
    // MARK: - accessors
    weak internal var delegate:SFAlbumPickerViewModelProtocol?
    
    private var currentFetchResult:PHFetchResult<PHAsset>?
    
    internal let cellIdentifier:String = "LPLibraryViewCollectionViewCell"
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
        self.delegate?.SFAlbumPickerViewModelShouldRefetch(self)
    }
}
