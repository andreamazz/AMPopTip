AMPopTip
========

Animated popover, great for subtle UI tips and onboarding.

#Screenshot
![AMPopTip](https://raw.githubusercontent.com/andreamazz/AMPopTip/master/screenshot.gif)



#Setup
* Add ```pod 'AMPopTip'``` to your ```Podfile```
* Run ```pod install```
* Run ```open App.xcworkspace```

#Usage
You must specify the text that you want to display alongside the popover direction, its max width, the view that will contain it and the frame of the view that the popover's arrow will point to.
```objc
self.popTip = [AMPopTip popTip];
[self.popTip showText:@"I'm a popover popping over" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:someView.frame];
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
	
