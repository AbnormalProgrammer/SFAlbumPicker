//
//  SFAlbumPickerViewControllerSettingsModel.swift
//  SFAlbumPickerDemo
//
//  Created by Stroman on 2021/6/26.
//

import UIKit

class SFAlbumPickerViewControllerSettingsModel: NSObject {
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
    internal var maxSelectionNumber:Int?
    // MARK: - delegates
}
