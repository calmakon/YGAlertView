//
//  YGAlertView.h
//  YGProgressHUD
//
//  Created by 胡亚刚 on 16/9/6.
//  Copyright © 2016年 hu yagang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCircleLoadingView.h"

@class YGAlertView;
@protocol YGAlertViewDelegate <NSObject>

@optional

/**
 * 点击了buttonIndex处的按钮
 */
- (void)ygAlertView:(YGAlertView *)alertView didClickedButtonAtIndex:(NSInteger)buttonIndex;

@end
@interface YGAlertView : UIView
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
///**
// * 内容文字
// */
//@property(nonatomic,copy) NSString * massage;
/**
 * 点击事件代理
 * index
 */
@property(nonatomic,weak) id<YGAlertViewDelegate>delegate;

+(YGAlertView *)defoultAlert;
/**
 * 弹出alert视图调用方法
 */
+(void)showAlertViewWithMassage:(NSString *)massage cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle delegate:(id<YGAlertViewDelegate>)delegate;
/**
 * 弹出loadingHUD视图调用方法
 */
+(void)showHudViewWithMassage:(NSString *)massage;
/**
 * 弹出提示View,随后消失
 */
+(void)showPromptViewWithMassage:(NSString *)massage;
/**
 * 销毁loadingView
 */
+(void)HudDismiss;
@end
