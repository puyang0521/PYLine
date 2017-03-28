//
//  BaseBottomView.h
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineData.h"
#import "LongPressDataDelegate.h"
#define kDefaultLineWidth 1
#define kMarkWidth   70*ScreenWidthRate

typedef enum : NSUInteger {
    BaseBottomViewYLabelNormal,
    BaseBottomViewYLabelPercent,
}BaseBottomViewYLabelFormatType;

typedef enum : NSUInteger {
    BaseBottomViewXLabelYYYYMMDD,//年月日
    BaseBottomViewXLabelYYYYMM,//年月
    BaseBottomViewXLabelMMDD,//月日
    BaseBottomViewXLabelYYYY,//年
}BaseBottomViewXLabelFormatType;
typedef enum : NSUInteger {
    BaseBottomViewLongPressLineNormal,//十字线
    BaseBottomViewLongPressLineHorizontal,//只有横线
    BaseBottomViewLongPressLineVertical,//只有竖线
}BaseBottomViewLongPressLineType;
@interface BaseBottomView : UIView
/**
 *  Screen's width.
 */
@property (nonatomic) CGFloat  width;

/**
 *  Screen's height.
 */
@property (nonatomic) CGFloat  height;

/**数据源*/
@property(nonatomic,strong) NSMutableDictionary *totalDataDic;
/**Y值最大值*/
@property (nonatomic)           CGFloat             maxY;
/**Y值最小值*/
@property (nonatomic)           CGFloat             minY;
/** x偏移量*/
@property (nonatomic)           CGFloat             xContentScroll;
/**是否可以滑动*/
@property (nonatomic)           BOOL                scrollEnable;
/**中间值*/
@property (nonatomic,strong)    NSNumber            *middleValue;
/**一页显示X数量*/
@property (nonatomic)           int                 xCount;
@property (nonatomic)           int                 xLineCount;
@property (nonatomic)           int                 xLabelCount;
/**y数量*/
@property (nonatomic)           int                 yCount;
/**x点间距*/
@property (nonatomic)           CGFloat             xPerStepWidth;
/**是否需要对称*/
@property (nonatomic)           BOOL                isNeedSymmetry;
/**是否需要渐变*/
@property (nonatomic,strong)    NSDictionary        *isNeedGradient;
/**横向线是否虚线*/
@property (nonatomic)           BOOL                isHorizontalDash;
/**ylabel是否在图标内*/
@property (nonatomic)           BOOL                isYLabelInChart;
/**左边距  如果ylabel不在图表内。左边距 == yLabelWidth*/
@property (nonatomic)           CGFloat             marginLeft;
@property (nonatomic)           CGFloat             marginTop;

/**线颜色*/
@property (nonatomic,strong)    NSDictionary        *lineColors;
/**线宽度*/
@property (nonatomic,strong)    NSDictionary        *lineWidthes;
/**y坐标小数位数*/
@property (nonatomic)           CGFloat             yBitCount;
/**ylabel是否需要+号*/
@property (nonatomic)           BOOL                IsYLabelNeedPlus;
/**y坐标字体*/
@property (nonatomic,strong)    UIFont              *yFont;
/**x坐标字体*/
@property (nonatomic,strong)    UIFont              *xFont;
/**y坐标颜色*/
@property (nonatomic,strong)    UIColor             *yColor;
/**x坐标颜色*/
@property (nonatomic,strong)    UIColor             *xColor;
/**绘图左边距 即y标签宽度*/
@property (nonatomic)           CGFloat             yLabelWidth;
/**y标签高度*/
@property (nonatomic)           CGFloat             yLabelHeight;
/**即X标签宽度*/
@property (nonatomic)           CGFloat             xLabelWidth;
/**即X标签高度*/
@property (nonatomic)           CGFloat             xLabelHeight;
/**长按线类型*/
@property (nonatomic)           BaseBottomViewLongPressLineType longPressLineType;
/**十字横线*/
@property (nonatomic,strong)    UIView              *tenHLine;
/**十字竖线*/
@property (nonatomic,strong)    UIView              *tenVLine;
/**长按是否需要显示xlabel*/
@property (nonatomic)           BOOL                isShowLongXLabel;
@property (nonatomic,strong)    UILabel             *longTimeLabel;
/**是否需要显示标注*/
@property (nonatomic)           BOOL                isNeedShowMark;
@property (nonatomic,strong)    UIView              *markView;

/**即y标签格式*/
@property (nonatomic)           BaseBottomViewYLabelFormatType   yLabelFormatType;
@property (nonatomic)           BaseBottomViewXLabelFormatType
xLabelFormatType;

@property (nonatomic,strong)    id<LongPressDataDelegate>   delegate;
/**是否长按*/
@property (nonatomic)           BOOL                 isLong;


/**
 添加数据源
 
 @param dataArray 数据源
 @param forKey  关键字 用于存储进dictionary 方便更新数据源
 @param xName x轴属性名
 @param yName y轴属性名
 */
- (void)addDatas:(NSArray*)dataArray forKey:(NSString*)forKey xKeyName:(NSString*)xName yKeyName:(NSString*)yName;

/**
 移动视图
 
 @param contentScroll 偏移量
 */
- (void)panView:(CGFloat)contentScroll;

/**
 移动十字星
 
 @param touchPoint 点击点
 @param forKey     关键字数据
 */
- (void)refreshTen:(CGPoint)touchPoint forKey:(NSString*)forKey;

/**
 删除十字
 */
- (void)removeTen;

/**
 数据数组转为线数组
 
 @param dataArray 数据数组
 @param xName x属性名
 @param yName y属性名
 @return 返回线数据数组
 */
- (NSArray<LineData *>*)lineModelArrayWithDataArray:(NSArray*)dataArray xKeyName:(NSString*)xName yKeyName:(NSString*)yName;

/**
 绘制坐标系
 
 @param ctx <#ctx description#>
 */
- (void)drawCoordinateSystem:(CGContextRef)ctx;

- (void)drawXCoordinateSystem:(CGContextRef)ctx;

- (void)drawYCoordinateSystem:(CGContextRef)ctx;


/**
 生成随机颜色
 
 @return 随机颜色
 */
- (UIColor *)randomColor;


/**
 生成xlabel的宽度和高度
 
 @param content 内容
 */
- (void)generateXLabelWidthAndHeight:(NSString*)content;
/**
 生成ylabel的宽度和高度
 
 @param content 内容
 */
- (void)generateYLabelWidthAndHeight:(NSString*)content;

/**
 *  取两点间直线与Y轴的交点
 *
 *  @param point1 A点
 *  @param point2 B点
 *
 *  @return 与Y轴的交点Y值
 */
-(CGFloat)pointByLineAndYAxixFromPointA:(CGPoint)point1 pointB:(CGPoint)point2  resultX:(CGFloat)resultX;

/**
 画xlabel
 
 @param date 日期
 @param rect 位置
 @param attribute 属性
 */
-(void)drawXLabelDate:(NSString*)date rect:(CGRect)rect attribute:(NSDictionary*)attribute;


/**
 生成一个标记view
 
 @param title 内容
 @param color 颜色
 @return 1
 */
-(UIView*)generateOneMarkView:(NSString*)title color:(UIColor*)color;


-(void)drawMark;

@end
