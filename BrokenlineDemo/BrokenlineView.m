//
//  BrokenlineView.m
//  BrokenlineDemo
//
//  Created by Xiniur on 2016/10/14.
//  Copyright © 2016年 Xiniur. All rights reserved.
//

#import "BrokenlineView.h"

@implementation BrokenlineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawBrokenlineWithPointNumber:(NSArray *)numbers
{
    self.backgroundColor = [UIColor colorWithRed:7.0/255 green:79.0/255 blue:86.0/255 alpha:1];
    
    [self layoutIfNeeded];
    
    CGFloat width_W = self.bounds.size.width;
    CGFloat height_H = self.bounds.size.height;
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    //线的路径
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, height_H/2)];
    for (int i = 0; i < numbers.count; i++) {
        CGFloat x = width_W/(numbers.count + 1)*(i+1);
        CGFloat y = height_H / 100 * (100 - [numbers[i] floatValue]);
        
        [bezierPath addLineToPoint:CGPointMake(x, y)];
    }
    [bezierPath addLineToPoint:CGPointMake(width_W, height_H/2)];
    //渐变色区域
    UIBezierPath *imgpath = [UIBezierPath bezierPathWithCGPath:bezierPath.CGPath];
    [imgpath addLineToPoint:CGPointMake(width_W, height_H)];
    [imgpath addLineToPoint:CGPointMake(0, height_H)];
    [imgpath closePath];
    //创建CGContextRef
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    //绘制渐变
    [self drawLinearGradient:gc path:imgpath.CGPath startColor:[UIColor colorWithRed:17.0/255 green:129.0/255 blue:125.0/255 alpha:1].CGColor endColor:self.backgroundColor.CGColor];
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //将生产的image加到view
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self addSubview:imgView];
    //画线
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = bezierPath.CGPath;
    fillLayer.strokeColor = [UIColor colorWithRed:30.0/255 green:188.0/255 blue:182.0/255 alpha:1].CGColor;
    fillLayer.fillColor = [UIColor clearColor].CGColor;
    fillLayer.lineCap = kCALineCapRound;
    fillLayer.lineJoin = kCALineJoinRound;
    fillLayer.lineWidth = 1;
    [self.layer addSublayer:fillLayer];
}

- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(0, CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(0, CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
