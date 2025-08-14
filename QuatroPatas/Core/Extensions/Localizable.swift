import Foundation

protocol Localizable: CaseIterable, RawRepresentable where RawValue == String {}

extension Localizable {
    
    var rawValue: String {
        let fullName = String(reflecting: self)
        let components = fullName.split(separator: ".").map { String($0).lowercased() }.dropFirst()
        return components.joined(separator: ".")
    }
    
    init?(rawValue: String) {
        let parts = rawValue.split(separator: ".").map { String($0) }
        guard let caseName = parts.last else { return nil }

        guard let match = Self.allCases.first(where: {
            String(reflecting: $0).split(separator: ".").last.map(String.init) == caseName
        }) else {
            return nil
        }
        self = match
    }
    
    static func localized(_ value: Self) -> String {
        NSLocalizedString(value.rawValue, comment: "")
    }

    static var allLocalized: [String] {
        allCases.map { localized($0) }
    }
}
