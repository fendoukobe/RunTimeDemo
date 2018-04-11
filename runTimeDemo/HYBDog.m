//
//  HYBDog.m
//  runTimeDemo
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HYBDog.h"
#import <objc/runtime.h>

@implementation HYBDog
// 我们不实现实现方法-eat,而是添加了一个C语言的eat方法，注意这个eat方法不是HYBDog的实例方法


// 第一步：实现此方法，在调用对象的某方法找不到时，会先调用此方法，允许
// 我们动态添加方法实现
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if([NSStringFromSelector(sel) isEqualToString:@"eat"]){
        class_addMethod(self, sel, (IMP)eat, "v@:");
        return YES;
    }
    return  [super resolveInstanceMethod:sel];
}

// 动态添加的方法
void eat(id self,SEL cmd){
    NSLog(@"%@ is eating",self);
}
@end
