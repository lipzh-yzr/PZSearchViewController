//
//  PZSearchSuggestionViewController.m
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/21.
//

#import "PZSearchSuggestionViewController.h"
#import "PZSearchSuggestBaseCell.h"
#import "PZSearchSuggestFuzzyCell.h"
#import "PZSearchSuggestConcreteCell.h"

@interface PZSearchSuggestionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@end

@implementation PZSearchSuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeTableView];
}

#pragma mark - UI
-(void) makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[PZSearchSuggestFuzzyCell class] forCellReuseIdentifier:[PZSearchSuggestBaseCell childCellIdentifierWith:PZSearchSuggestTypeFuzzy]];
    [_tableView registerClass:[PZSearchSuggestConcreteCell class] forCellReuseIdentifier:[PZSearchSuggestBaseCell childCellIdentifierWith:PZSearchSuggestTypeConcrete]];
    [self.view addSubview:_tableView];
}

#pragma mark - public
- (void)refreshSuggestViewWith:(NSArray<id<PZSearchData>> *)data {
    _data = data.copy;
    [_tableView reloadData];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<PZSearchData> model = self.data[indexPath.row];
    return [PZSearchSuggestBaseCell heightWithType:model.suggestType];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<PZSearchData> model = self.data[indexPath.row];
    PZSearchSuggestBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[PZSearchSuggestBaseCell childCellIdentifierWith:model.suggestType] forIndexPath:indexPath];
    [cell updateCellWithData:model];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchChildViewDidScroll)]) {
        [self.delegate searchChildViewDidScroll];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchChildViewDidSelectRow:)]) {
        [self.delegate searchChildViewDidSelectRow:self.data[indexPath.row]];
    }
}

@end
