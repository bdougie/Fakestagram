//
//  UIColorExt.h
//  Fakestagram
//
//  Created by Brian Douglas on 7/26/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

// Taken from http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
#import <UIKit/UIKit.h>

@interface UIColor (UIColor_PXExtensions)
+ (UIColor*)pxColorWithHexValue:(NSString*)hexValue;
@end
