//
//  PZSearchBaseCell.h
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/23.
//

#import <UIKit/UIKit.h>
#import "PZSearchConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface PZSearchSuggestBaseCell : UITableViewCell
+ (NSString *)childCellIdentifierWith:(PZSearchSuggestType)key;
+ (CGFloat)heightWithType:(PZSearchSuggestType)type;
- (void)updateCellWithData:(id<PZSearchData>)data;
@end

NS_ASSUME_NONNULL_END
