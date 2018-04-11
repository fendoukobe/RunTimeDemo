//
//  HYBTestModel.h
//  runTimeDemo
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HYBEmptyPropertyProtocol <NSObject>

// 设置默认值，若为空，则取出来的就是默认值
-(NSDictionary *)defaultValueForEmptyProperty;

@end

@interface HYBTestModel : NSObject<HYBEmptyPropertyProtocol>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, assign) int    commentCount;
@property (nonatomic, strong) NSArray *summaries;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) NSSet *results;

@property (nonatomic, strong) HYBTestModel *testModel;

// 只读属性
@property (nonatomic, assign, readonly) NSString *classVersion;

// 通过这个方法来实现自动生成model
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// 转换成字典
- (NSDictionary *)toDictionary;

// 测试
+ (void)test;

@end
