//
//  PZSearchViewController.m
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/21.
//

#import "PZSearchViewController.h"
#import "PZSearchNormalViewController.h"
#import "PZSearchSuggestionViewController.h"
#import "Masonry.h"

#define padding 20.f
#define bottomPadding 5.f
#define naviPadding 50.f
#define itemWidth 30.f
#define itemHeight 30.f
#define searchBarH 36.f
#define naviHeight (Match_PhoneXAll ? 88.f : 64.f)

@interface PZSearchViewController ()<UITextFieldDelegate, PZSearchChildVCDelegate>

@property(nonatomic) UIView *navView;
@property(nonatomic) UIView *bodyView;
@property(nonatomic) UITextField *searchTextField;
@property(nonatomic) UIButton *cancelBtn;
@property(nonatomic) UIButton *backBtn;

@property(nonatomic) PZSearchState searchState;
@property(nonatomic) PZSearchBarState searchBarState;
@property(nonatomic) UIViewController *resultVC;
@property(nonatomic) BOOL isResultVCAccessed;
@property(nonatomic) PZSearchSuggestionViewController *suggestVC;
@property(nonatomic) PZSearchNormalViewController *normalVC;
@property(nonatomic) NSInteger inputCount;
@end

@implementation PZSearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configBaseUI];
    self.searchState = PZSearchStateNormal;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (instancetype)initWithTrending:(NSArray<NSString *> *)trendingList {
    self = [super init];
    if (self) {
        [self.normalVC setTrendingData:trendingList];
    }
    return self;
}

- (void)setResultController:(UIViewController *)resultController {
    _resultVC = resultController;
}

#pragma mark - private
-(void) configBaseUI {
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.navView];
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.offset(0);
            make.height.mas_equalTo(naviHeight);
    }];
    [self.view addSubview:self.bodyView];
    [_bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.offset(0);
        make.top.equalTo(self.navView.mas_bottom);
    }];
}

#pragma mark - getter
- (UIViewController *)resultVC {
    if (_resultVC) {
        if (!_isResultVCAccessed) {
            _isResultVCAccessed = YES;
            [self addChildViewController:_resultVC];
            [_bodyView addSubview:_resultVC.view];
            [_resultVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.offset(0);
            }];
            [_resultVC didMoveToParentViewController:self];
        }
    }
    return _resultVC;
}

- (PZSearchSuggestionViewController *)suggestVC {
    if (!_suggestVC) {
        _suggestVC = [[PZSearchSuggestionViewController alloc] init];
        _suggestVC.delegate = self;
        [self addChildViewController:_suggestVC];
        [_bodyView addSubview:_suggestVC.view];
        [_suggestVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.offset(0);
        }];
        [_suggestVC didMoveToParentViewController:self];
    }
    return _suggestVC;
}

- (PZSearchNormalViewController *)normalVC {
    if (!_normalVC) {
        _normalVC = [[PZSearchNormalViewController alloc] init];
        _normalVC.delegate = self;
    }
    return _normalVC;
}

- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] init];
        [_navView addSubview:self.searchTextField];
        [_navView addSubview:self.backBtn];
        [_navView addSubview:self.cancelBtn];
    }
    return _navView;
}

- (UIView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
        [self addChildViewController:self.normalVC];
        [_bodyView addSubview:self.normalVC.view];
        [self.normalVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.offset(0);
        }];
        [self.normalVC didMoveToParentViewController:self];
        
    }
    return _bodyView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, naviHeight - searchBarH - bottomPadding, ZQSearchWidth - 20 - itemWidth - padding, searchBarH)];
        _searchTextField.placeholder = @"搜索";
        _searchTextField.layer.cornerRadius = 2.f;
        _searchTextField.font = [UIFont systemFontOfSize:14];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_search@3x"]];
        imgView.frame = CGRectMake(15, 42, 12, 12);
        _searchTextField.leftView = imgView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        _searchTextField.delegate = self;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_searchTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [_searchTextField addTarget:self action:@selector(textFieldDidExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [_searchTextField addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    }
    return _searchTextField;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(ZQSearchWidth - 10 - itemWidth, naviHeight - itemHeight - bottomPadding - 3, itemWidth, itemHeight);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(-itemWidth, naviHeight - itemHeight - 8, itemWidth, itemHeight);
        [_backBtn setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

#pragma mark - action
-(void) textFieldChanged:(UITextField *) textField {
    NSInteger len = textField.text.length;
    if (len == 0) {
        self.searchState = PZSearchStateNormal;
    } else {
        self.searchState = PZSearchStateEditing;
        self.inputCount++;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self suggestVCNeedRefresh:self.inputCount];
        });
    }
}

-(void) textFieldDidExit:(UITextField *) textField {
    [self updateSearchHistoryWith:textField.text];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchFuzzyResultWithKeyString:Data:resultVC:)]) {
        if (_resultVC) {
            [self.delegate searchFuzzyResultWithKeyString:textField.text Data:nil resultController:self.resultVC];
        } else {
            NSLog(@"resultVC must be set before search");
        }
        
    }
    self.searchState = PZSearchStateResult;
    self.searchBarState = PZSearchBarStateBack;
    
    
}

-(void) textFieldDidBegin:(UITextField *) textField {
    self.inputCount = 0;
    self.searchBarState = PZSearchBarStateCancel;
    if (textField.text.length) {
        self.searchState = PZSearchStateEditing;
    }
}

