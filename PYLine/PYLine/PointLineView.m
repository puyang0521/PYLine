//
//  PointLineView.m
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import "PointLineView.h"
#import "PointViewData.h"
#import "PointData.h"
#import "TrendLine.h"
@interface PointLineView()
@property(nonatomic,strong) NSMutableDictionary *dateDic;
/**日期字典关键字排序后数组*/
@property(nonatomic,strong) NSMutableArray      *dateDicKeyArray;
@property(nonatomic,strong) NSMutableDictionary *pointDic;
@end

@implementation PointLineView

- (id)initWithFrame:(CGRect)frame xCount:(int)x yCount:(int)y{
    self = [super initWithFrame:frame];
    if (self) {
        //x数量
        self.xCount     = x;
        //一页显示的x数量
        self.xMaxCount  = x;
        self.yCount     = y;
        self.xLineCount = 3;
        self.yBitCount  = 2;
        self.xFont      = [UIFont HeitiSCWithFontSize:11];
        self.xColor     = [@"333333" hexColor];
        self.yFont      = [UIFont HeitiSCWithFontSize:11];
        self.yColor     = [@"333333" hexColor];
        self.totalDataDic = [[NSMutableDictionary alloc] init];
        self.dateDic    = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)addDatas:(NSArray*)dataArray forKey:(NSString*)forKey xKeyName:(NSString*)xName yKeyName:(NSString*)yName{
    //将数据放入数据源
    [self.totalDataDic setObject:dataArray forKey:forKey];
    
    //处理数据。。生成日期字典、时间字典等
    [self analysisDatasWithArray:dataArray forKey:forKey xKeyName:xName yKeyName:yName];
    
    self.dateDicKeyArray =[[NSMutableArray alloc] initWithArray: self.dateDic.allKeys];
    [self.dateDicKeyArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *key1 = obj1;
        NSString *key2 = obj2;
        return [key1 compare:key2];
    }];
    if (!self.scrollEnable) {
        //如果不能滑动 则判断
        int totalCount = (int)self.dateDicKeyArray.count  * self.numberOfGroup ;
        if (totalCount > self.xMaxCount){
            //大于一页 可以滑动
            self.scrollEnable = YES;
            self.xCount = self.xMaxCount;
        }else{
            //小于一页
            self.xCount = totalCount;
            
        }
        
    }else{
        //如果能滑动。 则不用判断
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    if (self.xCount <= 1 || self.yCount <=0 ) {
        return;
    }
    if (self.middleValue.doubleValue == 0) {
        self.middleValue = @(1);
    }
    if(!self.isNeedSymmetry){
        //不用对称式 maxY和minY 为 -1 并在赋值时判断
        self.maxY        = -1;
        self.minY        = -1;
    }else{
        self.maxY        = self.middleValue.doubleValue;
        self.minY        = self.middleValue.doubleValue;
    }
    
    
    
    self.pointDic = [[NSMutableDictionary alloc] init];
    
    [self generateHeightAndWidth];
    if(self.dateDic.count >= 5){
        self.xLineCount = 6;
    }else if(self.dateDic.count <= 1){
        
    }else{
        self.xLineCount = (int)self.dateDic.count +1;
    }
    
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    [self drawCoordinateSystem:ctx];
    [self drawLabel];
    [self drawPointLine:ctx];
}

- (void)generateHeightAndWidth{
    
    NSArray *keyArray = self.totalDataDic.allKeys;
    for (int i = 0 ; i <keyArray.count; i++) {
        [self.pointDic setObject:[[NSMutableArray alloc] init] forKey:[keyArray objectAtIndex:i]];
    }
    
    
    //X轴 列间距
    self.xPerStepWidth = (self.width - self.marginLeft ) / (self.xCount-1);
    
    
    if (self.dateDic.count > 0) {
        if (self.scrollEnable) {
            //可滚动
            for (int i = ((int)self.dateDicKeyArray.count - 1); i>=0; i--) {
                if (((self.xMaxCount/self.numberOfGroup - ((int)self.dateDicKeyArray.count - i -1 )) * self.numberOfGroup * self.xPerStepWidth ) +self.xContentScroll +self.marginLeft   <= 0) {
                    //因为从右往左确定，故break;
                    break;
                }
                if((self.xMaxCount/self.numberOfGroup - ((int)self.dateDicKeyArray.count - i))*self.numberOfGroup * self.xPerStepWidth +self.xContentScroll +self.marginLeft > self.width){
                    //在屏幕右侧
                    //因为从右往左确定， 故continue;
                    continue;
                }
                [self analysisToPointDicByIndex:i];
                
            }
            
        }else{
            //不可滚动
            for (int i = 0; i<self.dateDicKeyArray.count; i++) {
                [self analysisToPointDicByIndex:i];
                
            }
        }
        
        if(self.isNeedSymmetry){
            if ((self.maxY - self.middleValue.doubleValue) > (self.middleValue.doubleValue - self.minY)) {
                self.minY = self.middleValue.doubleValue - (self.maxY - self.middleValue.doubleValue);
            }else if((self.maxY - self.middleValue.doubleValue) < (self.middleValue.doubleValue - self.minY)){
                self.maxY = self.middleValue.doubleValue + (self.middleValue.doubleValue - self.minY);
            }
            
        }
    }
    
    
    
}



-(void)analysisToPointDicByIndex:(NSInteger)i{
    
    NSString *date =[self.dateDicKeyArray objectAtIndex:i];
    NSMutableArray *timeArray = [self.dateDic objectForKey:date];
    
    for (int j = 0 ; j<timeArray.count; j++) {
        
        PointViewData *data = [timeArray objectAtIndex:j];
        
        for (int k = 0; k<data.dataDic.allKeys.count; k++) {
            NSString *forKey =[data.dataDic.allKeys objectAtIndex:k];
            NSNumber *value = [data.dataDic objectForKey:forKey];
            if (self.minY == -1 || self.maxY == -1) {
                self.maxY = value.doubleValue;
                self.minY = value.doubleValue;
            }
            
            
            if (value.doubleValue > self.maxY) {
                self.maxY = value.doubleValue;
            }else if(value.doubleValue < self.minY){
                self.minY = value.doubleValue;
            }
            
            if(self.groupType == PointLineViewGroupByTime){
                //分时
                [self generateXLabelWidthAndHeight:data.time];
            }else{
                //日期
                [self generateXLabelWidthAndHeight:date];
                
            }
            
            [self generateXLabelWidthAndHeight:data.time];
            if(self.yLabelFormatType == BaseBottomViewYLabelPercent){
                NSString *valueStr = [NumberFormatter percentStyleWithValue:value.doubleValue maximumFractionDigits:self.yBitCount minimumFractionDigits:self.yBitCount roundingMode:NSNumberFormatterRoundHalfUp];
                [self generateYLabelWidthAndHeight:valueStr];
                
            }else if(self.yLabelFormatType == BaseBottomViewYLabelNormal){
                
                NSString *valueStr = [NumberFormatter normalStyleWithValue:value.doubleValue maximumFractionDigits:self.yBitCount minimumFractionDigits:self.yBitCount roundingMode:NSNumberFormatterRoundHalfUp];
                [self generateYLabelWidthAndHeight:valueStr];
                
                
            }
            PointData *point = [[PointData alloc] init];
            point.index = i * self.groupDataArray.count + j;
            point.value = value;
            point.time  = data.time;
            point.date  = data.date;
            NSMutableArray *pointArray =[self.pointDic objectForKey:forKey];
            [pointArray addObject:point];
        }
    }
    
    
    
    
}

- (void)drawLabel{
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
        
        CGRect rect =CGRectMake( 0 , i * (self.height-self.xLabelHeight) / (self.yCount - .45), self.yLabelWidth, self.yLabelHeight);
        if(self.yLabelFormatType == BaseBottomViewYLabelPercent){
            NSString *value = [NumberFormatter percentStyleWithValue:(self.maxY - i * (self.maxY - self.minY)/(self.yCount -1)) maximumFractionDigits:self.yBitCount minimumFractionDigits:self.yBitCount roundingMode:NSNumberFormatterRoundHalfUp];
            [value drawInRect:rect withAttributes:attribute];
        }else if(self.yLabelFormatType == BaseBottomViewYLabelNormal){
            
            NSString *value = [NumberFormatter normalStyleWithValue:(self.maxY - i * (self.maxY - self.minY)/(self.yCount -1)) maximumFractionDigits:self.yBitCount minimumFractionDigits:self.yBitCount roundingMode:NSNumberFormatterRoundHalfUp];
            [value drawInRect:rect withAttributes:attribute];
            
        }
        
        
    }
    
    
}

