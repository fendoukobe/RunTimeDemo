//
//  HYBTest.m
//  runTimeDemo
//
//  Created by apple on 16/12/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HYBTest.h"
#import <objc/runtime.h>

void testMetaClass(id self,SEL _cmd){
    NSLog(@"this object is %p",self);
    NSLog(@"class is %@,super class is %@",[self class],[self superclass]);
    
    Class currentClass = [self class];
    for (int i=0; i<4;i++) {
        NSLog(@"Following the isa pointer %d times gives %p",i,currentClass);
        currentClass = objc_getClass((__bridge void *)currentClass);
    }
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class]));
}

@implementation HYBTest

- (void)ex_registerClassPair{
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    class_addMethod(newClass, @selector(testMetaClass), (IMP)testMetaClass, "v@:");
    objc_registerClassPair(newClass);
    
    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    [instance performSelector:@selector(testMetaClass)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