-(void) suggestVCNeedRefresh:(NSInteger) count {
    if (count != self.inputCount) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchSuggestVCRefreshWithKeyString:dataBlock:)]) {
        [self.delegate searchSuggestVCRefreshWithKeyString:self.searchTextField.text dataBlock:^(NSArray<id<PZSearchData>> *data) {
                    [self.suggestVC refreshSuggestViewWith:data];
        }];
    }
}

-(void) cancelBtnClicked:(UIButton *) cancelBtn {
    if (self.searchTextField.text.length) {
        self.searchBarState = PZSearchBarStateBack;
        self.searchState = PZSearchStateResult;
        [self.searchTextField resignFirstResponder];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void) backBtnClicked:(UIButton *) backBtn {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - childVC delegate
- (void)searchChildViewDidSelectItem:(id)value {
    [self updateSearchHistoryWith:value];
    self.searchTextField.text = value;
    self.searchState = PZSearchStateResult;
    self.searchBarState = PZSearchBarStateBack;
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchFuzzyResultWithKeyString:Data:resultVC:)]) {
        if (_resultVC) {
            [self.delegate searchFuzzyResultWithKeyString:value Data:nil resultController:self.resultVC];
        } else {
            NSLog(@"resultVC must be set before search");
        }
    }
}

- (void)searchChildViewDidSelectRow:(id<PZSearchData>)value {
    [self updateSearchHistoryWith:value.title];
    
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
    if (value.suggestType == PZSearchSuggestTypeFuzzy) {
        self.searchState = PZSearchStateResult;
        self.searchBarState = PZSearchBarStateBack;
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchFuzzyResultWithKeyString:Data:resultVC:)]) {
            if (_resultVC) {
                [self.delegate searchFuzzyResultWithKeyString:value.title Data:value resultController:self.resultVC];
            } else {
                NSLog(@"resultVC must be set before search");
            }
        }
        self.searchTextField.text = value.title;
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchConcreteResultWithKeyString:Data:resultController:)]) {
            if (_resultVC) {
                [self.delegate searchConcreteResultWithKeyString:value.title Data:value resultController:self.resultVC];
            } else {
                NSLog(@"resultVC must be set before search");
            }
        }
    }
}

- (void)searchChildViewDidScroll {
    if (self.searchTextField.isFirstResponder) {
        [_searchTextField resignFirstResponder];
    }
}

-(void) updateSearchHistoryWith:(NSString *) searchText {
    if (searchText.length > 0) {
        [self.normalVC updateHistoryWith:searchText];
    }
}

#pragma mark - setter
- (void)setSearchState:(PZSearchState)searchState {
    if (_searchState == searchState) {
        return;
    }
    _searchState = searchState;
    
    self.suggestVC.view.hidden = YES;
    self.normalVC.view.hidden = YES;
    if (_resultVC) {
        _resultVC.view.hidden = YES;
    }
    switch (_searchState) {
        case PZSearchStateNormal:
        {
            self.normalVC.view.hidden = NO;
        }
            break;
            
        case PZSearchStateEditing:
        {
            self.suggestVC.view.hidden = NO;
        }
            break;
        
        case PZSearchStateResult:
        {
            if (_resultVC) {
                _resultVC.view.hidden = NO;
            } else {
                self.normalVC.view.hidden = NO;
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder.copy;
    self.searchTextField.placeholder = _placeHolder;
}

- (void)setSearchBarState:(PZSearchBarState)searchBarState {
    if (_searchBarState == searchBarState) {
        return;
    }
    switch (searchBarState) {
        case PZSearchBarStateCancel:
        {
            [self showCancelAnim];
            _searchBarState = PZSearchBarStateCancel;
        }
            break;
        case PZSearchBarStateBack:
        {
            [self showBackAnim];
            _searchBarState = PZSearchBarStateBack;
        }
            break;
            
        default:
            break;
    }
}

-(void) showCancelAnim {
    [UIView animateWithDuration:0.25f animations:^{
//        CGRect cannelF = self.cancelBtn.frame;
//        CGRect searchF = self.searchTextField.frame;
//        CGRect backF = self.backBtn.frame;
//
//        CGFloat offset = itemWidth + padding/2;
        
//        backF.origin.x -= offset;
//        searchF.origin.x -= offset;
//        cannelF.origin.x -= offset;
//
//        self.backBtn.frame = backF;
//        self.searchTextField.frame = searchF;
//        self.cancelBtn.frame = cannelF;
        self.backBtn.transform = CGAffineTransformIdentity;
        self.searchTextField.transform = CGAffineTransformIdentity;
        self.cancelBtn.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) showBackAnim {
    [UIView animateWithDuration:0.25f animations:^{
//        CGRect cannelF = self.cancelBtn.frame;
//        CGRect searchF = self.searchTextField.frame;
//        CGRect backF = self.backBtn.frame;
//
        CGFloat offset = itemWidth + padding/2;
        
        self.backBtn.transform = CGAffineTransformMakeTranslation(offset, 0);
        self.searchTextField.transform = CGAffineTransformMakeTranslation(offset, 0);
        self.cancelBtn.transform = CGAffineTransformMakeTranslation(offset, 0);
        
//        backF.origin.x += offset;
//        searchF.origin.x += offset;
//        cannelF.origin.x += offset;
//
//        self.backBtn.frame = backF;
//        self.searchTextField.frame = searchF;
//        self.cancelBtn.frame = cannelF;
        
    } completion:^(BOOL finished) {
        
    }];
}


@end
