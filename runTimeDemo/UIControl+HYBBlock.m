//
//  UIControl+HYBBlock.m
//  runTimeDemo
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIControl+HYBBlock.h"
#import <objc/runtime.h>

static const void *sHYBUIControlTouchUpEventBlockKey = "sHYBUIControlTouchUpEventBlockKey";
static const void *sHYBPropertyNameKey = "sHYBPropertyNameKey";
@implementation UIControl (HYBBlock)


- (void)setBtnName:(NSString *)btnName{
    objc_setAssociatedObject(self, sHYBPropertyNameKey, btnName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)btnName{
    return  objc_getAssociatedObject(self, sHYBPropertyNameKey);
}

- (void)setHyb_touchUpBlock:(HYBTouchUpBlock)hyb_touchUpBlock{
    objc_setAssociatedObject(self, sHYBUIControlTouchUpEventBlockKey, hyb_touchUpBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self removeTarget:self action:@selector(hybOnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    if(hyb_touchUpBlock){
        [self addTarget:self action:@selector(hybOnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (HYBTouchUpBlock)hyb_touchUpBlock{
    return objc_getAssociatedObject(self, sHYBUIControlTouchUpEventBlockKey);
}

- (void)hybOnTouchUp:(UIButton *)sender{
    HYBTouchUpBlock touchUp = self.hyb_touchUpBlock;
    if(touchUp){
        touchUp(sender);
    }
}
@end
