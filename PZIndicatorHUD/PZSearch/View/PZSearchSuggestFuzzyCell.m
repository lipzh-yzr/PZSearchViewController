//
//  PZSearchSuggestFuzzyCell.m
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/23.
//

#import "PZSearchSuggestFuzzyCell.h"
#import "UIColor+ZQSearch.h"

@interface PZSearchSuggestFuzzyCell ()
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIImageView *iconImageView;
@end

@implementation PZSearchSuggestFuzzyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_search"]];
    [self.contentView addSubview:iconView];
    self.iconImageView = iconView;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHexString:@"#494949" alpha:1];
    [self.contentView addSubview:label];
    self.titleLabel = label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(15, (self.bounds.size.height - 12) / 2, 12, 12);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, (self.bounds.size.height - 20) / 2, ZQSearchWidth - CGRectGetMaxX(self.iconImageView.frame) - 10 * 2 , 20);
}

- (void)updateCellWithData:(id<PZSearchData>)data {
    self.titleLabel.text = [NSString stringWithFormat:@"搜索 \"%@\"",data.title];
}

@end
