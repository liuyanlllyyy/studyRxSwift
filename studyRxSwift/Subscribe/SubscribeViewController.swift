//
//  SubscribeViewController.swift
//  studyRxSwift
//
//  Created by 刘衍 on 2021/4/21.
//

import UIKit
import RxCocoa
import RxSwift
class SubscribeViewController: UIBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let ob = Observable.of("first","second","thrid");
       _ = ob.subscribe { event in
        print(event.element ?? "default")
        }
        // 可以通过不同的block回调处理不同类型的event事件 event里的参数打印出来
       _ = ob.subscribe { (event) in
            print(event)
        self.showMsgbox(_message: event)
        } onError: { (error) in
            print(error)
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("Disposed")
        }


        // Do any additional setup after loading the view.
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
