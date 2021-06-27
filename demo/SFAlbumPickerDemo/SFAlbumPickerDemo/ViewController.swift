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
        let promotionLabel:UILabel = UILabel.init()
        promotionLabel.translatesAutoresizingMaskIntoConstraints = false
        promotionLabel.font = UIFont.systemFont(ofSize: 30)
        promotionLabel.text = "点我"
        promotionLabel.textColor = .white
        self.view.addSubview(promotionLabel)
        NSLayoutConstraint.init(item: promotionLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: promotionLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        // Do any additional setup after loading the view.
    }
    
    @objc private func popPickerAction() -> Void {
        let pickerController:SFAlbumPickerViewController = SFAlbumPickerViewController.create()
        pickerController.pickerDelegate = self
        pickerController.inputSettings { (settingModel) in
            settingModel.maxSelectionNumber = 0
        }
        pickerController.modalPresentationStyle = .fullScreen
        self.present(pickerController, animated: true) {
        }
    }
    
    func SFAlbumPickerViewControllerCallbackAsset(_ controller: SFAlbumPickerViewController, _ assets: [PHAsset]) {
    }
    
    func SFAlbumPickerViewControllerFailureCallback(_ controller: SFAlbumPickerViewController, _ type: SFAlbumPickerErrorType) {
    }
    
    func SFAlbumPickerViewControllerShouldCustomFetch(_ controller: SFAlbumPickerViewController) -> Bool {
        return false
    }
    
    func SFAlbumPickerViewControllerInputCustomAssets(_ controller: SFAlbumPickerViewController) -> [PHAsset] {
        return []
    }
}

