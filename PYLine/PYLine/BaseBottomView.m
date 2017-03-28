//
//  BaseBottomView.m
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import "BaseBottomView.h"
#import "BaseLine.h"
#import "BaseColumn.h"

@implementation BaseBottomView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        self.width                = [UIScreen mainScreen].bounds.size.width;
        self.height               = [UIScreen mainScreen].bounds.size.height;
        
        self.backgroundColor = [@"123456" hexColor];
        self.longPressLineType = BaseBottomViewLongPressLineNormal;
        self.isNeedShowMark = NO;
        
        self.tenHLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        [self drawDashLine:self.tenHLine lineLength:2 lineSpacing:2 lineColor:[@"333333" hexColor] landscape:YES];
        self.tenHLine.hidden = YES;
        self.tenHLine.clipsToBounds = YES;
        [self addSubview:self.tenHLine];
        
        self.tenVLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.marginTop, 0.5, frame.size.height - self.marginTop)];
        self.tenVLine.clipsToBounds = YES;
        [self drawDashLine:self.tenVLine lineLength:2 lineSpacing:2 lineColor:[@"333333" hexColor] landscape:NO];
        self.tenVLine.hidden = YES;
        [self addSubview:self.tenVLine];
        
        
        self.longTimeLabel = [[UILabel  alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, 80, 20)];
        self.longTimeLabel.backgroundColor = [@"e2ebf9" hexColor];
        self.longTimeLabel.hidden = YES;
        self.longTimeLabel.font = [UIFont HeitiSCWithFontSize:10];
        self.longTimeLabel.textColor = [@"333333" hexColor];
        self.longTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.longTimeLabel];
        
        
    }
    
    return self;
}

-(void)setXCount:(int)xCount{
    if(self.xCount!=xCount){
        _xCount = xCount;
        [self setNeedsDisplay];
        
    }
    
}
-(void)setMiddleValue:(NSNumber *)middle{
    if (self.isNeedSymmetry &&  middle.doubleValue != self.middleValue.doubleValue) {
        _middleValue = middle;
        [self setNeedsDisplay];
    }
}

- (void)addDatas:(NSArray *)dataArray forKey:(NSString *)forKey xKeyName:(NSString *)xName yKeyName:(NSString *)yName{
    
}




- (void)panView:(CGFloat)contentScroll{
    
}




- (NSArray<LineData *>*)lineModelArrayWithDataArray:(NSArray*)dataArray xKeyName:(NSString*)xName yKeyName:(NSString*)yName{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *lastValueStr = @"";
    NSString *lastDateStr = @"";
    
    for (id obj in dataArray) {
        NSString *k     = [obj valueForKey:xName];
        NSNumber *value = [NSNumber numberWithDouble:[[obj valueForKey:yName] doubleValue]];
        //判断左边距需要的宽度
        {
            NSString *valueStr = nil;
            
            if(self.IsYLabelNeedPlus){
                valueStr = [NSString stringWithFormat:@"+%@",[NumberFormatter normalStyleWithNSNumberValue:value maximumFractionDigits:self.yBitCount minimumFractionDigits:self.yBitCount roundingMode:NSNumberFormatterRoundHalfUp]];
            }else{
                valueStr = [NSString stringWithFormat:@"%@",[NumberFormatter normalStyleWithNSNumberValue:value maximumFractionDigits:self.yBitCount minimumFractionDigits:self.yBitCount roundingMode:NSNumberFormatterRoundHalfUp]];
            }
            
            
            if (valueStr.length > lastValueStr.length && self.yFont) {
                [self generateYLabelWidthAndHeight:valueStr];
                lastValueStr = valueStr;
            }
        }
        
        //判断下边距需要的高度
        {
            
            if (k.length > lastDateStr.length && self.xFont) {
                [self generateXLabelWidthAndHeight:k];
                lastDateStr = k;
            }
        }
        
        LineData *lineData = [[LineData alloc] init];
        lineData.value  = value;
        lineData.date   = k;
        lineData.data   = obj;
        [array addObject:lineData];
    }
    
    return array;
}

