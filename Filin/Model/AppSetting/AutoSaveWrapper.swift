//
//  AutoSave.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/14.
//

import Foundation

@propertyWrapper
struct AutoSave<T: Codable> {
    private let key: String
    private let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.snuYum.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }
            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            // Set value to UserDefaults
            UserDefaults.snuYum.set(data, forKey: key)
        }
    }
}

extension UserDefaults {
    static let snuYum = UserDefaults(suiteName: "group.wannasleep.filin")!
}
