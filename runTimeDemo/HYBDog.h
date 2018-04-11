//
//  HYBDog.h
//  runTimeDemo
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 第一个例子：提供声明，但是不提供方法实现。验证当找不到方法的实现时，动态添加方法。第二个例子：不提供声明，将调用对象修改成其它类实例。验证修改处理消息的对象。第三个例子：不提供声明，不修改调用对象，但是修改调用的方法
 */

@interface HYBDog : NSObject

// 只声明，不实现
- (void)eat;

@end
