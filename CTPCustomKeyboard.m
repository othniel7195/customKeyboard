
#import "CTPCustomKeyboard.h"
#import "CTPCustomKeyboardButton.h"
#import "StringUtil.h"
#import "CTVectorImageView.h"

static const CGFloat kCTPCustomKeyboardHeight = 200.0;

@interface CTPCustomKeyboard()
/**
 键盘类型
 */
@property(nonatomic, assign)CTPKBStype kbStype;

@end

@implementation CTPCustomKeyboard


+ (nonnull instancetype)ctp_keyboardWithStyle:(CTPKBStype)stype
{
    CGFloat h = kCTPCustomKeyboardHeight;
    if ([CTDevice isIphoneX]) {
        h += 39.0;
    }
    return [[CTPCustomKeyboard alloc] initWithFrame:CGRectMake(0, 0, CTScreenWidth, h) withStype:stype];
}

- (instancetype)initWithFrame:(CGRect)frame withStype:(CTPKBStype)stype
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = CTColorHex(0xEFEFF4);
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

- (void)setInputSource:(id)inputSource
{
    _inputSource = inputSource;
    if (@available(iOS 9.0, *)) {
        
        if ([inputSource isKindOfClass:[UITextField class]]) {
            UITextField *tmp = (UITextField *)inputSource;
            UITextInputAssistantItem *item = tmp.inputAssistantItem;
            item.leadingBarButtonGroups = @[];
            item.trailingBarButtonGroups = @[];
            
        }else if ([inputSource isKindOfClass:[UITextView class]]){
            UITextView *tmp = (UITextView *)inputSource;
            UITextInputAssistantItem *item = tmp.inputAssistantItem;
            item.leadingBarButtonGroups = @[];
            item.trailingBarButtonGroups = @[];
        }else if ([inputSource isKindOfClass:[UISearchBar class]]){
            UISearchBar *tmp = (UISearchBar *)inputSource;
            UITextInputAssistantItem *item = tmp.inputAssistantItem;
            item.leadingBarButtonGroups = @[];
            item.trailingBarButtonGroups = @[];
        }
        
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
            numBtn.titleLabel.font = CTFontSysteSize(24);
            NSString *numberString = numberPads[row][col];
            numBtn.strTag = numberString;
            NSNumber *position = numberLinePositions[row][col];
            [numBtn drawLineWithPosition:position.integerValue];
            
            if ([StringUtil isNumString:numberString]) {
                [numBtn setTitle:numberString titleColor:[UIColor blackColor]];
                [numBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [numBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            }else if ([numberString isEqualToString:@"delete"]){
                CTVectorImageView *delImgView = [[CTVectorImageView alloc] initWithFrame:CGRectMake(0, 0, 34.0, 26) iconFontFamliyName:eCTIConFontFamilyName_pay imageCode:pay_icon_cancele62b_o_xe62b];
                delImgView.imageColor = CTColorHex(0x333333);
                UIImage *delImage = [delImgView toUIImage];
                [numBtn setImage:delImage forState:UIControlStateNormal];
                [numBtn setBackgroundColor:CTColorHex(0xEFEFF4) forState:UIControlStateNormal];
                [numBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            }
            [self addSubview:numBtn];
            [numBtn addTarget:self action:@selector(inputNumberDone:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
}
+ (CGFloat)ctp_keyboardHeight
{
    CGFloat h = kCTPCustomKeyboardHeight;
    if ([CTDevice isIphoneX]) {
        h += 39.0;
    }
    return h;
}

- (void)inputNumberDone:(CTPCustomKeyboardButton *)btn{
    CLog(@"点击键盘按钮：%@", btn.strTag);
    if ([btn.strTag isEqualToString:@"blank"]) {
        return;
    }
    if ([btn.strTag isEqualToString:@"delete"]) {
        if (self.inputSource) {
            if ([self.inputSource isKindOfClass:[UITextField class]]) {
                UITextField *tmp = (UITextField *)self.inputSource;
                [tmp deleteBackward];
                if(self.deleteBackwardCallBack){
                    self.deleteBackwardCallBack(tmp.text);
                }
                
            }else if ([self.inputSource isKindOfClass:[UITextView class]]){
                UITextView *tmp = (UITextView *)self.inputSource;
                [tmp deleteBackward];
                if(self.deleteBackwardCallBack){
                    self.deleteBackwardCallBack(tmp.text);
                }
            }else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
                UISearchBar *tmp = (UISearchBar *)self.inputSource;
                NSMutableString *info;
                if (tmp.text) {
                    info = [NSMutableString stringWithString:tmp.text];
                }
                if (info.length > 0) {
                    NSString *s = [info substringToIndex:info.length-1];
                    [tmp setText:s];
                }
                if(self.deleteBackwardCallBack){
                    self.deleteBackwardCallBack(tmp.text);
                }
            }
        }
    }else{
        NSString *title = [btn titleLabel].text;
        if (self.inputSource) {
            if ([self.inputSource isKindOfClass:[UITextField class]]) {
                UITextField *tmp = (UITextField *)self.inputSource;
                
                if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
                    NSRange range = NSMakeRange(tmp.text.length, 0);
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
                    NSRange range = NSMakeRange(tmp.text.length, 0);
                    BOOL ret = [tmp.delegate textView:tmp shouldChangeTextInRange:range replacementText:title];
                    if (ret) {
                        [tmp insertText:title];
                    }
                }else{
                    [tmp insertText:title];
                }
                
            }else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
                UISearchBar *tmp = (UISearchBar *)self.inputSource;
                NSMutableString *info;
                if (tmp.text) {
                      info = [NSMutableString stringWithString:tmp.text];
                }
                [info appendString:title];
                if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
                    NSRange range = NSMakeRange(tmp.text.length, 0);
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
