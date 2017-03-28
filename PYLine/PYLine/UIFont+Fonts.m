//
//  UIFont+Fonts.m
//  ZiPeiYi
//
//  Created by YouXianMing on 15/12/16.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import "UIFont+Fonts.h"

@implementation UIFont (Fonts)

+ (UIFont *)HeitiSCWithFontSize:(CGFloat)size {

    return [UIFont fontWithName:@"Heiti SC" size:size*ScreenHeightRate];
}

+ (UIFont *)HelveticaNeueFontSize:(CGFloat)size {

    return [UIFont fontWithName:@"HelveticaNeue" size:size*ScreenHeightRate];
}

+ (UIFont *)HelveticaNeueBoldFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size*ScreenHeightRate];
}

@end
