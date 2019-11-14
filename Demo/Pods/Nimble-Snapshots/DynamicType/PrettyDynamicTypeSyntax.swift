import Nimble

// MARK: - Nicer syntax using == operator

public struct DynamicTypeSnapshot {
    let name: String?
    let record: Bool
    let sizes: [UIContentSizeCategory]
    let deviceAgnostic: Bool

    init(name: String?, record: Bool, sizes: [UIContentSizeCategory], deviceAgnostic: Bool) {
        self.name = name
        self.record = record
        self.sizes = sizes
        self.deviceAgnostic = deviceAgnostic
    }
}

public func dynamicTypeSnapshot(_ name: String? = nil, sizes: [UIContentSizeCategory] = allContentSizeCategories(),
                                deviceAgnostic: Bool = false) -> DynamicTypeSnapshot {
    return DynamicTypeSnapshot(name: name, record: false, sizes: sizes, deviceAgnostic: deviceAgnostic)
}

public func recordDynamicTypeSnapshot(_ name: String? = nil,
                                      sizes: [UIContentSizeCategory] = allContentSizeCategories(),
                                      deviceAgnostic: Bool = false) -> DynamicTypeSnapshot {
    return DynamicTypeSnapshot(name: name, record: true, sizes: sizes, deviceAgnostic: deviceAgnostic)
}

public func == (lhs: Expectation<Snapshotable>, rhs: DynamicTypeSnapshot) {
    if let name = rhs.name {
        if rhs.record {
            lhs.to(recordDynamicTypeSnapshot(named: name, sizes: rhs.sizes, isDeviceAgnostic: rhs.deviceAgnostic))
        } else {
            lhs.to(haveValidDynamicTypeSnapshot(named: name, sizes: rhs.sizes, isDeviceAgnostic: rhs.deviceAgnostic))
        }

    } else {
        if rhs.record {
            lhs.to(recordDynamicTypeSnapshot(sizes: rhs.sizes, isDeviceAgnostic: rhs.deviceAgnostic))
        } else {
            lhs.to(haveValidDynamicTypeSnapshot(sizes: rhs.sizes, isDeviceAgnostic: rhs.deviceAgnostic))
        }
    }
}
