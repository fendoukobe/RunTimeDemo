//
//  HYBPropertyLearn.h
//  runTimeDemo
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYBPropertyLearn : NSObject{
   //成员变量
    float websiteTitle;
    
@private
    float privateAttribute;
}
//属性
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, assign) int count;
@property (nonatomic) id delegate;
@property (atomic, strong) NSNumber *atomicProperty;

+ (void)test;
@end
