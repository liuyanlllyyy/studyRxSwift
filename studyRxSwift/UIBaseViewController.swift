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
    public func getSinglePlayList(_ channel:String) ->Single<[String:Any]>{
        return Single<[String: Any]>.create {  singleSpecial in
            let url = "https://douban.fm/j/mine/playlist?"
                + "type=n&channel=\(channel)&from=mainsite"
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                if let error = error {
                    print("error*************" )
                    singleSpecial(.failure(error))
                    return
                }
                
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data,
                                                                 options: .mutableLeaves),
                    let result = json as? [String: Any] else {
                   
                    print("json解析error*************" )
                        return
                }
                
                singleSpecial(.success(result))
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
    }
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
