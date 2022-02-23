//
//  PZSearchSuggestionViewController.h
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/21.
//

#import <UIKit/UIKit.h>
#import "PZSearchConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface PZSearchSuggestionViewController : UIViewController
@property(nonatomic,weak) id<PZSearchChildVCDelegate> delegate;
@property(nonatomic) NSArray<id<PZSearchData>> *data;
-(void) refreshSuggestViewWith:(NSArray<id<PZSearchData>> *) data;
@end

NS_ASSUME_NONNULL_END
