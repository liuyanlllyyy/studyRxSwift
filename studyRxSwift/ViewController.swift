//
//  ViewController.swift
//  studyRxSwift
//
//  Created by Yan on 2021/4/15.
//

import UIKit
import RxSwift
import RxCocoa

struct DataModel {
    let className: UIViewController.Type?
    let name: String?
}

struct DataListModel {
    let  data = Observable.just([
        DataModel(className: EasyViewController.self,name: "tableview+MVVM思路"),
        DataModel(className: ObservaleViewController.self,name: "创建Observale被观察者"),
        DataModel(className: SubscribeViewController.self,name: "订阅Subscribe "),
        DataModel(className: SpecialViewController.self,name: "特征序列Observale这些序列都是由普通序列封装 "),
        DataModel(className: SchedulerViewController.self,name: "调度者 - scheduler."),
    ])
    

}
class ViewController: UIViewController {

  

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    let dataList = DataListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        dataList.data
            .bind(to: tableView.rx.items(cellIdentifier:"myCell")) { _, model, cell in
                cell.textLabel?.text = model.name
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(DataModel.self).subscribe({ event in
//            self.present(event.element!.className as! UIViewController, animated: true, completion: {
//            })
           
            let nextClass = event.element?.className
            if let nextClass = nextClass{
                let nextVC = nextClass.init()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }).disposed(by: disposeBag)
    }

}

