//
//  NumberFormatter.h
//  ZiPeiYi
//
//  Created by YouXianMing on 16/1/5.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NumberFormatter : NSObject

/**
 *  Get percent style value string.
 *
 *  @param value                 Input value.
 *  @param maximumFractionDigits Maximum fraction digits.
 *  @param minimumFractionDigits Minimum fraction digits.
 *  @param roundingMode          NSNumberFormatterRoundingMode.
 *
 *  @return Percent style value string.
 */
+ (NSString *)percentStyleWithValue:(double)value
              maximumFractionDigits:(NSUInteger)maximumFractionDigits
              minimumFractionDigits:(NSUInteger)minimumFractionDigits
                       roundingMode:(NSNumberFormatterRoundingMode)roundingMode;

/**
 *  Get normal style value string.
 *
 *  @param value                 Input value.
 *  @param maximumFractionDigits Maximum fraction digits.
 *  @param minimumFractionDigits Minimum fraction digits.
 *  @param roundingMode          NSNumberFormatterRoundingMode.
 *
 *  @return Percent style value string.
 */
+ (NSString *)normalStyleWithValue:(double)value
             maximumFractionDigits:(NSUInteger)maximumFractionDigits
             minimumFractionDigits:(NSUInteger)minimumFractionDigits
                      roundingMode:(NSNumberFormatterRoundingMode)roundingMode;

/**
 *  Get normal style value string.
 *
 *  @param value                 Input NSNumber value.
 *  @param maximumFractionDigits Maximum fraction digits.
 *  @param minimumFractionDigits Minimum fraction digits.
 *  @param roundingMode          NSNumberFormatterRoundingMode.
 *
 *  @return  string.
 */
+ (NSString *)normalStyleWithNSNumberValue:(NSNumber *)value
                     maximumFractionDigits:(NSUInteger)maximumFractionDigits
                     minimumFractionDigits:(NSUInteger)minimumFractionDigits
                              roundingMode:(NSNumberFormatterRoundingMode)roundingMode;

/**
*  Get normal style value string.
*
*  @param value                 Input NSNumber value.
*  @param maximumFractionDigits Maximum fraction digits.
*  @param minimumFractionDigits Minimum fraction digits.
*  @param roundingMode          NSNumberFormatterRoundingMode.
*
*  @return Percent style value string.
*/
+ (NSString *)noThousandBitStyleWithNSNumberValue:(NSNumber *)value
                            maximumFractionDigits:(NSUInteger)maximumFractionDigits
                            minimumFractionDigits:(NSUInteger)minimumFractionDigits
                                     roundingMode:(NSNumberFormatterRoundingMode)roundingMode;
@end
