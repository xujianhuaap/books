### Dagger learn 
#### 依赖声明
1.通过字段的Inject声明,这种Dagger框架不会帮你创建
对象，在这些字段需要初始化的时候，Dagger框架会自动的
获得所需的字段值。

2.通过构造器的Inject声明，这种Dagger框架会通过该构
造器帮你创建对象。当你需要该对象的时候，Dagger框架会
帮你获得构造器所需要的参数，并且调用Inject声明的构造
器创建对象。

#### 依赖提供
@Inject声明有时候无法使用的。例如在接口无法实例化，第
三方库的class无法添加声明，配置的对象必须要配置。

#### ps
component  包含若干module,module可以包含若干
subcomponent。