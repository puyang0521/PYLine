//
//  BaseLine.m
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import "BaseLine.h"

static CGPoint controlpoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

@implementation BaseLine

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.width                = [UIScreen mainScreen].bounds.size.width;
        self.height               = [UIScreen mainScreen].bounds.size.height;
    }
    return self;
}

- (void)drawLines{
    
    UIBezierPath *path =[UIBezierPath bezierPath];
    path.lineCapStyle   = kCGLineCapRound;  //线条拐角
    path.lineJoinStyle  = kCGLineCapRound;  //终点处理
    path.lineWidth      = self.lineWidth;
    [self.lineColor setStroke];
    CGPoint previouPoint = CGPointZero;
    for(int i = 0 ;i < self.dataArray.count; i++){
        
        NSArray *array = [self.dataArray objectAtIndex:i];
        CGPoint point =CGPointFromString([array objectAtIndex:0]);
        if (i == 0) {
            self.beginX = point.x;
            [path moveToPoint:point];
            if (self.dataArray.count == 1) {
                //只有一个点
                [path addArcWithCenter:point radius:1 startAngle:0 endAngle:0 clockwise:YES];
                self.endX = point.x;
                break;
            }
            previouPoint = point;
            continue;
        }
        if (i == ((int)self.dataArray.count - 1)) {
            self.endX = point.x;
        }
        CGPoint midPoint = controlpoint(previouPoint, point);
        [path addQuadCurveToPoint:point controlPoint:midPoint];
        previouPoint = point;
    }
    if (self.beginX > self.endX) {
        CGFloat temp = self.beginX;
        self.beginX = self.endX;
        self.endX = temp;
    }
    [path stroke];
}

- (void)drawGradient{
    
    if (self.isNeedGradient) {
        self.gradientView = [[GradientView alloc] initWithFrame:self.bounds color:self.lineColor];
        [self addSubview:self.gradientView];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineCapStyle = kCGLineCapRound; //线条拐角
        path.lineJoinStyle = kCGLineCapRound; //终点处理
        for (int i = 0; i<self.dataArray.count; i++) {
            NSArray *array = [self.dataArray objectAtIndex:i];
            CGPoint point = CGPointFromString([array objectAtIndex:0]);
            if (i == 0) {
                [path moveToPoint:CGPointMake(point.x , self.height)];
            }
            [path addLineToPoint:CGPointMake(point.x, point.y)];
            if (i == self.dataArray.count - 1) {
                [path addLineToPoint:CGPointMake(point.x , self.height )];
                [path closePath];//第五条线通过调用closePath方法得到的
            }
        }
        
        self.gradientView.areaPath = path;
        [self.gradientView drawContent];
        
        
    }
    
}

-(void)drawContent{
    [self drawLines];
    [self drawGradient];
    
}

-(NSArray*)pointByPressPointX:(CGFloat)touchPointX rangeWidth:(CGFloat)stepWidth{
    
    for(int i = 0  ; i<self.dataArray.count ; i++){
        
        NSArray *array = [self.dataArray objectAtIndex:i];
        CGPoint point =CGPointFromString([array objectAtIndex:0]);
        if(fabs(point.x - touchPointX) <= stepWidth / 2){
            return array;
        }
        
    }
    
    return nil;
}

@end
