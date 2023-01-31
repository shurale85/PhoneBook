//
//  URL+.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 31.01.2023.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = URL(string: value)!
    }
}
