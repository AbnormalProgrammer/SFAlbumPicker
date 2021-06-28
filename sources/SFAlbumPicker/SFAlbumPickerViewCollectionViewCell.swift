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
    
    override var isSelected: Bool {
        set {
            super.isSelected = newValue
            if newValue == true {
                let selectedImage:UIImage? = UIImage.init(systemName: "checkmark.circle",withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 30))? .withTintColor(.systemBlue)
                self.selectButton.setImage(selectedImage, for: .normal)
            } else {
                let deselectedImage:UIImage? = UIImage.init(systemName: "circle",withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 30))?.withTintColor(UIColor.systemBlue)
                self.selectButton.setImage(deselectedImage, for: .normal)
            }
        }
        get {
            return super.isSelected
        }
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

        NSLayoutConstraint.init(item: self.selectButton, attribute: .width, relatedBy: .equal, toItem: self.selectButton, attribute: .height, multiplier: 1, constant:0).isActive = true
        NSLayoutConstraint.init(item: self.selectButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 40).isActive = true
        NSLayoutConstraint.init(item: self.selectButton, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.selectButton, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    }
    // MARK: - public interfaces
    // MARK: - actions
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
        let defaultImage:UIImage? = UIImage.init(systemName: "circle",withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 30))?.withTintColor(UIColor.systemBlue)
        result.setImage(defaultImage, for: .normal)
        result.isUserInteractionEnabled = false
        result.contentMode = .scaleToFill
        result.adjustsImageWhenHighlighted = false
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
