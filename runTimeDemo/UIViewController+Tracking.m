//
//  UIViewController+Tracking.m
//  runTimeDemo
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIViewController+Tracking.h"

#import <objc/runtime.h>

@implementation UIViewController (Tracking)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xxx_viewWillAppear:);
        
        // note :假设当前类没有实现 originalSelector 这个方法，那么有可能会返回父类的方法
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzalMethod = class_getInstanceMethod(class, swizzledSelector);
        /**
         * Adds a new method to a class with a given name and implementation.
         *
         * @param cls The class to which to add a method.
         * @param name A selector that specifies the name of the method being added.
         * @param imp A function which is the implementation of the new method. The function must take at least two arguments—self and _cmd.
         * @param types An array of characters that describe the types of the arguments to the method.
         *
         * @return YES if the method was added successfully, otherwise NO
         *  (for example, the class already contains a method implementation with that name).
         *
         * @note class_addMethod will add an override of a superclass's implementation,
         *  but will not replace an existing implementation in this class.
         *  To change an existing implementation, use method_setImplementation.
         */
        /*
         添加是为了重写父类的 viewWillAppear 方法，如果你自己已经手动重写了 viewWillAppear 方法，class_addMethod() 就会添加失败，返回 NO。
         
         如果返回 NO ，说明已经重写，就直接交换。
         
         如果返回 YES, 说明添加成功，也就是你之前没有重写 viewWillAppear 方法。因为在添加方法里面是将 originalSelector 与 swizzledMethod 的 IMP 绑定在一起了，会将新的IMP替换掉旧的的IMP，所以接下来只用将 swizzledSelector 与 originalMethod 的 IMP 绑定就可以了。也就实现了交换。
         */
        
        
        // 1. 如果类中不存在要替换的方法，那就先用class_addMethod和class_replaceMethod函数添加和替换两个方法的实现；如果类中已经有了想要替换的方法，那么就调用method_exchangeImplementations函数交换了两个方法的 IMP，这是苹果提供给我们用于实现 Method Swizzling 的便捷方法。
        
        // 直接交换 IMP 是很危险的。因为如果这个类中没有实现这个方法，class_getInstanceMethod() 返回的是某个父类的 Method 对象，这样 method_exchangeImplementations() 就把父类的原始实现（IMP）跟这个类的 Swizzle 实现交换了。这样其他父类及其其他子类的方法调用就会出问题，最严重的就是 Crash。所以先做一个class_addMethod操作
        
        // 我们这里替换的viewWillAppear，类中是已经存在了的，所以返回的是NO
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzalMethod), method_getTypeEncoding(swizzalMethod));
        
        if(didAddMethod){
            // 2. 所以这里只需要把swizzledSelector的IMP替换成originalMethod的IMP
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            // 3.如果有重写或者实现，则交换imp
            method_exchangeImplementations(originalMethod, swizzalMethod);//交换实现方法
        }
        
    });
}
- (void)xxx_viewWillAppear:(BOOL)animated{
    [self xxx_viewWillAppear:animated];
    NSLog(@"-----------viewWillApear:%@",self);
}
@end
