//
//  LPLibraryViewController.swift
//  LovelyPet
//
//  Created by Stroman on 2021/6/19.
//

import UIKit
import Photos

internal enum SFAlbumPickerErrorType {
    case NotAuthorized
    case NoError
}

protocol SFAlbumPickerViewControllerProtocol:NSObjectProtocol {
    func SFAlbumPickerViewControllerFailureCallback(_ controller:SFAlbumPickerViewController?,_ type:SFAlbumPickerErrorType) -> Void
    func SFAlbumPickerViewControllerCallbackAsset(_ controller:SFAlbumPickerViewController,_ asset:PHAsset) -> Void
}

class SFAlbumPickerViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInitilizer()
        self.installUI()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("\(type(of: self))释放了")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // MARK: - custom methods
    private func customInitilizer() -> Void {
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func installUI() -> Void {
        self.view.addSubview(self.mediaCollectionView)
        
        NSLayoutConstraint.init(item: self.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: self.view.bounds.width).isActive = true
        NSLayoutConstraint.init(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: self.view.bounds.height).isActive = true
        NSLayoutConstraint.init(item: self.mediaCollectionView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .topMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.mediaCollectionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.mediaCollectionView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.mediaCollectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1, constant: 0).isActive = true

        self.viewModel.loadCompleteClosure = { [weak self](success,errorType) in
            DispatchQueue.main.async {
                if success == true {
                    self?.mediaCollectionView.reloadData()
                } else {
                    self?.delegate?.SFAlbumPickerViewControllerFailureCallback(self, errorType)
                }
            }
        }
        self.viewModel.loadAllPhotos()
    }
    // MARK: - public interfaces
    // MARK: - actions
    // MARK: - accessors
    internal var delegate:SFAlbumPickerViewControllerProtocol?
    private let viewModel:SFAlbumPickerViewModel = SFAlbumPickerViewModel.init()
    lazy private var mediaCollectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let result:UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.delegate = self
        result.dataSource = self
        result.register(SFAlbumPickerViewCollectionViewCell.self, forCellWithReuseIdentifier: self.viewModel.cellIdentifier)
        return result
    }()
    // MARK: - delegates
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let result:SFAlbumPickerViewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.viewModel.cellIdentifier, for: indexPath) as! SFAlbumPickerViewCollectionViewCell
        result.model = self.viewModel.mediaModels[indexPath.item]
        return result
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.mediaModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        default:
            self.delegate?.SFAlbumPickerViewControllerCallbackAsset(self, self.viewModel.mediaModels[indexPath.item].asset!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.viewModel.itemWidth, height: self.viewModel.itemWidth)
    }
}
