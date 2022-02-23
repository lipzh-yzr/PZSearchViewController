//
//  PZSearchBaseCell.m
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/23.
//

#import "PZSearchSuggestBaseCell.h"

static NSString *searchEditCellIdentifier = @"searchEditCellIdentifier";
static NSString *searchCustomCellIdentifier = @"searchCustomCellIdentifier";

@implementation PZSearchSuggestBaseCell

+ (NSString *)childCellIdentifierWith:(PZSearchSuggestType)key {
    return key == PZSearchSuggestTypeFuzzy? searchEditCellIdentifier: searchCustomCellIdentifier;
}
+ (CGFloat)heightWithType:(PZSearchSuggestType)type {
    return type == PZSearchSuggestTypeFuzzy ? 44 : 80;
}
- (void)updateCellWithData:(id<PZSearchData>)data {
    // abstract interface
}

@end
