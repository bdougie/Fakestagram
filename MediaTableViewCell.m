//
//  MediaTableViewCell.m
//  Fakestagram
//
//  Created by Brian Douglas on 7/25/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "MediaTableViewCell.h"
#import "Media.h"
#import "Comment.h"
#import "User.h"
#import "UIColorExt.h"
#import "LikeButton.h"

@interface MediaTableViewCell () {
    Media* _mediaItem;
}

@property (nonatomic, strong) UIImageView *mediaImageView;
@property (nonatomic, strong) UILabel *usernameAndCaptionLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) NSLayoutConstraint *imageHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *imageWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *likeHeightContraints;
@property (nonatomic, strong) NSLayoutConstraint *usernameAndCaptionLabelHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *commentLabelHeightConstraint;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *twoTapGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (nonatomic, strong) LikeButton *likeButton;

@end

static UIFont *lightFont;
static UIFont *boldFont;
static UIColor *usernameLabelGray;
static UIColor *commentLabelGray;
static UIColor *commentLabelOrange;
static UIColor *linkColor;
static NSParagraphStyle *paragraphStyle;

@implementation MediaTableViewCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:NO animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

- (void) setMediaItem:(Media *)mediaItem {
    _mediaItem = mediaItem;
    self.mediaImageView.image = _mediaItem.image;
    self.usernameAndCaptionLabel.attributedText = [self usernameAndCaptionString];
    self.commentLabel.attributedText = [self commentString];
    self.likeButton.likeButtonState = mediaItem.likeState;

    NSMutableString *likesCountString = [NSMutableString stringWithFormat:@"%tu", mediaItem.likeAmount];
    self.likeCountLabel.text = likesCountString;
}

+ (void)load {
    lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    usernameLabelGray = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1];
    commentLabelGray = [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1];
    commentLabelOrange = [UIColor pxColorWithHexValue:@"#FFA500"];
    linkColor = [UIColor colorWithRed:0.345 green:0.314 blue:0.427 alpha:1];
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 20.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    
    paragraphStyle = mutableParagraphStyle;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.mediaImageView = [[UIImageView alloc] init];
        self.mediaImageView.userInteractionEnabled = YES;
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        self.tapGestureRecognizer.delegate = self;
        [self.mediaImageView addGestureRecognizer:self.tapGestureRecognizer];
        self.backgroundColor = usernameLabelGray;
        
        self.twoTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerTapFired:)];
        self.twoTapGestureRecognizer.delegate = self;
        self.twoTapGestureRecognizer.numberOfTouchesRequired = 2;
        [self.mediaImageView addGestureRecognizer:self.twoTapGestureRecognizer];
        
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        self.longPressGestureRecognizer.delegate = self;
        [self.mediaImageView addGestureRecognizer:self.longPressGestureRecognizer];
        
        self.usernameAndCaptionLabel = [[UILabel alloc] init];
        self.usernameAndCaptionLabel.numberOfLines = 0;
        self.usernameAndCaptionLabel.backgroundColor = usernameLabelGray;
                               
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.backgroundColor = commentLabelGray;
        
        self.likeCountLabel = [[UILabel alloc] init];
        self.likeCountLabel.numberOfLines = 0;
        self.likeCountLabel.backgroundColor = usernameLabelGray;
        self.likeCountLabel.textAlignment = NSTextAlignmentCenter;
        
        self.likeButton = [[LikeButton alloc] init];
        [self.likeButton addTarget:self action:@selector(likePressed:) forControlEvents:UIControlEventTouchUpInside];
        self.likeButton.backgroundColor = usernameLabelGray;
        
        for (UIView *view in @[self.mediaImageView, self.usernameAndCaptionLabel, self.commentLabel, self.likeButton, self.likeCountLabel]) {
           [self.contentView addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }

        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_mediaImageView, _usernameAndCaptionLabel, _commentLabel, _likeButton, _likeCountLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_usernameAndCaptionLabel][_likeCountLabel(==40)][_likeButton(==38)]|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentLabel]|" options:kNilOptions metrics:nil views:viewDictionary]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mediaImageView][_usernameAndCaptionLabel][_commentLabel]"
                                                                                 options:kNilOptions
                                                                                 metrics:nil
                                                                                   views:viewDictionary]];
        self.imageWidthConstraint = [NSLayoutConstraint constraintWithItem:_mediaImageView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant: self.bounds.size.width];
        self.likeHeightContraints = [NSLayoutConstraint constraintWithItem:_likeCountLabel
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:40];
        self.imageHeightConstraint = [NSLayoutConstraint constraintWithItem:_mediaImageView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:self.bounds.size.width];
        self.imageHeightConstraint.identifier = @"Image height constraint";
        self.imageWidthConstraint.identifier = @"Image width constraint";
        
        self.usernameAndCaptionLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_usernameAndCaptionLabel
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:nil
                                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                                   multiplier:1
                                                                                     constant:self.bounds.size.width];
        self.usernameAndCaptionLabelHeightConstraint.identifier = @"Username and caption label height constraint";
        
        self.commentLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_commentLabel
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1
                                                                          constant:100];
        self.commentLabelHeightConstraint.identifier = @"Comment label height constraint";
        
        [self.contentView addConstraints:@[self.imageHeightConstraint, self.usernameAndCaptionLabelHeightConstraint, self.commentLabelHeightConstraint, self.imageWidthConstraint, self.likeHeightContraints]];
    }
    return self;
}

