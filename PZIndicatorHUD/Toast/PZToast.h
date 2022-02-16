//
//  PZToast.h
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/16.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSNotificationName const PZToastWillShowNotification;
UIKIT_EXTERN NSNotificationName const PZToastDidShowNotification;
UIKIT_EXTERN NSNotificationName const PZToastWillDismissNotification;
UIKIT_EXTERN NSNotificationName const PZToastDidDismissNotification;

NS_ASSUME_NONNULL_BEGIN

@interface PZToast : UIView

#pragma mark - show toast
+(void) showMessage:(NSString *) message;

+(void) showMessage:(NSString *) message withImage:(NSString *) imageName;

+(void) showMessage:(NSString *) message withImage:(NSString *) imageName duration:(NSTimeInterval) duration;

#pragma mark - set default styles

+(void) setDefaultBgColor:(UIColor *) bgColor;
+(void) setDefaultTextColor:(UIColor *) textColor;
+(void) setDefaultDuration:(NSTimeInterval) duration;
+(void) setDefaultFadeDuration:(NSTimeInterval) fadeDuration;

@end

NS_ASSUME_NONNULL_END
