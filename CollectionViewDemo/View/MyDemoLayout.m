//
//  MyDemoLayout.m
//  CollectionViewDemo
//
//  Created by Matt Glover on 07/10/2013.
//  Copyright (c) 2013 Duchy Software Limited. All rights reserved.
//

#import "MyDemoLayout.h"

@implementation MyDemoLayout

- (CGSize)collectionViewContentSize {
    
    NSArray *layoutAttributes = [self layoutAttributesForElementsInRect:self.collectionView.bounds];
    UICollectionViewLayoutAttributes *lastItemAttributes = [layoutAttributes lastObject];
    
    return CGSizeMake(CGRectGetMaxX(lastItemAttributes.frame), CGRectGetMaxY(lastItemAttributes.frame));
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSUInteger totalNumberOfItems = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    
    NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:totalNumberOfItems];
    
    for (NSInteger index = 0 ; index < totalNumberOfItems; index++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect cellBounds = CGRectMake(0,0,300, 50);
    
    CGFloat xOffset = 10.0f;
    CGFloat yOffset = (indexPath.item * 50) + (indexPath.item * 1);

    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    [attributes setFrame:CGRectOffset(cellBounds, xOffset, yOffset)];
    
    return attributes;
}

@end
