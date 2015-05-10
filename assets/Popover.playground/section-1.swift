// Playground - noun: a place where people can play

import UIKit

enum PopoverTip {
    case Up
    case Down
    case Left
    case Right
}

class Popover: UIView {
    var text: NSString
    var radius: CGFloat
    var padding: CGFloat
    var direction: PopoverTip
    var containerView: UIView
    var textBound: CGRect
    var tipPosition: CGPoint
    var tipSize: CGSize
    var paragraphStyle: NSMutableParagraphStyle
    
    init(text: NSString, fromFrame: CGRect, direction: PopoverTip, maxWidth: CGFloat, inView: UIView) {
        self.text = text
        self.radius = 4
        self.padding = 6
        self.containerView = inView
        self.direction = direction
        self.tipSize = CGSize(width: 16, height: 16)
        self.textBound = CGRectZero
        self.tipPosition = CGPointZero
        self.paragraphStyle = NSMutableParagraphStyle()
        
        self.paragraphStyle.alignment = .Center

        var rect = CGRectZero
        
        super.init(frame: rect)
        
        loadDefaults()

        // The text bound is the rect that contains the label, it will be drawn at (padding, padding)
        self.textBound = text.boundingRectWithSize(CGSize(width: maxWidth, height: FLT_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "Futura", size: 12)], context: nil)

        self.textBound.origin = CGPoint(x: self.padding, y: self.padding)

        // The rect includes the text, padding and arrow
        switch self.direction {
        case .Down, .Up:
            rect.size = CGSize(width: self.textBound.size.width + self.padding * 2.0, height: self.textBound.size.height + self.padding * 2.0 + self.tipSize.height)
            
            var x = fromFrame.origin.x + fromFrame.size.width / 2 - rect.size.width / 2
            if x < 0 { x = 0 }
            if x + rect.size.width > self.containerView.frame.size.width { x = self.containerView.frame.size.width - rect.size.width }
            rect.origin = CGPoint(x: x, y: fromFrame.origin.y + fromFrame.size.height)
            
        case .Left, .Right:
            rect.size = CGSize(width: self.textBound.size.width + self.padding * 2.0 + self.tipSize.height, height: self.textBound.size.height + self.padding * 2.0)
        }

        self.frame = rect
        
        self.backgroundColor = UIColor.clearColor()
        
        // TODO: init the other direction
        switch self.direction {
        case .Down:
            self.tipPosition = CGPoint(
                x: fromFrame.origin.x + fromFrame.size.width / 2 - rect.origin.x,
                y: fromFrame.origin.y + fromFrame.size.height - rect.origin.y)
            self.textBound.origin = CGPoint(x: self.textBound.origin.x, y: self.textBound.origin.y + self.tipSize.height)
            self.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            self.layer.position = CGPoint(x: self.layer.position.x, y: self.layer.position.y - rect.height / 2)
        case .Up:
            self.tipPosition = CGPoint(
                x: fromFrame.origin.x + fromFrame.size.width / 2,
                y: fromFrame.origin.y)
        case .Left:
            self.tipPosition = CGPoint(
                x: fromFrame.origin.x,
                y: fromFrame.origin.y + fromFrame.size.height / 2)
        case .Right:
            self.tipPosition = CGPoint(
                x: fromFrame.origin.x + fromFrame.size.width,
                y: fromFrame.origin.y + fromFrame.size.height / 2)
        }

    }
    
    func show() {
        self.transform = CGAffineTransformMakeScale(0, 0)
        self.containerView.addSubview(self)
        UIView.animateWithDuration(0.5, animations: {
            self.transform = CGAffineTransformIdentity
            })

    }
    
    func loadDefaults() {
        // TODO: load defaults if there's no appearance data
    }
    
    override func drawRect(rect: CGRect) {
        
        let arrow = UIBezierPath()
        
        var baloonFrame: CGRect
        switch self.direction {
        case .Down:
            baloonFrame = CGRect(x: 0, y: self.tipSize.height, width: self.frame.width, height: self.frame.height - self.tipSize.height)

            arrow.moveToPoint(self.tipPosition)
            arrow.addLineToPoint(CGPoint(x: self.tipPosition.x - self.tipSize.width / 2, y: self.tipPosition.y + self.tipSize.height))
            arrow.addLineToPoint(CGPoint(x: self.tipPosition.x + self.tipSize.width / 2, y: self.tipPosition.y + self.tipSize.height))
            self.tipPosition
            UIColor.redColor().setFill()
            arrow.fill()
            
        case .Up:
            baloonFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - self.tipSize.height)
        case .Left:
            baloonFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - self.tipSize.height)
        case .Right:
            baloonFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - self.tipSize.height)
        }
        
        let path = UIBezierPath(roundedRect: baloonFrame, cornerRadius: self.radius)
        
        UIColor.redColor().setFill()
        path.fill()
        
        let titleAttributes = [
            NSParagraphStyleAttributeName: self.paragraphStyle,
            NSFontAttributeName: UIFont(name: "Futura", size: 12),
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        text.drawInRect(self.textBound, withAttributes: titleAttributes)
    }
    
    func degrees_to_radians(degrees: CGFloat) -> CGFloat { return ((3.14159265359 * degrees) / 180.0) }
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 640))
let label = UILabel(frame: CGRect(x:10 , y: 300, width: 300, height: 100))
label.backgroundColor = UIColor.greenColor()
view.addSubview(label)

var popover = Popover(text: "Hi!\nI'm a popover", fromFrame: label.frame, direction: .Down, maxWidth: 320, inView: view)

popover.show()
view
