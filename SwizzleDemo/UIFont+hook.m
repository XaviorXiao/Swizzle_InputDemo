//
//  UIFont+hook.m
//  SwizzleDemo
//
//  Created by xavior on 2019/5/8.
//  Copyright © 2019 xavior. All rights reserved.
//

#import "UIFont+hook.h"
#import <objc/runtime.h>



@implementation UIFont (hook)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSel = @selector(systemFontOfSize:);
        Method originMethod = class_getClassMethod(object_getClass(self), originSel);
        
        SEL customSel = @selector(customFontOfSize:);
        Method customMethod = class_getClassMethod(object_getClass(self), customSel);
        
        BOOL success = class_addMethod(object_getClass(self), originSel, method_getImplementation(customMethod), method_getTypeEncoding(customMethod));
        
        if (success) {
            class_replaceMethod(object_getClass(self), customSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        }else{
            method_exchangeImplementations(originMethod, customMethod);
        }
    });
}

+ (UIFont *)customFontOfSize:(CGFloat )size{
    CGFloat scale = [UIScreen mainScreen].bounds.size.width / 375.0;
    CGFloat tepSize = size * scale;
    return [self customFontOfSize:tepSize];
}
@end
