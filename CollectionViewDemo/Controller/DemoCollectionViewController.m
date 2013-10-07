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
@property (nonatomic, strong) CollectionViewDataSource *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MyDemoLayout *demoLayout;
@end

@implementation DemoCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[CollectionViewDataSource alloc] init];
    self.demoLayout = [[MyDemoLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_demoLayout];
    [self registerNIBsForCollectionView:_collectionView];
    [_collectionView setDataSource:_dataSource];
    [_collectionView setDelegate:self];
    
    [self.view addSubview:_collectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)registerNIBsForCollectionView:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:kDemoCellNibName bundle:nil] forCellWithReuseIdentifier:kDemoCellIdentifier];
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

@end
