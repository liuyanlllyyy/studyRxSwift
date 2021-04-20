//
//  EasyViewController.swift
//  studyRxSwift
//
//  Created by 刘衍 on 2021/4/20.
//

import UIKit
 
//最基础的 tableview
class EasyViewController: UIBaseViewController {

    @IBOutlet weak var myTabView: UITableView!

    let easyModelList = EasyListModel();
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTabView.register(UITableViewCell.self,forCellReuseIdentifier: "myCell")
        //tableView   delegate & dataSource的赋值直接免去 可以直接 rx.items绑定事件   有modelSelected还有itemSelected事件 
        easyModelList.data
            .bind(to: myTabView.rx.items(cellIdentifier: "myCell")) { _,model,cell in
                cell.textLabel?.text = model.name
                cell.detailTextLabel?.text = String(model.age)
            }.disposed(by: disposeBag)
        //数据的点击事件
        myTabView.rx.modelSelected(Person.self).subscribe(onNext: { people in
            print("选择了\(people)")
//            self.showMsgbox(_message: people.name)
        }).disposed(by: disposeBag)
       // tableView点击事件
        myTabView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("选择了\(indexPath.row)行")
            self.showMsgbox(_message: String(indexPath.row))
           
             
            
        }).disposed(by: disposeBag)
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
