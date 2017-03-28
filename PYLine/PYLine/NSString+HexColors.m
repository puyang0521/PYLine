//
//  NSString+HexColors.m
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import "NSString+HexColors.h"
#import "HexColors.h"

@implementation NSString (HexColors)

- (UIColor *)hexColor {
    
    UIColor *color = nil;
    
    if (self.length) {
        
        color = [HXColor colorWithHexString:self];
    }
    
    return color;
}

@end
