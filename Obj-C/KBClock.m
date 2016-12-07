 

#import "KBClock.h"

@interface KBClock(){
    UIColor* rimColor;
    UIColor* faceColor;
    UIColor* markColor;
    UIColor* secondHandColor;
    UIColor* fontColor;
    UIColor* hourAndMinuteHandColor;
    KBClockTheme _theme;
    float _scale;
    CGPoint _centerPoint;
}
@end


@implementation KBClock


-(instancetype)initWithDelegate:(id<KBClockDelegate>)delegate frame:(CGRect)frame{
    CGFloat size = frame.size.height>frame.size.width?frame.size.height:frame.size.width;
    CGRect realRect = CGRectMake(frame.origin.x, frame.origin.y, size, size);
    self = [self initWithFrame:realRect];
    if (self) {
        _scale = realRect.size.height / KBClockSize;
        _centerPoint = CGPointMake(size/2, size/2);
        
        rimColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
        faceColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        markColor = [UIColor colorWithRed:  160.0/255.0 green: 160.0/255.0 blue: 160.0/255.0 alpha: 1];
        secondHandColor = [UIColor colorWithRed: 86.0/255.0 green: 232.0/255.0 blue: 157.0/255.0 alpha: 1];
        fontColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
        hourAndMinuteHandColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];

		
        if ([delegate respondsToSelector:NSSelectorFromString(@"rimColor")]) {
            rimColor = [delegate rimColor];
        }
        if ([delegate respondsToSelector:NSSelectorFromString(@"faceColor")]) {
            faceColor = [delegate faceColor];
        }
        if ([delegate respondsToSelector:NSSelectorFromString(@"markColor")]) {
            markColor = [delegate markColor];
        }
        if ([delegate respondsToSelector:NSSelectorFromString(@"fontColor")]) {
            fontColor = [delegate fontColor];
        }
        if ([delegate respondsToSelector:NSSelectorFromString(@"hourAndMinuteHandColor")]) {
            hourAndMinuteHandColor = [delegate hourAndMinuteHandColor];
        }
        if ([delegate respondsToSelector:NSSelectorFromString(@"secondHandColor")]) {
            secondHandColor = [delegate secondHandColor];
        }
		
		
        UIImage *img = [self drawSecondHandWithColor:secondHandColor scale:_scale frameSize:CGSizeMake(size, size) currentAngle:[self secondAngleFromDate:[NSDate new]]];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
        imgV.frame = CGRectMake(0 , 0, size, size);
        [self addSubview:imgV];
        
        
        CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        basicAnimation.toValue=[NSNumber numberWithFloat:2*M_PI];
        
        basicAnimation.duration=60.0;
        basicAnimation.autoreverses=false;
        basicAnimation.repeatCount = CGFLOAT_MAX;
        
        imgV.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        [imgV.layer addAnimation:basicAnimation forKey:@"Rotation"];
        
        [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    self.backgroundColor = [UIColor clearColor];
    return self;

}


-(instancetype)initWithTheme:(KBClockTheme)theme frame:(CGRect)frame{
    CGFloat size = frame.size.height>frame.size.width?frame.size.height:frame.size.width;
    CGRect realRect = CGRectMake(frame.origin.x, frame.origin.y, size, size);
    self = [self initWithFrame:realRect];
    if (self) {
        _theme = theme;
        _scale = realRect.size.height / KBClockSize;
        _centerPoint = CGPointMake(size/2, size/2);
        
        switch (theme) {
            case Default:
                rimColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
                faceColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
                markColor = [UIColor colorWithRed:  160.0/255.0 green: 160.0/255.0 blue: 160.0/255.0 alpha: 1];
                secondHandColor = [UIColor colorWithRed: 86.0/255.0 green: 232.0/255.0 blue: 157.0/255.0 alpha: 1];
                fontColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
                hourAndMinuteHandColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
                break;
                
            case Dark:
                rimColor = [UIColor colorWithRed: 66.0/255 green: 66.0/255 blue: 66.0/255 alpha: 1];
                faceColor = [UIColor colorWithRed: 66.0/255 green: 66.0/255 blue: 66.0/255 alpha: 1];
                markColor = [UIColor colorWithRed:  1 green: 1 blue: 1 alpha: 1];
                secondHandColor = [UIColor colorWithRed: 32.0/255.0 green: 250.0/255.0 blue: 200.0/255.0 alpha: 1];
                fontColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
                hourAndMinuteHandColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
                break;
                
            case Moderm:
                rimColor = [UIColor colorWithRed: 60.0/255 green: 90.0/255 blue: 110.0/255 alpha: 1];
                faceColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
                markColor = [UIColor colorWithRed:  160.0/255.0 green: 160.0/255.0 blue: 160.0/255.0 alpha: 1];
                secondHandColor = [UIColor colorWithRed: 210.0/255.0 green: 0 blue: 10.0/255.0 alpha: 1];
                fontColor = [UIColor colorWithRed: 210.0/255.0 green: 0 blue: 10.0/255.0 alpha: 1];
                hourAndMinuteHandColor = [UIColor colorWithRed: 60.0/255 green: 90.0/255 blue: 110.0/255 alpha: 1];
                break;
            default:
                rimColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
                faceColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
                markColor = [UIColor colorWithRed:  160.0/255.0 green: 160.0/255.0 blue: 160.0/255.0 alpha: 1];
                secondHandColor = [UIColor colorWithRed: 86.0/255.0 green: 232.0/255.0 blue: 157.0/255.0 alpha: 1];
                fontColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
                hourAndMinuteHandColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
                break;
        }
        
        if ([_delegate rimColor]) {
            rimColor = [_delegate rimColor];
        }
        if ([_delegate faceColor]) {
           faceColor = [_delegate faceColor];
        }
        if ([_delegate markColor]) {
            markColor = [_delegate markColor];
        }
        if ([_delegate fontColor]) {
            fontColor = [_delegate fontColor];
        }
        if ([_delegate faceColor]) {
            faceColor = [_delegate faceColor];
        }
        if ([_delegate hourAndMinuteHandColor]) {
            hourAndMinuteHandColor = [_delegate hourAndMinuteHandColor];
        }
        if ([_delegate secondHandColor]) {
            secondHandColor = [_delegate secondHandColor];
        }
        
        
        
        UIImage *img = [self drawSecondHandWithColor:secondHandColor scale:_scale frameSize:CGSizeMake(size, size) currentAngle:[self secondAngleFromDate:[NSDate new]]];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
        imgV.frame = CGRectMake(0 , 0, size, size);
        [self addSubview:imgV];
        
        CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        basicAnimation.toValue=[NSNumber numberWithFloat:2*M_PI];
        
        basicAnimation.duration=60.0;
        basicAnimation.autoreverses=false;
        basicAnimation.repeatCount = CGFLOAT_MAX;
        
        imgV.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        [imgV.layer addAnimation:basicAnimation forKey:@"Rotation"];

        [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}

-(void)onTimer{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self drawKBClockWithScale:_scale centerPoint:_centerPoint currentDate:[NSDate new]];


}


-(UIImage*)drawSecondHandWithColor:(UIColor*)color scale:(CGFloat)scale frameSize:(CGSize)size currentAngle:(float)currentAngle{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //// secondHand Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, size.height/2, size.height/2);
    CGContextRotateCTM(context, (currentAngle - 90) * M_PI / 180);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* secondHandPath = UIBezierPath.bezierPath;
    [secondHandPath moveToPoint: CGPointMake(4.96, -4.87)];
    [secondHandPath addCurveToPoint: CGPointMake(6.93, -0.92) controlPoint1: CGPointMake(6.07, -3.76) controlPoint2: CGPointMake(6.73, -2.37)];
    [secondHandPath addLineToPoint: CGPointMake(66.01, -0.92)];
    [secondHandPath addLineToPoint: CGPointMake(66.01, 0.08)];
    [secondHandPath addLineToPoint: CGPointMake(7.01, 0.08)];
    [secondHandPath addCurveToPoint: CGPointMake(4.96, 5.03) controlPoint1: CGPointMake(7.01, 1.87) controlPoint2: CGPointMake(6.32, 3.66)];
    [secondHandPath addCurveToPoint: CGPointMake(-4.94, 5.03) controlPoint1: CGPointMake(2.22, 7.76) controlPoint2: CGPointMake(-2.21, 7.76)];
    [secondHandPath addCurveToPoint: CGPointMake(-4.94, -4.87) controlPoint1: CGPointMake(-7.68, 2.29) controlPoint2: CGPointMake(-7.68, -2.14)];
    [secondHandPath addCurveToPoint: CGPointMake(4.96, -4.87) controlPoint1: CGPointMake(-2.21, -7.61) controlPoint2: CGPointMake(2.22, -7.61)];
    [secondHandPath closePath];
    [color setFill];
    [secondHandPath fill];
    CGContextRestoreGState(context);
    UIImage *img = [UIImage new];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


-(NSArray*)HourAndMinuteAngleFromDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    float hourf = [[formatter stringFromDate:date] floatValue];
    [formatter setDateFormat:@"mm"];
    float minutef = [[formatter stringFromDate:date] floatValue];
    if (hourf > 12) {
        hourf = (hourf - 12)*30 + 30*(minutef/60);
    }else{
        hourf = hourf*30 + 30*(minutef/60);
    }
    minutef = minutef*6;
    NSNumber *hour =  [[NSNumber alloc] initWithInt:hourf];
    NSNumber *minute = [[NSNumber alloc] initWithInt:minutef];
    NSArray *arr = [[NSArray alloc] initWithObjects:hour,minute, nil];
    return arr;
}

-(float)secondAngleFromDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ss"];
    float secondf = [[formatter stringFromDate:date] floatValue];
    secondf = secondf*6;
    return secondf;
}


- (void)drawKBClockWithScale: (CGFloat)scale centerPoint:(CGPoint)centerPoint currentDate:(NSDate*)currentDate;
{
    NSArray *arr = [self HourAndMinuteAngleFromDate:currentDate];
    NSNumber *hourAngle = (NSNumber*)[arr objectAtIndex:0];
    NSNumber *minuteAngle = (NSNumber*)[arr objectAtIndex:1];
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* rimPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-100, -100, 200, 200)];
    [rimColor setFill];
    [rimPath fill];
    
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* facePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-92.99, -92.92, 186, 186)];
    [faceColor setFill];
    [facePath fill];
    
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    CGRect aMPMRect = CGRectMake(-15.99, -42.92, 32, 18);
    NSMutableParagraphStyle* aMPMStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    aMPMStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* aMPMFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 15], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: aMPMStyle};
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    float hourf = [[formatter stringFromDate:currentDate] floatValue];
    NSString *str = hourf<12?@"AM":@"PM";
    [str drawInRect: aMPMRect withAttributes: aMPMFontAttributes];
    
    CGContextRestoreGState(context);
         CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextRotateCTM(context, [hourAngle floatValue] * M_PI / 180);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* hourHandPath = [UIBezierPath bezierPathWithRect: CGRectMake(-4.99, -52.46, 10, 43.54)];
    [hourAndMinuteHandColor setFill];
    [hourHandPath fill];
    
    CGContextRestoreGState(context);
         CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextRotateCTM(context, ([minuteAngle floatValue]) * M_PI / 180);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* minuteHandPath = [UIBezierPath bezierPathWithRect: CGRectMake(-2.99, -64.92, 6, 55.92)];
    [hourAndMinuteHandColor setFill];
    [minuteHandPath fill];
    
    CGContextRestoreGState(context);
         CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* centreEmptyOvalPath = UIBezierPath.bezierPath;
    [centreEmptyOvalPath moveToPoint: CGPointMake(-4.42, -4.35)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(-4.42, 4.33) controlPoint1: CGPointMake(-6.82, -1.95) controlPoint2: CGPointMake(-6.82, 1.93)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(4.26, 4.33) controlPoint1: CGPointMake(-2.02, 6.73) controlPoint2: CGPointMake(1.86, 6.73)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(4.26, -4.35) controlPoint1: CGPointMake(6.66, 1.93) controlPoint2: CGPointMake(6.66, -1.95)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(-4.42, -4.35) controlPoint1: CGPointMake(1.86, -6.75) controlPoint2: CGPointMake(-2.02, -6.75)];
    [centreEmptyOvalPath closePath];
    [centreEmptyOvalPath moveToPoint: CGPointMake(7.78, -7.7)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(7.78, 7.85) controlPoint1: CGPointMake(12.08, -3.41) controlPoint2: CGPointMake(12.08, 3.56)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(-7.77, 7.85) controlPoint1: CGPointMake(3.49, 12.15) controlPoint2: CGPointMake(-3.48, 12.15)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(-7.77, -7.7) controlPoint1: CGPointMake(-12.07, 3.56) controlPoint2: CGPointMake(-12.07, -3.41)];
    [centreEmptyOvalPath addCurveToPoint: CGPointMake(7.78, -7.7) controlPoint1: CGPointMake(-3.48, -12) controlPoint2: CGPointMake(3.49, -12)];
    [centreEmptyOvalPath closePath];
    [hourAndMinuteHandColor setFill];
    [centreEmptyOvalPath fill];
    
    CGContextRestoreGState(context);
         CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    CGRect text12Rect = CGRectMake(-10, -82, 21, 17);
    {
        NSString* textContent = @"12";
        NSMutableParagraphStyle* text12Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text12Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text12FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 18], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: text12Style};
        
        [textContent drawInRect: CGRectOffset(text12Rect, 0, (CGRectGetHeight(text12Rect) - [textContent boundingRectWithSize: text12Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text12FontAttributes context: nil].size.height) / 2) withAttributes: text12FontAttributes];
    }
    
    CGContextRestoreGState(context);
         CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    CGRect text3Rect = CGRectMake(72, -9, 12, 17);
    {
        NSString* textContent = @"3";
        NSMutableParagraphStyle* text3Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text3Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text3FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 18], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: text3Style};
        
        [textContent drawInRect: CGRectOffset(text3Rect, 0, (CGRectGetHeight(text3Rect) - [textContent boundingRectWithSize: text3Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text3FontAttributes context: nil].size.height) / 2) withAttributes: text3FontAttributes];
    }
    
    CGContextRestoreGState(context);
    
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    CGRect text6Rect = CGRectMake(-4, 65, 12, 17);
    {
        NSString* textContent = @"6";
        NSMutableParagraphStyle* text6Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text6Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text6FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 18], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: text6Style};
        
        [textContent drawInRect: CGRectOffset(text6Rect, 0, (CGRectGetHeight(text6Rect) - [textContent boundingRectWithSize: text6Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text6FontAttributes context: nil].size.height) / 2) withAttributes: text6FontAttributes];
    }
    
    CGContextRestoreGState(context);
    
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    CGRect text9Rect = CGRectMake(-82, -8, 12, 17);
    {
        NSString* textContent = @"9";
        NSMutableParagraphStyle* text9Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text9Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text9FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 18], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: text9Style};
        
        [textContent drawInRect: CGRectOffset(text9Rect, 0, (CGRectGetHeight(text9Rect) - [textContent boundingRectWithSize: text9Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text9FontAttributes context: nil].size.height) / 2) withAttributes: text9FontAttributes];
    }
    
    CGContextRestoreGState(context);
    
     
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* markPath = UIBezierPath.bezierPath;
    [markPath moveToPoint: CGPointMake(-2, -85)];
    [markPath addLineToPoint: CGPointMake(2, -85)];
    [markPath addLineToPoint: CGPointMake(2, -93)];
    [markPath addLineToPoint: CGPointMake(-2, -93)];
    [markPath addLineToPoint: CGPointMake(-2, -85)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(-1, 93)];
    [markPath addLineToPoint: CGPointMake(3, 93)];
    [markPath addLineToPoint: CGPointMake(3, 85)];
    [markPath addLineToPoint: CGPointMake(-1, 85)];
    [markPath addLineToPoint: CGPointMake(-1, 93)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(-45, -72.15)];
    [markPath addLineToPoint: CGPointMake(-41.54, -74.15)];
    [markPath addLineToPoint: CGPointMake(-45.54, -81.08)];
    [markPath addLineToPoint: CGPointMake(-49, -79.08)];
    [markPath addLineToPoint: CGPointMake(-45, -72.15)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(44.87, 81.5)];
    [markPath addLineToPoint: CGPointMake(48.33, 79.5)];
    [markPath addLineToPoint: CGPointMake(44.33, 72.57)];
    [markPath addLineToPoint: CGPointMake(40.87, 74.57)];
    [markPath addLineToPoint: CGPointMake(44.87, 81.5)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(-75.07, -40)];
    [markPath addLineToPoint: CGPointMake(-73.07, -43.46)];
    [markPath addLineToPoint: CGPointMake(-80, -47.46)];
    [markPath addLineToPoint: CGPointMake(-82, -44)];
    [markPath addLineToPoint: CGPointMake(-75.07, -40)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(79.58, 48.13)];
    [markPath addLineToPoint: CGPointMake(81.58, 44.67)];
    [markPath addLineToPoint: CGPointMake(74.65, 40.67)];
    [markPath addLineToPoint: CGPointMake(72.65, 44.13)];
    [markPath addLineToPoint: CGPointMake(79.58, 48.13)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(-85, 2)];
    [markPath addLineToPoint: CGPointMake(-85, -2)];
    [markPath addLineToPoint: CGPointMake(-93, -2)];
    [markPath addLineToPoint: CGPointMake(-93, 2)];
    [markPath addLineToPoint: CGPointMake(-85, 2)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(93, 1)];
    [markPath addLineToPoint: CGPointMake(93, -3)];
    [markPath addLineToPoint: CGPointMake(85, -3)];
    [markPath addLineToPoint: CGPointMake(85, 1)];
    [markPath addLineToPoint: CGPointMake(93, 1)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(-72.57, 44)];
    [markPath addLineToPoint: CGPointMake(-74.57, 40.54)];
    [markPath addLineToPoint: CGPointMake(-81.5, 44.54)];
    [markPath addLineToPoint: CGPointMake(-79.5, 48)];
    [markPath addLineToPoint: CGPointMake(-72.57, 44)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(81.08, -45.87)];
    [markPath addLineToPoint: CGPointMake(79.08, -49.33)];
    [markPath addLineToPoint: CGPointMake(72.15, -45.33)];
    [markPath addLineToPoint: CGPointMake(74.15, -41.87)];
    [markPath addLineToPoint: CGPointMake(81.08, -45.87)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(-39.67, 75.07)];
    [markPath addLineToPoint: CGPointMake(-43.13, 73.07)];
    [markPath addLineToPoint: CGPointMake(-47.13, 80)];
    [markPath addLineToPoint: CGPointMake(-43.67, 82)];
    [markPath addLineToPoint: CGPointMake(-39.67, 75.07)];
    [markPath closePath];
    [markPath moveToPoint: CGPointMake(48.46, -79.58)];
    [markPath addLineToPoint: CGPointMake(45, -81.58)];
    [markPath addLineToPoint: CGPointMake(41, -74.65)];
    [markPath addLineToPoint: CGPointMake(44.46, -72.65)];
    [markPath addLineToPoint: CGPointMake(48.46, -79.58)];
    [markPath closePath];
    [markColor setFill];
    [markPath fill];
    
    CGContextRestoreGState(context);
}


@end


