# studyRxSwift
学习 rxswift
 /*
            Observable 有哪些？
            • Single
            • Completable
            • Maybe
            • Driver
            • Signal
            • ControlEvent
         **/

          //create() 该方法接受一个 闭包形式的参数，任务是对每一个过来的订阅进行处理。

           //  interval 返回一个可观察序列，该序列在每个周期之后生成一个值，使用指定的调度程序运行计时器并发送观察者消息。

             //MARK:  generate  通过运行产生序列元素的状态驱动循环，使用指定的调度程序运行循环，发送观察者消息，从而生成一个可观察序列。
           // 该方法创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的 Observable 序列。
            //  初始值给定 然后判断条件1 再判断条件2 会一直递归下去,直到条件1或者条件2不满足
            // 类似 数组遍历循环
            // -参数一initialState:  初始状态。
            //-参数二 condition：终止生成的条件(返回“false”时)。
            // -参数三 iterate：迭代步骤函数。
            //-参数四 调度器：用来运行生成器循环的调度器，默认：CurrentThreadScheduler.instance。
            // -返回：生成的序列。
  //  3. of() 创建一个新的可观察实例  这个方法可以接受可变数量的参数 （一定是要同类型）

    //2. just  单个信号序列创建 该方法通过传入一个默认值来初始化，构建一个只有一个元素的Observable队列，订阅完信息自动complete

     //  1.创建个空的序列  empty