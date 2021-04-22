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
   
    let  data:[NameModel] =  [
        NameModel(name: "Single特征序列"),
        NameModel(name: "Observable转换为 Single"),
        NameModel(name: "Completable特征序列"),
        NameModel(name: "Maybe特征序列"),
        NameModel(name: "Driver特征序列,跳转新页面"),
        NameModel(name: "ControlProperty特征序列,跳转新页面"),
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        myTabView.delegate = self
        myTabView.dataSource = self
       
        // Do any additional setup after loading the view.
    }
    //将数据缓存到本地     Completable
    func cacheLocally() -> Completable {
        return Completable.create { completable in
            //将数据缓存到本地（这里掠过具体的业务代码，随机成功或失败）
            let success = (arc4random() % 2 == 0)
            
            guard success else {
                completable(.error(DataError.cantParseJSON))
                return Disposables.create {}
            }
            
            completable(.completed)
            return Disposables.create {}
        }
    }
    //创建 Maybe 和创建 Observable 同样非常相似：
    func generateString() -> Maybe<String> {
        return Maybe<String>.create { maybe in
            
            //成功并发出一个元素
            maybe(.success("hangge.com"))
            
            //成功但不发出任何元素
            maybe(.completed)
            
            //失败
            maybe(.error(DataError.cantParseJSON))
            
            return Disposables.create {}
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
                    print("asSingle()success时候的结果: ", json)
                }, onFailure: { error in
                    print("发生错误: ", error)
                })
                .disposed(by: disposeBag)
            
        case 2:
          // //        Completable 是 Observable 的另外一个版本。不像 Observable 可以发出多个元素，它要么只能产生一个 completed 事件，要么产生一个 error 事件。
            //
            //        不会发出任何元素
            //        只会发出一个 completed 事件或者一个 error 事件
            //        不会共享状态变化
            //        使用场景：Completable 和 Observable<Void> 有点类似。适用于那些只关心任务是否完成，而不需要在意任务返回值的情况。比如：在程序退出时将一些数据缓存到本地文件，供下次启动时加载。像这种情况我们只关心缓存是否成功。
            //        同样RXSwift也是提供了一个枚举CompletableEvent
            //        .completed：用于产生完成事件
            //        .error：用于产生一个错误
            print("********  Completable ********")
            //将数据缓存到本地
           _ = Completable.create{  completable in
                let success = (arc4random() % 2 == 0)
                guard success else{
                    completable(.error(DataError.cantParseJSON))
                    return Disposables.create {}
                }
                completable(.completed)
            return Disposables.create {}
            }.subscribe(
                { completable in
                    switch completable {
                    case .completed:
                        print("保存成功!Completable")
                    case .error(let error):
                        print("保存失败: \(error.localizedDescription)")
                    }
                }).disposed(by: disposeBag)
               
            
         
          
           
        case 3:
            /**
                 Maybe 同样是 Observable 的另外一个版本。它介于 Single 和 Completable 之间，它要么只能发出一个元素，要么产生一个 completed 事件，要么产生一个 error 事件。
             
                 发出一个元素、或者一个 completed 事件、或者一个 error 事件
                 不会共享状态变化
                 使用场景：Maybe 适合那种可能需要发出一个元素，又可能不需要发出的情况。

                 为方便使用，RxSwift 为 Maybe 订阅提供了一个枚举（MaybeEvent）：
             
                 .success：里包含该 Maybe 的一个元素值
                 .completed：用于产生完成事件
                 .error：用于产生一个错误
                 我们可以通过调用 Observable 序列的 .asMaybe()方法，将它转换为 Maybe。
             */
            print("********Maybee********")
            
            generateString()
                .subscribe(onSuccess: { element in
                    print("执行完毕，并获得元素：\(element)")
                }, onError: {
                    error in
                    print("执行失败: \(error.localizedDescription)")
                },onCompleted: {
                    print("执行完毕，且没有任何元素。")
                })
                .disposed(by: disposeBag)
        case 4:
            print("******** Driver ********")
          /*  什么是 Driver
            Driver 是一个精心准备的特征序列。它主要是为了简化 UI 层的代码，驱动 UI 的序列所具有的特征。
            特征：
            • 不会产生 error 事件
            • 一定在 MainScheduler 监听（主线程监听）
            • 共享附加作用
           */
            let Vc = DriverViewController()
            self.navigationController?.pushViewController(Vc, animated: true)
        case 5:
            print("******** ControlPropertyViewController ********")
            /**
             (1）ControlProperty 是专门用来描述 UI 控件属性，拥有该类型的属性都是被观察者（Observable）。
             （2）ControlProperty 具有以下特征：
             
             不会产生 error 事件
             一定在 MainScheduler 订阅（主线程订阅）
             一定在 MainScheduler 监听（主线程监听）
             共享状态变化
             */
            let Vc = ControlPropertyViewController()
            self.navigationController?.pushViewController(Vc, animated: true)
           
            

           
        default: break
           
        }
    }
}
