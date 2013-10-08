//
//  CollectionViewDataSource.m
//  CollectionViewDemo
//
//  Created by Matt Glover on 07/10/2013.
//  Copyright (c) 2013 Duchy Software Limited. All rights reserved.
//

#import "CollectionViewDataSource.h"
#import "DemoCollectionViewCell.h"
#import "MenuItem.h"
#import "PreviewItem.h"
#import "UIColor+Random.h"

NSString * const kDemoCellIdentifier = @"DemoCellIdentifier";
NSString * const kDemoCellNibName = @"DemoCollectionViewCell";

static const NSUInteger numberOfMenuItems= 1000;

@interface CollectionViewDataSource ()
@property (nonatomic, strong) NSMutableArray *menuItems;

@property (nonatomic, strong) MenuItem *currentSelectedMenuItem;
@end

@implementation CollectionViewDataSource

- (id)init {
    if ([super init]) {
        _menuItems = [NSMutableArray arrayWithCapacity:numberOfMenuItems];
        for (NSUInteger index = 0; index < numberOfMenuItems; index++) {
            MenuItem *menuItem = [[MenuItem alloc] init];
            [menuItem setColor:[UIColor randomColor]];
            [_menuItems addObject:menuItem];
        }
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_menuItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDemoCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath withItem:_menuItems[indexPath.item]];
    return cell;
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withItem:(Item *)item {
    
    DemoCollectionViewCell *demoCell = (DemoCollectionViewCell *)cell;
    [demoCell setBackgroundColor:item.color];
}

#pragma mark - Add Cell Helper
- (void)addColorToCollectionView:(UICollectionView *)collectionView {
    
    MenuItem *menuItem = [[MenuItem alloc] init];
    [menuItem setColor:[UIColor randomColor]];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:4 inSection:0];
    
    [collectionView performBatchUpdates:^{
        [_menuItems insertObject:menuItem atIndex:indexPath.item];
        NSIndexPath *insertedIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:0];
        [collectionView insertItemsAtIndexPaths:@[insertedIndexPath]];
    } completion:nil];
    
}

- (void)collectionView:(UICollectionView *)collectionView presentPreviewItemForMenuItemAtIndexPath:(NSIndexPath *)menuItemIndexPath {

    MenuItem *menuItem = _menuItems[menuItemIndexPath.item];
    
    if (menuItem == _currentSelectedMenuItem) { // <-- Reselected existing item
        
        [self removePreviewItemInCollectionView:collectionView completionBlock:nil];
        
    } else if (!_currentSelectedMenuItem) { // <-- No item currently selected
        
        // Add New Preview Item
        [self addPreviewItemInCollectionView:collectionView forMenuItem:menuItem];
        
    } else { // <-- // An Item already selected, but new different item selected
        
        // Remove Selected item
        [self removePreviewItemInCollectionView:collectionView
                                completionBlock:^(BOOL finished) {
                                    
                                    // Add New Preview Item
                                    [self addPreviewItemInCollectionView:collectionView forMenuItem:menuItem];
        }];
    }
}

#pragma mark - Preview Cell Helper
- (BOOL)isMenuItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = _menuItems[indexPath.item];
    return [item isKindOfClass:[MenuItem class]];
}

#pragma mark - Adding/Removing
- (void)addPreviewItemInCollectionView:(UICollectionView *)collectionView forMenuItem:(MenuItem *)menuItem {
    
    PreviewItem *previewItem = [[PreviewItem alloc] init];
    NSUInteger index = [_menuItems indexOfObject:menuItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index + 1 inSection:0];
    
    [collectionView performBatchUpdates:^{
        
        [_menuItems insertObject:previewItem atIndex:indexPath.item];
        NSIndexPath *insertedIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:0];
        [collectionView insertItemsAtIndexPaths:@[insertedIndexPath]];
        
    } completion:^(BOOL finished) {
        _currentSelectedMenuItem = menuItem;
    }];
}

- (void)removePreviewItemInCollectionView:(UICollectionView *)collectionView completionBlock:(void(^)(BOOL finished))removalCompletion {
    
    __block Item *previewItem = nil;
    [_menuItems enumerateObjectsUsingBlock:^(Item *item, NSUInteger idx, BOOL *stop) {
        if ([item isKindOfClass:[PreviewItem class]]) {
            previewItem = item;
            *stop = YES;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [collectionView performBatchUpdates:^{
                    
                    [_menuItems removeObject:previewItem];
                    NSIndexPath *removedIndexPath = [NSIndexPath indexPathForItem:idx inSection:0];
                    [collectionView deleteItemsAtIndexPaths:@[removedIndexPath]];
                    
                } completion:^(BOOL finished) {
                    _currentSelectedMenuItem = nil;
                    if (removalCompletion) {
                        removalCompletion(YES);
                    }
                }];
            });
        }
    }];
}

@end
