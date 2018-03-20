

#import "UIView+CTLine.h"


#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)
#define SINGLE_LINE_DEFAULT_COLOR   [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1]

@implementation UIView (CTLine)


- (void)drawLineInPosition:(CTLinePosition)position
{
    [self drawLineInPosition:position color:SINGLE_LINE_DEFAULT_COLOR];
}

- (void)drawLineInPosition:(CTLinePosition)position width:(CGFloat)width
{
    [self drawLineInPosition:position color:SINGLE_LINE_DEFAULT_COLOR width:width];
}

- (void)drawLineInPosition:(CTLinePosition)postion color:(UIColor *)color
{
    [self drawLineInPosition:postion color:color width:SINGLE_LINE_WIDTH];
}


- (void)drawLineInPosition:(CTLinePosition)postion color:(UIColor *)color width:(CGFloat)width
{
    [self drawLineInPosition:postion color:color width:width edge:UIEdgeInsetsZero];
}

- (void)drawLineInPosition:(CTLinePosition)postion color:(UIColor *)color  edge:(UIEdgeInsets)edge
{
    [self drawLineInPosition:postion color:color width:SINGLE_LINE_WIDTH edge:edge];
}


/**
 *  用shapeLayer的将UIiew的边角添加直线
 *  attention：如果你想线条随view的frame改变而改变，你应该将该方法放在UIView的layoutSubview中最后调用
 *
 *  @param postion 支持的位置
 *  @param color   线条的颜色
 *  @param width   线条宽度
 *  @param edge    edge
 */
- (void)drawLineInPosition:(CTLinePosition)postion color:(UIColor *)color width:(CGFloat)width edge:(UIEdgeInsets)edge
{
    NSString *layerId = [NSString stringWithFormat:@"lineLayer_%ld",(long)postion];
    
    for (CALayer *layer in self.layer.sublayers) {
    
        if ([layer.name isEqualToString:layerId]) {
            [layer removeFromSuperlayer];
            break;
        }
    }
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    //shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = width;
    shapeLayer.frame = self.bounds;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.name = layerId;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = width;
    
    
    /**
     *  https://developer.apple.com/library/ios/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/GraphicsDrawingOverview/GraphicsDrawingOverview.html
     * 仅当要绘制的线宽为奇数像素时，绘制位置需要调整
     */
    CGFloat pixelAdjustOffset = 0;
    if (((int)(width * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    
    if (postion & CTLinePositionTop) {
        //edge.bottom would be invalid
        [path moveToPoint:CGPointMake(0 + edge.left, 0 + edge.top - pixelAdjustOffset)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds)-edge.right, 0 + edge.top - pixelAdjustOffset)];
    }
    
    if (postion & CTLinePositionBottom) {
        //edge.top would be invalid
        [path moveToPoint:CGPointMake( 0 + edge.left, CGRectGetHeight(self.bounds)- width - edge.bottom - pixelAdjustOffset)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds)- edge.right,CGRectGetHeight(self.bounds)- width -  edge.bottom - pixelAdjustOffset)];
    }
    
    if (postion & CTLinePositionLeft) {
        //edge.right would be invalid
        [path moveToPoint:CGPointMake(0 + pixelAdjustOffset + edge.left, 0 + edge.top)];
        [path addLineToPoint:CGPointMake(0 + pixelAdjustOffset + edge.left, CGRectGetHeight(self.bounds) - edge.bottom)];
        
    }
    
    if (postion & CTLinePositionRight) {
        //edge.left would be invalid
        [path moveToPoint:CGPointMake(CGRectGetWidth(self.bounds) - width - edge.right + pixelAdjustOffset, 0 + edge.top)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - width - edge.right + pixelAdjustOffset, CGRectGetHeight(self.bounds) - edge.bottom)];
    }
    
    shapeLayer.path = path.CGPath;
    
    [self.layer addSublayer:shapeLayer];
}


- (void)removeLineInPosition:(CTLinePosition)position
{
    NSString *layerId = [NSString stringWithFormat:@"lineLayer_%ld",(long)position];
    
    for (CALayer *layer in self.layer.sublayers) {
        
        if ([layer.name isEqualToString:layerId]) {
            [layer removeFromSuperlayer];
            break;
        }
    }

}

- (void)drawRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer* shape = [CAShapeLayer layer];
    [shape setPath:roundPath.CGPath];
    self.layer.mask = shape;
}

@end
