//
//  GradientView.h
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientColorView.h"

@interface GradientView : UIView

/**
 *  网络数据的区域path
 */
@property (nonatomic, strong) UIBezierPath    *areaPath;

/**颜色*/
@property (nonatomic, strong) UIColor         *color;

-(id)initWithFrame:(CGRect)frame color:(UIColor*)color;

/**
 *  开始绘制内容
 */
- (void)drawContent;

@end
