//
//  BaseColumn.m
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import "BaseColumn.h"

@implementation BaseColumn

- (void)drawColumn{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for(int i = 0 ;i < self.dataArray.count; i++){
        [self.raiseColor set];
        
        NSArray *array = [self.dataArray objectAtIndex:i];
        CGPoint leftTopPoint =CGPointFromString([array objectAtIndex:0]);
        CGPoint rightBottomPoint =CGPointFromString([array objectAtIndex:1]);
        LineData *data = [array objectAtIndex:2];
        
        if (self.isNeedSymmetry) {
            if (data.value.doubleValue >= self.middleValue.doubleValue) {
                [self.raiseColor set];
            }else{
                [self.reduceColor set];
            }
        }
        
        if(leftTopPoint.y == rightBottomPoint.y){
            CGContextMoveToPoint(ctx, leftTopPoint.x, leftTopPoint.y);
            CGContextAddLineToPoint(ctx, rightBottomPoint.x, rightBottomPoint.y);
            CGContextSetLineWidth(ctx, 1);
            CGContextStrokePath(ctx);
        }
        CGContextAddRect(ctx, CGRectMake(leftTopPoint.x,leftTopPoint.y,rightBottomPoint.x-leftTopPoint.x,rightBottomPoint.y-leftTopPoint.y));
        CGContextFillPath(ctx);
        
    }
    
}


-(void)drawContent{
    [self drawColumn];
    
}

-(NSArray*)pointByPressPointX:(CGFloat)touchPointX rangeWidth:(CGFloat)stepWidth{
    
    if (touchPointX < 0 && self.dataArray && self.dataArray.count>0) {
        NSArray *array = [self.dataArray objectAtIndex:0];
        CGPoint point =CGPointFromString([array objectAtIndex:0]);
        if (point.x >= 0) {
            return array;
        }
        
        return nil;
        
    }
    
    for(int i = 0  ; i<self.dataArray.count ; i++){
        
        NSArray *array = [self.dataArray objectAtIndex:i];
        CGPoint point =CGPointFromString([array objectAtIndex:0]);
        if(fabs(point.x - touchPointX) <= stepWidth / 2){
            return array;
        }
        
    }
    if (self.dataArray.count >0) {
        return [self.dataArray objectAtIndex:(self.dataArray.count-1)];
    }
    return nil;
}

@end
