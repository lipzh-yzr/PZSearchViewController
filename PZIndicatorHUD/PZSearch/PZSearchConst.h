//
//  PZSearchConst.h
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/21.
//

#ifndef PZSearchConst_h
#define PZSearchConst_h

#define ZQ_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ZQSearchhistories.plist"] // the path of search record cached

#define ZQSearchWidth [UIScreen mainScreen].bounds.size.width
#define ZQSearchHeight [UIScreen mainScreen].bounds.size.height

//判断iPhoneX所有系列
#define Match_PhoneXAll ({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);\
})

#define k_Height_NavContentBar 44.0f
#define k_Height_StatusBar (Match_PhoneXAll? 44.0 : 20.0)
#define k_Height_NavBar (Match_PhoneXAll ? 88.0 : 64.0)
#define k_Height_TabBar (Match_PhoneXAll ? 83.0 : 49.0)

typedef NS_ENUM(NSUInteger, PZSearchSuggestType) {
    PZSearchSuggestTypeFuzzy,
    PZSearchSuggestTypeConcrete,
};

@protocol PZSearchData <NSObject>
@required
@property(nonatomic, copy) NSString *title;

@optional
@property(nonatomic) PZSearchSuggestType suggestType;
@property(nonatomic) UIImage *image;
@property(nonatomic,copy) NSString *desc;


@end

@protocol PZSearchChildVCDelegate <NSObject>

- (void)searchChildViewDidScroll;

- (void)searchChildViewDidSelectItem:(id)value;
- (void)searchChildViewDidSelectRow:(id<PZSearchData>)value;

@end


#endif /* PZSearchConst_h */
