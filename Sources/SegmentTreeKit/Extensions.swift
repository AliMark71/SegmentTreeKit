//
//  Extensions.swift
//
//
//  Created by Ali AlSalman on 05/06/2024.
//

import Foundation

extension Range {
    func contains(_ other: Range) -> Bool {
        self.lowerBound <= other.lowerBound && other.upperBound <= self.upperBound
    }

    func contains(_ other: ClosedRange<Bound>) -> Bool {
        self.lowerBound <= other.lowerBound && other.upperBound < self.upperBound
    }
}

extension ClosedRange {
    func contains(_ other: ClosedRange) -> Bool {
        self.lowerBound <= other.lowerBound && other.upperBound <= self.upperBound
    }

    func contains(_ other: Range<Bound>) -> Bool {
        self.lowerBound <= other.lowerBound && self.upperBound < other.upperBound
    }
}

infix operator !!

extension Optional {
    static func !! (lhs: Self, rhs: String) -> Wrapped {
        guard let lhs else {
            fatalError("Error while force-unwrapping: \(rhs)")
        }
        return lhs
    }
}
