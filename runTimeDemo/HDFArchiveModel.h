//
//  HDFArchiveModel.h
//  runTimeDemo
//  自动归档，解档
//  Created by apple on 16/11/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDFArchiveModel : NSObject<NSCoding>//遵守了NSCoding协议之后，我们就可以在实现文件中实现-encodeWithCoder:方法来归档和-initWithCoder:解档。

@property (nonatomic, assign) int    referenceCount;
@property (nonatomic, copy) NSString *archive;
@property (nonatomic, assign) const void *session;
@property (nonatomic, strong) NSNumber *totalCount;
// 注意，这里只是为了测试一下属性使用下划线的情况
@property (nonatomic, assign) float  _floatValue;

+ (void)test;
@end
