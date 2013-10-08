//
//  DemoCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by Matt Glover on 07/10/2013.
//  Copyright (c) 2013 Duchy Software Limited. All rights reserved.
//

#import "DemoCollectionViewCell.h"

@implementation DemoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self prepareForReuse];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.titleLabel setText:@""];
}

@end