-(void)drawXLabel{
    NSMutableDictionary *attribute              = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraphStyle     = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment                    = NSTextAlignmentLeft;
    attribute[NSParagraphStyleAttributeName]    = paragraphStyle;
    attribute[NSForegroundColorAttributeName]   = self.xColor;
    attribute[NSFontAttributeName]              = self.xFont;
    
    if(self.groupType == PointLineViewGroupByTime){
        //当天分时
        
        for (int i = 0;  i < 5; i++) {
            CGRect rect =CGRectMake( self.marginLeft + i * (self.width - self.marginLeft) / 4.7 ,(self.height-self.xLabelHeight), self.xLabelWidth, self.xLabelHeight);
            
            if (i == 0) {
                paragraphStyle.alignment                    = NSTextAlignmentLeft;
                
            }else if(i == 4){
                paragraphStyle.alignment                    = NSTextAlignmentRight;
            }else{
                paragraphStyle.alignment                    = NSTextAlignmentCenter;
                
            }
            NSString *time = [self.groupDataArray objectAtIndex:(self.groupDataArray.count-1)/4*i];
            [time drawInRect:rect withAttributes:attribute];
            
        }
        
    }else{
        paragraphStyle.alignment                    = NSTextAlignmentCenter;
        
        //多天数据
        int count =(int) self.dateDic.count;
        if (count > (self.xMaxCount / self.numberOfGroup)) {
            count = (self.xMaxCount / self.numberOfGroup);
        }
        CGFloat width =(self.width - self.marginLeft) / count;
        
        
        
        
        
        for (int i = ((int)self.dateDicKeyArray.count - 1 );  i >=0 ; i--) {
            
            double x = self.marginLeft + (self.xCount/self.numberOfGroup - ((int)self.dateDicKeyArray.count - i)) * width + (width - self.xLabelWidth)/2 + self.xContentScroll;
            
            if ( x + self.xLabelWidth/2 >= self.marginLeft && x + self.xLabelWidth/2 <= self.width ) {
                CGRect rect =CGRectMake( x  ,(self.height-self.xLabelHeight) +4*ScreenHeightRate, self.xLabelWidth, self.xLabelHeight);
                
                NSString *date = [self.dateDicKeyArray objectAtIndex:i];
                if(date.length > 5){
                    date = [date substringFromIndex:5];
                }
                
                [date drawInRect:rect withAttributes:attribute];
                
            }
        }
    }
    
    
    
}



