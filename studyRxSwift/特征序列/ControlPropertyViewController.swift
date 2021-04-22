//
//  ControlPropertyViewController.swift
//  studyRxSwift
//
//  Created by 刘衍 on 2021/4/22.
//

import UIKit
import RxSwift
import RxCocoa
/**
 (1）ControlProperty 是专门用来描述 UI 控件属性，拥有该类型的属性都是被观察者（Observable）。
 （2）ControlProperty 具有以下特征：
 
 不会产生 error 事件
 一定在 MainScheduler 订阅（主线程订阅）
 一定在 MainScheduler 监听（主线程监听）
 共享状态变化
 */
class ControlPropertyViewController: UIBaseViewController {
    
    let myTextField:UITextField = UITextField.init(frame: CGRect(x: 100, y: 100, width: 375, height: 50))
    let myLabel:UILabel = UILabel.init(frame: CGRect(x: 100, y: 200, width: 375, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ControlProperty()
        self.ControlEvent()
        // Do any additional setup after loading the view.
    }
    
    func ControlProperty() {
        /**
            在RxCocoa中，拥有ControlProperty这个属性的控件都是被观察者
            那么我们如果想让一个 textField 里输入内容实时地显示在另一个 label 上，即前者作为被观察者，后者作为观察者。
         */
        myTextField.backgroundColor = .red
        myLabel.backgroundColor = .orange
        self.view.addSubview(myLabel)
        self.view.addSubview(myTextField)
        //将textField输入的文字绑定到label上
        myTextField.rx.text
            .bind(to: myLabel.rx.text)
            .disposed(by: disposeBag)
        myTextField.rx.text.map { passwordString in
            print(passwordString as Any)
            return passwordString?.count ?? 0>4
    } .subscribe{ (event) in
            print(event)
        }.disposed(by: disposeBag)
        
      
        
    }
    func ControlEvent() {
        /**
            同样地，在 RxCocoa 下许多 UI 控件的事件方法都是被观察者（可观察序列）。
            那么我们如果想实现当一个 button 被点击时，在控制台输出一段文字。即前者作为被观察者，后者作为观察者。可以这么写：
         */
        let btn:UIButton = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 30, y: 100, width: 50, height: 50)
        btn.setTitle("点击", for: .normal)
        btn.backgroundColor  = .red
        self.view.addSubview(btn)
        btn.rx.tap
            .subscribe(onNext: {
                print("btn被点击了")
            }).disposed(by: disposeBag)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// 扩展label属性
extension UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self) { label, fontSize in
                label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
