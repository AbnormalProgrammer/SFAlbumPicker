# 选图页面（SFAlbumPicker）
这是自制的iOS选图页
## 它是什么？
它就是个demo，是我学习iOS中的Photos框架的结果体现。
## 它有什么用？
这里面记录了使用操作相册的常规方式，以后如果生疏了，可以参考它，以便让自己快速地回忆起来。
## 它的需求背景是什么？
相册的选图页是一种非常常见的需求功能，几乎每个APP都涉及到，最起码注册的时候你需要选择个头像吧。虽然如此，它却很难被组件化，因为对相册操作的需求总有些许不同，每个APP的风格也不同，所以相册的风格也要跟着变。唯一能够被复用的就是它的逻辑了，如果哪位大神完美地提出了复用的解决方案，可以留言。
## 效果
![演示](https://github.com/AbnormalProgrammer/SFAlbumPicker/raw/master/Resources/demo.gif)
## 行为表现
1. 罗列相册APP中的所有数据。
2. 罗列某个相簿的所有数据。
3. 可以不限制数量选择媒体数据。
4. 可以以指定数量选择媒体数据。
5. 在相册数据发生变化时及时刷新UI。
6. 能够返回用户选择的媒体数据。
7. 可以取消本次媒体数据的选取。
8. 对相册操作权限的检查。
## 原理
`PHAssetCollection`继承自`PHCollection`它是相簿的抽象，代表了某个相簿，比如“最近”相簿。<br>
`PHAsset`是媒体数据的抽象，代表了某个具体的媒体数据，比如一张照片，一个视频。<br>
`PHFetchResult`是一个容器类型，专门用于相册检索，它代表的是抓取到的指定类型的媒体数据集。<br>
`PHPhotoLibrary`是相册APP的抽象，通过它可以监听到相册数据的一举一动。<br>
首先通过`PHAssetCollection`去获取所有相簿的数据，放到`PHFetchResult`中，形成一个个相簿列表。然后针对每个相簿，使用`PHAsset`抓取单个相册中的媒体数据，放到另一个`PHFetchResult`中。每次展示某个相簿的数据实际上就是展示该相簿的每个`PHAsset`。每次监听到相簿数据变化就重新抓取该相簿的数据。<br>
像这种选图页iOS自带了一个`PHPickerViewController`可供选择。
## 默认设定
在默认情况下，该demo展示的是整个相册APP中的所有媒体数据。
## 代码展示
```
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
            settingModel.maxSelectionNumber = 2
        }
        pickerController.modalPresentationStyle = .fullScreen
        self.present(pickerController, animated: true) {
        }
    }
    
    func SFAlbumPickerViewControllerCallbackAsset(_ controller: SFAlbumPickerViewController, _ assets: [PHAsset]) {
    }
    
    func SFAlbumPickerViewControllerFailureCallback(_ controller: SFAlbumPickerViewController, _ type: SFAlbumPickerErrorType) {
    }
}
```
## 环境
Swift 5.0<br>
XCode 12<br>
iOS 14<br>
