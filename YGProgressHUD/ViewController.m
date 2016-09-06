//
//  ViewController.m
//  YGProgressHUD
//
//  Created by 胡亚刚 on 16/9/6.
//  Copyright © 2016年 hu yagang. All rights reserved.
//

#import "ViewController.h"
#import "YGAlertView.h"
@interface ViewController ()<YGAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 30);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"加载" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)addClick
{
    [YGAlertView showAlertViewWithMassage:@"提示" cancelTitle:@"取消" sureTitle:@"确定" delegate:self];
    //[self performSelector:@selector(missClick) withObject:self afterDelay:2];
}

-(void)missClick
{
    [YGAlertView HudDismiss];
}

-(void)ygAlertView:(YGAlertView *)alertView didClickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
