//
//  PZSearchFlowLayout.m
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/23.
//

#import "PZSearchFlowLayout.h"

@implementation PZSearchFlowLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxInteritemSpacing = 10;
    }
    return self;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
    
    for (int i = 1; i < attrs.count; i++) {
        UICollectionViewLayoutAttributes *curAttr = attrs[i];
        UICollectionViewLayoutAttributes *preAttr = attrs[i-1];
        
        CGFloat targetX = CGRectGetMaxX(preAttr.frame) + _maxInteritemSpacing;
        if (CGRectGetMinX(curAttr.frame) > targetX && targetX + CGRectGetWidth(curAttr.frame) < self.collectionViewContentSize.width) {
            CGRect frame = curAttr.frame;
            frame.origin.x = targetX;
            curAttr.frame = frame;
        }
    }
    return attrs;
}

@end
