//
//  ObservaleViewController.swift
//  studyRxSwift
//
//  Created by 刘衍 on 2021/4/20.
//

import UIKit
import RxSwift
import RxCocoa
class ObservaleViewController: UIBaseViewController {
    
    @IBOutlet weak var myTabView: UITableView!
    let  data:[NameModel] =  [
        NameModel(name: "空的序列"),
        NameModel(name: "单个信号序列just"),
        NameModel(name: "用of创建信号序列"),
        NameModel(name: "用from创建信号序列"),
        NameModel(name: "用generate创建信号序列"),
        NameModel(name: "用create创建信号序列"),
       NameModel(name: "用 interval  创建信号序列"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTabView.delegate = self
        myTabView.dataSource = self
       
       
        
        
     

         

      
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

extension ObservaleViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let indentifier = "cell"

        let cell = UITableViewCell(style: .default, reuseIdentifier: indentifier)

        cell.textLabel?.text = data[indexPath.row].name

       
       
                return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //  1.创建个空的序列
              print("********emty********")
              let emtyOb = Observable<Int>.empty()
              _ = emtyOb.subscribe(onNext: { (number) in
                  print("订阅:",number)
              }, onError: { (error) in
                  print("error:",error)
              }, onCompleted: {
                  print("完成回调")
              }, onDisposed: {
                  print("释放回调")
              })
            
        case 1:
            
              //2. 单个信号序列创建 该方法通过传入一个默认值来初始化，构建一个只有一个元素的Observable队列，订阅完信息自动complete
               print("********just********")
               let array = ["just 方法创建信号"," empty方法创建信号"]
               Observable<[String]>.just(array)
                   .subscribe { (event) in
                       print(event)
                   }.disposed(by: disposeBag)

               _ = Observable<[String]>.just(array).subscribe(onNext: { (number) in
                   print("订阅:",number)
               }, onError: { (error) in
                   print("error:",error)
               }, onCompleted: {
                   print("完成回调")
               }) {
                   print("释放回调")
               }
            
        case 2:
          //  3. of() 创建一个新的可观察实例  这个方法可以接受可变数量的参数 （一定是要同类型）
            print("********of********")
            //MARK:  of
            // 多个元素 - 针对序列处理
            Observable<String>.of("第一个字符串","第二个字符串")
                .subscribe { (event) in
                    print(event)
                }.disposed(by: disposeBag)

            // 字典
            Observable<[String: Any]>.of(["name":"of","age":18])
                .subscribe { (event) in
                    print(event)
                }.disposed(by: disposeBag)

            // 数组
            Observable<[String]>.of(["test01","test02"])
                .subscribe { (event) in
                    print(event)
                }.disposed(by: disposeBag)
        case 3:
           // 4. from 将可选序列转换为可观察序列。 从集合中获取序列:数组,集合,set 获取序列 - 有可选项处理 - 更安全
            print("********from********")
            //MARK:  of
            Observable<[String]>.from(optional: ["test01","test02"])
                .subscribe { (string) in
                    print(string)
                }.disposed(by: disposeBag)
        case 4:
            print("********generate********")
            //MARK:  generate  通过运行产生序列元素的状态驱动循环，使用指定的调度程序运行循环，发送观察者消息，从而生成一个可观察序列。
           // 该方法创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的 Observable 序列。
            //  初始值给定 然后判断条件1 再判断条件2 会一直递归下去,直到条件1或者条件2不满足
            // 类似 数组遍历循环
            // -参数一initialState:  初始状态。
            //-参数二 condition：终止生成的条件(返回“false”时)。
            // -参数三 iterate：迭代步骤函数。
            //-参数四 调度器：用来运行生成器循环的调度器，默认：CurrentThreadScheduler.instance。
            // -返回：生成的序列。
 
           
            // 数组遍历
            let arr = ["generate1","generate2","generate3","generate4","generate5","generate6","generate7","generate8","generate9","generate10"]
            Observable.generate(initialState: 0,// 初始值
                condition: { $0 < arr.count}, // 条件1
                iterate: { $0 + 1 })  // 条件2 +2
                .subscribe(onNext: {
                    print("遍历arr:",arr[$0])
                })
                .disposed(by: disposeBag)
        case 5:
            //create() 该方法接受一个 闭包形式的参数，任务是对每一个过来的订阅进行处理。
            let observable = Observable<String>.create{observer in
                //对订阅者发出了.next事件，且携带了一个数据"net 数据"
                observer.onNext("net 数据")
                //对订阅者发出了.completed事件
                observer.onCompleted()
                //因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要returen一个Disposable
                return Disposables.create()
            }
             
            //订阅测试
           _ = observable.subscribe {
                print($0)
            }.disposed(by: disposeBag)
        
        case 6:
          //  interval 返回一个可观察序列，该序列在每个周期之后生成一个值，使用指定的调度程序运行计时器并发送观察者消息。
            print("********interval********")
            //MARK:  interval
            // 定时器
          _ =   Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
                .subscribe { (event) in
                    print(event)
                }
                //.disposed(by: disposeBag)

            

           
        default: break
            //repeatElement 使用指定的调度程序发送观察者消息，生成无限重复给定元素的可观察序列。\
        //error  返回一个以“error”结束的可观察序列。 这个序列平时在开发也比较常见，请求网络失败也会发送失败信号！
        
        /*
            Observable 有哪些？
            • Single
            • Completable
            • Maybe
            • Driver
            • Signal
            • ControlEvent
         **/
        }
    }
}
