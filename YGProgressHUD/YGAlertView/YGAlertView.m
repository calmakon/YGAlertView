//
//  YGAlertView.m
//  YGProgressHUD
//
//  Created by 胡亚刚 on 16/9/6.
//  Copyright © 2016年 hu yagang. All rights reserved.
//

#import "YGAlertView.h"

#define alertWidth 260
#define hudDefaultHeight 44
#define alertDefaultHeight 140
#define animationDuratuin 0.2

typedef NS_ENUM(NSInteger,YGAlertViewType) {
    YGAlertViewTypeAlert = 0,
    YGAlertViewTypeLoading,
    YGAlertViewTypeTip
};

@interface YGAlertView ()
{
    YGAlertViewType _currentType;
    UIView * _currentView;
}
/**
 * 弹出时背景
 */
@property(nonatomic,strong)UIView * darkView;
/**
 * 弹出视图
 */
@property(nonatomic,strong)UIView * alertView;
/**
 * HUD弹出视图
 */
@property(nonatomic,strong)UIView * hudView;
/**
 * LoadingView转圈视图
 */
@property(nonatomic,strong)HYCircleLoadingView * LoadingView;
/**
 * 取消按钮
 */
@property(nonatomic,strong)UIButton * cancelBtn;
/**
 * 确认按钮
 */
@property(nonatomic,strong)UIButton * sureBtn;
/**
 * 内容label
 */
@property(nonatomic,strong)UILabel * massageLabel;

@end

@implementation YGAlertView

- (id)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.darkView];
    }

    return self;
}

+(YGAlertView *)defoultAlert
{
    static YGAlertView * alert = nil;
    if (!alert) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            alert = [[YGAlertView alloc] initWithFrame:(CGRect){0, 0, [UIScreen mainScreen].bounds.size}];
        });
    }
    return alert;
}

+(void)showAlertViewWithMassage:(NSString *)massage cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle delegate:(id<YGAlertViewDelegate>)delegate
{
    YGAlertView * alertView = [YGAlertView defoultAlert];
    [alertView initWithType:YGAlertViewTypeAlert massage:massage cancelTitle:cancelTitle sureTitle:sureTitle delegate:delegate];
    [alertView showAlert];
}

+(void)showLoadingWithMassage:(NSString *)massage
{
    YGAlertView * alertView = [YGAlertView defoultAlert];;
    [alertView initWithType:YGAlertViewTypeLoading massage:massage cancelTitle:nil sureTitle:nil delegate:nil];

    [alertView showHud];
}

+(void)showTextWithMassage:(NSString *)massage
{
    YGAlertView * alertView = [YGAlertView defoultAlert];
    [alertView initWithType:YGAlertViewTypeTip massage:massage cancelTitle:nil sureTitle:nil delegate:nil];

    [alertView showHud];
}

+(void)hudDismiss
{
    [[YGAlertView defoultAlert] dismiss];
}

- (void)showAlert {
    [self show:self.alertView];
}

- (void)showHud {
    [self show:self.hudView];
}

- (void)show:(UIView *)currentView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    currentView.center = CGPointMake(self.center.x, self.center.y);
    currentView.alpha = 0;
    [UIView animateWithDuration:animationDuratuin animations:^{
        currentView.center = CGPointMake(self.center.x, self.center.y - currentView.frame.size.height/2);
        currentView.alpha = 1;
        self.darkView.alpha = 0.3;
    }];
    if (_currentType == YGAlertViewTypeTip) {
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }
}

- (void)dismiss {
    [UIView animateWithDuration:animationDuratuin animations:^{
        _currentView.center = CGPointMake(self.center.x, self.center.y);
        _currentView.alpha = 0;
        self.darkView.alpha = 0;
    } completion:^(BOOL finished) {
        if (_currentType == YGAlertViewTypeLoading) {
            [self.LoadingView stopAnimation];
        }
        [self removeFromSuperview];
    }];
}

- (void)initWithType:(YGAlertViewType)type massage:(NSString *)massage cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle delegate:(id<YGAlertViewDelegate>)delegate{
    _currentType = type;
    if (type == YGAlertViewTypeAlert) {
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
        _currentView = self.alertView;
    }
    if (type == YGAlertViewTypeLoading ||
        type == YGAlertViewTypeTip) {
        [self.hudView addSubview:self.massageLabel];
        if (type == YGAlertViewTypeLoading) {
            [self.hudView addSubview:self.LoadingView];
            self.hudView.bounds = CGRectMake(0, 0, alertWidth / 2.0f, hudDefaultHeight);
            self.LoadingView.center = CGPointMake(self.LoadingView.center.x, hudDefaultHeight / 2.0f);
            [self.LoadingView startAnimation];
            self.massageLabel.frame = CGRectMake(CGRectGetMaxX(self.LoadingView.frame)+10, 10, self.hudView.bounds.size.width - 40 - 10, 24);
            self.massageLabel.textAlignment = NSTextAlignmentLeft;
            self.massageLabel.text = massage;
        }else {
            [self.LoadingView stopAnimation];
            [self.LoadingView removeFromSuperview];
            CGSize massageSize = [self getSizeFromString:massage];
            self.massageLabel.frame = CGRectMake(20, 10, massageSize.width, massageSize.height);
            self.massageLabel.textAlignment = NSTextAlignmentCenter;
            self.massageLabel.text = massage;
            self.hudView.bounds = CGRectMake(0, 0, alertWidth, CGRectGetMaxY(self.massageLabel.frame) + 10);
            self.massageLabel.center = CGPointMake(alertWidth / 2.0f, self.hudView.bounds.size.height / 2.0f);
        }
        _currentView = self.hudView;
    }
}

-(void)initWithMassage:(NSString *)massage cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle delegate:(id<YGAlertViewDelegate>)delegate
{
    YGAlertView * alertView = [YGAlertView defoultAlert];
    [alertView initWithType:YGAlertViewTypeAlert massage:massage cancelTitle:cancelTitle sureTitle:sureTitle delegate:delegate];
    [alertView showAlert];
}

-(void)setAlertViewCenter:(CGPoint)center
{
    self.alertView.center = center;
}

-(void)setHudViewCenter:(CGPoint)center
{
    self.hudView.center = center;
}

-(void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        //取消消失
        [self dismiss];
    }else{
        //确认
        [self dismiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuratuin * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(yg_alertView:didClickedButtonAtIndex:)]) {
                [self.delegate yg_alertView:self didClickedButtonAtIndex:sender.tag];
            }
        });
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
        _alertView.bounds = CGRectMake(0, 0, alertWidth, alertDefaultHeight);
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
        _hudView.bounds = CGRectMake(0, 0, alertWidth, hudDefaultHeight);
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
        _LoadingView = [[HYCircleLoadingView alloc] initWithFrame:CGRectMake(20, 14, 15, 15)];/*可自行修改大小、颜色*/
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

