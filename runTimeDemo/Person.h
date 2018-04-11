//
//  Person.h
//  runTimeDemo
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject{
    NSString *_studyNo;//成员变量
}
@property (nonatomic,copy) NSString *studyNo;//苹果默认编译器从GCC转换为LLVM，从此不再需要为属性声明实例变量了，如果LLVM发现一个没有匹配实例变灵的属性，他将自动创建一个以下划线开头的实例变量，因此基本上不会同时写属性以及下划线开头的实例变量如（studyNo,_studyNo）
@property (nonatomic,copy) NSString *name;//属性
@property (nonatomic,copy) NSString *status;

@property (nonatomic,getter=isRight) BOOL right;
/**
 * @author wangjun, 16-05-04 15:05:14
 * 1.atomic 原子性，默认的提供线程安全保护
 * 2.nonatomic 非原子性不保证安全，绝大多数情况下使用
 * 3.assign 理论上，所有类型都支持，但是实际上只有基本数据类型，delegate使用
 * 4.retain 所有对象的类都支持，包括，系统提供的类，自定义的类
 * 5.copy 所有遵守NSCopying协议的对象都支持
 */
- (void)setDataWithDic:(NSDictionary *)dic;
- (void)method1;
@end
