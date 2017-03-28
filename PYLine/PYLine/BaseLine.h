//
//  BaseLine.h
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientView.h"

@interface BaseLine : UIView
/**
 *  Screen's width.
 */
@property (nonatomic) CGFloat  width;

/**
 *  Screen's height.
 */
@property (nonatomic) CGFloat  height;

/**线宽*/
@property (nonatomic) CGFloat lineWidth;
/**线颜色*/
@property (nonatomic) UIColor *lineColor;
/**是否需要渐变*/
@property (nonatomic) BOOL    isNeedGradient;
/**点数组*/
@property (nonatomic,strong) NSArray *dataArray;
/**渐变效果*/
@property (nonatomic,strong) GradientView *gradientView;
/**标识*/
@property (nonatomic,strong) NSString *forKey;
/**开始X*/
@property (nonatomic)   CGFloat beginX;
/**结束X*/
@property (nonatomic)   CGFloat endX;

-(void)drawContent;

/**
 根据按压点获得最近的点
 
 @param touchPointX 按压点X
 @param stepWidth  点间距
 @return 数组 0 点 1 数据
 */
-(NSArray*)pointByPressPointX:(CGFloat)touchPointX rangeWidth:(CGFloat)stepWidth;

@end