-(void)drawPointLine:(CGContextRef)ctx{
    for(UIView *v in self.subviews){
        if ([v isKindOfClass:[TrendLine class]]) {
            [v removeFromSuperview];
        }
    }
    
    for (int i = 0; i<self.pointDic.allKeys.count; i++) {
        NSString *forKey =[self.pointDic.allKeys objectAtIndex:i];
        NSArray *dataPointArray = [self.pointDic objectForKey:forKey];
        if (dataPointArray.count > 0) {
            NSMutableArray *pointArray = [[NSMutableArray alloc] init];
            NSString *lastDate = @"";
            
            for (int j = 0; j < dataPointArray.count; j++) {
                
                
                PointData *pData = [dataPointArray objectAtIndex:j];
                
                if(![lastDate isEqualToString: pData.date]){
                    [self generateLineView:pointArray forKey:forKey];
                    pointArray =[[NSMutableArray alloc] init];
                }
                
                double x =self.width - (self.dateDicKeyArray.count * self.numberOfGroup - pData.index-1 ) * self.xPerStepWidth+self.marginLeft + self.xContentScroll;
                if (x < self.marginLeft || x > self.width) {
                    if (pointArray.count > 0) {
                        [self generateLineView:pointArray forKey:forKey];
                        pointArray =[[NSMutableArray alloc] init];
                    }
                    continue;
                }
                pData.x  = x;
                double value = pData.value.doubleValue;
                double y = (self.height - self.xLabelHeight) * ((self.maxY - value) / (self.maxY - self.minY));
                CGPoint point =  CGPointMake(x, y);
                [pointArray addObject:[[NSArray alloc] initWithObjects:NSStringFromCGPoint(point),pData, nil] ];
                
                lastDate = pData.date;
                
                if(j == dataPointArray.count - 1   ){
                    [self generateLineView:pointArray forKey:forKey];
                    
                }
            }
            
            
            
            
        }
        
    }
    
    
}

