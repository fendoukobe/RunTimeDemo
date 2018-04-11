//
//  MyClass.h
//  runTimeDemo
//
//  Created by apple on 16/12/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject<NSCopying,NSCoding>

@property (nonatomic,strong) NSArray *array;
@property (nonatomic,copy) NSString *string;

- (void)method1;
- (void)method2;
+ (void)classMethod1;

@end
