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

@interface MyDemoLayout()
@property (nonatomic, assign) BOOL foundPreviewItem;
@property (nonatomic, assign) int  foundPreviewItemRow;

@property (nonatomic, strong) NSMutableArray *insertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *removedIndexPaths;

@end

@implementation MyDemoLayout

- (CGSize)collectionViewContentSize {
    
    NSArray *layoutAttributes = [self layoutAttributesForElementsInRect:self.collectionView.bounds];
    UICollectionViewLayoutAttributes *lastItemAttributes = [layoutAttributes lastObject];
    
    return CGSizeMake(CGRectGetMaxX(lastItemAttributes.frame), CGRectGetMaxY(lastItemAttributes.frame));
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSUInteger totalNumberOfItems = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    
    NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:totalNumberOfItems];
    
    self.foundPreviewItem = NO;
    self.foundPreviewItemRow = 0;
    for (NSInteger index = 0 ; index < totalNumberOfItems; index++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    return attributes;
}

// Preview Cell to appear to the right of the Selected MenuItem (same size as the Menu Item)
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    CGFloat spacer = 16.0f; // distance between the cells (all sides)
//    CGRect menuItemBounds = CGRectMake(0,0, 60, 60);
//
//    int column = indexPath.item % 4;
//    int row    = floor(indexPath.item / 4);
//
//    CGFloat xOffset = spacer + (CGRectGetWidth(menuItemBounds) * column) + (spacer * column);
//    CGFloat yOffset = spacer + (CGRectGetHeight(menuItemBounds) * row) + (spacer * row);
//
//    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    [attributes setFrame:CGRectOffset(menuItemBounds, xOffset, yOffset)];
//
//    return attributes;
//}

// Preview Cell to appear as a large block under the Selected Menu Item
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat spacer = 16.0f; // distance between the cells (all sides)
    CGRect menuItemBounds = CGRectMake(0,0, 60, 60);
    CGRect previewItemBounds = CGRectMake(0,0, 288, 76); //76 or 136 or 196 or 256
    
    BOOL isMenuItem = [(CollectionViewDataSource *)[self collectionView].dataSource isMenuItemAtIndexPath:indexPath];
    
    if (!isMenuItem) {
        self.foundPreviewItem = YES;
    }
    
    CGRect cellBounds = isMenuItem ? menuItemBounds : previewItemBounds;
    
    int column = self.foundPreviewItem ? (indexPath.item -1) % 4 : indexPath.item % 4;
    int row =    self.foundPreviewItem ? floor((indexPath.item-1) / 4) : floor(indexPath.item / 4);
    
    if (!isMenuItem) {
        self.foundPreviewItemRow = row;
    }
    
    CGFloat xOffset = isMenuItem ? spacer + (CGRectGetWidth(cellBounds) * column) + (spacer * column) : spacer;
    CGFloat yOffset = isMenuItem ? spacer + (CGRectGetHeight(menuItemBounds) * row) + (spacer * row) :
    spacer + (CGRectGetHeight(menuItemBounds) * row) + (spacer * row) + CGRectGetHeight(menuItemBounds) + spacer ;
    
    // shuffle the MenuItem down by the height of the PreviewItem + a spacer
    if (self.foundPreviewItem && isMenuItem) {
        yOffset += (CGRectGetHeight(previewItemBounds) + spacer);
    }
    
    // however, if the MenuItem is on the same calculated row as the preview then shuffle it back up
    if (self.foundPreviewItem && row == self.foundPreviewItemRow && isMenuItem) {
        yOffset -= (CGRectGetHeight(previewItemBounds) + spacer);
    }
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    [attributes setFrame:CGRectOffset(cellBounds, xOffset, yOffset)];
    
    return attributes;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    self.insertedIndexPaths = [NSMutableArray array];
    self.removedIndexPaths  = [NSMutableArray array];
    
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            [self.insertedIndexPaths addObject:updateItem.indexPathAfterUpdate];
        } else if (updateItem.updateAction == UICollectionUpdateActionDelete) {
            [self.removedIndexPaths addObject:updateItem.indexPathBeforeUpdate];
        }
    }];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([self.insertedIndexPaths containsObject:itemIndexPath])  {
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, -CGRectGetWidth(self.collectionView.bounds), 0);
        transform = CGAffineTransformScale(transform, 0.1, 0.1);
        
        attributes.transform = transform;
        attributes.alpha = 0.0f;
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.removedIndexPaths containsObject:itemIndexPath]) {
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, CGRectGetWidth(self.collectionView.bounds), 0);
        transform = CGAffineTransformScale(transform, 0.1, 0.1);
        
        attributes.transform = transform;
        attributes.alpha = 0.0f;
    }
    
    return attributes;
}

@end