- (void)generateXLabelWidthAndHeight:(NSString*)content{
    
    CGSize size = [content sizeWithAttributes:@{NSFontAttributeName:self.xFont}];
    
    if (size.width > self.xLabelWidth) {
        self.xLabelWidth = size.width + 15;
    }
    if (size.height > self.xLabelHeight) {
        self.xLabelHeight = size.height + 5;
    }
    
}
- (void)generateYLabelWidthAndHeight:(NSString*)content{
    
    
    CGSize size = [content sizeWithAttributes:@{NSFontAttributeName:self.yFont}];
    if (size.width > self.yLabelWidth) {
        self.yLabelWidth = size.width + 30;
    }
    if (size.height > self.yLabelHeight) {
        self.yLabelHeight = size.height + 5;
    }
    
    if (!self.isYLabelInChart) {
        self.marginLeft = self.yLabelWidth;
    }
    
    if(self.marginTop!=0){
        self.marginTop = self.yLabelHeight;
    }
}

- (void)drawCoordinateSystem:(CGContextRef)ctx{
    
    [self drawYCoordinateSystem:ctx];
    [self drawXCoordinateSystem:ctx];
}


- (void)drawYCoordinateSystem:(CGContextRef)ctx{
    
    
    //f2f6f9
    CGContextSetRGBStrokeColor(ctx, 242.0/255.0, 246.0/255.0, 249.0/255.0, 1);
    CGContextSetLineWidth(ctx, 1);
    
    CGFloat width = (self.width - self.marginLeft ) / (_xLineCount - 1);
    
    for (int i = 0 ; i<self.xLineCount; i++) {
        CGContextMoveToPoint(ctx, width  * i + self.marginLeft, self.marginTop);
        CGContextAddLineToPoint(ctx, width * i + self.marginLeft, self.height - self.xLabelHeight);
        CGContextStrokePath(ctx);
    }
    
    
}

- (void)drawXCoordinateSystem:(CGContextRef)ctx{
    
    //e5e5e5
    CGContextSetRGBStrokeColor(ctx, 229.0/255.0, 229.0/255.0, 229.0/255.0, 1);
    CGContextSetLineWidth(ctx, 1);
    
    for(int i = 0 ; i < self.yCount ; i++){
        
        if(self.isHorizontalDash){
            if( i == 0 || i == self.yCount -1){
                //实线
                
                CGContextSetLineDash(ctx, 0, 0, 0);
                
            }else{
                //虚线
                CGFloat lengths[] = {3, 3};
                CGContextSetLineDash(ctx, 0, lengths, 2);
                
            }
        }
        if(self.isYLabelInChart){
            CGContextMoveToPoint(ctx, 0, i * (self.height - self.xLabelHeight - self.marginTop) / (self.yCount -1)+self.marginTop);
            
        }else{
            CGContextMoveToPoint(ctx, self.yLabelWidth, i * (self.height - self.xLabelHeight - self.marginTop) / (self.yCount -1)+self.marginTop);
            
        }
        
        CGContextAddLineToPoint(ctx, self.width, i * (self.height - self.xLabelHeight - self.marginTop) / (self.yCount -1)+self.marginTop);
        CGContextStrokePath(ctx);
        
    }
    
    
}

