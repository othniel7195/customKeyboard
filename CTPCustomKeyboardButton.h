
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, CTPKeyboardBtnPosition) {
    CTPKeyboardBtnPositionTop     = 1 << 0,
    CTPKeyboardBtnPositionBottom  = 1 << 1,
    CTPKeyboardBtnPositionLeft    = 1 << 2,
    CTPKeyboardBtnPositionRight   = 1 << 3,
};


@interface CTPCustomKeyboardButton : UIButton

@property (nonatomic, copy, nullable)NSString *strTag;

- (void)setTitle:(nullable NSString *)title titleColor:(nullable UIColor *)titleColor;
- (void)setBackgroundColor:(nullable UIColor *)color forState:(UIControlState)state;
- (void)drawLineWithPosition:(CTPKeyboardBtnPosition)position;
@end
