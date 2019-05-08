//
//  ViewController.m
//  SwizzleDemo
//
//  Created by xavior on 2019/5/8.
//  Copyright © 2019 xavior. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(20, 200, 300, 30)];
    field.borderStyle =  UITextBorderStyleRoundedRect;
    //这里代理必须实现，因为需要hook需要获取代理对象
    field.delegate = self;
    [self.view addSubview:field];
    
    
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 300, 300, 50)];
    textView.backgroundColor = [UIColor grayColor];
    textView.delegate = self;
    [self.view addSubview:textView];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    return YES;
//}


@end
