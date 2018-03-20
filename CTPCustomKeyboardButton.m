//
//  CTPCustomKeyboardButton.m
//  CTPay
//
//  Created by zhao.feng on 2018/3/16.
//  Copyright © 2018年 ctrip. All rights reserved.
//

#import "CTPCustomKeyboardButton.h"
#import "UIColor+CTExtensions.h"
#import "UIView+CTLine.h"

@implementation CTPCustomKeyboardButton

- (void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateHighlighted];
}
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    [self setBackgroundImage:[color toImage] forState:state];
}

- (void)drawLineWithPosition:(CTPKeyboardBtnPosition)position
{
    if ((position & CTPKeyboardBtnPositionTop) == CTPKeyboardBtnPositionTop) {
        [self drawLineInPosition:CTLinePositionTop];
    }
    if ((position & CTPKeyboardBtnPositionBottom) == CTPKeyboardBtnPositionBottom) {
        [self drawLineInPosition:CTLinePositionBottom];
    }
    if ((position & CTPKeyboardBtnPositionLeft) == CTPKeyboardBtnPositionLeft) {
        [self drawLineInPosition:CTLinePositionLeft];
    }
    if ((position & CTPKeyboardBtnPositionRight) == CTPKeyboardBtnPositionRight) {
        [self drawLineInPosition:CTLinePositionRight];
    }
}
@end
