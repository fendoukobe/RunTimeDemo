//
//  Person.m
//  runTimeDemo
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
static NSMutableDictionary *map = nil;
@interface Person()
{
    NSString *_name;
}
@end
@implementation Person
@synthesize name = _name;//@synthesize的作用是让编译器为你自动生成setter和getter方法，还可以指定与属性对应的实例变量，比如属性name,如果在.m文件中写了@synthesize name，那么编译器就会自动生成name的实例变量以及相应的getter和setter方法，注意，这个是时候实例变量并不是_name,如果没写，实例变量则是_name，如果写成@synthesize name = _name就将属性（name）和实例变量(_name)对应起来
+ (void)load{
    map = [NSMutableDictionary dictionary];
    map[@"name1"] = @"name";
    map[@"status1"] = @"status";
    map[@"name2"] = @"name";
    map[@"status2"] = @"status";
}
- (NSString *)name{
    return _name;
}
- (void)setName:(NSString *)name{
    _name = name;
    NSLog(@"%@",_name);
}
- (void)setDataWithDic:(NSDictionary *)dic{
    
    //NSLog(@"%d",self.retainCount);
    self.name = @"123";
   // NSLog(@"%d",self.retainCount);
    _name = @"23";
    //NSLog(@"%d",self.retainCount);
    
   [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  obj, BOOL * stop) {
       NSLog(@"%@-----%@",key,obj);
       
       
       NSString *propertyKey = [self propertyForKey:key];
       if(propertyKey){
           objc_property_t property = class_getProperty([self class], [propertyKey UTF8String]);
           
           
           
           // TODO: 针对特殊数据类型做处理
           
          // NSString *attributeString = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
           
           [self setValue:obj forKey:propertyKey];
       }
   }];
}

- (NSString *)propertyForKey:(NSString *)key{
    return [map objectForKey:key];
}
- (void)method1{
    Ivar ivar1 = class_getInstanceVariable([self class], "_name");
    NSString *name = object_getIvar(self, ivar1);
     Ivar ivar2 = class_getInstanceVariable([self class], "_studyNo");
    NSString *studyNo = object_getIvar(self, ivar2);
    
}
/*
 // 属性操作
 
 objc_property_t * properties = class_copyPropertyList(cls, &outCount);
 
 for (int i = 0; i < outCount; i++) {
 
 objc_property_t property = properties[i];
 
 NSLog(@"property's name: %s", property_getName(property));
 
 }
 
 
 
 free(properties);
 */

@end
