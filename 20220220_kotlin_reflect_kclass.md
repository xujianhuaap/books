### Kotlin Reflect 
#### KClass 标准库
    interface KClass<T:Any>
        qulifiedName:String?
        simpleName:String?
        members:List<KCallable<*>>
        constructors:Collections<KFunction<T>>
        nestedClasses:Collection<KClass<*>>
        objectInstance:T?//针对Object class
        typeParamters:List<KTypeParamter>
        superTypes:List<KType>
        visibility:KVisibility?
        isFinal:Boolean
        isOpen:Boolean
        isAbstract:Boolean
        isData:Boolean
        isValue:Boolean
        isInner:Boolean
        isCompanion:Boolean
        isFun:Boolean //顶级函数
        fun equal(other:Any?):Boolean
        fun hashCode():Int
        fun isInstance(value:Any?):Boolean

#### reflect库 KClass扩展
    val <T:Any> KClass<T>.primaryConstructor:KFunction<T>?
    val KClass<*>.companyObject:KClass<*>
    val KClass<*>.companyObjectInstance:Any?
    val KClass<*>.superClasses:List<KClass<*>>

    //本class 定义的属性和方法，包含扩展属性和扩展方法，
    //静态方法和属性（此时的class 是java class 才会有静态属性和静态方法）
    val KClass<*>.declredMembers:Collection<KCallable<*>>

    //包含superClass以及 this class 包含的方法，以及 this class 定义的 静态方法
    //只有this class 是 java类型的，才会有静态方法
    val KClass<*>.functions:Collection<KFunction<*>>

    //this class 声明的方法 包含 静态方法 ，扩展方法
    val KClass<*>.declaredFunctions:Collection<KFunction<*>>
    
    //只有this class 是 java类型的，才会有静态方法
    val KClass<*>.staticFunctions:Collection<KFunction<*>>
    
    //this class 和 super class 定义的扩展方法
    val KClass<*>.memberExtensionFunctions:Collection<KFunction<*>>
    //this class 中定义的扩展方法
    val KClass<*>.declaredMemberExtensionFunctions:Collection<KFunction<*>>

    //this class 和 super class 中 定义的非静态和非扩展方法
    val KClass<*>.memberFunctions:Collection<KFunction<*>>
    //this class 中定义的 非静态 和非扩展方法
    val KClass<*>declaredMemberFunctions:Collection<KFunction<*>>

    //this class 定义的静态属性，class 必须是java类型 
    val KClass<*> staticProperties:Collection<KProperty0<*>>
    //this class 和 super class 定义的属性，不包括静态和扩展属性
    val <T:Any> KClass<T>.memberProperties:Collection<KProperty1<T,*>>
    
    //this class  定义的属性，不包括静态属性和扩展属性
    val <T:Any> KClass<T>.declaredMemberProperties:Collection<KProperty1<T,*>>
    
    val <T:Any> KClass<T>.memberExtensionProperties:Collection<KProperty2<T,*,*>>
    val <T:Any> KClass<T>.declaredMemberExtensionProperties:Collection<KProperty2<T,*,*>>

    
    

#### ps
value class 替代 inline class 的。value class 的属性都是val,本身
不能继承也不能被继承。