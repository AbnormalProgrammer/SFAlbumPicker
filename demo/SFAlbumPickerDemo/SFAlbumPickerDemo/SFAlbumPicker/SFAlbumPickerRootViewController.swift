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
    func SFAlbumPickerViewControllerFailureCallback(_ controller:SFAlbumPickerViewController,_ type:SFAlbumPickerErrorType) -> Void
    func SFAlbumPickerViewControllerCallbackAsset(_ controller:SFAlbumPickerViewController,_ assets:[PHAsset]) -> Void
    
    /// 是否需要自定义抓取的过程
    /// 调用此方法可实现动态配置是否使用该相册
    /// 如果返回真，相册不会回调任何数据
    /// - Parameter controller: 是否自定义
    func SFAlbumPickerViewControllerShouldCustomFetch(_ controller:SFAlbumPickerViewController) -> Bool
}

/*
 这个地方主要是表现层
 数据的处理不应该发生在这里
 */
class SFAlbumPickerRootViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SFAlbumPickerViewModelProtocol {
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
        self.navigationItem.leftBarButtonItem = self.leftItem
        self.navigationItem.rightBarButtonItem = self.rightItem
        self.viewModel.delegate = self
    }
    
    private func installUI() -> Void {
        self.view.addSubview(self.mediaCollectionView)
        self.view.addSubview(self.noLabel)
        self.navigationController?.view.addSubview(self.loadingControl)
        
        NSLayoutConstraint.init(item: self.mediaCollectionView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .topMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.mediaCollectionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.mediaCollectionView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.mediaCollectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.noLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.noLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

        self.controlLoadProcess()
    }
    
    private func controlLoadProcess() -> Void {
        if self.delegate?.SFAlbumPickerViewControllerShouldCustomFetch(self.navigationController  as! SFAlbumPickerViewController) == false {
            self.viewModel.loadAllPhotos()
        }
    }
    // MARK: - public interfaces
    internal func inputSettings(_ settingClosure:@escaping((SFAlbumPickerViewControllerSettingsModel) -> Void)) -> Void {
        let settingModel:SFAlbumPickerViewControllerSettingsModel = SFAlbumPickerViewControllerSettingsModel.init()
        settingClosure(settingModel)
        if settingModel.maxSelectionNumber != nil {
            self.viewModel.maxSelectionNumber = settingModel.maxSelectionNumber!
        }
    }
    // MARK: - actions
    @objc private func leftItemAction(_ sender:UIBarButtonItem) -> Void {
        self.navigationController?.dismiss(animated: true, completion: {
        })
    }
    
    @objc private func rightItemAction(_ sender:UIBarButtonItem) -> Void {
        self.navigationController?.dismiss(animated: true, completion: {
            let assets:[PHAsset] = self.viewModel.requestSelectedAssets(self.mediaCollectionView.indexPathsForSelectedItems ?? [])
            self.delegate?.SFAlbumPickerViewControllerCallbackAsset(self.navigationController  as! SFAlbumPickerViewController, assets)
        })
    }
    // MARK: - accessors
    internal var delegate:SFAlbumPickerViewControllerProtocol?
    private let viewModel:SFAlbumPickerViewModel = SFAlbumPickerViewModel.init()
    lazy private var mediaCollectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = self.viewModel.itemGap
        layout.minimumLineSpacing = self.viewModel.itemGap
        let result:UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        result.backgroundColor = self.viewModel.pickerBackgroundColor
        result.translatesAutoresizingMaskIntoConstraints = false
        result.delegate = self
        result.dataSource = self
        result.allowsMultipleSelection = true
        result.register(SFAlbumPickerViewCollectionViewCell.self, forCellWithReuseIdentifier: self.viewModel.cellIdentifier)
        return result
    }()
    lazy private var leftItem:UIBarButtonItem = {
        let result:UIBarButtonItem = UIBarButtonItem.init(systemItem: .cancel)
        result.style = .plain
        result.target = self
        result.action = #selector(leftItemAction(_:))
        return result
    }()
    lazy private var rightItem:UIBarButtonItem = {
        let result:UIBarButtonItem = UIBarButtonItem.init(systemItem: .done)
        result.style = .plain
        result.target = self
        result.action = #selector(rightItemAction(_:))
        return result
    }()
    lazy private var loadingControl:UIActivityIndicatorView = {
        let result:UIActivityIndicatorView = UIActivityIndicatorView.init()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.color = .systemBlue
        result.hidesWhenStopped = true
        result.style = .large
        result.stopAnimating()
        return result
    }()
    lazy private var noLabel:UILabel = {
        let promotionLabel:UILabel = UILabel.init()
        promotionLabel.translatesAutoresizingMaskIntoConstraints = false
        promotionLabel.font = UIFont.systemFont(ofSize: 30)
        promotionLabel.text = "没有媒体"
        promotionLabel.textColor = .black
        promotionLabel.isHidden = false
        return promotionLabel
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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard self.viewModel.isNoLimit == false else {
            return true
        }
        guard collectionView.indexPathsForSelectedItems != nil else {
            return true
        }
        guard collectionView.indexPathsForSelectedItems!.count < self.viewModel.maxSelectionNumber else {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.viewModel.itemWidth, height: self.viewModel.itemWidth)
    }
    
    func SFAlbumPickerViewModelBeginFetch(_ viewModel: SFAlbumPickerViewModel) {
        self.loadingControl.startAnimating()
    }
    
    func SFAlbumPickerViewModelFinishFetch(_ viewModel: SFAlbumPickerViewModel, _ success: Bool, _ errorType: SFAlbumPickerErrorType) {
        DispatchQueue.main.async {
            if success == true {
                self.mediaCollectionView.reloadData()
            } else {
                self.delegate?.SFAlbumPickerViewControllerFailureCallback(self.navigationController as! SFAlbumPickerViewController, errorType)
            }
            self.noLabel.isHidden = self.viewModel.mediaModels.count != 0
            self.loadingControl.stopAnimating()
        }
    }
    
    func SFAlbumPickerViewModelShouldRefetch(_ viewModel: SFAlbumPickerViewModel) {
        self.controlLoadProcess()
    }
}
