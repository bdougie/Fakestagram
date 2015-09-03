//
//  FilterCollectionViewCell.h
//  Fakestagram
//
//  Created by Brian Douglas on 9/1/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *thumbnail;
@property (strong, nonatomic) UILabel *label;
- (void) layoutWithEdgeSize: (CGFloat) thumbnailEdgeSize;

@end
