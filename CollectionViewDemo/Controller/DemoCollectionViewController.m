//
//  DemoCollectionViewController.m
//  CollectionViewDemo
//
//  Created by Matt Glover on 07/10/2013.
//  Copyright (c) 2013 Duchy Software Limited. All rights reserved.
//

#import "DemoCollectionViewController.h"

#import "MyDemoLayout.h"
#import "CollectionViewDataSource.h"

@interface DemoCollectionViewController () <UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CollectionViewDataSource *dataSource;

@end

@implementation DemoCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[CollectionViewDataSource alloc] init];
    MyDemoLayout *demoLayout = [[MyDemoLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:demoLayout];
    [_collectionView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setShowsVerticalScrollIndicator:YES];
    [self registerNIBsForCollectionView:_collectionView];
    [_collectionView setDataSource:_dataSource];
    [_collectionView setDelegate:self];
    [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_collectionView];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addColor:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    UIBarButtonItem *autoScrollToCell500Button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(autoScroll:)];
    [self.navigationItem setLeftBarButtonItem:autoScrollToCell500Button];
}

- (void)registerNIBsForCollectionView:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:kDemoCellNibName bundle:nil] forCellWithReuseIdentifier:kDemoCellIdentifier];
}

- (void)addColor:(id)sender {
    [self.dataSource addColorToCollectionView:_collectionView];
}

- (void)autoScroll:(id)sender {
    
    //AutoScroll to the 500th cell
    NSIndexPath *indexPath500 = [NSIndexPath indexPathForItem:500 inSection:0];

    // Option 1
    [self.collectionView scrollToItemAtIndexPath:indexPath500
                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                        animated:YES];
    
    // Option 2
    /*
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath500];
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self.collectionView scrollRectToVisible:attributes.frame animated:NO];
                     }];
     */
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [(CollectionViewDataSource *)collectionView.dataSource collectionView:self.collectionView presentPreviewItemForMenuItemAtIndexPath:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return [(CollectionViewDataSource *)collectionView.dataSource isMenuItemAtIndexPath:indexPath];
}

#pragma mark - AutoRotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [self.collectionView.collectionViewLayout invalidateLayout];
}

@end
