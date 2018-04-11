//
//  UIControl+HYBBlock.h
//  runTimeDemo
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HYBTouchUpBlock)(id sender);

@interface UIControl (HYBBlock)

@property (nonatomic,copy) NSString *btnName;
@property (nonatomic,copy) HYBTouchUpBlock hyb_touchUpBlock;

@end
