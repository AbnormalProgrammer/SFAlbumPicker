//
//  SFAlbumPickerViewController.swift
//  SFAlbumPickerDemo
//
//  Created by Stroman on 2021/6/22.
//

import UIKit

class SFAlbumPickerViewController: UINavigationController {
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(rootViewController: UIViewController) {
        self.rootController = rootViewController as? SFAlbumPickerRootViewController
        super.init(rootViewController: rootViewController)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - custom methods
    private func customInitilizer() -> Void {
        self.view.backgroundColor = UIColor.white
    }
    
    private func installUI() -> Void {
    }
    // MARK: - public interfaces
    internal static func create() -> SFAlbumPickerViewController {
        let rootController:SFAlbumPickerRootViewController = SFAlbumPickerRootViewController.init()
        let controller:SFAlbumPickerViewController = SFAlbumPickerViewController.init(rootViewController: rootController)
        return controller
    }
    // MARK: - actions
    // MARK: - accessors
    weak private var rootController:SFAlbumPickerRootViewController?
    weak internal var pickerDelegate:SFAlbumPickerViewControllerProtocol? {
        set {
            self.rootController?.delegate = newValue
        }
        get {
            return self.rootController?.delegate
        }
    }
    // MARK: - delegates
}
