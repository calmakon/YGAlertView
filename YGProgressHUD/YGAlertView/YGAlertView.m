//
//  YGAlertView.m
//  YGProgressHUD
//
//  Created by 胡亚刚 on 16/9/6.
//  Copyright © 2016年 hu yagang. All rights reserved.
//

#import "YGAlertView.h"

#define alertWidth 260
#define alertDefoultHeight 140

static YGAlertView *hudAlert = nil;

@implementation YGAlertView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.darkView];
    }
    
    return self;
}

+(YGAlertView *)defoultAlert
{
    if (!hudAlert) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            hudAlert = [[YGAlertView alloc] initWithFrame:(CGRect){0, 0, [UIScreen mainScreen].bounds.size}];
        });
    }
    return hudAlert;
}

+(void)showAlertViewWithMassage:(NSString *)massage cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle delegate:(id<YGAlertViewDelegate>)delegate
{
    YGAlertView * alertView = [[YGAlertView alloc] initWithMassage:massage cancelTitle:cancelTitle sureTitle:sureTitle delegate:delegate];
    
    [alertView showAlert];
}

+(void)showHudViewWithMassage:(NSString *)massage
{
    
    YGAlertView * alertView = [YGAlertView defoultAlert];;
    [alertView initWithMassage:massage isLoad:YES];
    
    [alertView showHud:YES];
}

+(void)showPromptViewWithMassage:(NSString *)massage
{
    YGAlertView * alertView = [YGAlertView defoultAlert];
    [alertView initWithMassage:massage isLoad:NO];
    
    [alertView showHud:NO];
}

+(void)HudDismiss
{
    [[YGAlertView defoultAlert] hudDismiss];
}

-(void)showHud:(BOOL)isLoad
{
    self.hudView.center = CGPointMake(self.center.x, self.center.y);
    self.hudView.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.hudView.center = CGPointMake(self.center.x, self.center.y-self.hudView.frame.size.height/2);
        self.hudView.alpha = 1;
        self.darkView.alpha = 0.3;
    }];
    // [self bringSubviewToFront:self.hudView];
    if (!isLoad) {
        [self performSelector:@selector(hudDismiss) withObject:nil afterDelay:1.5];
    }
}

-(void)showAlert
{
    self.alertView.center = CGPointMake(self.center.x, self.center.y);
    self.alertView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.center = CGPointMake(self.center.x, self.center.y-self.alertView.frame.size.height/2);
        self.alertView.alpha = 1;
        self.darkView.alpha = 0.3;
    }];
    // [self bringSubviewToFront:self.alertView];
}

-(void)alertDismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.center = CGPointMake(self.center.x, self.center.y);
        self.alertView.alpha = 0;
        self.darkView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)hudDismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.hudView.center = CGPointMake(self.center.x, self.center.y);
        self.hudView.alpha = 0;
        self.darkView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.LoadingView stopAnimation];
        [self removeFromSuperview];
    }];
}

