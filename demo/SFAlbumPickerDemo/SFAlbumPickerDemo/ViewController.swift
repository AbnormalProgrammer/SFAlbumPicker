//
//  ViewController.swift
//  SFAlbumPickerDemo
//
//  Created by Stroman on 2021/6/21.
//

import UIKit
import Photos

class ViewController: UIViewController,SFAlbumPickerViewControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        self.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(popPickerAction)))
        // Do any additional setup after loading the view.
    }
    
    @objc private func popPickerAction() -> Void {
        let pickerController:SFAlbumPickerViewController = SFAlbumPickerViewController.create()
        pickerController.pickerDelegate = self
        pickerController.modalPresentationStyle = .fullScreen
        self.present(pickerController, animated: true) {
        }
    }
    
    func SFAlbumPickerViewControllerFailureCallback(_ controller: SFAlbumPickerRootViewController?, _ type: SFAlbumPickerErrorType) {
        print(type)
    }
    
    func SFAlbumPickerViewControllerCallbackAsset(_ controller: SFAlbumPickerRootViewController, _ asset: PHAsset) {
        print(asset)
    }
}

