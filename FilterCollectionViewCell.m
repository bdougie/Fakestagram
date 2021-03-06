//
//  FilterCollectionViewCell.m
//  Fakestagram
//
//  Created by Brian Douglas on 9/1/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "FilterCollectionViewCell.h"

@implementation FilterCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    

    
    return self;
}


- (void) layoutWithEdgeSize: (CGFloat) thumbnailEdgeSize{
    static NSInteger imageViewTag = 1000;
    static NSInteger labelTag = 1001;
    
    self.thumbnail = (UIImageView *)[self.contentView viewWithTag:imageViewTag];
    self.label = (UILabel *)[self.contentView viewWithTag:labelTag];
    
    if (!self.thumbnail) {
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, thumbnailEdgeSize, thumbnailEdgeSize)];
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFill;
        self.thumbnail.tag = imageViewTag;
        self.thumbnail.clipsToBounds = YES;
        
        [self.contentView addSubview:self.thumbnail];
    }
    
    if (!self.label) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, thumbnailEdgeSize, thumbnailEdgeSize, 20)];
        self.label.tag = labelTag;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
        [self.contentView addSubview:self.label];
    }
}


@end
