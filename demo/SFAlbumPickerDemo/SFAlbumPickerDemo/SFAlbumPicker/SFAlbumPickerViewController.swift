//
//  LPLibraryViewController.swift
//  LovelyPet
//
//  Created by Stroman on 2021/6/19.
//

import UIKit

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
    
    // MARK: - custom methods
    private func customInitilizer() -> Void {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = UIColor.white
    }
    
    private func installUI() -> Void {
        self.view.addSubview(self.mediaCollectionView)
        
        NSLayoutConstraint.init(item: self.mediaCollectionView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .topMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.mediaCollectionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.mediaCollectionView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.mediaCollectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1, constant: 0).isActive = true

        self.viewModel.loadCompleteClosure = { [weak self]() in
            DispatchQueue.main.async {
                print("异步结束")
                self?.mediaCollectionView.reloadData()
            }
        }
        print("同步结束")
    }
    // MARK: - public interfaces
    // MARK: - actions
    // MARK: - accessors
    private let viewModel:SFAlbumPickerViewModel = SFAlbumPickerViewModel.init()
    lazy private var mediaCollectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let result:UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        result.backgroundColor = .clear
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
            print("点到了缩略图按钮")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.viewModel.itemWidth, height: self.viewModel.itemWidth)
    }
}
