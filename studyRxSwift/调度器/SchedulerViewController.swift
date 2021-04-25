//
//  SchedulerViewController.swift
//  studyRxSwift
//
//  Created by 刘衍 on 2021/4/22.
//


/**
     （1）调度器（Schedulers）是 RxSwift 实现多线程的核心模块，它主要用于控制任务在哪个线程或队列运行。
     （2）RxSwift 内置了如下几种 Scheduler：
 
 
     CurrentThreadScheduler：表示当前线程 Scheduler。（默认使用这个）
 
     MainScheduler：表示主线程。如果我们需要执行一些和 UI 相关的任务，就需要切换到该 Scheduler运行。
 
     SerialDispatchQueueScheduler：封装了 GCD 的串行队列。如果我们需要执行一些串行任务，可以切换到这个 Scheduler 运行。
 
     ConcurrentDispatchQueueScheduler：封装了 GCD 的并行队列。如果我们需要执行一些并发任务，可以切换到这个 Scheduler 运行。
 
     OperationQueueScheduler：封装了 NSOperationQueue。
 */
import UIKit
import RxSwift
import RxCocoa

class SchedulerViewController: UIBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async {
            self.getSinglePlayList("0")
                .subscribe(onSuccess: { (json) in
                    //再到主线程显示结果
                    DispatchQueue.main.async {
                        //                        self.data = json[...]
                        print("json:",json)
                    }
                }, onFailure: { (error) in
                    
                })
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
