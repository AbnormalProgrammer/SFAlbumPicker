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
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let pickerController:SFAlbumPickerViewController = SFAlbumPickerViewController.init()
        pickerController.delegate = self
        pickerController.modalPresentationStyle = .fullScreen
        self.present(pickerController, animated: true) {
        }
    }
    
    func SFAlbumPickerViewControllerFailureCallback(_ controller: SFAlbumPickerViewController?, _ type: SFAlbumPickerErrorType) {
    }
    
    func SFAlbumPickerViewControllerCallbackAsset(_ controller: SFAlbumPickerViewController, _ asset: PHAsset) {
    }
}

