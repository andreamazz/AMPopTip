import Nimble

// MARK: - Nicer syntax using == operator

public struct Snapshot {
    let name: String?
    let record: Bool
    let usesDrawRect: Bool

    init(name: String?, record: Bool, usesDrawRect: Bool) {
        self.name = name
        self.record = record
        self.usesDrawRect = usesDrawRect
    }
}

public func snapshot(_ name: String? = nil,
                     usesDrawRect: Bool = false) -> Snapshot {
    return Snapshot(name: name, record: false, usesDrawRect: usesDrawRect)
}

public func recordSnapshot(_ name: String? = nil,
                           usesDrawRect: Bool = false) -> Snapshot {
    return Snapshot(name: name, record: true, usesDrawRect: usesDrawRect)
}

public func == (lhs: Expectation<Snapshotable>, rhs: Snapshot) {
    if let name = rhs.name {
        if rhs.record {
            lhs.to(recordSnapshot(named: name, usesDrawRect: rhs.usesDrawRect))
        } else {
            lhs.to(haveValidSnapshot(named: name, usesDrawRect: rhs.usesDrawRect))
        }

    } else {
        if rhs.record {
            lhs.to(recordSnapshot(usesDrawRect: rhs.usesDrawRect))
        } else {
            lhs.to(haveValidSnapshot(usesDrawRect: rhs.usesDrawRect))
        }
    }
}

// MARK: - Nicer syntax using emoji

// swiftlint:disable:next identifier_name
public func 📷(_ snapshottable: Snapshotable, file: FileString = #file, line: UInt = #line) {
    expect(snapshottable, file: file, line: line).to(recordSnapshot())
}

// swiftlint:disable:next identifier_name
public func 📷(_ snapshottable: Snapshotable, named name: String, file: FileString = #file, line: UInt = #line) {
    expect(snapshottable, file: file, line: line).to(recordSnapshot(named: name))
}