-(id)initWithMassage:(NSString *)massage cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle delegate:(id<YGAlertViewDelegate>)delegate
{
    if (self = [self init]) {
        [self addSubview:self.darkView];
        self.delegate = delegate;
        
        CGSize massageSize = [self getSizeFromString:massage];
        self.massageLabel.text = massage;
        self.massageLabel.frame = CGRectMake(20, 20, alertWidth-40, massageSize.height);
        [self.alertView addSubview:self.massageLabel];
        
        UIView * lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        lineView.frame = CGRectMake(0, CGRectGetMaxY(self.massageLabel.frame)+20, alertWidth, 1);
        
        UIView * lineView2 = [UIView new];
        lineView2.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        lineView2.frame = CGRectMake(alertWidth/2, CGRectGetMaxY(self.massageLabel.frame)+20, 1, 44);
        
        [self.alertView addSubview:lineView];
        [self.alertView addSubview:lineView2];
        
        self.alertView.bounds = CGRectMake(0, 0, alertWidth, CGRectGetMaxY(lineView2.frame));
        
        if (cancelTitle && sureTitle) {
            self.cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(self.massageLabel.frame)+21, alertWidth/2, 43);
            [self.cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
            
            self.sureBtn.frame = CGRectMake(alertWidth/2, CGRectGetMaxY(self.massageLabel.frame)+21, alertWidth/2, 43);
            [self.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
            [self.alertView addSubview:self.cancelBtn];
            [self.alertView addSubview:self.sureBtn];
        }else{
            NSString * title = nil;
            if (cancelTitle) {
                title = cancelTitle;
            }else{
                title = sureTitle;
            }
            self.sureBtn.frame = CGRectMake(0, CGRectGetMaxY(self.massageLabel.frame)+21, alertWidth, 43);
            [self.sureBtn setTitle:title forState:UIControlStateNormal];
            [self.alertView addSubview:self.sureBtn];
            lineView2.hidden = YES;
        }
        
        self.frame = (CGRect){0, 0, [UIScreen mainScreen].bounds.size};
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    return self;
}

-(void)setAlertViewCenter:(CGPoint)center
{
    self.alertView.center = center;
}

-(void)setHudViewCenter:(CGPoint)center
{
    self.hudView.center = center;
}

-(void)initWithMassage:(NSString *)massage isLoad:(BOOL)isLoad
{
    if (isLoad) {
        [self.hudView addSubview:self.LoadingView];
        [self.LoadingView startAnimation];
        self.massageLabel.frame = CGRectMake(CGRectGetMaxX(self.LoadingView.frame)+10, 10, alertWidth-40-55, 20);
        self.massageLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        self.massageLabel.frame = CGRectMake(20, 10, alertWidth-80, 20);
        self.massageLabel.textAlignment = NSTextAlignmentCenter;
    }
    self.massageLabel.text = massage;
    [self.hudView addSubview:self.massageLabel];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        //取消消失
        [self alertDismiss];
    }else{
        //确认
        [self alertDismiss];
        if ([self.delegate respondsToSelector:@selector(ygAlertView:didClickedButtonAtIndex:)]) {
            [self.delegate ygAlertView:self didClickedButtonAtIndex:sender.tag];
        }
    }
}

-(UIView *)darkView
{
    if (!_darkView) {
        _darkView = [[UIView alloc] init];
        _darkView.backgroundColor = [UIColor colorWithRed:0.87 green:0.93 blue:0.98 alpha:1];
        _darkView.alpha = 0;
        _darkView.frame = (CGRect){0, 0, [UIScreen mainScreen].bounds.size};
    }
    return _darkView;
}

-(UIView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1];
        _alertView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _alertView.layer.shadowOffset = CGSizeMake(2, 1);
        _alertView.layer.shadowOpacity = 1;
        _alertView.bounds = CGRectMake(0, 0, alertWidth, alertDefoultHeight);
        [self addSubview:_alertView];
    }
    return _alertView;
}

-(UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"text_bg"] forState:UIControlStateHighlighted];
        _cancelBtn.tag = 100;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitleColor:[UIColor colorWithRed:0.21 green:0.64 blue:0.86 alpha:1] forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"text_bg"] forState:UIControlStateHighlighted];
        _sureBtn.tag = 200;
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

-(UIView *)hudView
{
    if (!_hudView) {
        _hudView = [[UIView alloc] init];
        _hudView.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1];
        _hudView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _hudView.layer.shadowOffset = CGSizeMake(2, 1);
        _hudView.layer.shadowOpacity = 1;
        _hudView.bounds = CGRectMake(0, 0, alertWidth-40, 40);
        [self addSubview:_hudView];
    }
    return _hudView;
}

-(UILabel *)massageLabel
{
    if (!_massageLabel) {
        _massageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, alertWidth-40, 20)];
        _massageLabel.textAlignment = NSTextAlignmentCenter;
        _massageLabel.numberOfLines = 0;
        _massageLabel.textColor = [UIColor darkGrayColor];
        _massageLabel.font = [UIFont systemFontOfSize:15];
    }
    return _massageLabel;
}

-(HYCircleLoadingView *)LoadingView
{
    if (!_LoadingView) {
        _LoadingView = [[HYCircleLoadingView alloc] initWithFrame:CGRectMake(30, 12, 15, 15)];/*可自行修改大小、颜色*/
        _LoadingView.lineColor = [UIColor colorWithRed:0.21 green:0.64 blue:0.85 alpha:1];
        _LoadingView.lineWidth = 1;
    }
    return _LoadingView;
}

-(CGSize)getSizeFromString:(NSString*)_theString
{
    CGSize size = CGSizeMake(alertWidth-40, MAXFLOAT);
    
    CGSize tempSize = [_theString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    return tempSize;
}

-(void)dealloc
{
    
}


@end
