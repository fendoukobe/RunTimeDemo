//
//  HYBPropertyLearn.m
//  runTimeDemo
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HYBPropertyLearn.h"
#import <objc/runtime.h>

@implementation HYBPropertyLearn

+ (void)test{
    HYBPropertyLearn *learn = [[HYBPropertyLearn alloc] init];
    [learn getAllProperties];
    //[learn getAllMemberVariables];
}
//获取所有的属性
- (void)getAllProperties{
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
    for (unsigned int i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        
        const char *propertyAttributes = property_getAttributes(property);
        NSLog(@"%s,   %s",propertyName,propertyAttributes);
        
        unsigned int count = 0;
        objc_property_attribute_t *attrbuties = property_copyAttributeList(property, &count);
        for (unsigned int i=0; i<count; i++) {
            objc_property_attribute_t attrbute = attrbuties[i];// objc_property_attribute_t 结构体
            const char *name = attrbute.name;
            const char *value = attrbute.value;
            
            NSLog(@"name: %s   value: %s", name, value);
        }
        free(attrbuties);
    }
    free(properties);
}

//获取所有的成员变量
- (void)getAllMemberVariables{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(self.class, &outCount);
    for (unsigned int i=0; i<outCount; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        NSLog(@"name: %s encodeType: %s", name, type);
    }
    free(ivars);
}
@end