- (UIColor*)randomColor{
    return [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
}

/**
 *  取两点间直线与Y轴的交点
 *
 *  @param point1 A点
 *  @param point2 B点
 *
 *  @return 与Y轴的交点Y值
 */
-(CGFloat)pointByLineAndYAxixFromPointA:(CGPoint)point1 pointB:(CGPoint)point2  resultX:(CGFloat)resultX{
    //A点X坐标
    CGFloat pax = point1.x;
    //B点X坐标
    CGFloat pbx = point2.x;
    //A点y坐标
    CGFloat pay = point1.y;
    //B点y坐标
    CGFloat pby = point2.y;
    
    //计算两点间直线和Y轴的交点的Y值
    CGFloat resultY = (resultX - pbx) / (pax - pbx) * (pay - pby) +pby;
    return  resultY;
    
}

-(void)refreshTen:(CGPoint)touchPoint forKey:(NSString*)forKey{
    
    //最终解决方案。。即
    BaseLine *minLine = nil;
    BaseLine *maxLine = nil;
    
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[BaseLine class]]) {
            BaseLine *line = (BaseLine*)view;
            if (![line.forKey isEqualToString:forKey]) {
                continue;
            }
            if (!minLine || minLine.beginX > line.beginX) {
                minLine = line;
            }
            if (!maxLine || maxLine.endX < line.endX) {
                maxLine = line;
            }
            if (touchPoint.x >= line.beginX - self.xPerStepWidth/2 && touchPoint.x <= line.endX + self.xPerStepWidth/2 ) {
                //找到目标view
                NSArray *array = [line pointByPressPointX:touchPoint.x rangeWidth:self.xPerStepWidth];
                if (array) {
                    [self notifyTen:CGPointFromString([array objectAtIndex:0]) data:[array objectAtIndex:1]];
                }
                return;
            }
        }else if ([view isKindOfClass:[BaseColumn class]]) {
            BaseColumn *column = (BaseColumn*)view;
            if (![column.forKey isEqualToString:forKey]) {
                continue;
            }
            
            NSArray *array = [column pointByPressPointX:touchPoint.x rangeWidth:self.xPerStepWidth];
            if (array) {
                CGPoint leftTopPoint =CGPointFromString([array objectAtIndex:0]);
                CGPoint rightBottomPoint =CGPointFromString([array objectAtIndex:1]);
                LineData *data = [array objectAtIndex:2];
                if (self.isNeedSymmetry) {
                    if (data.value.doubleValue >= self.middleValue.doubleValue) {
                        [self notifyTen:CGPointMake(leftTopPoint.x + self.xPerStepWidth/2 - 0.5, leftTopPoint.y) data:data];
                    }else{
                        [self notifyTen:CGPointMake(rightBottomPoint.x - self.xPerStepWidth/2 -0.5, leftTopPoint.y) data:data];
                    }
                }
                
            }
            return;
            
        }
        
    }
    //未找到
    [self notifyTen:CGPointZero data:nil];
    
}

-(void)notifyTen:(CGPoint)point data:(id)data{
    self.tenVLine.y =self.marginTop;
    
    if(self.tenVLine.height != self.height - self.xLabelHeight - self.marginTop){
        self.tenVLine.height = self.height - self.xLabelHeight -self.marginTop;
    }
    if(self.tenHLine.width != self.width - self.yLabelWidth){
        if(!self.isYLabelInChart){
            self.tenHLine.x     = self.yLabelWidth;
            self.tenHLine.width = self.width - self.yLabelWidth;
            
        }else{
            self.tenHLine.x     = 0;
            self.tenHLine.width = self.width ;
        }
        
    }
    if(data){
        if(point.x >= self.tenHLine.x && point.x <= self.tenHLine.right){
            self.tenVLine.x = point.x;
            self.tenHLine.y = point.y;
            
            if (self.longPressLineType == BaseBottomViewLongPressLineNormal) {
                self.tenVLine.hidden = NO;
                self.tenHLine.hidden = NO;
            }else if (self.longPressLineType == BaseBottomViewLongPressLineVertical){
                self.tenVLine.hidden = NO;
            }else if (self.longPressLineType == BaseBottomViewLongPressLineHorizontal){
                self.tenHLine.hidden = NO;
                
            }
            
            if (self.isShowLongXLabel) {
                self.longTimeLabel.hidden = NO;
                self.longTimeLabel.frame = CGRectMake(0, self.frame.size.height - self.xLabelHeight, self.xLabelWidth, self.xLabelHeight);
                
                if ((point.x - self.xLabelWidth/2 )<0) {
                    self.longTimeLabel.centerX = self.xLabelWidth/2;
                }else if((point.x + self.xLabelWidth/2)>self.width){
                    self.longTimeLabel.centerX = self.width - self.xLabelWidth/2;
                }else{
                    self.longTimeLabel.centerX = point.x;
                }
                
                
                LineData *lineData = data;
                NSString *tempDate =lineData.date;
                if (tempDate.length > 10) {
                    tempDate = [tempDate substringToIndex:10];
                }
                
                if (![tempDate containsString:@"-"]) {
                    tempDate = [NSString stringWithFormat:@"%@-%@-%@",[tempDate substringToIndex:4],[tempDate substringWithRange:NSMakeRange(4, 2)],[tempDate substringWithRange:NSMakeRange(6, 2)]];
                }
                
                if (self.xLabelFormatType == BaseBottomViewXLabelYYYY) {
                    tempDate = [tempDate substringToIndex:4];
                }else if(self.xLabelFormatType == BaseBottomViewXLabelYYYYMM){
                    tempDate = [tempDate substringToIndex:7];
                }else if (self.xLabelFormatType == BaseBottomViewXLabelMMDD){
                    tempDate = [tempDate substringFromIndex:5];
                }
                self.longTimeLabel.text = tempDate;
                
            }
            
            
            
        }else{
            self.tenVLine.hidden = YES;
            self.tenHLine.hidden = YES;
            self.longTimeLabel.hidden = YES;
        }
    }else{
        self.tenVLine.hidden = YES;
        self.tenHLine.hidden = YES;
        self.longTimeLabel.hidden = YES;
        
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(notifyDataChange:withView:)]) {
        [self.delegate notifyDataChange:data withView:self];
    }
    
}

