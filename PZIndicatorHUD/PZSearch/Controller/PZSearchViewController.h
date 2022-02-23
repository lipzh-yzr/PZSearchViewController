//
//  PZSearchViewController.h
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/21.
//

#import <UIKit/UIKit.h>
#import "PZSearchConst.h"

typedef NS_ENUM(NSUInteger, PZSearchState) {
    PZSearchStateNormal = 1,
    PZSearchStateEditing,
    PZSearchStateResult,
};

typedef NS_ENUM(NSUInteger, PZSearchBarState) {
    PZSearchBarStateNone = 1,
    PZSearchBarStateCancel,
    PZSearchBarStateBack,
};
typedef void(^PZSuggestDataHandler)(NSArray<id<PZSearchData>> *data);

@protocol PZSearchVCDelegate <NSObject>

@required
-(void) searchFuzzyResultWithKeyString:(NSString *) keyString Data:(id<PZSearchData>) data resultController:(UIViewController *) resultController;
@optional
-(void) searchSuggestVCRefreshWithKeyString:(NSString *) key dataBlock:(PZSuggestDataHandler) handler;
-(void) searchConcreteResultWithKeyString:(NSString *) keyString Data:(id<PZSearchData>) data resultController:(UIViewController *) resultController;

@end

@interface PZSearchViewController : UIViewController
@property(nonatomic, weak) id<PZSearchVCDelegate> delegate;
@property(nonatomic, copy) NSString *placeHolder;

-(instancetype) initWithTrending:(NSArray<NSString *> *) trendingList;
-(void) setResultController:(UIViewController *) resultController;

@end


