### koltin - 类型安全检查与转型
#### is和！is 以及智能转型
在运行时，判断是不是所指定的类型
```text
if(obj is String){
    println(obj) //智能转化为String
}
```
#### as 不安全的转型
```text
val str:String = y as String
注意null 不能转型为任何non-null类型，若y为null,上面的转型为抛出异常

val str:String? = y as String? 这种可以避免ｙ为null的异常

```

#### 类型檫除与泛型检查
```text
泛型的检查是在编译的时候，运行的时候泛型信息被檫除了。
```