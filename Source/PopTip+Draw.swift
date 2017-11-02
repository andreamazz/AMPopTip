//
//  PopTip.swift
//  AMPopTip
//
//  Created by Andrea Mazzini on 01/05/2017.
//  Copyright © 2017 Andrea Mazzini. All rights reserved.
//

fileprivate func degreesToRadians(degrees: CGFloat) -> CGFloat {
  return (CGFloat.pi * degrees) / 180
}

// MARK: - Draw helper
public extension PopTip {
  class func pathWith(rect: CGRect, frame: CGRect, direction: PopTipDirection, arrowSize: CGSize, arrowPosition: CGPoint, borderWidth: CGFloat = 0, radius: CGFloat = 0) -> UIBezierPath {
    var path = UIBezierPath()
    var baloonFrame = CGRect.zero
  
    switch direction {
    case .none:
      baloonFrame = CGRect(x: borderWidth, y: borderWidth, width: frame.width - borderWidth * 2, height: frame.height - borderWidth * 2)
      path = UIBezierPath(roundedRect: baloonFrame, cornerRadius: radius)
    case .down:
      baloonFrame = CGRect(x: 0, y: arrowSize.height, width: rect.width - borderWidth * 2, height: rect.height - arrowSize.height - borderWidth * 2)

      path.move(to: CGPoint(x: arrowPosition.x, y: arrowPosition.y + borderWidth))
      path.addLine(to: CGPoint(x: arrowPosition.x + arrowSize.width / 2, y: arrowPosition.y + arrowSize.height + borderWidth))      
      path.addLine(to: CGPoint(x: baloonFrame.width - radius, y: arrowSize.height + borderWidth))
      path.addArc(withCenter: CGPoint(x: baloonFrame.width - radius, y: arrowSize.height + radius + borderWidth) , radius: radius, startAngle: degreesToRadians(degrees: 270), endAngle: degreesToRadians(degrees: 0), clockwise: true)
      path.addLine(to: CGPoint(x: baloonFrame.width, y: arrowSize.height + baloonFrame.height - radius))
      path.addArc(withCenter: CGPoint(x: baloonFrame.width - radius, y: arrowSize.height + baloonFrame.height - radius), radius: radius, startAngle: degreesToRadians(degrees: 0), endAngle: degreesToRadians(degrees: 90), clockwise: true)
      path.addLine(to: CGPoint(x: borderWidth + radius, y: arrowSize.height + baloonFrame.height))
      path.addArc(withCenter: CGPoint(x: borderWidth + radius, y: arrowSize.height + baloonFrame.height - radius), radius: radius, startAngle: degreesToRadians(degrees: 90), endAngle: degreesToRadians(degrees: 180), clockwise: true)
      path.addLine(to: CGPoint(x: borderWidth, y: arrowSize.height + radius + borderWidth))
      path.addArc(withCenter: CGPoint(x: borderWidth + radius, y: arrowSize.height + radius  + borderWidth), radius: radius, startAngle: degreesToRadians(degrees: 180), endAngle: degreesToRadians(degrees: 270), clockwise: true)
      path.addLine(to: CGPoint(x: arrowPosition.x - arrowSize.width / 2, y: arrowPosition.y + arrowSize.height + borderWidth))
      path.close()
    case .up:
      baloonFrame = CGRect(x: 0, y: 0, width: rect.size.width - borderWidth * 2, height: rect.size.height - arrowSize.height - borderWidth * 2)
      
      path.move(to: CGPoint(x: arrowPosition.x, y: arrowPosition.y - borderWidth))
      path.addLine(to: CGPoint(x: arrowPosition.x + arrowSize.width / 2, y: arrowPosition.y - arrowSize.height - borderWidth))
      path.addLine(to: CGPoint(x: baloonFrame.width - radius, y: baloonFrame.origin.y + baloonFrame.height - borderWidth))
      path.addArc(withCenter: CGPoint(x: baloonFrame.width - radius, y: baloonFrame.origin.y + baloonFrame.height - radius - borderWidth), radius:radius, startAngle:degreesToRadians(degrees: 90), endAngle:degreesToRadians(degrees: 0), clockwise:false)
      path.addLine(to: CGPoint(x: baloonFrame.width, y: baloonFrame.origin.y + radius + borderWidth))
      path.addArc(withCenter: CGPoint(x: baloonFrame.width - radius, y: baloonFrame.origin.y + radius + borderWidth), radius:radius, startAngle:degreesToRadians(degrees: 0), endAngle:degreesToRadians(degrees: 270), clockwise: false)
      path.addLine(to: CGPoint(x: borderWidth + radius, y: baloonFrame.origin.y + borderWidth))
      path.addArc(withCenter: CGPoint(x: borderWidth + radius, y: baloonFrame.origin.y + radius + borderWidth), radius:radius, startAngle:degreesToRadians(degrees: 270), endAngle:degreesToRadians(degrees: 180), clockwise: false)
      path.addLine(to: CGPoint(x: borderWidth, y: baloonFrame.origin.y + baloonFrame.height - radius - borderWidth))
      path.addArc(withCenter: CGPoint(x: borderWidth + radius, y: baloonFrame.origin.y + baloonFrame.height - radius - borderWidth), radius:radius, startAngle:degreesToRadians(degrees: 180), endAngle:degreesToRadians(degrees: 90), clockwise: false)
      path.addLine(to: CGPoint(x: arrowPosition.x - arrowSize.width / 2, y: arrowPosition.y - arrowSize.height - borderWidth))
      path.close()
    case .left:
      baloonFrame = CGRect(x: 0, y: 0, width: rect.size.width - arrowSize.height - borderWidth * 2, height: rect.size.height - borderWidth * 2)

      path.move(to: CGPoint(x: arrowPosition.x - borderWidth, y: arrowPosition.y))
      path.addLine(to: CGPoint(x: arrowPosition.x - arrowSize.height - borderWidth, y: arrowPosition.y - arrowSize.width / 2))
      path.addLine(to: CGPoint(x: baloonFrame.width - borderWidth, y: baloonFrame.origin.y + radius + borderWidth))
      path.addArc(withCenter: CGPoint(x: baloonFrame.width - radius - borderWidth, y: baloonFrame.origin.y + radius + borderWidth), radius:radius, startAngle:degreesToRadians(degrees: 0), endAngle:degreesToRadians(degrees: 270), clockwise: false)
      path.addLine(to: CGPoint(x: radius + borderWidth, y: baloonFrame.origin.y + borderWidth))
      path.addArc(withCenter: CGPoint(x: radius + borderWidth, y: baloonFrame.origin.y + radius + borderWidth), radius:radius, startAngle:degreesToRadians(degrees: 270), endAngle:degreesToRadians(degrees: 180), clockwise: false)
      path.addLine(to: CGPoint(x: borderWidth, y: baloonFrame.origin.y + baloonFrame.height - radius - borderWidth))
      path.addArc(withCenter: CGPoint(x: radius + borderWidth, y: baloonFrame.origin.y + baloonFrame.height - radius - borderWidth), radius:radius, startAngle:degreesToRadians(degrees: 180), endAngle:degreesToRadians(degrees: 90), clockwise: false)
      path.addLine(to: CGPoint(x: baloonFrame.width - radius - borderWidth, y: baloonFrame.origin.y + baloonFrame.height - borderWidth))
      path.addArc(withCenter: CGPoint(x: baloonFrame.width - radius -  borderWidth, y: baloonFrame.origin.y + baloonFrame.height - radius -  borderWidth), radius:radius, startAngle:degreesToRadians(degrees: 90), endAngle:degreesToRadians(degrees: 0), clockwise: false)
      path.addLine(to: CGPoint(x: arrowPosition.x - arrowSize.height - borderWidth, y: arrowPosition.y + arrowSize.width / 2))
      path.close()
    case .right:
      baloonFrame = CGRect(x: arrowSize.height, y: 0, width: rect.size.width - arrowSize.height - borderWidth * 2, height: rect.size.height - borderWidth * 2)

      path.move(to: CGPoint(x: arrowPosition.x + borderWidth, y: arrowPosition.y))
      path.addLine(to: CGPoint(x: arrowPosition.x + arrowSize.height + borderWidth, y: arrowPosition.y - arrowSize.width / 2))
      path.addLine(to: CGPoint(x: baloonFrame.origin.x + borderWidth, y: baloonFrame.origin.y + radius + borderWidth))
      path.addArc(withCenter: CGPoint(x: baloonFrame.origin.x + radius + borderWidth, y: baloonFrame.origin.y + radius + borderWidth), radius:radius, startAngle:degreesToRadians(degrees: 180), endAngle:degreesToRadians(degrees: 270), clockwise: true)
      path.addLine(to: CGPoint(x: baloonFrame.origin.x + baloonFrame.width - radius - borderWidth, y: baloonFrame.origin.y + borderWidth))
      path.addArc(withCenter: CGPoint(x: baloonFrame.origin.x + baloonFrame.width - radius - borderWidth, y: baloonFrame.origin.y + radius + borderWidth), radius:radius, startAngle:degreesToRadians(degrees: 270), endAngle:degreesToRadians(degrees: 0), clockwise: true)
      path.addLine(to: CGPoint(x: baloonFrame.origin.x + baloonFrame.width - borderWidth, y: baloonFrame.origin.y + baloonFrame.height - radius - borderWidth))
      path.addArc(withCenter: CGPoint(x: baloonFrame.origin.x + baloonFrame.width - radius - borderWidth, y: baloonFrame.origin.y + baloonFrame.height - radius - borderWidth), radius:radius, startAngle:degreesToRadians(degrees: 0), endAngle:degreesToRadians(degrees: 90), clockwise: true)
      path.addLine(to: CGPoint(x: baloonFrame.origin.x + radius + borderWidth, y: baloonFrame.origin.y + baloonFrame.height - borderWidth))
      path.addArc(withCenter: CGPoint(x: baloonFrame.origin.x + radius + borderWidth, y: baloonFrame.origin.y + baloonFrame.height - radius - borderWidth), radius:radius, startAngle:degreesToRadians(degrees: 90), endAngle:degreesToRadians(degrees: 180), clockwise: true)
      path.addLine(to: CGPoint(x: arrowPosition.x + arrowSize.height + borderWidth, y: arrowPosition.y + arrowSize.width / 2))
      path.close()
    }

    return path
  }
}
