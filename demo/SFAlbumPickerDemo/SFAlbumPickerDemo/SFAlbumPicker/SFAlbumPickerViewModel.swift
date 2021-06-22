//
//  LPLibraryViewModel.swift
//  LovelyPet
//
//  Created by Stroman on 2021/6/19.
//

import UIKit
import Photos

class SFAlbumPickerViewModel: NSObject {
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
    }
    
    /*
     加载相册中所有的照片资源
     */
    internal func loadAllPhotos() -> Void {
        let status:SFAlbumPickerErrorType = self.requestAuthorization()
        if status == .NotAuthorized {
            self.loadCompleteClosure!(false,status)
            return
        }
        DispatchQueue.global().async {
            let fetchOptions:PHFetchOptions = PHFetchOptions.init()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            let fetchResult:PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: fetchOptions)
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
            guard self.loadCompleteClosure != nil else {
                return
            }
            self.loadCompleteClosure!(true,status)
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
    // MARK: - actions
    // MARK: - accessors
    internal var selectionModelsForMax:[SFAlbumPickerViewMediaModel] = []/*用户设定的能够选择的最大数目*/
    
    internal var loadCompleteClosure:((Bool,SFAlbumPickerErrorType) -> Void)?
    internal let cellIdentifier:String = "LPLibraryViewCollectionViewCell"
    internal var itemGap:CGFloat = 1/*每个展示图片之间的间隔距离*/
    internal var itemNumberOfOneRow:Int = 4/*每行展示的缩略图的个数*/
    internal var pickerBackgroundColor:UIColor = .white/*整个展示页面的背景颜色*/
    internal var backItemTitle:String = "返回"/*返回按钮的标题*/
    internal var maxSelectionNumber:Int = -1/*用户允许选择的最大数目*/
    internal var itemWidth:CGFloat {
        get {
            return (UIScreen.main.bounds.width - CGFloat.init(itemNumberOfOneRow - 1) * itemGap) / CGFloat.init(itemNumberOfOneRow)
        }
    }
    internal var mediaModels:[SFAlbumPickerViewMediaModel] = [SFAlbumPickerViewMediaModel].init()
    // MARK: - delegates
}
