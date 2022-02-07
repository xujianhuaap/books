### Glide4.0.0框架分析
#### Request/Target层介绍
##### <li>RequestManager介绍

    每一个应用对应唯一个glide对象，而且glide对象对应一个RequestManagerRetriever,其主要作用获取相应的
    RequestManager。RequestManager的生命周期,有两个级别一个是Activity级别，一个是application级别。
    对于组件(Activity)工作线程或者是在application,发起的请求生成的RequestManager是应用级别的。

    RequestManager重要的作用之一便是监测Activity或者Application生命周期的变化。在onStart的时候运行
    所有待执行完毕的Request；遍历Target数组，每个target也开始执行onStart方法(开启动画)。在onStop的
    时候暂停所有正在运行的Request并且放到等待队列中;所有的Target要执行onStop方法（暂停动画）。在
    onDestroy的时候清除所有的Request，所有的Target执行destroy方法，这里是空的实现。（这里Target是
    以ImageViewTarget为例子）

    RequestManager是如何实现监听Activity和Application生命周期的。对于Activity级别的RequestManager
    通过创建空的RequestManagerFragment,并且添加到Activity中，以此来监测Activity生命周期变化。对于
    Application级别的RequestManager,首次创建RequestManager的时候执行onStart()方法，并不不会调用其
    他周期方法。

    RequestManager 的clear(Target),在监控到onDestroy生命的时候或者预加载结束会调用这个方法。具体逻辑
    如下
        1.若不是主线程，通过handler发送消息，在主线程执行clear(Target);若是进行2步骤
        2.判断target持有的Request是否为空，若为空已经成功清除；若不为空进行3步骤
        3.判断target的request，是否在requestManager的追踪的Request数组中，若在则从数组中移除，并且对
          request做回收处理，target持有的Request置空值。若target持有的request，不在requestManager
          追踪的Request数组中，执行4步骤
        4. 遍历Glide这个单例持有的所有RequestManager执行clear(Target)操作，直到有成功清除的，若都没有
          成功清除则抛异常



    RequestManager另一个作用构建RequestBuilder。

##### <li> Request
    请求主要是对Resource请求任务的封装，主要提供了开启，暂停，取消，回收这些功能，以及任务的状态，是否完
    成，是否暂停，是否失败。

##### <li> Target
    主要作用有二，其一监听到requestManager的生命周期变化，执行对应的方法。以ImageViewTarget为例子,
    监听到onStart()方法，target也执行target的onStart方法(开启存在的动画)。监听到onStop方法，target
    执行onStop方法（结束动画）监听到onDestroy方法，target执行onDestroy方法（这里是空实现）；其二监听
    request的任务状态变化，例如开始请求Resource任务，请求任务失败，请求任务就绪（意味者已经拿到数据），
    请求任务取消。
##### <li> 小结
    该层主要的工作是根据配置选项构建Request,根据RequestManager监测到组件（Activity）生命周期，对
    所有的Request和Target做相应的处理。

#### Job层
##### <li> Engine
    RequestManager的最重要的作作用之一是构建RequestBuilder,通过RequestBuilder的into(Target/Viiew)
    方法,我们会构建Request,并且设置为Target成员字段；Request会被RequestManager跟踪，并且启动对应的任务
    。我们以SingleRequest为例子来做分析：
    
        1.Request任务开启过程中若可以获取资源所需的宽高数据，直接通过engine的load方法执行任务；若不能获得
        宽高数据执行下一步。
        2.通过Target获取资源所需的宽高数据，通过成员变量engine的load方法执行任务。
        
    因此Request任务的执行依赖于成员变量engine来实现的。
    
    Engine重要的职责之一是实现Resource的三级缓存,再次请求的时候加速获取，具体如下：
        1.优先根据key从内存缓存获取，使用的是LRUCache这种缓存方式。若取得数据，从内存缓存中移除，加入到active
        Cache这个缓存中，并且该Resource的引用数加1;若无法从内存缓存中获取，执行下一步。
        2.从activeCache中获取，能够获取，就结束；若无法获取则进行下一步。
        3.通过engineJob继续获取资源。若支持磁盘缓存，先在工作线程中寻找磁盘缓存中的资源，若寻找到资源结束，否则
        进入下一步。
        4.从网络，设备（Asset）获取资源，并且缓存到磁盘和activeCache中。
    
    内存缓存，磁盘缓存采用的是LRUCache这种缓存方式。当系统内存紧张的时候内存缓存所有数据会被清理。而activeCache
    缓存策略是这样的：
        1.activeCache本身是一个HashMap,键对应的是资源的key,值对应的是缓存的资源的弱引用
        2.在Request监听到RequestManger的生命周期的时候onStop()的时候，若Request的成员字段resource
        有值就会被释放。释放后的资源若引用数为0，通过Request的成员变量engine,从activeCache中移除，并且
        加入到内存缓存中。
        3.在将resource加入到actveCache的时候，resource的引用计数会增加1.只有引用计数为零的resource才
        能被回收。
     
    Engine另一个的职责是监听Request任务的状态（完成，取消），资源的状态（释放，移除）具体如下：
        1.当Request任务完成的时候，engine将资源缓存到activeCache,并且从jobs中移除相应的EnineJob。
        2.当Request任务取消的时候，engine将相应的EngineJob从jobs中移除
        3.当Request监听到RequestManaer的生命周期onStop的时候，正在运行的Request会释放已获得资源，
        若资源引用计数为0，就会从activeCache中移除，加入到内存缓存中。
        4.当内存缓存已满，新的资源添加进来的时候，最早加入的资源会被移除,资源执行回收工作。（必须在主线程）


