//
//  PopTip_DemoTests.swift
//  PopTip DemoTests
//
//  Created by Andrea Mazzini on 01/05/2017.
//  Copyright © 2017 Andrea Mazzini. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import AMPopTip

class PopTipTests: XCTestCase {
  let container = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
  var subject = PopTip()

  override func setUp() {
    super.setUp()

    subject = PopTip()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testVerticalSetup() {
    subject.show(text: "Hello", direction: .down, maxWidth: 200, in: container, from: CGRect(x: 0, y: 0, width: 0, height: 0))
    let dimensions = subject.setupVertically()
  }

}
