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
import Nimble_Snapshots

@testable import AMPopTip

let RECORD_SNAPSHOT = false

class PopTipTests: QuickSpec {
  let container: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    view.backgroundColor = .white
    return view
  }()
  var subject: PopTip = {
    let popTip = PopTip()
    popTip.entranceAnimation = .none
    popTip.exitAnimation = .none
    return popTip
  }()

  override func spec() {
    describe("showing a text") {
      it("displays correctly on the right") {
        self.subject.show(text: "Hello", direction: .right, maxWidth: 200, in: self.container, from: CGRect(x: 50, y: 50, width: 0, height: 0))
        if RECORD_SNAPSHOT {
          expect(self.container).to(recordSnapshot(named: "right-standard"))
        } else {
          expect(self.container).to(haveValidSnapshot(named: "right-standard"))
        }
      }

      it("displays correctly on the left") {
        self.subject.show(text: "Hello", direction: .left, maxWidth: 200, in: self.container, from: CGRect(x: 250, y: 50, width: 0, height: 0))
        if RECORD_SNAPSHOT {
          expect(self.container).to(recordSnapshot(named: "left-standard"))
        } else {
          expect(self.container).to(haveValidSnapshot(named: "left-standard"))
        }
      }

      it("displays correctly up") {
        self.subject.show(text: "Hello", direction: .up, maxWidth: 200, in: self.container, from: CGRect(x: 150, y: 150, width: 0, height: 0))
        if RECORD_SNAPSHOT {
          expect(self.container).to(recordSnapshot(named: "up-standard"))
        } else {
          expect(self.container).to(haveValidSnapshot(named: "up-standard"))
        }
      }

      it("displays correctly down") {
        self.subject.show(text: "Hello", direction: .down, maxWidth: 200, in: self.container, from: CGRect(x: 150, y: 50, width: 0, height: 0))
        if RECORD_SNAPSHOT {
          expect(self.container).to(recordSnapshot(named: "down-standard"))
        } else {
          expect(self.container).to(haveValidSnapshot(named: "down-standard"))
        }
      }

      it("displays correctly with no direction") {
        self.subject.show(text: "Hello", direction: .none, maxWidth: 200, in: self.container, from: CGRect(x: 150, y: 50, width: 0, height: 0))
        if RECORD_SNAPSHOT {
          expect(self.container).to(recordSnapshot(named: "none-standard"))
        } else {
          expect(self.container).to(haveValidSnapshot(named: "none-standard"))
        }
      }
    }
  }

}
