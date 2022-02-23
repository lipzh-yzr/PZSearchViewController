//
//  PZSearchHeaderView.h
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PZSearchHeaderView : UICollectionReusableView
@property (nonatomic, strong) NSString *title;
- (void)showDeleteHistoryBtn:(BOOL)show CallBack:(void(^)(void))callBack;
@end

NS_ASSUME_NONNULL_END
