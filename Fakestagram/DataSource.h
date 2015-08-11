//
//  DataSource.h
//  Fakestagram
//
//  Created by Brian Douglas on 7/25/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Media;

typedef void (^NewItemCompletetionBlock)(NSError *error);

@interface DataSource : NSObject

+(instancetype) sharedInstance;
+(NSString *) instagramClientID;
@property (nonatomic, strong) NSMutableArray *mediaItems;
@property (nonatomic, strong, readonly) NSString *accessToken;

- (void) deleteMediaItem:(Media *)item;
- (void) insertObject:(Media *)object inMediaItemsAtIndex:(NSUInteger)index;
- (void) requestNewItemswithCompletionHandler:(NewItemCompletetionBlock)completionHandler;
- (void) requestOldItemsWithCompletionHandler:(NewItemCompletetionBlock)completionHandler;

- (void) downloadImageForMediaItem:(Media *)mediaItem;

@end
