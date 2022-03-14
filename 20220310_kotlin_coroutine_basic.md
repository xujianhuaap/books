### kotlin 协程基本概念

* #### 协程的启动策略
    * ##### CoroutineStart.DEFAULT
  ```text
      根据context,来决定合适的线程，立即提交协程，该协程是可以取消的。
      已经执行的协程是否可以取消，取决于实现。已提交未执行的协程，在此策略下
      也是可以取消的，但会报异常。
  ```
    * ##### CoroutineStart.ATOMIC
  ```text
    同Default一样，只是协程在提交之后，运行之前不能取消。开始执行的协程在挂起点是否可以取消
    取决于实现。
    ```
    * ##### CoroutineStart.UNDISPATCHED
  ```text
    同ATOMIC一样，不通过Dispatcher来指定线程，在当前线程执行协程
  ```
    * ##### CoroutineStart.LAZY
  ```text
    不立即提交协程，在需要的时候才提交
  ```
* #### <li>协程的Dispatcher
    ```text
    Dispatcher.Main
    协程执行限制在刷新Ui的线程
  
    Dispatcher.io
    可以使用default的线程池，也可以在扩充，不做数量限制，根据需要而定
    
    Dispatcher.undefined
    对协程的执行不做线程限制
  
    Dispatcher.default  
    共享的JVM线程池 若context中没有ContinuationInterceptor指定的时候，默认使用该模式
   ```
