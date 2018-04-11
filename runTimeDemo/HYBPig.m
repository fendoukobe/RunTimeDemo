//
//  HYBPig.m
//  runTimeDemo
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HYBPig.h"
#import "HYBDog.h"
//修改调用-eat方法的对象
@implementation HYBPig
// 第一步，不动态添加方法，所以返回NO
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    return NO;
}
// 第二步，备选提供响应aSelector的对象，我们不备选，因此设置为nil，就会进入第三步
- (id)forwardingTargetForSelector:(SEL)aSelector{
    return  nil;
}
// 第三步，先返回方法选择器，如果返回nil,则表示无法处理消息
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if([NSStringFromSelector(aSelector) isEqualToString:@"eat"]){
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}
// 第三步，只有返回了方法签名，都会进入这一步，这一步用户调用方法
// 改变调用对象
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    //改变调用对象为dog
    [anInvocation invokeWithTarget:[[HYBDog alloc] init]];
}
@end
