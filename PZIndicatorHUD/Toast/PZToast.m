//
//  PZToast.m
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/16.
//

#import "PZToast.h"
#import "Masonry.h"

NSNotificationName const PZToastWillShowNotification = @"PZToastWillShowNotification";
NSNotificationName const PZToastDidShowNotification = @"PZToastDidShowNotification";
NSNotificationName const PZToastWillDismissNotification = @"PZToastWillDismissNotification";
NSNotificationName const PZToastDidDismissNotification = @"PZToastDidDismissNotification";

typedef NS_ENUM(NSUInteger, PZToastStyle) {
    PZToastStyleText,
    PZToastStyleTextWithImage,
    PZToastStyleLikeIcon,
};

// toast初始背景颜色
static UIColor *PZToastInitialBackgroundColor;
// toast初始文本颜色
static UIColor *PZToastInitialTextColor;
// toast初始展示时间
static NSTimeInterval PZToastInitialDuration;
// toast初始消失时间
static NSTimeInterval PZToastInitialFadeDuration;

// toast默认背景颜色
static UIColor *PZToastDefaultBackgroundColor;
// toast默认文本颜色
static UIColor *PZToastDefaultTextColor;
// toast默认展示时间
static NSTimeInterval PZToastDefaultDuration;
// toast默认消失时间
static NSTimeInterval PZToastDefaultFadeDuration;

@interface PZToast ()
@property(nonatomic) UILabel *messageLabel;
@property(nonatomic) UIImageView *imageView;
@end

@implementation PZToast

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (void)initialize
{
    if (self == [PZToast class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //========== 设置初始值 ==========//
            PZToastInitialBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
            PZToastInitialTextColor       = [UIColor whiteColor];
            PZToastInitialDuration     = 2;
            PZToastInitialFadeDuration = 0.3;
            
            //========== 设置初始默认值 ==========//
            PZToastDefaultBackgroundColor = PZToastInitialBackgroundColor;
            PZToastDefaultTextColor       = PZToastInitialTextColor;
            PZToastDefaultDuration        = PZToastInitialDuration;
            PZToastDefaultFadeDuration    = PZToastInitialFadeDuration;
        });
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _messageLabel = [[UILabel alloc] init];
        [self addSubview:_messageLabel];
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        self.layer.cornerRadius = 5;
        self.backgroundColor = PZToastDefaultBackgroundColor?:PZToastInitialBackgroundColor;
        _messageLabel.textColor = PZToastDefaultTextColor?:PZToastInitialTextColor;
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(void)p_setUpText:(NSString *) text {
    _messageLabel.text = text;
    _messageLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [[UIApplication sharedApplication].windows.lastObject addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.bottom.equalTo(self.superview).offset(-100);
            make.top.leading.equalTo(self.messageLabel).offset(-20);
            make.bottom.trailing.equalTo(self.messageLabel).offset(20);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_lessThanOrEqualTo(140);
        make.center.equalTo(self);
    }];
}

-(void)p_setUpText:(NSString *) text image:(NSString *) imageName {
    _messageLabel.text = text;
    _messageLabel.font = [UIFont boldSystemFontOfSize:22];
    
    _imageView.image = [UIImage imageNamed:imageName];
    
    [[UIApplication sharedApplication].windows.lastObject addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.superview);
        make.width.mas_equalTo(150);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset(20);
            make.size.mas_equalTo(CGSizeMake(34, 34));
            
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_lessThanOrEqualTo(130);
            make.centerX.offset(0);
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
        make.bottom.offset(-18);
    }];
}

-(void)p_setUpText:(NSString *) text image:(NSString *) image style:(PZToastStyle) style {
    switch (style) {
        case PZToastStyleText:
        {
            [self p_setUpText:text];
        }
            break;
        
        case PZToastStyleTextWithImage:
        {
            [self p_setUpText:text image:image];
        }
            break;
            
        default:
            break;
    }
}



#pragma mark - show toast
+(void) showMessage:(NSString *) message {
    [PZToast p_showMessage:message withImage:nil duration:PZToastDefaultDuration style:PZToastStyleText];
}

+(void) showMessage:(NSString *) message withImage:(NSString *) imageName {
    [PZToast p_showMessage:message withImage:imageName duration:PZToastDefaultDuration style:PZToastStyleTextWithImage];
}

+(void) showMessage:(NSString *) message withImage:(NSString *) imageName duration:(NSTimeInterval) duration {
    [PZToast p_showMessage:message withImage:imageName duration:duration style:PZToastStyleTextWithImage];
}

+(void) p_showMessage:(NSString *) message withImage:(NSString *) imageName duration:(NSTimeInterval) duration style:(PZToastStyle) style {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSNotificationCenter.defaultCenter postNotificationName:PZToastWillShowNotification object:self];
        PZToast *toast = [[PZToast alloc] init];
        [toast p_setUpText:message image:imageName style:style];
        
        [NSNotificationCenter.defaultCenter postNotificationName:PZToastDidShowNotification object:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(PZToastDefaultDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [NSNotificationCenter.defaultCenter postNotificationName:PZToastWillDismissNotification object:self];
            [UIView animateWithDuration:PZToastDefaultFadeDuration animations:^{
                toast.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    [toast removeFromSuperview];
                    [NSNotificationCenter.defaultCenter postNotificationName:PZToastDidDismissNotification object:self];
                }
            }];
        });
    });
}

#pragma mark - set default styles

+(void) setDefaultBgColor:(UIColor *) bgColor {
    PZToastDefaultBackgroundColor = bgColor;
}
+(void) setDefaultTextColor:(UIColor *) textColor {
    PZToastDefaultTextColor = textColor;
}
+(void) setDefaultDuration:(NSTimeInterval) duration {
    PZToastDefaultDuration = duration;
}
+(void) setDefaultFadeDuration:(NSTimeInterval) fadeDuration {
    PZToastInitialFadeDuration = fadeDuration;
}

@end
