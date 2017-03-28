//
//  NumberFormatter.m
//  ZiPeiYi
//
//  Created by YouXianMing on 16/1/5.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import "NumberFormatter.h"

@implementation NumberFormatter

+ (NSString *)percentStyleWithValue:(double)value
              maximumFractionDigits:(NSUInteger)maximumFractionDigits
              minimumFractionDigits:(NSUInteger)minimumFractionDigits
                       roundingMode:(NSNumberFormatterRoundingMode)roundingMode {
    
    NSNumberFormatter *numFormatter    = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle           = kCFNumberFormatterPercentStyle;
    numFormatter.maximumFractionDigits = maximumFractionDigits;
    numFormatter.minimumFractionDigits = minimumFractionDigits;
    numFormatter.roundingMode          = roundingMode;
    return [numFormatter stringFromNumber:[NSNumber numberWithFloat:value]];
}

+ (NSString *)normalStyleWithValue:(double)value
             maximumFractionDigits:(NSUInteger)maximumFractionDigits
             minimumFractionDigits:(NSUInteger)minimumFractionDigits
                      roundingMode:(NSNumberFormatterRoundingMode)roundingMode {
    
    NSNumberFormatter *numFormatter    = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle           = kCFNumberFormatterDecimalStyle;
    numFormatter.maximumFractionDigits = maximumFractionDigits;
    numFormatter.minimumFractionDigits = minimumFractionDigits;
    numFormatter.roundingMode          = roundingMode;
    
    return [numFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
}

+ (NSString *)normalStyleWithNSNumberValue:(NSNumber *)value
                     maximumFractionDigits:(NSUInteger)maximumFractionDigits
                     minimumFractionDigits:(NSUInteger)minimumFractionDigits
                              roundingMode:(NSNumberFormatterRoundingMode)roundingMode {
    
    NSNumberFormatter *numFormatter    = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle           = kCFNumberFormatterDecimalStyle;
    numFormatter.maximumFractionDigits = maximumFractionDigits;
    numFormatter.minimumFractionDigits = minimumFractionDigits;
    numFormatter.roundingMode          = roundingMode;
    
    return [numFormatter stringFromNumber:value];
}

+ (NSString *)noThousandBitStyleWithNSNumberValue:(NSNumber *)value
                     maximumFractionDigits:(NSUInteger)maximumFractionDigits
                     minimumFractionDigits:(NSUInteger)minimumFractionDigits
                              roundingMode:(NSNumberFormatterRoundingMode)roundingMode {
    
    NSNumberFormatter *numFormatter    = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle           = kCFNumberFormatterDecimalStyle;
    numFormatter.groupingSize          = 1000;
    numFormatter.maximumFractionDigits = maximumFractionDigits;
    numFormatter.minimumFractionDigits = minimumFractionDigits;
    numFormatter.roundingMode          = roundingMode;
    
    return [numFormatter stringFromNumber:value];
}
@end
