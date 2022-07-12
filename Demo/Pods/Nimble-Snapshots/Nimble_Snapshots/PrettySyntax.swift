import Nimble

// MARK: - Nicer syntax using == operator

public struct Snapshot {
    let name: String?
    let identifier: String?
    let record: Bool
    let usesDrawRect: Bool

    init(name: String?, identifier: String?, record: Bool, usesDrawRect: Bool) {
        self.name = name
        self.identifier = identifier
        self.record = record
        self.usesDrawRect = usesDrawRect
    }
}

public func snapshot(_ name: String? = nil,
                     identifier: String? = nil,
                     usesDrawRect: Bool = false) -> Snapshot {
    return Snapshot(name: name, identifier: identifier, record: false, usesDrawRect: usesDrawRect)
}

public func recordSnapshot(_ name: String? = nil,
                           identifier: String? = nil,
                           usesDrawRect: Bool = false) -> Snapshot {
    return Snapshot(name: name, identifier: identifier, record: true, usesDrawRect: usesDrawRect)
}

public func == (lhs: Expectation<Snapshotable>, rhs: Snapshot) {
    if rhs.record {
        lhs.to(recordSnapshot(named: rhs.name, identifier: rhs.identifier, usesDrawRect: rhs.usesDrawRect))
    } else {
        lhs.to(haveValidSnapshot(named: rhs.name, identifier: rhs.identifier, usesDrawRect: rhs.usesDrawRect))
    }
}

// MARK: - Nicer syntax using emoji

// swiftlint:disable:next identifier_name
public func 📷(_ file: FileString = #file, line: UInt = #line, snapshottable: Snapshotable) {
  expect(file: file, line: line, snapshottable).to(recordSnapshot())
}

// swiftlint:disable:next identifier_name
public func 📷(_ name: String, file: FileString = #file, line: UInt = #line, snapshottable: Snapshotable) {
  expect(file: file, line: line, snapshottable).to(recordSnapshot(named: name))
}
