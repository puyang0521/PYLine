//
//  GradientColorView.h
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientColorView : UIView

/**
 *  CGColor's array.
 */
@property (nonatomic, strong) NSArray   *colors;

/**
 *  CGColor's location.
 */
@property (nonatomic, strong) NSArray   *locations;

/**
 *  Start point.
 */
@property (nonatomic) CGPoint startPoint;

/**
 *  End point.
 */
@property (nonatomic) CGPoint endPoint;

/**
 *  After you have set all the propeties, you should run this method to become effective.
 */
- (void)becomeEffective;

@end
