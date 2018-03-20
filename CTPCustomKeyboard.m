//
//  CTPCustomKeyboard.m
//  CTPay
//
//  Created by zhao.feng on 2018/3/16.
//  Copyright © 2018年 ctrip. All rights reserved.
//

#import "CTPCustomKeyboard.h"
#import "CTPCustomKeyboardButton.h"
#import "StringUtil.h"

static const CGFloat kCTPCustomKeyboardHeight = 216.0;

@interface CTPCustomKeyboard()
/**
 键盘类型
 */
@property(nonatomic, assign)CTPKBStype kbStype;

@end

@implementation CTPCustomKeyboard


+ (nonnull instancetype)ctp_keyboardWithStyle:(CTPKBStype)stype
{
    return [[CTPCustomKeyboard alloc] initWithFrame:CGRectMake(0, 0, CTScreenWidth, kCTPCustomKeyboardHeight) withStype:stype];
}

- (instancetype)initWithFrame:(CGRect)frame withStype:(CTPKBStype)stype
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _kbStype = stype;
    [self initKeyboardLayout];
    
    return self;
}

- (void)initKeyboardLayout{
    
    switch (self.kbStype) {
        case CTPKBStypeNumberPad:
            [self reloadNumberPad];
            break;
            
        default:
            break;
    }
}

- (void)reloadNumberPad
{
    int cols = 3;//3列
    int rows = 4;//4行
    NSArray *numberPads = @[@[@"1",@"2",@"3"],@[@"4",@"5",@"6"],@[@"7",@"8",@"9"],@[@"blank",@"0",@"delete"]];
    NSArray *numberLinePositions = @[@[@(CTPKeyboardBtnPositionBottom),@(CTPKeyboardBtnPositionLeft|CTPKeyboardBtnPositionBottom|CTPKeyboardBtnPositionRight),@(CTPKeyboardBtnPositionBottom)],@[@(CTPKeyboardBtnPositionBottom),@(CTPKeyboardBtnPositionLeft|CTPKeyboardBtnPositionBottom|CTPKeyboardBtnPositionRight),@(CTPKeyboardBtnPositionBottom)],@[@(CTPKeyboardBtnPositionBottom),@(CTPKeyboardBtnPositionLeft|CTPKeyboardBtnPositionBottom|CTPKeyboardBtnPositionRight),@(CTPKeyboardBtnPositionBottom)],@[@(0),@(CTPKeyboardBtnPositionLeft|CTPKeyboardBtnPositionRight),@(0)]];
    
    CGFloat itemWidth = CTScreenWidth/cols;
    CGFloat itemHeight = kCTPCustomKeyboardHeight/rows;
    
    for (int col = 0; col < cols; col++) {
        for (int row = 0; row < rows; row++) {
            
            CGRect frame = CGRectMake(col * itemWidth, row * itemHeight, itemWidth, itemHeight);
            CTPCustomKeyboardButton *numBtn = [CTPCustomKeyboardButton buttonWithType:UIButtonTypeCustom];
            numBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            numBtn.titleLabel.textColor = [UIColor whiteColor];
            numBtn.frame = frame;
            NSString *numberString = numberPads[row][col];
            numBtn.strTag = numberString;
            NSNumber *position = numberLinePositions[row][col];
            [numBtn drawLineWithPosition:position.integerValue];
            
            if ([StringUtil isNumString:numberString]) {
                [numBtn setTitle:numberString titleColor:[UIColor blackColor]];
                [numBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [numBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            }else if ([numberString isEqualToString:@"delete"]){
                [numBtn setTitle:@"DEL" titleColor:[UIColor blackColor]];
                [numBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            }
            [numBtn addTarget:self action:@selector(inputNumberDone:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:numBtn];
        }
        
    }
}
- (CGFloat)ctp_keyboardHeight
{
    return kCTPCustomKeyboardHeight;
}
- (void)inputNumberDone:(CTPCustomKeyboardButton *)btn{
    CLog(@"点击键盘按钮：%@", btn.strTag);
    if ([btn.strTag isEqualToString:@"delete"]) {
        if (self.inputSource) {
            if ([self.inputSource isKindOfClass:[UITextField class]]) {
                UITextField *tmp = (UITextField *)self.inputSource;
                [tmp deleteBackward];
            }else if ([self.inputSource isKindOfClass:[UITextView class]]){
                UITextView *tmp = (UITextView *)self.inputSource;
                [tmp deleteBackward];
            }else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
                UISearchBar *tmp = (UISearchBar *)self.inputSource;
                NSMutableString *info = [NSMutableString stringWithString:tmp.text];
                if (info.length > 0) {
                    NSString *s = [info substringToIndex:info.length-1];
                    [tmp setText:s];
                }
            }
        }
    }else{
        NSString *title = [btn titleLabel].text;
        if (self.inputSource) {
            if ([self.inputSource isKindOfClass:[UITextField class]]) {
                UITextField *tmp = (UITextField *)self.inputSource;
                
                if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
                    NSRange range = NSMakeRange(tmp.text.length, 1);
                    BOOL ret = [tmp.delegate textField:tmp shouldChangeCharactersInRange:range replacementString:title];
                    if (ret) {
                        [tmp insertText:title];
                    }
                }else{
                    [tmp insertText:title];
                }
                
            }else if ([self.inputSource isKindOfClass:[UITextView class]]){
                UITextView *tmp = (UITextView *)self.inputSource;
                
                if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
                    NSRange range = NSMakeRange(tmp.text.length, 1);
                    BOOL ret = [tmp.delegate textView:tmp shouldChangeTextInRange:range replacementText:title];
                    if (ret) {
                        [tmp insertText:title];
                    }
                }else{
                    [tmp insertText:title];
                }
                
            }else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
                UISearchBar *tmp = (UISearchBar *)self.inputSource;
                NSMutableString *info = [NSMutableString stringWithString:tmp.text];
                [info appendString:title];
                
                if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
                    NSRange range = NSMakeRange(tmp.text.length, 1);
                    BOOL ret = [tmp.delegate searchBar:tmp shouldChangeTextInRange:range replacementText:title];
                    if (ret) {
                        [tmp setText:[info copy]];
                    }
                }else{
                    [tmp setText:[info copy]];
                }
            }
        }
    }
    
}
@end