- (NSAttributedString *) usernameAndCaptionString {
    CGFloat usernameFontSize = 15;
    
    NSString *baseString = [NSString stringWithFormat:@"%@ %@", self.mediaItem.user.userName, self.mediaItem.caption];
    NSMutableAttributedString *mutableUsernameAndCaptionString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : [lightFont fontWithSize:usernameFontSize], NSParagraphStyleAttributeName : paragraphStyle}];
    NSRange usernameRange = [baseString rangeOfString:self.mediaItem.user.userName];
    [mutableUsernameAndCaptionString addAttribute:NSFontAttributeName value:[boldFont fontWithSize:usernameFontSize] range:usernameRange];
    [mutableUsernameAndCaptionString addAttribute:NSForegroundColorAttributeName value:linkColor range:usernameRange];
    
    // Increase the kerning (character spacing) of the image caption.
    NSRange captionRange = [baseString rangeOfString:self.mediaItem.caption];
    float spacing = 2.0f;
    [mutableUsernameAndCaptionString addAttribute:NSKernAttributeName value:@(spacing) range:captionRange];
    
    return mutableUsernameAndCaptionString;
}
     
 - (NSAttributedString * ) commentString {
     NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
     
     for (Comment *comment in self.mediaItem.comments) {
         NSString *baseString = [NSString stringWithFormat:@"%@ %@\n", comment.from.userName, comment.text];
         NSMutableAttributedString *oneCommentString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : lightFont, NSParagraphStyleAttributeName : paragraphStyle}];
         
         NSRange usernameRange = [baseString rangeOfString:comment.from.userName];
         [oneCommentString addAttribute:NSFontAttributeName value:boldFont range:usernameRange];
         [oneCommentString addAttribute:NSForegroundColorAttributeName value:linkColor range:usernameRange];
         
         // change first comment to orange
         
//         if ([self.mediaItem.comments indexOfObject:comment] == 0 && comment.text.length > 0) {
//             NSRange selectedRange = NSMakeRange(0, oneCommentString.length);
//             [oneCommentString setAttributes:@{NSForegroundColorAttributeName: commentLabelOrange} range:selectedRange];
//         }
         
         // paragraph align right for every other comment.

//         if ([self.mediaItem.comments indexOfObject:comment] % 2 == 0) {
//             NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//             paragraph.alignment = NSTextAlignmentRight;
//             [oneCommentString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, oneCommentString.length)];
//         }
         [commentString appendAttributedString:oneCommentString];
     }
     
     return commentString;
 }
     
 - (void) layoutSubviews {
     [super layoutSubviews];
     
     // Before layout, calculate the intrinsic size of the labels (the size they "want" to be), and add 20 to the height for some vertical padding.
     CGSize maxSize = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
     CGSize usernameLabelSize = [self.usernameAndCaptionLabel sizeThatFits:maxSize];
     CGSize commentLabelSize = [self.commentLabel sizeThatFits:maxSize];
     
     self.usernameAndCaptionLabelHeightConstraint.constant = usernameLabelSize.height == 0 ? 0 : usernameLabelSize.height + 20;
     self.commentLabelHeightConstraint.constant = commentLabelSize.height == 0 ? 0 : commentLabelSize.height + 20;
     
     // Hide the line between cells
     self.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(self.bounds)/2.0, 0, CGRectGetWidth(self.bounds)/2.0);
 }

+ (CGFloat) heightForMediaItem:(Media *)mediaItem width:(CGFloat)width {
    // Make a cell
    MediaTableViewCell *layoutCell = [[MediaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layoutCell"];
    layoutCell.mediaItem = mediaItem;
    layoutCell.frame = CGRectMake(0, 0, width, CGRectGetHeight(layoutCell.frame));
    
    // The height will be wherever the bottom of the comments label is
    [layoutCell setNeedsLayout];
    [layoutCell layoutIfNeeded];
    
    // Get the actual height required for the cell
    return CGRectGetMaxY(layoutCell.commentLabel.frame);
}

#pragma mark - Liking

- (void) likePressed:(UIButton *)sender {
    [self.delegate cellDidPressLikeButton:self];
}

#pragma mark - Image View

- (void) tapFired:(UITapGestureRecognizer *)sender {
    [self.delegate cell:self didTapImageView:self.mediaImageView];
}

- (void) twoFingerTapFired:(UIGestureRecognizer *)sender {
    if ([sender numberOfTouches] == 2) {
        [self.delegate cell:self didDoubleTapImageView:self.mediaImageView];
    }
}

- (void) longPressFired:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.delegate cell:self didTapImageView:self.mediaImageView];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.isEditing == NO;
}
@end
