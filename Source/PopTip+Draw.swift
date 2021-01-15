//
//  PopTip.swift
//  AMPopTip
//
//  Created by Andrea Mazzini on 01/05/2017.
//  Copyright © 2017 Andrea Mazzini. All rights reserved.
//

import UIKit

fileprivate struct CornerPoint {
  var center: CGPoint
  var startAngle: CGFloat
  var endAngle: CGFloat
}

// MARK: - Draw helper
public extension PopTip {
  class func pathWith(rect: CGRect, frame: CGRect, direction: PopTipDirection, arrowSize: CGSize, arrowPosition: CGPoint, arrowRadius: CGFloat, borderWidth: CGFloat = 0, radius: CGFloat = 0) -> UIBezierPath {
    var path = UIBezierPath()
    var baloonFrame = CGRect.zero
    
    switch direction {
    case .auto, .autoHorizontal, .autoVertical: break // The decision will be made at this point
    case .none:
      baloonFrame = CGRect(x: borderWidth, y: borderWidth, width: frame.width - borderWidth * 2, height: frame.height - borderWidth * 2)
      path = UIBezierPath(roundedRect: baloonFrame, cornerRadius: radius)
    case .down:
      baloonFrame = CGRect(x: 0, y: arrowSize.height, width: rect.width - borderWidth * 2, height: rect.height - arrowSize.height - borderWidth * 2)
      
      let arrowStartPoint = CGPoint(x: arrowPosition.x - arrowSize.width / 2, y: arrowPosition.y + arrowSize.height)
      let arrowEndPoint = CGPoint(x: arrowPosition.x + arrowSize.width / 2, y: arrowPosition.y + arrowSize.height)
      let arrowVertex = arrowPosition
      
      // 1: Arrow starting point
      path.move(to: CGPoint(x: arrowStartPoint.x, y: arrowStartPoint.y))
      // 2: Arrow vertex arc
      if let cornerPoint = self.roundCornerCircleCenter(start: arrowStartPoint, vertex: arrowVertex, end: arrowEndPoint, radius: arrowRadius) {
        path.addArc(withCenter: cornerPoint.center, radius: arrowRadius, startAngle: cornerPoint.startAngle, endAngle: cornerPoint.endAngle, clockwise: true)
      }
      // 3: End drawing arrow
      path.addLine(to: CGPoint(x: arrowEndPoint.x, y: arrowEndPoint.y))
      // 4: Top right line
      path.addLine(to: CGPoint(x: baloonFrame.width - radius, y: baloonFrame.minY))
      // 5: Top right arc
      path.addArc(withCenter: CGPoint(x: baloonFrame.width - radius, y: baloonFrame.minY + radius), radius:radius, startAngle: CGFloat.pi * 1.5, endAngle: 0, clockwise:true)
      // 6: Right line
      path.addLine(to: CGPoint(x: baloonFrame.width, y: baloonFrame.maxY - radius - borderWidth))
      // 7: Bottom right arc
      path.addArc(withCenter: CGPoint(x: baloonFrame.maxX - radius, y: baloonFrame.maxY - radius), radius:radius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
      // 8: Bottom line
      path.addLine(to: CGPoint(x: baloonFrame.minX + radius + borderWidth, y: baloonFrame.maxY))
      // 9: Bottom left arc
      path.addArc(withCenter: CGPoint(x: borderWidth + radius, y: baloonFrame.maxY - radius), radius:radius, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: true)
      // 10: Left line
      path.addLine(to: CGPoint(x: borderWidth, y: baloonFrame.minY + radius + borderWidth))
      // 11: Top left arc
      path.addArc(withCenter: CGPoint(x: borderWidth + radius, y: baloonFrame.minY + radius), radius:radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 1.5, clockwise: true)
      // 13: Close path
      path.close()
      
    case .up:
      baloonFrame = CGRect(x: 0, y: 0, width: rect.size.width - borderWidth * 2, height: rect.size.height - arrowSize.height - borderWidth * 2)
      
      let arrowStartPoint = CGPoint(x: arrowPosition.x + arrowSize.width / 2, y: arrowPosition.y - arrowSize.height)
      let arrowEndPoint = CGPoint(x: arrowPosition.x - arrowSize.width / 2, y: arrowPosition.y - arrowSize.height)
      let arrowVertex = arrowPosition
      
      // 1: Arrow starting point
      path.move(to: CGPoint(x: arrowStartPoint.x, y: arrowStartPoint.y))
      // 2: Arrow vertex arc
      if let cornerPoint = self.roundCornerCircleCenter(start: arrowStartPoint, vertex: arrowVertex, end: arrowEndPoint, radius: arrowRadius) {
        path.addArc(withCenter: cornerPoint.center, radius: arrowRadius, startAngle: cornerPoint.startAngle, endAngle: cornerPoint.endAngle, clockwise: true)
      }
      // 3: End drawing arrow
      path.addLine(to: CGPoint(x: arrowEndPoint.x, y: arrowEndPoint.y))
      // 4: Bottom left line
      path.addLine(to: CGPoint(x: baloonFrame.minX + radius + borderWidth, y: baloonFrame.maxY))
      // 5: Bottom left arc
      path.addArc(withCenter: CGPoint(x: borderWidth + radius, y: baloonFrame.maxY - radius), radius:radius, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: true)
      // 6: Left line
      path.addLine(to: CGPoint(x: borderWidth, y: baloonFrame.minY + radius + borderWidth))
      // 7: Top left arc
      path.addArc(withCenter: CGPoint(x: baloonFrame.minX + radius + borderWidth, y: baloonFrame.minY + radius), radius:radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 1.5, clockwise: true)
      // 8: Top line
      path.addLine(to: CGPoint(x: baloonFrame.width - radius, y: baloonFrame.minY))
      // 9: Top right arc
      path.addArc(withCenter: CGPoint(x: baloonFrame.width - radius, y: baloonFrame.minY + radius), radius:radius, startAngle: CGFloat.pi * 1.5, endAngle: 0, clockwise:true)
      // 10: Right line
      path.addLine(to: CGPoint(x: baloonFrame.width, y: baloonFrame.maxY - radius - borderWidth))
      // 11: Bottom right arc
      path.addArc(withCenter: CGPoint(x: baloonFrame.maxX - radius, y: baloonFrame.maxY - radius), radius:radius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
      // 12: Close path
      path.close()
      
    case .left:
      baloonFrame = CGRect(x: 0, y: 0, width: rect.size.width - arrowSize.height - borderWidth * 2, height: rect.size.height - borderWidth * 2)
      
      let arrowStartPoint = CGPoint(x: arrowPosition.x - arrowSize.height, y: arrowPosition.y - arrowSize.width / 2)
      let arrowEndPoint = CGPoint(x: arrowPosition.x - arrowSize.height, y: arrowPosition.y + arrowSize.width / 2)
      let arrowVertex = arrowPosition
      
      // 1: Arrow starting point
      path.move(to: CGPoint(x: arrowStartPoint.x, y: arrowStartPoint.y))
      // 2: Arrow vertex arc
      if let cornerPoint = self.roundCornerCircleCenter(start: arrowStartPoint, vertex: arrowVertex, end: arrowEndPoint, radius: arrowRadius) {
        path.addArc(withCenter: cornerPoint.center, radius: arrowRadius, startAngle: cornerPoint.startAngle, endAngle: cornerPoint.endAngle, clockwise: true)
      }
      // 3: End drawing arrow
      path.addLine(to: CGPoint(x: arrowEndPoint.x, y: arrowEndPoint.y))
      // 4: Right bottom line
      path.addLine(to: CGPoint(x: baloonFrame.width, y: baloonFrame.maxY - radius - borderWidth))
      // 5: Bottom right arc
      path.addArc(withCenter: CGPoint(x: baloonFrame.maxX - radius, y: baloonFrame.maxY - radius), radius:radius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
      // 6: Bottom line
      path.addLine(to: CGPoint(x: baloonFrame.minX + radius + borderWidth, y: baloonFrame.maxY))
      // 7: Bottom left arc
      path.addArc(withCenter: CGPoint(x: borderWidth + radius, y: baloonFrame.maxY - radius), radius:radius, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: true)
      // 8: Left line
      path.addLine(to: CGPoint(x: borderWidth, y: baloonFrame.minY + radius + borderWidth))
      // 9: Top left arc
      path.addArc(withCenter: CGPoint(x: borderWidth + radius, y: baloonFrame.minY + radius + borderWidth), radius:radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 1.5, clockwise: true)
      // 10: Top line
      path.addLine(to: CGPoint(x: baloonFrame.width - radius, y: baloonFrame.minY + borderWidth))
      // 11: Top right arc
      path.addArc(withCenter: CGPoint(x: baloonFrame.width - radius, y: baloonFrame.minY + radius + borderWidth), radius:radius, startAngle: CGFloat.pi * 1.5, endAngle: 0, clockwise:true)
      // 12: Close path
      path.close()
      
    case .right:
      baloonFrame = CGRect(x: arrowSize.height, y: 0, width: rect.size.width - arrowSize.height - borderWidth * 2, height: rect.size.height - borderWidth * 2)
      
      let arrowStartPoint = CGPoint(x: arrowPosition.x + arrowSize.height, y: arrowPosition.y + arrowSize.width / 2)
      let arrowEndPoint = CGPoint(x: arrowPosition.x + arrowSize.height, y: arrowPosition.y - arrowSize.width / 2)
      let arrowVertex = arrowPosition
      
      // 1: Arrow starting point
      path.move(to: CGPoint(x: arrowStartPoint.x, y: arrowStartPoint.y))
      // 2: Arrow vertex arc
      if let cornerPoint = self.roundCornerCircleCenter(start: arrowStartPoint, vertex: arrowVertex, end: arrowEndPoint, radius: arrowRadius) {
        path.addArc(withCenter: cornerPoint.center, radius: arrowRadius, startAngle: cornerPoint.startAngle, endAngle: cornerPoint.endAngle, clockwise: true)
      }
      // 3: End drawing arrow
      path.addLine(to: CGPoint(x: arrowEndPoint.x, y: arrowEndPoint.y))
      // 6: Left top line
      path.addLine(to: CGPoint(x: baloonFrame.minX, y: baloonFrame.minY + radius + borderWidth))
      // 7: Top left arc
      path.addArc(withCenter: CGPoint(x: baloonFrame.minX + radius, y: baloonFrame.minY + radius + borderWidth), radius:radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 1.5, clockwise: true)
      // 8: Top line
      path.addLine(to: CGPoint(x: baloonFrame.width - radius, y: baloonFrame.minY + borderWidth))
      // 9: Top right arc
      path.addArc(withCenter: CGPoint(x: baloonFrame.maxX - radius, y: baloonFrame.minY + radius + borderWidth), radius:radius, startAngle: CGFloat.pi * 1.5, endAngle: 0, clockwise:true)
      // 10: Right line
      path.addLine(to: CGPoint(x: baloonFrame.maxX, y: baloonFrame.maxY - radius))
      // 11: Bottom right arc
      path.addArc(withCenter: CGPoint(x: baloonFrame.maxX - radius, y: baloonFrame.maxY - radius), radius:radius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
      // 4: Bottom line
      path.addLine(to: CGPoint(x: baloonFrame.minX + radius, y: baloonFrame.maxY ))
      // 5: Bottom left arc
      path.addArc(withCenter: CGPoint(x: baloonFrame.minX + radius, y: baloonFrame.maxY - radius), radius:radius, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: true)
      path.close()
    }
    
    return path
  }
  
  private class func roundCornerCircleCenter(start: CGPoint, vertex: CGPoint, end: CGPoint, radius: CGFloat) -> CornerPoint? {
    
    let firstLineAngle: CGFloat = atan2(vertex.y - start.y, vertex.x - start.x)
    let secondLineAngle: CGFloat = atan2(end.y - vertex.y, end.x - vertex.x)
    
    let firstLineOffset = CGVector(dx: -sin(firstLineAngle) * radius, dy: cos(firstLineAngle) * radius)
    let secondLineOffset = CGVector(dx: -sin(secondLineAngle) * radius, dy: cos(secondLineAngle) * radius)
    
    let x1 = start.x + firstLineOffset.dx
    let y1 = start.y + firstLineOffset.dy
    
    let x2 = vertex.x + firstLineOffset.dx
    let y2 = vertex.y + firstLineOffset.dy
    
    let x3 = vertex.x + secondLineOffset.dx
    let y3 = vertex.y + secondLineOffset.dy
    
    let x4 = end.x + secondLineOffset.dx
    let y4 = end.y + secondLineOffset.dy
    
    let divisor = ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4))
    
    if divisor == 0 {
      return nil
    }
    
    let intersectionX = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) / divisor
    let intersectionY = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) / divisor
    
    return CornerPoint(center: CGPoint(x: intersectionX, y: intersectionY),
                       startAngle: firstLineAngle - CGFloat.pi / 2,
                       endAngle: secondLineAngle - CGFloat.pi / 2)
  }
}

