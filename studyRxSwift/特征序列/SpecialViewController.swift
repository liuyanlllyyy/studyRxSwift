//
//  SpecialViewController.swift
//  studyRxSwift
//
//  Created by 刘衍 on 2021/4/21.
//
//特征序列
import UIKit
import RxSwift
import RxCocoa
class SpecialViewController: UIBaseViewController {

    @IBOutlet weak var myTabView: UITableView!
    
    let  data:[NameModel] =  [
        NameModel(name: "Single特征序列"),
        NameModel(name: "Observable转换为 Single"),
        NameModel(name: "Completable特征序列"),
        NameModel(name: "Driver特征序列"),
        NameModel(name: "Signal特征序列"),
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        myTabView.delegate = self
        myTabView.dataSource = self
       
        // Do any additional setup after loading the view.
    }
    //将数据缓存到本地
    func cacheLocally() -> Completable {
        return Completable.create { completable in
            //将数据缓存到本地（这里掠过具体的业务代码，随机成功或失败）
            let success = (arc4random() % 2 == 0)
            
            guard success else {
                completable(.error("error"))
                return Disposables.create {}
            }
            
            completable(.completed)
            return Disposables.create {}
        }
    }
    /**
     
     创建 Single 和创建 Observable 非常相似。下面代码我们定义一个用于生成网络请求 Single 的函数
     获取豆瓣某频道下的歌曲信息
     */
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
                    singleSpecial(.failure(DataError.cantParseJSON))
                    print("json解析error*************" )
                        return
                }
                
                singleSpecial(.success(result))
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
    }
}
   
    func single(){
        //获取第0个频道的歌曲信息
//        getSinglePlayList("0")
//            .subscribe { event in
//                switch event {
//                case .success(let json):
//                    print("JSON结果: ", json)
//                case .failure(let error):
//                    print("发生错误: ", error)
//                }
//            }
//            .disposed(by: disposeBag)
        
        //或者直接调取 success 跟 failure  不需要判断 switch
        getSinglePlayList("0")
            .subscribe(onSuccess: { json in
                print("JSON结果: ", json)
            }, onFailure: { error in
                print("发生错误: ", error)
            })
            .disposed(by: disposeBag)
    }
    //与数据相关的错误类型
    enum DataError: Error {
        case cantParseJSON
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
extension SpecialViewController:UITableViewDelegate,UITableViewDataSource{
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
            //        Single 是 Observable 的另外一个版本。但它不像 Observable 可以发出多个元素，它要么只能发出一个元素，要么产生一个 error 事件。
            //       可以对 Observable 调用 .asSingle() 方法，将它转换为 Single。
            //        发出一个元素，或一个 error 事件
            //        不会共享状态变化
            //        使用场景：Single 比较常见的例子就是执行 HTTP 请求，然后返回一个应答或错误。不过我们也可以用 Single 来描述任何只有一个元素的序列。
            //        SingleEvent
            //        为方便使用，RxSwift 还为 Single 订阅提供了一个枚举（SingleEvent）：
            //            .success：里面包含该Single的一个元素值
            //            .error：用于包含错误
              print("********Single********")
            single()
        case 1:
            
              //2. 调用 Observable 序列的.asSingle()方法，将它转换为 Single
               print("********转换为 Single********")
            Observable.of("1")
                .asSingle()
                .subscribe(onSuccess: { json in
                    print("success时候的结果: ", json)
                }, onFailure: { error in
                    print("发生错误: ", error)
                })
                .disposed(by: disposeBag)
            
        case 2:
          //  3. of() 创建一个新的可观察实例  这个方法可以接受可变数量的参数 （一定是要同类型）
            print("********of********")
           
        case 3:
           // 4. from 将可选序列转换为可观察序列。 从集合中获取序列:数组,集合,set 获取序列 - 有可选项处理 - 更安全
            print("********from********")
            //MARK:  of
           
        case 4:
            print("********generate********")
           
        case 5:
            print("********interval********")
            //create() 该方法接受一个 闭包形式的参数，任务是对每一个过来的订阅进行处理。
           
        
        case 6:
          //  interval 返回一个可观察序列，该序列在每个周期之后生成一个值，使用指定的调度程序运行计时器并发送观察者消息。
            print("********interval********")
            
            

           
        default: break
           
        }
    }
}
