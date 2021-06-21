//
//  LPLibraryViewCollectionViewCell.swift
//  LovelyPet
//
//  Created by Stroman on 2021/6/19.
//

import UIKit

class SFAlbumPickerViewCollectionViewCell: UICollectionViewCell {
    // MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.customInitilizer()
        self.installUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(type(of: self))释放了")
    }
    // MARK: - custom methods
    func customInitilizer() -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func installUI() -> Void {
        self.contentView.addSubview(self.thumbnailImageView)
        self.contentView.addSubview(self.selectButton)
        
        NSLayoutConstraint.init(item: self.thumbnailImageView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.thumbnailImageView, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.thumbnailImageView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.thumbnailImageView, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint.init(item: self.selectButton, attribute: .width, relatedBy: .equal, toItem: self.selectButton, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.selectButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 20).isActive = true
    }
    // MARK: - public interfaces
    // MARK: - actions
    @objc private func sureButtonAction(_ sender:UIButton) -> Void {
        
    }
    // MARK: - accessors
    internal var model:SFAlbumPickerViewMediaModel? {
        set {
            self.thumbnailImageView.image = newValue?.thumbnailImage
        }
        get {
            return nil
        }
    }
    lazy private var selectButton:UIButton = {
        let result:UIButton = UIButton.init(type: .custom)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.setBackgroundImage(UIImage.init(named: "matchsuccess_close"), for: .normal)
        result.contentMode = .scaleToFill
        result.adjustsImageWhenHighlighted = false
        result.addTarget(self, action: #selector(sureButtonAction(_:)), for: UIControl.Event.init(rawValue: UIControl.Event.touchUpInside.rawValue | UIControl.Event.touchUpOutside.rawValue))
        return result
    }()
    lazy private var thumbnailImageView:UIImageView = {
        let result:UIImageView = UIImageView.init()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.contentMode = .scaleAspectFill
        result.clipsToBounds = true
        return result
    }()
    // MARK: - delegates
}
