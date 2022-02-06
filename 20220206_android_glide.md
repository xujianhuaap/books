### Glide4.0.0框架分析
#### RequestManager介绍

每一个应用对应唯一个glide对象，而且glide对象对应一个RequestManagerRetriever,其主要作用获取相应的<br>
RequestManager。RequestManager的生命周期,有两个级别一个是Activity级别，一个是application级别。<br>
对于组件(Activity)工作线程或者是在application,发起的请求生成的RequestManager是应用级别的。

RequestManager重要的作用之一便是监测Activity或者Application生命周期的变化。在onStart的时候运行<br>
所有待执行完毕的Request；遍历Target，每个target也开始执行动画。在onStop的时候暂停所有正在运行的Request<br>
并且放到等待队列中;所有的Target要暂停动画。在onDestroy的时候清除所有的Request，所有的Target执行destroy<br>
方法，这里是空的实现。

RequestManager是如何实现监听Activity和Application生命周期的。对于Activity级别的RequestManager<br>
通过创建空的RequestManagerFragment,并且添加到Activity中，以此来监测Activity生命周期变化。对于Application<br>
级别的RequestManager,首次创建RequestManager的时候执行onStart()方法，并不不会调用其他周期方法。


RequestManager另一个作用构建RequestBuilder。

#### RequestBuilder

