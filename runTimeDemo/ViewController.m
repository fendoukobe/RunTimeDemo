//
//  ViewController.m
//  runTimeDemo
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"

#import "HYBTestModel.h"
#import "HDFArchiveModel.h"
#import "HYBDog.h"
#import "HYBPig.h"
#import "HYBCat.h"
#import "HYBMsgSend.h"
#import "HYBPropertyLearn.h"
#import "HYBMethodLearn.h"
#import "HYBTest.h"
#import "MyClass.h"

#import "UIControl+HYBBlock.h"
#import "UIView+TapBlock.h"
#import "UIViewController+Tracking.h"

#import <objc/runtime.h>
#import <objc/message.h>
#import <objc/objc.h>

#import "Person.h"

@interface ViewController ()
{
    UIButton *otherButton;
    NSString *name;
    // NSMutableArray *_array;
}

@end
@implementation ViewController
@synthesize array = _array;//（属性的需要这样做，如果是成员变量则不需要加这行代码，但成员变量名必须是_array，或者会报）不加这句代码会报错，系统不能识别_array,原因是因为你同时重写了getter和setter方法，系统就不会再帮你自动生成_array这个变量，所以系统就不认识这个变量_array了，所以你得手动指定成员变量才能同时重写setter和getter方法
@dynamic title;//告诉编译器不用自动生成getter和setter方法，在程序运行的过程中会用其他方式动态的添加实现getter和setter方法，常用于NSManagedObject

- (NSString *)title{
    if(_title == nil){
      _title = @"day day up";
    }
    return _title;
    //return self.title;如果这样写会造成死循环，因为这句代码等同于[self title]
}
- (void)setTitle:(NSString *)title{
    if(_title != title){
        _title = nil;
        _title = title;
      //  self.title = title;如果这样赋值会造成死循环，因为这句代码等同于 [self setTitle:title]
    }
}

