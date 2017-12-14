//
//  ViewController.swift
//  PopTip Demo
//
//  Created by Andrea Mazzini on 01/05/2017.
//  Copyright © 2017 Andrea Mazzini. All rights reserved.
//

import UIKit
import AMPopTip

class ViewController: UIViewController {

  enum ButtonType: Int {
    case center, topLeft, topRight, bottomLeft, bottomRight
  }

  let popTip = PopTip()
  var direction = PopTipDirection.up
  var topRightDirection = PopTipDirection.down
  var timer: Timer? = nil

  let /* Woody Allen's */ quotes = ["Life doesn't imitate art, it imitates bad television.", "The difference between sex and love is that sex relieves tension and love causes it.", "If you want to make God laugh, tell him about your plans.", "Eighty percent of success is showing up.", "If you're not failing every now and again, it's a sign you're not doing anything very innovative.", "Confidence is what you have before you understand the problem.", "Life is full of misery, loneliness, and suffering - and it's all over much too soon."]

  override func viewDidLoad() {
    super.viewDidLoad()

    popTip.font = UIFont(name: "Avenir-Medium", size: 12)!
    popTip.shouldDismissOnTap = true
    popTip.shouldDismissOnTapOutside = true
    popTip.shouldDismissOnSwipeOutside = true
    popTip.edgeMargin = 5
    popTip.offset = 2
    popTip.bubbleOffset = 0
    popTip.borderWidth = 1
    popTip.borderColor = .black
    popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)

    popTip.actionAnimation = .bounce(8)

    popTip.tapHandler = { _ in
      print("tap")
    }

    popTip.tapOutsideHandler = { _ in
      print("tap outside")
    }

    popTip.swipeOutsideHandler = { _ in
      print("swipe outside")
    }

    popTip.dismissHandler = { _ in
      print("dismiss")
    }
  }

  @IBAction func action(sender: UIButton) {
    guard let button = ButtonType(rawValue: sender.tag) else { return }

    timer?.invalidate()
    
    switch button {
    case .topLeft:
      let customView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 120))
      let imageView = UIImageView(image: UIImage(named: "comment"))
      imageView.frame = CGRect(x: (80 - imageView.frame.width) / 2, y: 0, width: imageView.frame.width, height: imageView.frame.height)
      customView.addSubview(imageView)
      let label = UILabel(frame: CGRect(x: 0, y: imageView.frame.height, width: 80, height: 120 - imageView.frame.height))
      label.numberOfLines = 0
      label.text = "This is a custom view"
      label.textAlignment = .center
      label.textColor = .white
      label.font = UIFont.systemFont(ofSize: 12)
      customView.addSubview(label)
      popTip.bubbleColor = UIColor(red: 0.95, green: 0.65, blue: 0.21, alpha: 1)
      popTip.show(customView: customView, direction: .down, in: view, from: sender.frame)

      popTip.entranceAnimationHandler = { [weak self] completion in
        guard let `self` = self else { return }
        self.popTip.transform = CGAffineTransform(rotationAngle: 0.3)
        UIView.animate(withDuration: 0.5, animations: { 
          self.popTip.transform = .identity
        }, completion: { (_) in
          completion()
        })
      }

    case .topRight:
      popTip.bubbleColor = UIColor(red: 0.97, green: 0.9, blue: 0.23, alpha: 1)
      if topRightDirection == .left {
        topRightDirection = .down
      } else {
        topRightDirection = .left
      }
      popTip.show(text: "I have a offset to move the bubble down or left side.", direction: topRightDirection, maxWidth: 150, in: view, from: sender.frame)
    case .bottomLeft:
      popTip.bubbleColor = UIColor(red: 0.73, green: 0.91, blue: 0.55, alpha: 1)
      let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.white]
      let underline: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
      let attributedText = NSMutableAttributedString(string: "I'm presenting a string ", attributes: attributes)
      attributedText.append(NSAttributedString(string: "with attributes!", attributes: underline))
      popTip.show(attributedText: attributedText, direction: .up, maxWidth: 200, in: view, from: sender.frame)
    case .bottomRight:
      popTip.bubbleColor = UIColor(red: 0.81, green: 0.04, blue: 0.14, alpha: 1)
      popTip.show(text: "Animated popover, great for subtle UI tips and onboarding", direction: .left, maxWidth: 200, in: view, from: sender.frame)
    case .center:
      popTip.bubbleColor = UIColor(red: 0.31, green: 0.57, blue: 0.87, alpha: 1)
      popTip.show(text: "Animated popover, great for subtle UI tips and onboarding", direction: direction, maxWidth: 200, in: view, from: sender.frame)
      direction = direction.cycleDirection()
      timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (_) in
        self.popTip.update(text: self.quotes.sample())
      }
    }
  }

}

extension PopTipDirection {
  func cycleDirection() -> PopTipDirection {
    switch self {
    case .up:
      return .right
    case .right:
      return .down
    case .down:
      return .left
    case .left:
      return .up
    case .none:
      return .none
    }
  }
}

extension Array {
  func sample() -> Element {
    let index = Int(arc4random_uniform(UInt32(count)))
    return self[index]
  }
}
