//
//  UITextView+Predict.m
//  SwizzleDemo
//
//  Created by xavior on 2019/5/8.
//  Copyright © 2019 xavior. All rights reserved.
//

#import "UITextView+Predict.h"
#import <objc/runtime.h>

@implementation UITextView (Predict)

+ (void)load{
    Class selfClass = [self class];
    SEL originSel = @selector(setDelegate:);
    Method originDelegate = class_getInstanceMethod(selfClass, originSel);
    
    
    SEL customSel = @selector(setCustomDelegate:);
    Method customDelegate = class_getInstanceMethod(selfClass, customSel);
    
    BOOL success = class_addMethod(selfClass, originSel, method_getImplementation(customDelegate), method_getTypeEncoding(customDelegate));
    if (success) {
        class_replaceMethod(selfClass, customSel, method_getImplementation(originDelegate), method_getTypeEncoding(originDelegate));
    }else{
        method_exchangeImplementations(originDelegate, customDelegate);
    }
    
}

- (void)setCustomDelegate:(id<UITextViewDelegate>)delegate{
    [self setCustomDelegate:delegate];
    [self exchangeTextViewDelegate:delegate];
    
}

- (void)exchangeTextViewDelegate:(id<UITextViewDelegate>)delegate{
    
    SEL originSel = @selector(textView:shouldChangeTextInRange:replacementText:);
    Method originMethod = class_getInstanceMethod([self class], originSel);
    
    SEL swizzleSel = @selector(swizzleTextView:shouldChangeTextInRange:replacementText:);
    Method swizzleMethod = class_getInstanceMethod([self class], swizzleSel);
    
    method_exchangeImplementations(originMethod, swizzleMethod);
}

- (BOOL)swizzleTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
     NSLog(@"swizzleTextView  input == %@",text);
    if ([text isEqualToString:@"%"]|| [text isEqualToString:@"#"]) {
        NSLog(@"不允许输入特殊字符");
        return NO;
        
    }
    return YES;
}

@end
