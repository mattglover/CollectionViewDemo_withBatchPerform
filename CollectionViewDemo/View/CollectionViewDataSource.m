//
//  CollectionViewDataSource.m
//  CollectionViewDemo
//
//  Created by Matt Glover on 07/10/2013.
//  Copyright (c) 2013 Duchy Software Limited. All rights reserved.
//

#import "CollectionViewDataSource.h"
#import "DemoCollectionViewCell.h"
#import "UIColor+Random.h"

NSString * const kDemoCellIdentifier = @"DemoCellIdentifier";
NSString * const kDemoCellNibName = @"DemoCollectionViewCell";

static const NSUInteger numberOfCells = 1000;

@interface CollectionViewDataSource ()
@property (nonatomic, strong) NSMutableArray *colors;
@end

@implementation CollectionViewDataSource

- (id)init {
    if ([super init]) {
        NSMutableArray *colors = [NSMutableArray arrayWithCapacity:numberOfCells];
        for (NSUInteger index = 0; index < numberOfCells; index++) {
            [colors addObject:[UIColor randomColor]];
        }
        _colors = colors;
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_colors count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDemoCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath withTitle:[NSString stringWithFormat:@"This is cell index : %ld of %lu", (long)indexPath.item, (unsigned long)[_colors count]]];
    return cell;
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withTitle:(NSString *)titleString {
    
    DemoCollectionViewCell *demoCell = (DemoCollectionViewCell *)cell;
    [demoCell setBackgroundColor:_colors[indexPath.item]];
    [demoCell.titleLabel setText:titleString];
}

- (void)addColorToCollectionView:(UICollectionView *)collectionView {
    
    UIColor *newColor = [UIColor randomColor];
    
    [collectionView performBatchUpdates:^{
        
        [_colors insertObject:newColor atIndex:4];
        NSIndexPath *insertedIndexPath = [NSIndexPath indexPathForItem:4 inSection:0];
        [collectionView insertItemsAtIndexPaths:@[insertedIndexPath]];
        
    } completion:^(BOOL finished) {
        NSLog(@"Completed Insertion");
    }];
}

@end