//重写setter和getter方法(也就是所谓的懒加载)
- (void)setArray:(NSMutableArray *)array{
    if(_array != array){
        _array = nil;
        _array = array;
    }
}
- (NSMutableArray *)array{
    if(!_array){
        _array = [NSMutableArray array];
    }
    return _array;
}
/*- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"hahhaha");
}*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.btnName = @"runTime";
    [btn setTapActionWithBlock:^{
        NSLog(@"哈哈哈，效果怎么样");
    }];
   /* btn.hyb_touchUpBlock = ^(id sender){
        UIButton *button = (UIButton *)sender;
        NSLog(@"hello %@",button.btnName);
    };*/
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    //[self myClassTest];
    
    [self addNewClass];
    
   // [self getClassTest];
    
    //[[[HYBTest alloc] init] ex_registerClassPair];
    
    //[HYBTestModel test];
    //[HDFArchiveModel test];
    
    
   // HYBDog *dog = [[HYBDog alloc] init];
    //[dog eat];
    
   // HYBPig *pig = [[HYBPig alloc] init];
    
   // ((void (*)(id,SEL))objc_msgSend)((id)pig,@selector(eat));
    //等价于
   // [pig performSelector:@selector(eat) withObject:nil afterDelay:0];
    
    //HYBCat *cat = [[HYBCat alloc] init];
    
    //[cat performSelector:@selector(eat) withObject:nil afterDelay:0];
    //等价于
    //((void (*)(id,SEL))objc_msgSend)((id)cat,@selector(eat));
    
    //我们一直以来都是使用类似这样的[[HYBMsgSend alloc] init]来创建并初始化对象，其实在编译时，这一行代码也会转换成类似如下的代码
    //创建对象
    //HYBMsgSend *msg = ((HYBMsgSend *(*)(id,SEL))objc_msgSend)((id)[HYBMsgSend class],@selector(alloc));
    //初始化对象
    //msg = ((HYBMsgSend *(*) (id,SEL))objc_msgSend)((id)msg,@selector(init));
    //要发送消息给msg对象，并将创建的对象返回，那么我们需要强转函数指针类型。(HYBMsgSend * (*)(id, SEL)这是带一个对象指针返回值和两个参数的函数指针，这样就可以调用了。
    //调用无参数，无返回值的消息
   // ((void (*)(id,SEL))objc_msgSend)((id)msg,@selector(noArgumentsAndNoReturenValue));
    //带一个参数，无返回值消息
   // ((void (*) (id,SEL,NSString *))objc_msgSend)((id)msg,@selector(hasArguments:),@"带一个参数，但无返回值");
    //带返回值，不带参数消息
    //((NSString *(*) (id,SEL))objc_msgSend)((id)msg,@selector(noArgumentsButReturnValue));
    //带参数，带返回值的消息
    //int returnValue = ((int (*)(id,SEL,NSString *,int))objc_msgSend)((id)msg,@selector(hasArguments: andReturnValue:),@"参数1",2016);
    //NSLog(@"6. return value is %d", returnValue);
    
    //[HYBMsgSend test];
    //[HYBPropertyLearn test];
    //[HYBMethodLearn test];
    
    
   /* Person *p = [[Person alloc] init];
    p.name = @"right";
    p.studyNo = @"20081556";
    [p method1];*/
    
    /*方法与消息
     SEL,两个类之间不管他们是父类还是子类的关系还是之间没有这种关系，只要方法名相同，那么方法的SEL就是一样的，每一个方法都对应一个SEL。所以在OC中同一个类不能存在2个同名的方法，即使参数类型不同也不行，相同的方法只能对应一个SEL.这也就导致OC在处理相同方法名去参数个数相同但类型不同的方法方面的能力很差
    - (void)setWidth:(int)width;
    - (void)setWidth:(double)width;
     这样定义会被认为是一种编译错误
     当然，不同的类可以拥有相同的selector，这个没有问题，不同类的实例对象执行相同的selector时会在各自的方法列表中根据seletor去寻找自己对应的IMP
     工程中所有的SEL组成一个set集合，set的特点就是唯一，因此我们想到这个方法集合中查找某个方法时，只需要去找到这个方法对应的SEL就行了，SEL实际上就是方法名hash化了的一个字符串，而对于字符串的比较仅仅需要比较他们的地址就可以了，可以说速度是无以伦比的，但是有一个问题，就是数量增多会增大hash冲突而导致性能下降（或是没有冲突，因为也可能用perfect hash)。但是不管使用什么样的方法加速，如果能够将总量减少（多个方法对应一个SEL），那将是最犀利的方法，那么，我们就不难理解，为什么SEL仅仅是函数名了
         本质上SEL只是一个指向方法的指针（准确的说，只是一个根据方法名hash化了的key值，能唯一代表一个方法），他的存在只是为了加快方法的查询进度
     
     我们可以在运行时添加新的selector，也可以在运行时获取已存在的selector，我们可以通过下面三中方法来获取SEL
     1.sel_registerName函数
     2.Object-C编译器提供的@selector()  SEL sel1 = @selector(method)
     3.NSSelectorFromString()
     
     IMP 
     IMP实际上是一个函数指针，指向方法实现的首地址，定义如下 id(*IMP)(id ,SEL,...),id是指向self的指针(如果是实例方法，则是类实例的内存地址，如果是类方法，则是指向元类的指针)，第二个参数方法是方法选择器selector,接下来的是方法的实际参数列表
     由于每一个方法对应唯一的SEL，因此我们可以通过SEL方便快速准确的获得他所对应的IMP.去的IMP之后，我们就获得了只系想难过这个方法代码的入口点，此时，我们可以像调用普通的C语言函数一样来实用这个函数指针了 
     通过去的IMP。我们可以跳过Runtime的消息传递机制，直接执行IMP只想的函数实现，这样省区了Runtime消息传递过程中所做的一系列查找操作，会比直接像对象发送消息高效一些。
     
     Method 用于表示类定义中的方法
     */
    
    //方法相关的操作函数
    //id menthod_invoke(id receiver,Method m,...) --调用指定方法的实现
    //void method_invoke_stret(id receiver,Method m,...)---调用返回一个数据结构的方法的实现
    
    //这里可以在获取类所有的方法中使用
   /* int methodCount =0;
    Method *methodList = class_copyMethodList([self class], &methodCount);
    for (int i=0; i<methodCount; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);//获取方法名称，但是类型是一个SEL选择器类型
         const char *name = sel_getName(sel);//获取C字符串
        NSString *methodName = [NSString stringWithUTF8String:name];//将方法名转换为OC字符串
         IMP imp = method_getImplementation(method);//返回方法的实现
        const char *type = method_getTypeEncoding(method);//返回描述方法参数和返回值类型的字符串
        const char *argumentType = method_copyArgumentType(method, 1);//获取方法的指定位置的参数的类型字符串
        int count = method_getNumberOfArguments(method);//获取方法的参数个数
        char *returnType;
        method_getReturnType(method, returnType, sizeof(char *));//通过引用返回方法的返回值类型字符串
    }
    
    
    
    //获取方法的地址
    int i;
    void (*setter)(id,SEL,BOOL);
    
    setter = (void (*)(id,SEL,BOOL))[self methodForSelector:@selector(setFilled:)];
    for (int i=0; i<1000; i++) {
        setter(self,@selector(setFilled:),YES);
    }*/
}

