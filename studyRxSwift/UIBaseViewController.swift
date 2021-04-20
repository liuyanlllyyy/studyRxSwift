//
//  UIBaseViewController.swift
//  studyRxSwift
//
//  Created by 刘衍 on 2021/4/20.
//

import UIKit
import RxSwift
import RxCocoa

//基础 base 类  继承了 弹框跟其他事件
class UIBaseViewController: UIViewController {
    struct NameModel {
        
        let name: String?
    }
    
    let disposeBag = DisposeBag();
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   public func showMsgbox(_message: String, _title: String = "提示"){
            
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
            let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
            
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
