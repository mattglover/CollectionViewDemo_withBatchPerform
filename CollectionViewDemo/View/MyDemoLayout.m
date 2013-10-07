//
//  MyDemoLayout.m
//  CollectionViewDemo
//
//  Created by Matt Glover on 07/10/2013.
//  Copyright (c) 2013 Duchy Software Limited. All rights reserved.
//

#import "MyDemoLayout.h"

@implementation MyDemoLayout

// Implement -layoutAttributesForElementsInRect: to return layout attributes for for supplementary or decoration views, or to perform layout in an as-needed-on-screen fashion.
// Additionally, all layout subclasses should implement -layoutAttributesForItemAtIndexPath: to return layout attributes instances on demand for specific index paths.

// return an array layout attributes instances for all the views in the given rect
- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    for (NSInteger i=0 ; i < 10; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    /*
    CGSize itemSize = [self.viewController sizeForItem:comment];
    
    attributes.frame = CGRectMake(0,0,itemSize.width, itemSize.height);
    
    float yOffset = 0;
    
    for (NSInteger i = 0; i < path.item; i++) {
        
        CGSize itemSize = [self.viewController sizeForItem:comment];
        yOffset += itemSize.height;
    }
    
    attributes.frame = CGRectOffset(attributes.frame, 0, yOffset + path.item);
    */
    
    attributes.frame = CGRectOffset(attributes.frame, 0, 0);
    
    return attributes;
}

@end
