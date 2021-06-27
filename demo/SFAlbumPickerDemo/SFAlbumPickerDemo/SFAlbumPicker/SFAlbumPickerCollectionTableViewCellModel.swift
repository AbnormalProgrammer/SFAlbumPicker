//
//  SFAlbumPickerCollectionTableViewCellModel.swift
//  SFAlbumPickerDemo
//
//  Created by Stroman on 2021/6/27.
//

import UIKit
import Photos

class SFAlbumPickerCollectionTableViewCellModel: NSObject {
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
    // MARK: - public interfaces
    // MARK: - actions
    // MARK: - accessors
    internal var thumbnailImage:UIImage = UIImage.init(systemName: "nosign", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 50))!.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    internal var displayName:String?
    internal var assetCount:Int = 0
    weak internal var associatedCollection:PHAssetCollection?
    // MARK: - delegates
}
