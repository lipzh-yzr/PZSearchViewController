//
//  PZSearchHeaderView.m
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/22.
//

#import "PZSearchHeaderView.h"
#import "UIColor+ZQSearch.h"
#import "PZSearchConst.h"

@interface PZSearchHeaderView ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, copy) void(^block)(void);
@end

@implementation PZSearchHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor colorWithHexString:@"#494949" alpha:1];
    self.label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    [self addSubview:self.label];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.hidden = YES;
    [deleteBtn setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    deleteBtn.frame = CGRectMake(ZQSearchWidth - 30 - 10, 30, 20, 20);
    [deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    self.button = deleteBtn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = CGRectMake(20, 30, ZQSearchWidth - 40, 20);
}

- (void)showDeleteHistoryBtn:(BOOL)show CallBack:(void(^)(void))callBack {
    self.button.hidden = !show;
    self.block = callBack;
}

- (void)deleteBtnClicked {
    if (self.block) {
        self.block();
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.label.text = title;
}

@end
