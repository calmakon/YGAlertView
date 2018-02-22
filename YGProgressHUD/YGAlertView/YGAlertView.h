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
- (void)yg_alertView:(YGAlertView *)alertView didClickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface YGAlertView : UIView

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
+ (void)showLoadingWithMassage:(NSString *)massage;
/**
 * 弹出提示View,随后消失
 */
+ (void)showTextWithMassage:(NSString *)massage;
/**
 * 销毁loadingView
 */
+ (void)hudDismiss;
@end
