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
    }
    // MARK: - public interfaces
    // MARK: - actions
    // MARK: - accessors
    lazy private var headerImageView:UIImageView = {
        let result:UIImageView = UIImageView.init()
        return result
    }()
    lazy private var nameLabel:UILabel = {
        let result:UILabel = UILabel.init()
        return result
    }()
    // MARK: - delegates
}
