//
//  PZSearchSuggestConcreteCell.m
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/23.
//

#import "PZSearchSuggestConcreteCell.h"
#import "UIColor+ZQSearch.h"

@interface PZSearchSuggestConcreteCell ()

@property (weak, nonatomic) UIImageView *iconImageView;
@property (weak, nonatomic) UILabel *titlelabel;
@property (weak, nonatomic) UILabel *descLabel;

@end

@implementation PZSearchSuggestConcreteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconImageView = iconView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"#494949" alpha:1];
    [self.contentView addSubview:titleLabel];
    self.titlelabel = titleLabel;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
    [self.contentView addSubview:descLabel];
    self.descLabel = descLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(15, (self.bounds.size.height - 60) / 2, 60, 60);
    CGFloat leftMargin = CGRectGetMaxX(self.iconImageView.frame) + 10;
    self.titlelabel.frame = CGRectMake(leftMargin, self.iconImageView.frame.origin.y + 5, ZQSearchWidth - leftMargin - 10, 20);
    self.descLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.titlelabel.frame) + 10, ZQSearchWidth - leftMargin - 10, 20);
}

- (void)updateCellWithData:(id<PZSearchData>)data {
    
    self.titlelabel.text = data.title;
    self.descLabel.text = data.desc;
    if (data.image) {
        self.iconImageView.image = data.image;
    }
}

@end
