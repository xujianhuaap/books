### Dagger learn 
#### 定义依赖
1.通过字段的Inject声明,这种Dagger框架不会帮你创建
对象，在这些字段需要初始化的时候，Dagger框架会自动的
获得所需的字段值。

2.通过构造器的Inject声明，这种Dagger框架会通过该构
造器帮你创建对象。当你需要该对象的时候，Dagger框架会
帮你获得构造器所需要的参数，并且调用Inject声明的构造
器创建对象。

#### 提供依赖
@Inject声明有时候无法使用的。例如在接口无法实例化，第
三方库的class无法添加声明，配置的对象必须要配置。这时候
可以使用@Provide.

#### scope
1.@Singleton
提醒潜在的实例使用者，可能会被多个线程共享。@Singleton
不能与其他scope类型共用。

2.@Reuable
```text
@Reusable
calss Student @Inject constructor(){
}


@Module
class MainMoudle{
    @Provides
    @Reusable
    fun getStudent() = Student()
}

```
@Reusable 会限制构造器实例化和provide方法调用的次数，但是不能保证在同一个组件
内，获得是同一个对象。@Resuable 标记的方法返回的对象或者标记的类实例化的对象，
会被缓存，但是不会和单个组件关联在一起。

换句话说，如果一个组件内的某个模块中包含@Reusable方法，但是只有某个子组件使用，
那么只有该子组件缓存该实例。如果一个组件已经缓存了该实例，那么子组件就可以复用
该实例了。如果两个子组件不属于同一个组件，并且每一个子组件使用@Reusable的实例，
那么子组件就会各自缓存@Resuable实例。

因此，对于会变的对象，或者非常在意对象一致的，使用@Reusable的对象很危险。

#### 限定注解
```text
@Qualifier
@Documented
@Retention(RUNTIME)
public @interface Named{
    String value() default "";
}

class Person{
    @Inject @Named("name") String name;
    @Inject @Named("schoolName") String schoolName;
}

@Module
class PersonModule{
    @Provides @Named("name") static String getName = "default"
    @Provides @Named("SchoolName" ) static String getSchoolName = "sensorSchool"
}
```
#### 延迟注入
```text
calss Person{
    @Inject Lazy<Info> info;
    

    fun printInfo(){
        val info = info.get()
        ...
    }
}

```

#### provider注入
主要是为了解决根据不同状态注入不同的对象。
#### 可选
一个组件中缺乏依赖，如果还想继续使用相关的依赖可以如下做：

```text
@BindsOptionalOf absract Info optionalInfo();
你可以注入一下对象中的一个
Optional<Info>   //允许依赖的对象为null
Optional<Provider<Info>>
Optional<Lazy<Info>>
Optional<Provider<Lazy<Info>>>
```
#### bind Instances
```text
@Component(modules = AppModule.class)
interface AppComponent {
    @Component.Builder
    interface Builder {
        @BindsInstance Builder application(app:LearnApplication);
        AppComponent build();
    }
}
```

为组件注入依赖初始化数据
#### ps
component  包含若干module,module可以包含若干
subcomponent。