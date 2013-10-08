//
//  CollectionViewDataSource.h
//  CollectionViewDemo
//
//  Created by Matt Glover on 07/10/2013.
//  Copyright (c) 2013 Duchy Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kDemoCellIdentifier;
extern NSString * const kDemoCellNibName;

@class MenuItem;
@interface CollectionViewDataSource : NSObject <UICollectionViewDataSource>

- (void)addColorToCollectionView:(UICollectionView *)collectionView;

- (BOOL)isMenuItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)insertPreviewForMenuItemAtIndexPath:(NSIndexPath *)menuItemIndexPath toCollectionView:(UICollectionView *)collectionView;

@end
