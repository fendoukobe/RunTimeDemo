//
//  UIView+TapBlock.m
//  runTimeDemo
//
//  Created by apple on 16/12/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIView+TapBlock.h"
#import <objc/runtime.h>

static const void *kDTActionHandlerTapGestureKey = "ActionHandlerTapGestureKey";
static const void *kDTActionHandlerTapBlockKey = "ActionHandlerTapBlockKey";
@implementation UIView (TapBlock)

- (void)setTapActionWithBlock:(void(^)(void))block{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    if(!gesture){
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateRecognized){
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        if(action){
            action();
        }
    }
}
@end
