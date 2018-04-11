//
//  HYBMethodLearn.m
//  runTimeDemo
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HYBMethodLearn.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation HYBMethodLearn
- (int)testInstanceMethod:(NSString *)name andValue:(NSNumber *)value {
    NSLog(@"%@", name);
    
    return value.intValue;
}

- (NSArray *)arrayWithNames:(NSArray *)names {
    NSLog(@"%@", names);
    return names;
}
/**
 // 函数调用，但是不接收返回值类型为结构体
 method_invoke
 // 函数调用，但是接收返回值类型为结构体
 method_invoke_stret
 // 获取函数名
 method_getName
 // 获取函数实现IMP
 method_getImplementation
 // 获取函数type encoding
 method_getTypeEncoding
 // 复制返回值类型
 method_copyReturnType
 // 复制参数类型
 method_copyArgumentType
 // 获取返回值类型
 method_getReturnType
 // 获取参数个数
 method_getNumberOfArguments
 // 获取函数参数类型
 method_getArgumentType
 // 获取函数描述
 method_getDescription
 // 设置函数实现IMP
 method_setImplementation
 // 交换函数的实现IMP
 method_exchangeImplementations
 */

- (void)getMethods{
    unsigned int outCount = 0;
    Method *methodList = class_copyMethodList(self.class, &outCount);
    for (unsigned int i=0; i<outCount; i++) {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        NSLog(@"方法名：%@",NSStringFromSelector(methodName));
        
        //获取方法的参数类型
        unsigned int argumentsCount = method_getNumberOfArguments(method);
        char argName[512] = {};
        for (unsigned int j=0; j<argumentsCount; j++) {
            method_getArgumentType(method, j, argName, 512);
            NSLog(@"第%u个参数类型为：%s", j, argName);
            memset(argName, '\0', strlen(argName));
        }
        char returnType[512] = {};
        method_getReturnType(method, returnType, 512);
        NSLog(@"返回值类型：%s", returnType);
        
        // type encoding
        NSLog(@"TypeEncoding: %s", method_getTypeEncoding(method));
        
    }
    free(methodList);
    
}


+ (void)test {
    HYBMethodLearn *m = [[HYBMethodLearn alloc] init];
    [m getMethods];
    
    // 这就是为什么有四个参数的原因
    int returnValue = ((int (*)(id, SEL, NSString *, NSNumber *))objc_msgSend)((id)m, @selector(testInstanceMethod:andValue:), @"标哥的技术博客", @100);
    NSLog(@"return value is %d", returnValue);
}
@end
