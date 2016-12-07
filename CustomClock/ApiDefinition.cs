using System;
using CoreGraphics;
using Foundation;
using ObjCRuntime;
using UIKit;

namespace CustomClock
{
	// @protocol KBClockDelegate <NSObject>
	[Protocol, Model]
	[BaseType(typeof(NSObject))]
	interface KBClockDelegate
	{
		// @optional -(UIColor *)rimColor;
		[Export("rimColor")]
		UIColor RimColor { get; }

		// @optional -(UIColor *)markColor;
		[Export("markColor")]
		UIColor MarkColor { get; }

		// @optional -(UIColor *)faceColor;
		[Export("faceColor")]
		UIColor FaceColor { get; }

		// @optional -(UIColor *)fontColor;
		[Export("fontColor")]
		UIColor FontColor { get; }

		// @optional -(UIColor *)secondHandColor;
		[Export("secondHandColor")]
		UIColor SecondHandColor { get; }

		// @optional -(UIColor *)hourAndMinuteHandColor;
		[Export("hourAndMinuteHandColor")]
		UIColor HourAndMinuteHandColor { get; }
	}

	// @interface KBClock : UIView
	[BaseType(typeof(UIView))]
	interface KBClock
	{
		[Wrap("WeakDelegate")]
		KBClockDelegate Delegate { get; set; }

		// @property (nonatomic, weak) id<KBClockDelegate> delegate;
		[NullAllowed, Export("delegate", ArgumentSemantic.Weak)]
		NSObject WeakDelegate { get; set; }

		// -(instancetype)initWithDelegate:(id<KBClockDelegate>)delegate frame:(CGRect)frame;
		[Export("initWithDelegate:frame:")]
		IntPtr Constructor(KBClockDelegate @delegate, CGRect frame);

		// -(instancetype)initWithTheme:(KBClockTheme)theme frame:(CGRect)frame;
		[Export("initWithTheme:frame:")]
		IntPtr Constructor(KBClockTheme theme, CGRect frame);
	}
}
