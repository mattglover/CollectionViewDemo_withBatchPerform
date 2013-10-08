//
//  MyDemoLayout.m
//  CollectionViewDemo
//
//  Created by Matt Glover on 07/10/2013.
//  Copyright (c) 2013 Duchy Software Limited. All rights reserved.
//

#import "MyDemoLayout.h"
#import "CollectionViewDataSource.h"
#import "PreviewItem.h"

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
    
    BOOL isMenuItem = [(CollectionViewDataSource *)[self collectionView].dataSource isMenuItemAtIndexPath:indexPath];
    
    CGRect cellBounds = CGRectMake(0,0, 60, 60);
    
    int column = indexPath.item % 4;
    int row = floor(indexPath.item / 4);
    
    CGFloat xOffset = 16.0f + (CGRectGetWidth(cellBounds) * column) + (16.0f * column);
    CGFloat yOffset = 16.0f + (CGRectGetHeight(cellBounds) * row) + (16.0f * row);

    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    [attributes setFrame:CGRectOffset(cellBounds, xOffset, yOffset)];
    
    if (!isMenuItem) {
        [attributes setTransform:CGAffineTransformMakeScale(0.2, 0.2)];
    }
    
    return attributes;
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    
    NSArray *visibleCells = [self.collectionView visibleCells];
    [visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!CGAffineTransformIsIdentity(cell.transform)) {
                [UIView animateWithDuration:0.4
                                 animations:^{
                                     [cell setTransform:CGAffineTransformIdentity];
                                 }];
            }
        });
    }];
}

@end
