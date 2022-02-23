//
//  PZSearchSuggestModel.h
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/23.
//

#import <UIKit/UIKit.h>
#import "PZSearchConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface PZSearchSuggestModel : NSObject<PZSearchData>
@property (nonatomic, assign) PZSearchSuggestType suggestType;

@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END
