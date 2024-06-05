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
}

extension Int: STNode {}
extension Double: STNode {}

extension STNode where Self: AdditiveArithmetic {
    public static func Merge(lhs: Self, rhs: Self) -> Self {
        lhs + rhs
    }
}
