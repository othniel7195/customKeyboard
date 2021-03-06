
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, CTPKBStype) {
    CTPKBStypeNumberPad = 1 << 0,
};


typedef void(^CTPCustomKeyboardDeleteBackward)(NSString * _Nullable text);

@interface CTPCustomKeyboard : UIView


/**
 输入源
 */
@property (nonatomic, weak, nullable)id inputSource;
@property (nonatomic, copy, nullable)CTPCustomKeyboardDeleteBackward deleteBackwardCallBack;

/**
 键盘初始化

 @param stype 键盘类型
 @return 返回键盘
 */
+ (nonnull instancetype)ctp_keyboardWithStyle:(CTPKBStype)stype;

+ (CGFloat)ctp_keyboardHeight;

@end
