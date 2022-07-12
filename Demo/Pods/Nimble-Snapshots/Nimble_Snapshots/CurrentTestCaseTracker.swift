import XCTest

/// Helper class providing access to the currently executing XCTestCase instance, if any
@objc
public final class CurrentTestCaseTracker: NSObject, XCTestObservation {
    @objc(sharedInstance)
    public static let shared = CurrentTestCaseTracker()

    private(set) var currentTestCase: XCTestCase?

    @objc
    public func testCaseWillStart(_ testCase: XCTestCase) {
        currentTestCase = testCase
    }

    @objc
    public func testCaseDidFinish(_ testCase: XCTestCase) {
        currentTestCase = nil
    }
}

extension XCTestCase {
    var sanitizedName: String? {
        let fullName = self.name
        let characterSet = CharacterSet(charactersIn: "[]+-")
        #if swift(>=4)
            let name = fullName.components(separatedBy: characterSet).joined()
        #else
            let name = (fullName ?? "").components(separatedBy: characterSet).joined()
        #endif

        #if SWIFT_PACKAGE
            let className: AnyClass? = NSClassFromString("Quick.QuickSpec")
        #else
            let className: AnyClass? = NSClassFromString("QuickSpec")
        #endif
        if let quickClass = className, self.isKind(of: quickClass) {
            let className = String(describing: type(of: self))
            if let range = name.range(of: className), range.lowerBound == name.startIndex {
                return name.replacingCharacters(in: range, with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        return name
    }
}
