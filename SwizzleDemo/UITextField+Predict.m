//
//  UITextField+Predict.m
//  SwizzleDemo
//
//  Created by xavior on 2019/5/8.
//  Copyright © 2019 xavior. All rights reserved.
//

#import "UITextField+Predict.h"
#import <objc/runtime.h>

@implementation UITextField (Predict)

+ (void)load{
    Class selfClass = [self class];
    //注意这里是实例方法
    SEL originSel = @selector(setDelegate:);
    Method originDelegate = class_getInstanceMethod(selfClass, originSel);
    
    SEL customSel = @selector(setCustomDelegate:);
    Method customDelegate = class_getInstanceMethod(selfClass, customSel);
    
    method_exchangeImplementations(originDelegate, customDelegate);
}

- (void)setCustomDelegate:(id<UITextFieldDelegate>)delegate{
    //注意：这里不会引起死循环，方法已经交换过来了
    [self setCustomDelegate:delegate];
    [self exchangeDelegate:delegate];
}

//hook 代理对象的方法
- (void)exchangeDelegate:(id<UITextFieldDelegate>)delegate{
    SEL originSel = @selector(textField:shouldChangeCharactersInRange:replacementString:);
    Method originMethod = class_getInstanceMethod([delegate class], originSel);
    
    SEL swizzleSel = @selector(swizzleTextField:shouldChangeCharactersInRange:replacementString:);
    Method swizzleMethod = class_getInstanceMethod([self class], swizzleSel);
    
    BOOL success = class_addMethod([delegate class], originSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (success) {
        class_replaceMethod([self class], swizzleSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else{
        method_exchangeImplementations(originMethod, swizzleMethod);
    }
}

- (BOOL)swizzleTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"swizzleTextField input == %@", string);
    if ([string isEqualToString:@"#"] || [string isEqualToString:@"%"]) {
        NSLog(@"不能输入特殊字符");
        return NO;
        
    }
    return  YES;
}


@end
