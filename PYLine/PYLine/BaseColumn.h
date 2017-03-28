//
//  BaseColumn.h
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineData.h"

@interface BaseColumn : UIView

/**线宽*/
@property (nonatomic)           CGFloat     columnWidth;
/**线颜色*/
@property (nonatomic)           UIColor     *columnColor;
/**柱数组  0左上角 1右下角*/
@property (nonatomic,strong)    NSArray     *dataArray;
/**标识*/
@property (nonatomic,strong)    NSString    *forKey;
/**是否需要对称， 如果需要对称*/
@property (nonatomic)           BOOL        isNeedSymmetry;
@property (nonatomic,strong)    NSNumber    *middleValue;
@property (nonatomic,strong)    UIColor     *raiseColor;
@property (nonatomic,strong)    UIColor     *reduceColor;

-(void)drawContent;
-(NSArray*)pointByPressPointX:(CGFloat)touchPointX rangeWidth:(CGFloat)stepWidth;

@end