-(void)generateLineView:(NSArray*)pointArray forKey:(NSString*)forKey{
    if (pointArray.count > 0 ) {
        TrendLine *line = [[TrendLine alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - self.xLabelHeight)];
        //pointArray  0 点  1 数据
        line.dataArray  = pointArray;
        line.forKey  = forKey;
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
        [line drawContent];
        
        [self addSubview:line];
        
    }
    
    
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)analysisDatasWithArray:(NSArray*)dataArray forKey:(NSString*)forKey xKeyName:(NSString*)xName yKeyName:(NSString*)yName {
    
    for (int i = 0; i <dataArray.count; i++) {
        id data = [dataArray objectAtIndex:i];
        NSString *date = [data valueForKey:xName];
        NSNumber *value = [data valueForKey:yName];
        
        if (date.length >= 16 ) {
            NSString *d = [date substringToIndex:10];
            NSString *t = [date substringWithRange:NSMakeRange(11, 5)];
            NSMutableArray *timeArray = nil;
            if ([self.dateDic.allKeys containsObject:d]) {
                //如果日期已经包含
                timeArray = [self.dateDic objectForKey:d];
            }else{
                //日期未包含
                timeArray = [[NSMutableArray alloc] init];
                for (int j = 0; j<self.groupDataArray.count; j++) {
                    PointViewData *data = [[PointViewData alloc] init];
                    data.time = [self.groupDataArray objectAtIndex:j];
                    data.date = d;
                    [timeArray addObject:data];
                }
                [self.dateDic setObject:timeArray forKey:d];
            }
            PointViewData *data = [timeArray objectAtIndex:[self.groupDataArray indexOfObject:t]];
            [data.dataDic setObject:value forKey:forKey];
            
        }else{
            NSLog(@"时间参数有误 下发的参数是 %@",date);
            break;
        }
    }
}

- (void)drawYCoordinateSystem:(CGContextRef)ctx{
    
    
    //f2f6f9
    CGContextSetRGBStrokeColor(ctx, 242.0/255.0, 246.0/255.0, 249.0/255.0, 1);
    CGContextSetLineWidth(ctx, 1);
    
    
    
    
    if (self.groupType == PointLineViewGroupByTime || self.dateDic.count == 1) {
        //分时
        [super drawYCoordinateSystem:ctx];
    }else{
        //日期
        CGContextMoveToPoint(ctx,  self.marginLeft, 0);
        CGContextAddLineToPoint(ctx, self.marginLeft, self.height - self.xLabelHeight);
        CGContextStrokePath(ctx);
        
        CGContextMoveToPoint(ctx,  self.width, 0);
        CGContextAddLineToPoint(ctx, self.width, self.height - self.xLabelHeight);
        CGContextStrokePath(ctx);
        if(self.dateDicKeyArray.count == 0){
            [super drawYCoordinateSystem:ctx];
        }else{
            for (int i = ((int)self.dateDicKeyArray.count - 1 );  i >=0 ; i--) {
                
                double x = 0;
                
                if (self.scrollEnable) {
                    x =  ((self.xMaxCount/self.numberOfGroup - ((int)self.dateDicKeyArray.count - i)) * self.numberOfGroup * self.xPerStepWidth ) +self.xContentScroll +self.marginLeft;
                }else{
                    if (self.xCount == 0) {
                        return;
                    }
                    
                    x = ((self.width - self.marginLeft)/(self.xCount/self.numberOfGroup)*i)+self.marginLeft;
                }
                
                
                
                if ( x  >= self.marginLeft && x  <= self.width ) {
                    CGContextMoveToPoint(ctx,  x, 0);
                    CGContextAddLineToPoint(ctx, x, self.height - self.xLabelHeight);
                    CGContextStrokePath(ctx);
                    
                }
            }
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
        NSInteger count = self.dateDic.count * self.numberOfGroup;
        
        //当向右滑动移动值为正数  移动值大于（总数量-1） * 每点间隔 即 总宽度
        if (self.xContentScroll > ((int)count - (int)self.xCount  )*self.xPerStepWidth) {
            //设置移动值为 最右值
            self.xContentScroll  = (count - self.xCount  )*self.xPerStepWidth;
        }
        
        [self setNeedsDisplay];
    }
}

@end
