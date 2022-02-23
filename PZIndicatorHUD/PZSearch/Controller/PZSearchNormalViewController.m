//
//  PZSearchNormalViewController.m
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/21.
//

#import "PZSearchNormalViewController.h"
#import "Masonry.h"
#import "PZSearchFlowLayout.h"
#import "PZSearchNormalCell.h"
#import "PZSearchHeaderView.h"

static NSString *normalHeaderIdentifier = @"headerIdentifier";
static NSString *normalCellIdentifier = @"cellIdentifier";

@interface PZSearchNormalViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic) UICollectionView *wordCV;
@property(nonatomic) NSMutableArray<NSString *> *historyList;
@property(nonatomic) NSMutableArray<NSString *> *trendingList;
@end

@implementation PZSearchNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _wordCV.delegate = self;
    _wordCV.dataSource = self;
    [_wordCV registerClass:[PZSearchNormalCell class] forCellWithReuseIdentifier:normalCellIdentifier];
    [_wordCV registerClass:[PZSearchHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:normalHeaderIdentifier];
    
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self setUpCollectionView];
}

#pragma mark - UI
-(void) setUpCollectionView {
    PZSearchFlowLayout *layout = [[PZSearchFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(15, 20, 0, 20);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _wordCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _wordCV.showsHorizontalScrollIndicator = NO;
    
    _wordCV.backgroundColor = [UIColor whiteColor];
    _wordCV.alwaysBounceVertical = YES;
    [self.view addSubview:_wordCV];
    [_wordCV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
    }];
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.trendingList.count) {
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.trendingList.count) {
        if (section == 0) {
            return self.trendingList.count;
        } else {
            return self.historyList.count;
        }
    } else {
        return self.historyList.count;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    BOOL showDeleteBtn = NO;
    
    PZSearchHeaderView *header = (PZSearchHeaderView *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:normalHeaderIdentifier forIndexPath:indexPath];
    if (self.trendingList.count) {
        header.title = indexPath.section == 0 ? @"热门搜索" : @"搜索历史";
        showDeleteBtn = indexPath.section == 1;
    } else {
        header.title = @"搜索历史";
        showDeleteBtn = indexPath.section == 0;
    }
    
    __weak typeof(self) weakSelf = self;
    [header showDeleteHistoryBtn:showDeleteBtn CallBack:^{
            [weakSelf.historyList removeAllObjects];
            [NSKeyedArchiver archiveRootObject:weakSelf.historyList toFile:ZQ_SEARCH_HISTORY_CACHE_PATH];
            [weakSelf refreshHistoryView];
    }];
    return header;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PZSearchNormalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:normalCellIdentifier forIndexPath:indexPath];
    if (self.trendingList.count) {
        cell.title = indexPath.section == 0 ? self.trendingList[indexPath.item] : self.historyList[indexPath.item];
    } else {
        cell.title = self.historyList[indexPath.item];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchChildViewDidScroll)]) {
        [self.delegate searchChildViewDidScroll];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchChildViewDidSelectItem:)]) {
        id value;
        if (self.trendingList.count) {
            value = indexPath.section == 0 ? self.trendingList[indexPath.item] : self.historyList[indexPath.item];
        } else {
            value = self.historyList[indexPath.item];
        }
        [self.delegate searchChildViewDidSelectItem:value];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width , 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *word = nil;
    if (self.trendingList.count) {
        word = indexPath.section == 0 ? self.trendingList[indexPath.item] : self.historyList[indexPath.item];
    } else {
        word = self.historyList[indexPath.item];
    }
    
    CGSize size = [word boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    return CGSizeMake(size.width + 15 * 2, 34);
}


#pragma mark - public
- (void)setTrendingData:(NSArray<NSString *> *)trendingList {
    _trendingList = trendingList.mutableCopy;
    [_wordCV reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (void)updateHistoryWith:(NSString *)searchText {
    [_historyList removeObject:searchText];
    [_historyList insertObject:searchText atIndex:0];
    
    [NSKeyedArchiver archiveRootObject:_historyList toFile:ZQ_SEARCH_HISTORY_CACHE_PATH];
    [self refreshHistoryView];
}

-(void) refreshHistoryView {
    [_wordCV reloadSections:[NSIndexSet indexSetWithIndex:1]];
}

#pragma mark - getter
- (NSMutableArray<NSString *> *)historyList {
    if (!_historyList) {
        _historyList = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:ZQ_SEARCH_HISTORY_CACHE_PATH]];
    }
    return _historyList;
}

@end
