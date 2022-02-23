//
//  ViewController.m
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/15.
//

#import "ViewController.h"
#import "PZSearchViewController.h"
#import "PZSearchSuggestModel.h"

@interface ViewController ()<PZSearchVCDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.lightGrayColor;
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, ZQSearchWidth - 200, 36)];
    barView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:barView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [barView addGestureRecognizer:tap];
}

-(void) handleTap {
    NSArray *hots = @[@"热门",@"热门热门",@"热门热门热门",@"热门热门",@"热门",@"热门",@"热热门热门热门门"];
    
    PZSearchViewController *vc = [[PZSearchViewController alloc] initWithTrending:hots];
//    vc.closeFuzzyTable = YES; //关闭模糊匹配table
    vc.delegate = self;
    UIViewController *resultVC = [[UIViewController alloc] init];
    [vc setResultController:resultVC];
    [self.navigationController pushViewController:vc animated:NO];
    
}

#pragma mark - searchDelegate
- (void)searchSuggestVCRefreshWithKeyString:(NSString *)key dataBlock:(PZSuggestDataHandler)handler {
    NSMutableArray *arr = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger num = 5 + arc4random() % 10;
        for (int i = 0; i < num; i++) {
            PZSearchSuggestModel *edit = [PZSearchSuggestModel new];
//            edit.iconUrl = @"123";
            edit.image = [UIImage imageNamed:@"default"];
            edit.title = [NSString stringWithFormat:@"内容 %d", i];
            edit.desc = @"描述描述描述";
            edit.suggestType = i < 3 ? PZSearchSuggestTypeConcrete : PZSearchSuggestTypeFuzzy;
            [arr addObject:edit];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(arr.copy);
        });
    });
}

- (void)searchFuzzyResultWithKeyString:(NSString *)keyString Data:(id<PZSearchData>)data resultController:(UIViewController *)resultController {
    
}

- (void)searchConcreteResultWithKeyString:(NSString *)keyString Data:(id<PZSearchData>)data resultController:(UIViewController *)resultController {
    
}

@end
