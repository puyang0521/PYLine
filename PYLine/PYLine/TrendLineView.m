//
//  TrendLineView.m
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import "TrendLineView.h"
#import "TrendLine.h"


@interface TrendLineView()
@end

@implementation TrendLineView

- (id)initWithFrame:(CGRect)frame xCount:(int)x yCount:(int)y{
    self = [super initWithFrame:frame];
    if (self) {
        self.xCount     = x;
        self.yCount     = y;
        self.xLineCount = 5;
        self.yBitCount  = 2;
        self.xFont      = [UIFont HeitiSCWithFontSize:11];
        self.xColor     = [@"333333" hexColor];
        self.yFont      = [UIFont HeitiSCWithFontSize:11];
        self.yColor     = [@"333333" hexColor];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}



- (void)addDatas:(NSArray*)dataArray forKey:(NSString*)forKey xKeyName:(NSString*)xName yKeyName:(NSString*)yName{
    
    if(!self.scrollEnable){
        if(dataArray.count > self.xCount){
            self.scrollEnable = YES;
        }else{
            self.scrollEnable = NO;
        }
    }
    
    if(!self.totalDataDic){
        self.totalDataDic = [[NSMutableDictionary alloc] init];
    }else{
        if (self.totalDataDic.count>0) {
            if([self.totalDataDic.allKeys containsObject:forKey]){
                //如果字典里已包含，则替换数据源
                
            }else{
                //不包含
                NSArray *datas = [self.totalDataDic objectForKey:[[self.totalDataDic allKeys] objectAtIndex:0]];
                if (datas.count != dataArray.count) {
                    //第一组数据量与第二组不一致直接返回。 后续可增加特殊处理。
                    return;
                }
            }
        }
    }
    [self.totalDataDic setObject:[self lineModelArrayWithDataArray:dataArray xKeyName:xName yKeyName:yName] forKey:forKey];
    [self drawMark];
    
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect{
    if (self.xCount <= 1 || self.yCount <=0 ) {
        return;
    }
    
    self.maxY        = self.middleValue.doubleValue;
    self.minY        = self.middleValue.doubleValue;
    [self generateHeightAndWidth];
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    [self drawLineChart:ctx];
    
}

- (void)generateHeightAndWidth{
    double last = self.middleValue.doubleValue;
    if (self.totalDataDic.count > 0) {
        for (int i = 0; i<self.totalDataDic.count; i++) {
            NSArray<LineData*> *datas = [self.totalDataDic objectForKey:[self.totalDataDic.allKeys objectAtIndex:i]];
            for (int j = 0; j<datas.count; j++) {
                LineData *data = [datas objectAtIndex:j];
                double d = data.value.doubleValue;
                if (d >= last ) {
                    data.isRaise = YES;
                }
                last = d;
                if (d > self.maxY) {
                    self.maxY = d;
                }else if(d < self.minY){
                    self.minY = d;
                }
            }
        }
        
        if(self.isNeedSymmetry){
            if ((self.maxY - self.middleValue.doubleValue) > (self.middleValue.doubleValue - self.minY)) {
                self.minY = self.middleValue.doubleValue - (self.maxY - self.middleValue.doubleValue);
            }else if((self.maxY - self.middleValue.doubleValue) < (self.middleValue.doubleValue - self.minY)){
                self.maxY = self.middleValue.doubleValue + (self.middleValue.doubleValue - self.minY);
            }
            
            
            if (self.maxY == self.minY ) {
                self.maxY = 100;
                self.minY = -100;
            }
            
        }
    }
    
    //X轴 列间距
    self.xPerStepWidth = (self.width - self.marginLeft ) / (self.xCount-1);
    
}

- (void)drawLineChart:(CGContextRef)ctx{
    
    [self drawCoordinateSystem:ctx];
    [self drawLabel];
    [self drawLine:ctx];
    
}


- (void)drawLine:(CGContextRef)ctx{
    for(UIView *v in self.subviews){
        if ([v isKindOfClass:[TrendLine class]]) {
            [v removeFromSuperview];
        }
    }
    
    for (int i = 0; i < self.totalDataDic.count; i++) {
        NSString *forKey =[[self.totalDataDic allKeys] objectAtIndex:i];
        NSArray *datas = [self.totalDataDic objectForKey:forKey];
        NSMutableArray *pointArray = [[NSMutableArray alloc] initWithCapacity:1];
        if(self.scrollEnable){
            //可滑动 超过一屏
            for (int j = (int)(datas.count - 1); j >= 0; j--) {
                double x =(j-((int)datas.count - self.xCount)) * self.xPerStepWidth +self.xContentScroll + self.marginLeft ;
                LineData *lineData = [datas objectAtIndex:j];
                double value = lineData.value.doubleValue;
                double y = (self.height - self.xLabelHeight- self.marginTop) * ((self.maxY - value) / (self.maxY - self.minY))+self.marginTop;
                
                
                if(x > self.width){
                    
                    if (j!=0 && x - self.xPerStepWidth < self.width ) {
                        LineData *lastData = [datas objectAtIndex:j-1];
                        double lastValue = lastData.value.doubleValue;
                        double lastX = x - self.xPerStepWidth;
                        double lastY = (self.height - self.xLabelHeight -self.marginTop) * ((self.maxY - lastValue) / (self.maxY - self.minY))+self.marginTop;
                        CGFloat p = [self pointByLineAndYAxixFromPointA:CGPointMake(x, y) pointB:CGPointMake(lastX, lastY) resultX:self.width];
                        
                        CGPoint point =  CGPointMake(self.width, p);
                        [pointArray addObject:[[NSArray alloc] initWithObjects:NSStringFromCGPoint(point), nil] ];
                    }
                    
                    
                    continue;
                }
                if(x < self.marginLeft){
                    
                    if (j!=datas.count - 1 && x + self.xPerStepWidth > 0 ) {
                        LineData *nextData = [datas objectAtIndex:j+1];
                        double nextValue = nextData.value.doubleValue;
                        double nextX = x + self.xPerStepWidth;
                        double nextY = (self.height - self.xLabelHeight -self.marginTop) * ((self.maxY - nextValue) / (self.maxY - self.minY))+self.marginTop;
                        CGFloat p = [self pointByLineAndYAxixFromPointA:CGPointMake(x, y) pointB:CGPointMake(nextX, nextY) resultX:self.marginLeft];
                        
                        CGPoint point =  CGPointMake(self.marginLeft, p);
                        [pointArray addObject:[[NSArray alloc] initWithObjects:NSStringFromCGPoint(point), nil] ];
                    }
                    
                    break;
                }
                
                CGPoint point =  CGPointMake(x, y);
                [pointArray addObject:[[NSArray alloc] initWithObjects:NSStringFromCGPoint(point),lineData, nil] ];
                
                
                
                
            }
        }else{
            //不可滑动
            for (int j = 0; j<datas.count; j++) {
                double x = j *self.xPerStepWidth + self.marginLeft;
                LineData *lineData = [datas objectAtIndex:j];
                double value = lineData.value.doubleValue;
                double y = (self.height - self.xLabelHeight - self.marginTop) * ((self.maxY - value) / (self.maxY - self.minY))+self.marginTop;
                CGPoint point =  CGPointMake(x, y);
                [pointArray addObject:[[NSArray alloc] initWithObjects:NSStringFromCGPoint(point),lineData, nil] ];
                
            }
        }
        if (pointArray.count > 0 ) {
            TrendLine *line = [[TrendLine alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - self.xLabelHeight)];
            line.dataArray  = pointArray;
            if([self.lineColors.allKeys containsObject:forKey]){
                line.lineColor = [self.lineColors objectForKey:forKey];
            }else{
                line.lineColor = [self randomColor];
            }
            if([self.lineWidthes.allKeys containsObject:forKey]){
                line.lineWidth = ((NSNumber*)[self.lineWidthes objectForKey:forKey]).floatValue;
            }else{
                line.lineWidth = kDefaultLineWidth;
            }
            if([self.isNeedGradient.allKeys containsObject:forKey]){
                line.isNeedGradient = [[self.isNeedGradient objectForKey:forKey] boolValue];
            }else{
                line.isNeedGradient = NO;
            }
            line.forKey = forKey;
            [line drawContent];
            [self addSubview:line];
            
        }
        
        
    }
}


-(void)panView:(CGFloat)contentScroll{
    if (self.scrollEnable) {
        //只有倒序时可以平移
        //移动累加
        self.xContentScroll            += contentScroll;
        
        //当移动小于0时  则修改为0 即起始点
        if (self.xContentScroll < 0) {
            self.xContentScroll = 0;
        }
        NSInteger count = ((NSArray*) [self.totalDataDic objectForKey:[self.totalDataDic.allKeys objectAtIndex:0]]).count;
        
        //当向右滑动移动值为正数  移动值大于（总数量-1） * 每点间隔 即 总宽度
        if (self.xContentScroll > ((int)count - (int)self.xCount  )*self.xPerStepWidth) {
            //设置移动值为 最右值
            self.xContentScroll  = (count - self.xCount  )*self.xPerStepWidth;
        }
        
        [self setNeedsDisplay];
    }
    
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)drawLabel{
    [self drawYLabel];
    [self drawXLabel];
    
}
-(void)drawYLabel{
    
    NSMutableDictionary *attribute              = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraphStyle     = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment                    = NSTextAlignmentLeft;
    attribute[NSForegroundColorAttributeName]   = self.yColor;
    attribute[NSFontAttributeName]              = self.yFont;
    attribute[NSParagraphStyleAttributeName]    = paragraphStyle;
    
    
    
    for ( int i = 0 ;i < self.yCount; i++){
        
        CGRect rect =CGRectMake( 2 , i * (self.height-self.xLabelHeight - self.marginTop) / (self.yCount-1), self.yLabelWidth, self.yLabelHeight);
        if(self.yLabelFormatType == BaseBottomViewYLabelPercent){
            NSString *value = [NumberFormatter percentStyleWithValue:(self.maxY - i * (self.maxY - self.minY)/(self.yCount -1)) maximumFractionDigits:self.yBitCount minimumFractionDigits:self.yBitCount roundingMode:NSNumberFormatterRoundHalfUp];
            [value drawInRect:rect withAttributes:attribute];
        }else if(self.yLabelFormatType == BaseBottomViewYLabelNormal){
            
            NSString *value = [NumberFormatter normalStyleWithValue:(self.maxY - i * (self.maxY - self.minY)/(self.yCount -1)) maximumFractionDigits:self.yBitCount minimumFractionDigits:self.yBitCount roundingMode:NSNumberFormatterRoundHalfUp];
            if (self.IsYLabelNeedPlus) {
                if (value.doubleValue > 0) {
                    value = [NSString stringWithFormat:@"+%@",value];
                }
            }
            [value drawInRect:rect withAttributes:attribute];
            
        }
        
        
    }
}

-(void)drawXLabel{
    
    if(self.totalDataDic.count > 0){
        
        NSArray *array = [self.totalDataDic objectForKey:[self.totalDataDic.allKeys objectAtIndex:0]];
        NSMutableDictionary *attribute = [[NSMutableDictionary alloc] init];
        NSMutableParagraphStyle *paragraphStyle     = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment                    = NSTextAlignmentCenter;
        attribute[NSForegroundColorAttributeName]   = self.xColor;
        attribute[NSFontAttributeName]              = self.xFont;
        attribute[NSParagraphStyleAttributeName]    = paragraphStyle;
        if(self.scrollEnable){
            
        }else{
            //不能滚动
            if(self.xLabelCount == 1){
                if (array.count > 0) {
                    LineData *data = [array objectAtIndex:0];
                    NSString *date = data.date;
                    CGRect rect = CGRectMake(self.marginLeft, self.height - self.xLabelHeight, self.xLabelWidth, self.xLabelHeight);
                    
                    [self drawXLabelDate:date rect:rect attribute:attribute];
                }
                
            }else{
                
                for (int i = 0; i<self.xLabelCount; i++) {
                    CGRect rect = CGRectZero;
                    if (i == 0) {
                        //第一个 左对齐
                        if(array.count > 0){
                            paragraphStyle.alignment = NSTextAlignmentLeft;
                            LineData *data = [array objectAtIndex:0];
                            NSString *date = data.date;
                            rect = CGRectMake(0, self.height - self.xLabelHeight, self.xLabelWidth, self.xLabelHeight);
                            [self drawXLabelDate:date rect:rect attribute:attribute];
                        }else{
                            break;
                        }
                    }else if (i == (self.xLabelCount - 1)) {
                        //最后一个右对齐
                        if(array.count == self.xCount){
                            paragraphStyle.alignment = NSTextAlignmentRight;
                            LineData *data = [array objectAtIndex:(array.count - 1)];
                            NSString *date = data.date;
                            rect = CGRectMake((array.count -1) * self.xPerStepWidth- self.xLabelWidth, self.height - self.xLabelHeight, self.xLabelWidth, self.xLabelHeight);
                            [self drawXLabelDate:date rect:rect attribute:attribute];
                        }
                    }else{
                        //中间居中对齐
                        int index = ((int)round((double)self.xCount/(double)(self.xLabelCount - 1) * (double)i));
                        paragraphStyle.alignment = NSTextAlignmentCenter;
                        if (array.count >= index) {
                            LineData *data = [array objectAtIndex:(index - 1)];
                            NSString *date = data.date;
                            rect = CGRectMake((index-1) * self.xPerStepWidth - self.xLabelWidth/2, self.height - self.xLabelHeight, self.xLabelWidth, self.xLabelHeight);
                            
                            [self drawXLabelDate:date rect:rect attribute:attribute];
                        }
                    }
                    
                }
            }
            
            
        }
    }
}

@end
