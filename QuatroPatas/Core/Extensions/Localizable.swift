import Foundation

protocol Localizable: Identifiable, CaseIterable, RawRepresentable where RawValue == String {}

extension Localizable {
    
    var rawValue: String {
        let fullName = String(reflecting: self)
        let components = fullName.split(separator: ".").map { String($0).lowercased() }.dropFirst()
        return components.joined(separator: ".")
    }
    
    var caseName: String {
        String(describing: self).lowercased()
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

    static func fromLocalized(_ string: String) -> Self? {
        return allCases.first { localized($0) == string }
    }

    static var allLocalized: [String] {
        allCases.map { localized($0) }
    }
    
    var id: String {
        String(describing: self)
    }
}
