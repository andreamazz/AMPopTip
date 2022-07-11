//
//  PopTip.swift
//  AMPopTip
//
//  Created by Andrea Mazzini on 01/05/2017.
//  Copyright © 2017 Andrea Mazzini. All rights reserved.
//

import UIKit

public extension PopTip {

  /// Triggers the chosen entrance animation
  ///
  /// - Parameter completion: the completion handler
  func performEntranceAnimation(completion: @escaping () -> Void) {
    switch entranceAnimation {
    case .scale:
      entranceScale(completion: completion)
    case .transition:
      entranceTransition(completion: completion)
    case .fadeIn:
      entranceFadeIn(completion: completion)
    case .custom:
      if shouldShowMask {
        addBackgroundMask(to: containerView)
      }
      containerView?.addSubview(self)
      entranceAnimationHandler?(completion)
    case .none:
      if shouldShowMask {
        addBackgroundMask(to: containerView)
      }
      containerView?.addSubview(self)
      completion()
    }
  }

  /// Triggers the chosen exit animation
  ///
  /// - Parameter completion: the completion handler
  func performExitAnimation(completion: @escaping () -> Void) {
    switch exitAnimation {
    case .scale:
      exitScale(completion: completion)
    case .fadeOut:
      exitFadeOut(completion: completion)
    case .custom:
      exitAnimationHandler?(completion)
    case .none:
      completion()
    }
  }

  private func entranceTransition(completion: @escaping () -> Void) {
    transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    switch direction {
    case .up:
      transform = transform.translatedBy(x: 0, y: -from.origin.y)
    case .down, .none:
      transform = transform.translatedBy(x: 0, y: (containerView?.frame.height ?? 0) - from.origin.y)
    case .left:
      transform = transform.translatedBy(x: from.origin.x, y: 0)
    case .right:
      transform = transform.translatedBy(x: (containerView?.frame.width ?? 0) - from.origin.x, y: 0)
    case .auto, .autoHorizontal, .autoVertical: break // The decision will be made at this point
    }
    if shouldShowMask {
      addBackgroundMask(to: containerView)
    }
    containerView?.addSubview(self)

    UIView.animate(withDuration: animationIn, delay: delayIn, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.5, options: [.curveEaseInOut, .beginFromCurrentState], animations: { 
      self.transform = .identity
      self.backgroundMask?.alpha = 1
    }) { (_) in
      completion()
    }
  }

  private func entranceScale(completion: @escaping () -> Void) {
    transform = CGAffineTransform(scaleX: 0, y: 0)
    if shouldShowMask {
      addBackgroundMask(to: containerView)
    }
    containerView?.addSubview(self)

    UIView.animate(withDuration: animationIn, delay: delayIn, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.5, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
      self.transform = .identity
      self.backgroundMask?.alpha = 1
    }) { (_) in
      completion()
    }
  }

  private func entranceFadeIn(completion: @escaping () -> Void) {
    if shouldShowMask {
      addBackgroundMask(to: containerView)
    }
    containerView?.addSubview(self)

    alpha = 0
    UIView.animate(withDuration: animationIn, delay: delayIn, options: [.curveEaseInOut, .beginFromCurrentState], animations: { 
      self.alpha = 1
      self.backgroundMask?.alpha = 1
    }) { (_) in
      completion()
    }
  }

  private func exitScale(completion: @escaping () -> Void) {
    transform = .identity

    UIView.animate(withDuration: animationOut, delay: delayOut, options: [.curveEaseInOut, .beginFromCurrentState], animations: { 
      self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
      self.backgroundMask?.alpha = 0
    }) { (_) in
      completion()
    }
  }

  private func exitFadeOut(completion: @escaping () -> Void) {
    alpha = 1

    UIView.animate(withDuration: animationOut, delay: delayOut, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
      self.alpha = 0
      self.backgroundMask?.alpha = 0
    }) { (_) in
      completion()
    }
  }
    
  private func addBackgroundMask(to targetView: UIView?) {

    guard let backgroundMask = backgroundMask, let targetView = targetView else { return }
      
    targetView.addSubview(backgroundMask)

    guard shouldCutoutMask else {
      backgroundMask.backgroundColor = maskColor
      return
    }

    let cutoutView = UIView(frame: backgroundMask.bounds)
    let cutoutShapeMaskLayer = CAShapeLayer()
    let cutoutPath = cutoutPathGenerator(from)
    let path = UIBezierPath(rect: backgroundMask.bounds)

    path.append(cutoutPath)

    cutoutShapeMaskLayer.path = path.cgPath
    cutoutShapeMaskLayer.fillRule = .evenOdd

    cutoutView.layer.mask = cutoutShapeMaskLayer
    cutoutView.clipsToBounds = true
    cutoutView.backgroundColor = maskColor
    cutoutView.isUserInteractionEnabled = false

    backgroundMask.addSubview(cutoutView)
  }
}
