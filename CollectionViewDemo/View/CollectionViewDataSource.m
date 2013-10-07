//
//  CollectionViewDataSource.m
//  CollectionViewDemo
//
//  Created by Matt Glover on 07/10/2013.
//  Copyright (c) 2013 Duchy Software Limited. All rights reserved.
//

#import "CollectionViewDataSource.h"

NSString * const kDemoCellIdentifier = @"DemoCellIdentifier";
NSString * const kDemoCellNibName = @"DemoCollectionViewCell";

@implementation CollectionViewDataSource

- (CGSize)collectionViewContentSize {
    return CGSizeMake(320, 500);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDemoCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

@end
