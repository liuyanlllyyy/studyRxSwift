RxSwift是一种基于数据流 和变化传递的声明式的编程范式
第一个核心特点是 变化传递 :在一串事件流中的一个事件发生变化后，一连串的事件均会发生变化，有点像现实里的多米诺骨牌
第二个核心特点是 数据流 。可以基于任何东西创建数据流。流非常轻便，并且无处不在，任何东西都可以是一个流：变量，用户输入，属性，缓存，数据结构等等
第三个核心特点是 声明式的编程方式 。无论传递过来的元素是什么，计算逻辑是不变的，从而形成了一种对计算逻辑的绑定，有点不变应万变的感觉
有下面几个特征
Observable - 产生事件
Observer - 响应事件链接
Operator - 创建变化组合事件
Disposable - 管理绑定（订阅）的生命周期
Schedulers - 线程队列调配

 Rxswift 核心逻辑有   创建序列  订阅序列  发送响应



创建序列
Observable  
常用创建 Observable 方法 
 never就是创建一个sequence，但是不发出任何事件信号。
 empty就是创建一个空的sequence,只能发出一个completed事件
just是创建一个sequence只能发出一种特定的事件，能正常结束
of是创建一个sequence能发出很多种事件信号  这个方法可以接受可变数量的参数 （一定是要同类型）
from from 将可选序列转换为可观察序列。 从集合中获取序列:数组,集合,set 获取序列 - 有可选项处理 - 更安全
range就是创建一个sequence，他会发出这个范围中的从开始到结束的所有事件
create() 该方法接受一个 闭包形式的参数，任务是对每一个过来的订阅进行处理。


Observable 有一些特殊的特征序列 
Single
Completable
Maybe
Driver
Signal
ControlEvent

特征序列	元素	符号	error事件	符号	completed事件	是否会共享	MainScheduler 监听	MainScheduler 订阅
Single	1个	or	1个	-	-	NO	NO	NO
Completable	-	-	1个	or	1个	NO	NO	NO
Maybe	1个	or	1个	or	1个	NO	NO	NO
Driver	多个	-	-	or	1个	YES	YES	NO
Signal	多个	-	-	or	1个	YES	YES	NO
ControlEvent	多个	or	1个	or	1个	YES	YES	YES

1.single
Single 是 Observable  的另外一个版本，不支持发出多个元素。要么发出一个元素，要么产生一个 error  事件
发出一个元素，或一个 error 事件。
可以对 Observable 调用 .asSingle() 方法，将它转换为 Single。
应用场景：常用于网络请求，对应答或者错误做出响应。

2.Completable
Completable 是 Observable 的另外一个版本。不像 Observable 可以发出多个元素，它要么只能产生一个 completed 事件，要么产生一个 error 事件
注意：发出零个元素
发出一个 completed 事件或者一个 error 事件
应用场景：一般用在不关心后端返回的结果，只在于发出请求。比如数据统计，数据缓存

3.Maybe
Maybe 是 Observable 的另外一个版本。它介于 Single 和 Completable 之间，它要么只能发出一个元素，要么产生一个 completed 事件，要么产生一个 error 事件。
发出一个元素或者一个 completed 事件或者一个 error 事件
应用场景：暂时没想到
4.Driver
Driver 是一个精心准备的特征序列。它主要是为了简化 UI 层的代码，驱动 UI 的序列所具有的特征。可以使用.asDriver()将普通序列转换为 Driver
不会产生 error 事件
一定在 MainScheduler 监听（主线程监听）
应用场景：一般用在 UI 控件上
5.Signal 
SIgnal和 Driver 相似，唯一的区别是，Driver 会对新观察者回放（重新发送）上一个元素，而 Signal不会对新观察者回放上一个元素。
他有如下特性:
不会产生 error 事件
一定在 MainScheduler 监听（主线程监听）
应用场景：Driver 会回放上一个元素，而 Signal 不会，所以 一般情况下状态序列我们会选用 Driver 这个类型，事件序列我们会选用 Signal 这个类型
6.ControlEvent
ControlEvent 专门用于描述 UI 控件所产生的事件，ControlEvent 和 ControlProperty 一样，都具有以下特征：
不会产生 error 事件
一定在 MainScheduler 订阅（主线程订阅）
一定在 MainScheduler 监听（主线程监听）
一般rxcocoa 封装好了很多 比如 label 

Subject
 Subject既是可监听序列也是观察者  比如 textField的当前文本。它可以看成是由用户输入，而产生的一个文本序列。也可以是由外部文本序列，来控制当前显示内容的观察者

有下面几种subject
AsyncSubject
PublishSubject
ReplaySubject
BehaviorSubject
ControlProperty
PublishRelay 
 
1. PublishSubject
  PublishSubject不需要初值就可以创建
PublishSubject 将对观察者发送订阅后产生的元素，而在订阅前发出的元素将不会发送给观察者。如果你希望观察者接收到所有的元素，你可以通过使用 Observable 的 create 方法来创建 Observable，或者使用 ReplaySubject。
如果源 Observable 因为产生了一个 error 事件而中止， PublishSubject 就不会发出任何元素，而是将这个 error 事件发送出来。

从你开始订阅开始，后面发送的元素能输出，之前的元素就不能被输出了。
如果遇到 error 则只发出 error 事件并终止

ReplaySubject
bufferSize 缓存池大小来存储能发送的最近的元素个数 不要在多线程去调用避免异常
ReplaySubject 将对观察者发送全部的元素，无论观察者是何时进行订阅的。
这里存在多个版本的 ReplaySubject，有的只会将最新的 n 个元素发送给观察者，有的只会将限制时间段内最新的元素发送给观察者。
如果把 ReplaySubject 当作观察者来使用，注意不要在多个线程调用 onNext, onError 或 onCompleted。这样会导致无序调用，将造成意想不到的结果。

 3. BehaviorSubject
BehaviorSubject 需要一个默认值来创建 
类似 bufferSize  = 1 的 ReplaySubject, 只会发送最近一次的元素，如果没有则以初始化元素（初始化是必须有一个默认值）
遇到 error 就不会发送任何元素，发错错误 error 并中止

当观察者对 BehaviorSubject 进行订阅时，它会将源 Observable 中最新的元素发送出来（如果不存在最新的元素，就发出默认元素）。然后将随后产生的元素发送出来。
如果源 Observable 因为产生了一个 error 事件而中止， BehaviorSubject 就不会发出任何元素，而是将这个 error 事件发送出来。

4.ControlProperty
ControlProperty 专门用于描述 UI 控件属性的，它具有以下特征：
不会产生 error 事件
一定在 MainScheduler 订阅（主线程订阅）
一定在 MainScheduler 监听（主线程监听）
5.PublishRelay
  PublishRelay就是PublishSubject去掉终止事件onError或onCompleted。

6.BehaviorRelay
BehaviorRelay就是BehaviorSubject去掉终止事件onError或onCompleted。

参考链接：RxSwift 中文文档 
