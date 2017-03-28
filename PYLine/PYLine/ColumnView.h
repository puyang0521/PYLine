//
//  ColumnView.h
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import "BaseBottomView.h"

@interface ColumnView : BaseBottomView

@property(nonatomic,strong) UIColor *raiseColor;
@property(nonatomic,strong) UIColor *reduceColor;
- (id)initWithFrame:(CGRect)frame xCount:(int)x yCount:(int)y;

@end
