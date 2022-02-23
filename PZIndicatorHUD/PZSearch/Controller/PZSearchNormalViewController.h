//
//  PZSearchNormalViewController.h
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/21.
//

#import <UIKit/UIKit.h>
#import "PZSearchConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface PZSearchNormalViewController : UIViewController
@property(nonatomic,weak) id<PZSearchChildVCDelegate> delegate;
//@property(nonatomic) NSMutableArray *historyList;
-(void) setTrendingData:(NSArray<NSString *> *)trendingList;

-(void) updateHistoryWith:(NSString *) searchText;
@end

NS_ASSUME_NONNULL_END
