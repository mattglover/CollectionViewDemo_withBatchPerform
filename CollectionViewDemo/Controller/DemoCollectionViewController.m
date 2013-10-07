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
    [self.view addSubview:_collectionView];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addColor:)];
    [self.navigationItem setRightBarButtonItem:addButton];
}

- (void)registerNIBsForCollectionView:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:kDemoCellNibName bundle:nil] forCellWithReuseIdentifier:kDemoCellIdentifier];
}

- (void)addColor:(id)sender {
    [self.dataSource addColorToCollectionView:_collectionView];
}

@end
