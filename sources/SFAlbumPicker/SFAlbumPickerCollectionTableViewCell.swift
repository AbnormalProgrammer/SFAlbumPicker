//
//  SFAlbumPickerCollectionTableViewCell.swift
//  SFAlbumPickerDemo
//
//  Created by Stroman on 2021/6/26.
//

import UIKit

class SFAlbumPickerCollectionTableViewCell: UITableViewCell {
    // MARK: - lifecycle
    deinit {
        print("\(type(of: self))释放了")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.customInitilizer()
        self.installUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - custom methods
    private func customInitilizer() -> Void {
    }
    
    private func installUI() -> Void {
        self.contentView.addSubview(self.headerImageView)
        self.contentView.addSubview(self.nameLabel)
        
        NSLayoutConstraint.init(item: self.headerImageView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.headerImageView, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.headerImageView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.headerImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 100).isActive = true
        NSLayoutConstraint.init(item: self.nameLabel, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.nameLabel, attribute: .leading, relatedBy: .equal, toItem: self.headerImageView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    }
    // MARK: - public interfaces
    // MARK: - actions
    // MARK: - accessors
    internal var model:SFAlbumPickerCollectionTableViewCellModel? {
        set {
            self.headerImageView.image = newValue?.thumbnailImage
            self.nameLabel.text = newValue?.displayName?.appending("(").appending(String.init(newValue!.assetCount)).appending(")")
        }
        get {
            return nil
        }
    }
    lazy private var headerImageView:UIImageView = {
        let result:UIImageView = UIImageView.init()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.contentMode = .scaleAspectFill
        result.clipsToBounds = true
        return result
    }()
    lazy private var nameLabel:UILabel = {
        let result:UILabel = UILabel.init()
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    // MARK: - delegates
}
