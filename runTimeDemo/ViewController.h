//
//  ViewController.h
//  runTimeDemo
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Person;
@interface ViewController : UIViewController{
    UIButton *_myButton;//成员变量，只能在当前类内调用
    NSString *_title;
}

@property (nonatomic,retain) UIButton *myButton;//属性，可以类外调用

@property (nonatomic,strong) Person *person;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSMutableArray *array;

@end


@interface SUTRuntimeDemo : NSObject

@end
