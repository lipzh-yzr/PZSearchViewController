//
//  PZSearchNormalCell.m
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/22.
//

#import "PZSearchNormalCell.h"
#import "UIColor+ZQSearch.h"

@interface PZSearchNormalCell ()
@property(nonatomic, weak) UILabel *titleLabel;
@end

@implementation PZSearchNormalCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self changeStyleWith:NO];
    }
    return self;
}

- (void)configUI {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    self.titleLabel = label;
    
    self.layer.cornerRadius = 4;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
}

- (void)changeStyleWith:(BOOL)highlightStyled {
    self.backgroundColor = highlightStyled ? [UIColor colorWithHexString:@"#00BC71" alpha:0.1] : [UIColor colorWithHexString:@"F7F7F7" alpha:1];
    self.titleLabel.textColor = highlightStyled ? [UIColor colorWithHexString:@"#00BC71" alpha:1] : [UIColor colorWithHexString:@"494949" alpha:1];
}

- (void)seHighlightStyled:(BOOL)highlightStyled {
    _highlightStyled = highlightStyled;
    [self changeStyleWith:highlightStyled];
}

- (void)setTitle:(NSString *)title {
    _title = title.copy;
    self.titleLabel.text = title;
}

@end
