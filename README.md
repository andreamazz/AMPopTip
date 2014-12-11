<p align="center">
  <img width="640" height="240" src="assets/logo.png"/>
</p>

[![Build Status](https://travis-ci.org/andreamazz/AMPopTip.png)](https://travis-ci.org/andreamazz/AMPopTip)
[![Cocoapods](https://cocoapod-badges.herokuapp.com/v/AMPopTip/badge.png)](http://cocoapods.org/?q=ampoptip)
[![Analytics](https://ga-beacon.appspot.com/UA-42282237-8/AMPopTip/README)](https://github.com/igrigorik/ga-beacon)


Animated popover that pops out of a frame. You can specify the direction of the popover and the arrow that points to its origin. Color, border radius and font can be easily customized. 
This popover can be used to leave subtle hints about your UI and provide fun looking onboarding popups.


#Screenshot
![AMPopTip](https://raw.githubusercontent.com/andreamazz/AMPopTip/master/assets/screenshot.gif)



#Setup
* Add ```pod 'AMPopTip'``` to your ```Podfile```
* Run ```pod install```
* Run ```open App.xcworkspace```

#Usage
The API is fairly straight forward, you can show and hide the popover at any time.

##Showing the popover
You must specify the text that you want to display alongside the popover direction, its max width, the view that will contain it and the frame of the view that the popover's arrow will point to.
```objc
self.popTip = [AMPopTip popTip];
[self.popTip showText:@"I'm a popover popping over" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:someView.frame];
```
You can also display the popover in the center, with no arrow, in this case the `fromFrame` parameter will be the whole view:
```objc
[self.popTip showText:@"I'm a popover" direction:AMPopTipDirectionNone maxWidth:200 inView:self.view fromFrame:self.view.frame];
```

##Dismissing the popover
You can hide the popover by calling:
```objc
[self.popTip hide];
```
Or you can specify the duration of the popover:
```objc
[self.popTip showText:@"I'm a popover popping over" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:someView.frame duration:3];
```
You can also let the user dismiss the popover by tapping on it:
```objc
self.popTip.shouldDismissOnTap = YES;
```
You can add a block that will be fired when the user taps the popover...
```objc
self.popTip.tapHandler = ^{
     NSLog(@"Popover selected!");
};
```
... when the popover is shown...
```objc
self.popTip.appearHandler = ^{
    NSLog(@"Appeared!");
};
```

... or when the popover is dismissed:
```objc
self.popTip.dismissHandler = ^{
    NSLog(@"Dismissed!");
};
```

#Customization
Use the appearance proxy to customize the popover before creating the instance, or just use its public properties:
```objc
[[AMPopTip appearance] setFont:<#UIFont#>];
[[AMPopTip appearance] setTextColor:<#UIColor#>];
[[AMPopTip appearance] setPopoverColor:<#UIColor#>];
[[AMPopTip appearance] setRadius:<#CGFloat#>];
[[AMPopTip appearance] setPadding:<#CGFloat#>];
[[AMPopTip appearance] setArrowSize:<#CGSize#>];
[[AMPopTip appearance] setAnimationIn:<#NSInterval#>];
[[AMPopTip appearance] setAnimationOut:<#NSInterval#>];
```

#MIT License

	Copyright (c) 2014 Andrea Mazzini. All rights reserved.

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the "Software"),
	to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	