-(void)removeTen{
    
    self.tenHLine.hidden = YES;
    self.tenVLine.hidden = YES;
    self.longTimeLabel.hidden = YES;
}


/**
 ** lineView:	   需要绘制成虚线的view
 ** lineLength:	 虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:	  虚线的颜色
 ** landscape: 是否横向
 **/
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor landscape:(BOOL)landscape
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    if (landscape) {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    }else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame), CGRectGetHeight(lineView.frame)/2)];
        
    }
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:landscape?CGRectGetHeight(lineView.frame):CGRectGetWidth(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    if (landscape) {
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    }else{
        CGPathMoveToPoint(path, NULL, lineView.x, 0);
        CGPathAddLineToPoint(path, NULL, lineView.x,CGRectGetHeight(lineView.frame));
        
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}


-(void)drawXLabelDate:(NSString*)date rect:(CGRect)rect attribute:(NSDictionary*)attribute{
    NSString *tempDate = date;
    if (tempDate.length > 10) {
        tempDate = [tempDate substringToIndex:10];
    }
    
    if (![tempDate containsString:@"-"]) {
        tempDate = [NSString stringWithFormat:@"%@-%@-%@",[tempDate substringToIndex:4],[tempDate substringWithRange:NSMakeRange(4, 2)],[tempDate substringWithRange:NSMakeRange(6, 2)]];
    }
    
    if (self.xLabelFormatType == BaseBottomViewXLabelYYYY) {
        tempDate = [tempDate substringToIndex:4];
    }else if(self.xLabelFormatType == BaseBottomViewXLabelYYYYMM){
        tempDate = [tempDate substringToIndex:7];
    }else if (self.xLabelFormatType == BaseBottomViewXLabelMMDD){
        tempDate = [tempDate substringFromIndex:5];
    }
    
    
    [tempDate drawInRect:rect withAttributes:attribute];
}

-(UIView*)generateOneMarkView:(NSString*)title color:(UIColor*)color{
    
    UIView *markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMarkWidth, self.marginTop)];
    
    
    
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont HeitiSCWithFontSize:9]}];
    
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(markView.width - size.width - 10*ScreenWidthRate, 0, size.width + 5*ScreenWidthRate, markView.height)];
    titleLabel.text = title;
    titleLabel.font = [UIFont HeitiSCWithFontSize:10];
    titleLabel.textColor =[@"666666" hexColor];
    [markView addSubview:titleLabel];
    
    
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0,(markView.height - (size.height-2))/2 , size.height-2, size.height-2)];
    colorView.x = titleLabel.x - colorView.width - 3*ScreenWidthRate;
    colorView.backgroundColor = color;
    [markView addSubview:colorView];
    
    
    return  markView;
}

-(void)drawMark{
    if(self.isNeedShowMark){
        
        if (self.marginTop > 0) {
            if (self.markView) {
                for (UIView *view in self.markView.subviews) {
                    [view removeFromSuperview];
                }
            }else{
                self.markView = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, self.width, self.marginTop  )];
                [self addSubview:self.markView];
            }
            
            for(int i = 0;i<self.totalDataDic.allKeys.count;i++){
                NSString *key = [self.totalDataDic.allKeys objectAtIndex:i];
                UIColor *color = [self.lineColors objectForKey:key];
                UIView *v = [self generateOneMarkView:key color:color];
                v.x = self.markView.width - (i+1)*v.width;
                [self.markView addSubview:v];
            }
        }
        
    }
}

@end
