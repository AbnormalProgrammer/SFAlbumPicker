//
//  LPLibraryViewMediaModel.swift
//  LovelyPet
//
//  Created by Stroman on 2021/6/19.
//

import UIKit
import Photos

class SFAlbumPickerViewMediaModel: NSObject {
    // MARK: - lifecycle
    deinit {
        print("\(type(of: self))释放了")
    }
    
    override init() {
        super.init()
        self.customInitilizer()
    }
    
    convenience init(_ asset:PHAsset) {
        self.init()
        self.asset = asset
    }
    // MARK: - custom methods
    private func customInitilizer() -> Void {
    }
    // MARK: - public interfaces
    // MARK: - actions
    // MARK: - accessors
    internal var thumbnailImage:UIImage?
    internal var asset:PHAsset?
    // MARK: - delegates
}
