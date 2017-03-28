//
//  NSString+HexColors.h
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (HexColors)

/**
 *  hexColor
 *
 *  @"#ff8942" or @"ff8942" or @"fff"
 *
 *  @return 二进制的颜色
 */
- (UIColor *)hexColor;

@end
