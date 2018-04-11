//
//  UIView+TapBlock.h
//  runTimeDemo
//
//  Created by apple on 16/12/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TapBlock)
- (void)setTapActionWithBlock:(void(^)(void))block;
@end
