using System;
using CustomClock;
using CoreGraphics;
using UIKit;

namespace Sample
{
	public partial class ViewController : UIViewController
	{
		protected ViewController(IntPtr handle) : base(handle)
		{
			// Note: this .ctor should not contain any initialization logic.
		}

		public override void ViewDidLoad()
		{
			base.ViewDidLoad();

			var clock = new KBClock(KBClockTheme.Dark, new CGRect(30, 60, 200, 200));
			this.View.AddSubview(clock);
		}
	}
}
