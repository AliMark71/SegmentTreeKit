import XCTest
@testable import SegmentTreeKit

final class SegmentTreeKitTests: XCTestCase {
    func testInit() throws {
        let ST1 = SegmentTree(capacity: 5, of: Int.self)
        let ST2 = SegmentTree<Int>(capacity: 5)
        
        XCTAssertEqual(ST1[0], ST2[0])
        XCTAssertEqual(ST1[2], ST2[4])
    }
    
    func testElementModifing() throws {
        var tree: SegmentTree<Int> = [1, 4, 3, 5, 0, 4]
        
        XCTAssertEqual(tree[0], 1)
        XCTAssertNotEqual(tree[0], tree[1])
        
        tree[0] = tree[1]
        
        XCTAssertNotEqual(tree[0], 1)
        XCTAssertEqual(tree[0], tree[1])
    }
    
    func testElementAccess() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
        
        let tree: SegmentTree<Int> = [1, 4, 3, 5, 0, 4]
        
        XCTAssertEqual(tree[0], 1)
        XCTAssertEqual(tree[3], 5)
        XCTAssertEqual(tree[1], tree[5])
        XCTAssertEqual(tree.first!, 1)
        XCTAssertNotEqual(tree[0], tree[1])
    }
    
    func testStaticRangeSum() throws {
        let tree: SegmentTree<Int> = [1, 4, -3, 5, 0, 4]
        
        XCTAssertEqual(tree[0..<2], 5)
        XCTAssertEqual(tree[0..<3], 2)
        XCTAssertEqual(tree[3...5], 9)
    }
    
    func testDynamicRangeSum() throws {
        var tree: SegmentTree<Int> = [1, 4, -3, 5, 0, 4]
        
        XCTAssertEqual(tree[0..<2], 5)
        XCTAssertEqual(tree[0..<3], 2)
        tree[2] = 2
        XCTAssertEqual(tree[0..<3], 7)
        XCTAssertEqual(tree[3...5], 9)
    }
    
    struct MinInt: STNode, ExpressibleByIntegerLiteral, Equatable {
        typealias IntegerLiteralType = Int
        
        let num: Int
        
        init() { self.init(0) }
        init(_ num: Int) {
            self.num = num
        }
        init(integerLiteral value: Int) {
            self.init(value)
        }
        
        static func Merge(lhs: MinInt, rhs: MinInt) -> MinInt {
            if lhs.num < rhs.num { return lhs }
            else { return rhs }
        }
    }
    
    func testStaticRangeMin() throws {
        let tree: SegmentTree<MinInt> = [1, 4, -3, 5, 0, 4]
        
        XCTAssertEqual(tree[0..<2], 1)
        XCTAssertEqual(tree[0..<3], -3)
        XCTAssertEqual(tree[3...5], 0)
    }
    
    func testDynamicRangeMin() throws {
        var tree: SegmentTree<MinInt> = [1, 4, -3, 5, 0, 4]
        
        XCTAssertEqual(tree[0..<2], 1)
        XCTAssertEqual(tree[0..<3], -3)
        tree[2] = 2
        XCTAssertEqual(tree[0..<3], 1)
        XCTAssertEqual(tree[3...5], 0)
        XCTAssertEqual(tree[0..<2], tree[0..<3])
        tree[0] = 6
        tree[4] = 9
        XCTAssertEqual(tree[0..<tree.count], 2)
    }
}

