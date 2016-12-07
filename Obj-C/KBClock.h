

#import <UIKit/UIKit.h>
#define KBClockSize 200  
#if ! __has_feature(objc_arc)
#error "Need to Open ARC"
#endif

@protocol KBClockDelegate <NSObject>

@optional
-(UIColor*)rimColor;
-(UIColor*)markColor;
-(UIColor*)faceColor;
-(UIColor*)fontColor;
-(UIColor*)secondHandColor;
-(UIColor*)hourAndMinuteHandColor;
@end


@interface KBClock : UIView

@property (weak, nonatomic) id<KBClockDelegate> delegate;

typedef NS_ENUM(NSUInteger, KBClockTheme) {
    Default = 0,
    Dark,
    Moderm
};

-(instancetype)initWithDelegate:(id<KBClockDelegate>)delegate frame:(CGRect)frame;

-(instancetype)initWithTheme:(KBClockTheme)theme frame:(CGRect)frame;



@end