#pragma mark -获取类定义
- (void)getClassTest{
    /*int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL, 0);// You can pass \c NULL to obtain the total number of registered class  你可以传递\ c NULL来获取注册类的总数
    if(numClasses>0){
        classes = malloc(sizeof(classes) * numClasses);//malloc 向系统申请分配指定size个字节的内存空间，返回类型是 void* 类型。void* 表示未确定类型的指针
        // 上面的代码在ARC环境下会报编译错误
        numClasses = objc_getClassList(classes, numClasses);//buffer An array of \c Class values. On output, each \c Class value points to one class definition,每一个Class 值都是指向一个类（内存地址）
        NSLog(@"number of classes :%d",numClasses);
        
        for (int i=0; i<numClasses; i++) {
            Class cls = classes[i];
            NSLog(@"class name : %s",class_getName(cls));
        }
        free(classes);
    }*/
}



- (void)myClassTest{
    MyClass *myClass = [[MyClass alloc] init];
    unsigned int outCount = 0;
    Class cls = myClass.class;//元类？
    
    //类名
    NSLog(@"class name :%s",class_getName(cls));
    NSLog(@"==========================================================");
    
    //父类
    NSLog(@"super class name:%s",class_getName(class_getSuperclass(cls)));
    NSLog(@"==========================================================");
    
    //是否是元类
    NSLog(@"MyClass is %@ a meta-class",class_isMetaClass(cls)?@"":@"not");
    NSLog(@"==========================================================");
    
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s",class_getName(cls),class_getName(meta_class));
    NSLog(@"==========================================================");
    
    
    //变量实例大小
    NSLog(@"instance size :%zu",class_getInstanceSize(cls));
    NSLog(@"==========================================================");
    
    //成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i=0; i<outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name :%s at index :%d",ivar_getName(ivar),i);
    }
    free(ivars);//释放
    NSLog(@"==========================================================");
    
    //属性操作
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i=0;i<outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name is :%s",property_getName(property));
    }
    free(properties);
    
    objc_property_t array = class_getProperty(cls, "array");
    if(array != NULL){
        NSLog(@"property %s",property_getName(array));
    }
    
    NSLog(@"==========================================================");
    
    //方法操作
    
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i=0; i<outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature :%s",method_getName(method));
    }
    free(methods);
    
    //实例方法
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if(method1 != NULL){
        NSLog(@"method %s",method_getName(method1));
    }
    
    //类方法
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if(classMethod != NULL){
      NSLog(@"class method : %s", method_getName(classMethod));
    }
     NSLog(@"MyClass is%@ responsd to selector: method3WithArg1:arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @" not");
    
    IMP imp = class_getMethodImplementation(cls, @selector(method1));//返回一个指向方法实现函数的指针
    imp();//执行方法
    
    //协议
    Protocol * __unsafe_unretained *protocols = class_copyProtocolList(cls, &outCount);
    Protocol *protocol;
    for (int i=0; i<outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name : %s",protocol_getName(protocol));
    }
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    NSLog(@"==========================================================");
}
//runtime的强大之处在于他能在运行时创建类和对象
- (void)addNewClass{
    Class cls = objc_allocateClassPair([MyClass class], "MySubClass", 0);
    
    class_addMethod(cls, @selector(subMethod1), (IMP)imp_subMethod1, "v@:");
    class_replaceMethod(cls, @selector(method1), (IMP)imp_method1, "v@:");
    class_addIvar(cls, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");
    class_addMethod(object_getClass(cls), @selector(classMethodTest), (IMP)calss_imp_submethod, "v@:");
    
    
    objc_property_attribute_t type = {"T","@\"NSString\""};//type
   // {"T",[NSString stringWithFormat:@"@\%@\"",NSStringFromClass([NSString class])]};
    objc_property_attribute_t ownership = {"C",""};//C = copy
    objc_property_attribute_t ownership1 = {"N",""};//N = nonatomic
    objc_property_attribute_t backingivar = {"V","_property2"};//variable name
    //{"V",[[NSString stringWithFormat:@"_%@",@"property2"] UTF8String]};
    objc_property_attribute_t attrs[] = {type,ownership,ownership1,backingivar};
    //Type encoding must be first，Backing ivar must be last。
    class_addProperty(cls, "property2", attrs, 2);
    objc_registerClassPair(cls);
    
    id instance = [[cls alloc] init];
    [instance performSelector:@selector(subMethod1)];
    [instance performSelector:@selector(method1)];
    
    [object_getClass(instance) performSelector:@selector(classMethodTest)];
    
    unsigned int outCount = 0;
    
    
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i=0; i<outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name :%s at index :%d",ivar_getName(ivar),i);
    }
    free(ivars);//释放
    
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"instance variable's name :%s at index :%d",property_getName(property),i);
    }
    free(properties);
    
    //销毁一个类及其相关的类
    
    [NSString stringWithUTF8String:"123"];
    [@"123" UTF8String];
    
   
    // 如果cls 正在使用，则不能销毁,所以这里把他置为nil
    instance = nil;
    objc_disposeClassPair(cls);
    
    NSLog(@"分割线");
}
void imp_method1(id self,SEL _cmd){
    NSLog(@"imp_method1");
}
void imp_subMethod1(id self,SEL _cmd){
    NSLog(@"imp_subMethod1");
}
void calss_imp_submethod(id self,SEL _cmd){
    NSLog(@"类方法");
}

- (void)getMethName{

}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSString *selectorStr = NSStringFromSelector(sel);
    if([selectorStr isEqualToString:@"method1"]){
        class_addMethod([self class], @selector(method1), (IMP)functionForMethod1, "@:");
    }
    return [super resolveInstanceMethod:sel];
}


void functionForMethod1(id self,SEL _cmd){
    NSLog(@"%@   %p",self,_cmd);
}

void ReportFunction(id self,SEL _cmd){
    NSLog(@"This object is %p.",self);
    NSLog(@"Class is %@, and super is %@.",[self class],[self superview]);
    
    Class currentClass = [self class];
    for (int i=0; i<5; i++) {
        NSLog(@"Following the isa pointer %d times gives %p",i,currentClass);
        currentClass = object_getClass(currentClass);
    }
    NSLog(@"NSObject's class is %p",[NSObject class]);
    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
}

- (void)method1{
    NSLog(@"method1");
}
- (void)setFilled:(int)fill{
    NSLog(@"1");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface SUTRuntimeDemo(){}

@end

@implementation SUTRuntimeDemo

- (void)test{
    [self performSelector:@selector(method1)];
}

@end


