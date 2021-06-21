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
        self.loadAllPhotos()
    }
    
    /*
     加载相册中所有的照片资源
     */
    private func loadAllPhotos() -> Void {
        DispatchQueue.global().async {
            let fetchOption:PHFetchOptions = PHFetchOptions.init()
            fetchOption.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
            fetchOption.fetchLimit = .zero
            let result:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .smartAlbumUserLibrary, options: nil)
            result.enumerateObjects(options: .concurrent) { (asserts, index, stop) in
                let assetResult:PHFetchResult = PHAsset.fetchAssets(in: asserts, options: fetchOption)
                for index in 0..<assetResult.count {
                    self.mediaModels.append(SFAlbumPickerViewMediaModel.init(assetResult[index]))
                }
            }
            let requestOption:PHImageRequestOptions = PHImageRequestOptions.init()
            requestOption.deliveryMode = .fastFormat
            requestOption.isSynchronous = true
            requestOption.resizeMode = .fast
            requestOption.isNetworkAccessAllowed = false
            for iterator in self.mediaModels {
                PHCachingImageManager.default().requestImage(for: iterator.asset!, targetSize: CGSize.init(width: self.itemWidth, height: self.itemWidth), contentMode: .aspectFit, options: requestOption) { image, dictionary in
                    iterator.thumbnailImage = image
                }
            }
            guard self.loadCompleteClosure != nil else {
                return
            }
            self.loadCompleteClosure!()
        }
    }
    // MARK: - public interfaces
    // MARK: - actions
    // MARK: - accessors
    internal var loadCompleteClosure:(() -> Void)?
    internal let cellIdentifier:String = "LPLibraryViewCollectionViewCell"
    internal var itemWidth:CGFloat {
        get {
            return UIScreen.main.bounds.width / 4
        }
    }
    internal var mediaModels:[SFAlbumPickerViewMediaModel] = [SFAlbumPickerViewMediaModel].init()
    // MARK: - delegates
}
