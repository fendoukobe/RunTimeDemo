//
//  HDFArchiveModel.m
//  runTimeDemo
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HDFArchiveModel.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation HDFArchiveModel


//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);//获取所都得成员变量
    
    for (unsigned int i=0; i<outCount; i++) {
        Ivar ivar = ivars[i];
        
        //获取成员变量名
        const void *name = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:name];
        //我们获取到的属性所生成的成员变量是带下划线，因此我们需要在获取到成员变量名称后，需要去掉下划线
        //去掉成员变量的下划线
        ivarName = [ivarName substringFromIndex:1];
        
        //获取getter方法
        SEL getter = NSSelectorFromString(ivarName);
        if([self respondsToSelector:getter]){
            const void *typeEnCoding = ivar_getTypeEncoding(ivar);
            NSString *type = [NSString stringWithUTF8String:typeEnCoding];
            
            //const void *
            if([type isEqualToString:@"r^v"]){
                const char *value = ((const void*(*)(id,SEL))(void *) objc_msgSend)((id)self,getter);
                NSString *utf8Value = [NSString stringWithUTF8String:value];
                [aCoder encodeObject:utf8Value forKey:ivarName];
                continue;
                //int
            }else if([type isEqualToString:@"i"]){
                int value = ((int (*)(id,SEL))(void *)objc_msgSend)((id)self,getter);
                [aCoder encodeObject:@(value) forKey:ivarName];
                continue;
                // float
            }else if ([type isEqualToString:@"f"]){
                float value = ((float (*)(id,SEL))(void *)objc_msgSend)((id)self,getter);
                [aCoder encodeObject:@(value) forKey:ivarName];
                continue;
            }
            id value = ((id (*)(id,SEL))(void *)objc_msgSend)((id)self,getter);
            if(value != nil && [value respondsToSelector:@selector(encodeWithCoder:)]){
                [aCoder encodeObject:value forKey:ivarName];
            }
        }
        
    }
    free(ivars);
}

//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        unsigned int ooutCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &ooutCount);
        for (unsigned int i=0; i<ooutCount;i++) {
            Ivar ivar = ivars[i];
            const void *name = ivar_getName(ivar);
            NSString *ivarName = [NSString stringWithUTF8String:name];
            //去掉成员变量的下划线
            ivarName = [ivarName substringFromIndex:1];
            //生成setter格式
            NSString *setterName = ivarName;
            if(![setterName hasPrefix:@"_"]){
                NSString *firstLetter = [NSString stringWithFormat:@"%c",[setterName characterAtIndex:0]];
                setterName = [setterName substringFromIndex:1];
                setterName = [NSString stringWithFormat:@"%@%@",firstLetter.uppercaseString,setterName];
            }
            setterName = [NSString stringWithFormat:@"set%@",setterName];
            // 获取setter方法
            SEL setter = NSSelectorFromString(setterName);
            if([self respondsToSelector:setter]){
                const void *typeEnCoding = ivar_getTypeEncoding(ivar);
                NSString *type = [NSString stringWithUTF8String:typeEnCoding];
                NSLog(@"%@", type);
                
                // const void *
                if([type isEqualToString:@"r^v"]){
                    NSString *value  = [aDecoder decodeObjectForKey:ivarName];
                    if(value){
                        ((void (*)(id,SEL,const void *))objc_msgSend)(self,setter,value.UTF8String);
                    }
                    continue;
                }
                // int
                else if ([type isEqualToString:@"i"]){
                    NSNumber *value = [aDecoder decodeObjectForKey:ivarName];
                    if(value != nil){
                        ((void (*)(id,SEL,int))objc_msgSend)(self,setter,[value intValue]);
                    }
                    continue;
                }// float
                else if([type isEqualToString:@"f"]){
                    NSNumber *value = [aDecoder decodeObjectForKey:ivarName];
                    if(value != nil){
                        ((void (*)(id,SEL,float))objc_msgSend)(self,setter,[value floatValue]);
                    }
                    continue;
                }
                // object
                id value = [aDecoder decodeObjectForKey:ivarName];
                if (value != nil) {
                    ((void (*)(id, SEL, id))objc_msgSend)(self, setter, value);
                }
            }
        }
        free(ivars);
    }
    return  self;
}

+ (void)test {
    HDFArchiveModel *archiveModel = [[HDFArchiveModel alloc] init];
    archiveModel.archive = @"标哥学习自动归档";
    archiveModel.session = "http://www.henishuo.com";
    archiveModel.totalCount = @(123);
    archiveModel.referenceCount = 10;
    archiveModel._floatValue = 10.0;
    
    NSString *path = NSHomeDirectory();
    path = [NSString stringWithFormat:@"%@/archive", path];
    [NSKeyedArchiver archiveRootObject:archiveModel
                                toFile:path];
    
    HDFArchiveModel *unarchiveModel = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
}
@end
