//
//  SFAlbumPickerExtensions.swift
//  SFAlbumPickerDemo
//
//  Created by Stroman on 2021/6/23.
//

import Foundation
import Photos
import UIKit

extension PHAsset {
    /*
     获取原始图片
     */
    func toOriginalImage() -> UIImage {
        let options:PHImageRequestOptions = PHImageRequestOptions.init()
        options.deliveryMode = .opportunistic
        options.isSynchronous = true
        options.isNetworkAccessAllowed = false
        options.version = .original
        var result:UIImage = UIImage.init()
        PHImageManager.default().requestImageDataAndOrientation(for: self, options: options) { (imageData, dataUTI, orientation, info) in
            guard imageData != nil else {
                return
            }
            result = UIImage.init(data: imageData!) ?? UIImage.init()
        }
        return result
    }
}
