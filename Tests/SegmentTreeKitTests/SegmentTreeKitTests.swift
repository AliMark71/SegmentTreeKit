import Testing
@testable import SegmentTreeKit

struct MinInt: STNode, ExpressibleByIntegerLiteral, Comparable {
    typealias IntegerLiteralType = Int
    
    let num: Int
    
    init() { self.init(Int.max) }
    init(_ num: Int) { self.num = num }
    init(integerLiteral value: Int) { self.init(value) }
    
    static func Merge(lhs: MinInt, rhs: MinInt) -> MinInt {
        min(lhs, rhs)
    }
    
    static func < (lhs: MinInt, rhs: MinInt) -> Bool {
        lhs.num < rhs.num
    }
}

struct MaxInt: STNode, ExpressibleByIntegerLiteral, Comparable {
    typealias IntegerLiteralType = Int
    
    let num: Int
    
    init() { self.init(Int.min) }
    init(_ num: Int) { self.num = num }
    init(integerLiteral value: Int) { self.init(value) }
    
    static func Merge(lhs: MaxInt, rhs: MaxInt) -> MaxInt {
        max(lhs, rhs)
    }
    
    static func < (lhs: MaxInt, rhs: MaxInt) -> Bool {
        lhs.num < rhs.num
    }
}

extension Int: @retroactive STNode {
    public static func Merge(lhs: Int, rhs: Int) -> Int {
        lhs + rhs
    }
}

extension Tag {
    enum rangeQueries {
        @Tag static var min: Tag
        @Tag static var max: Tag
        @Tag static var sum: Tag
        
        @Tag static var `static`: Tag
        @Tag static var dynamic: Tag
    }
}

struct SegmentTreeKitTests {
    @Test("test some initializer methods")
    func `init`() {
        let ST1 = SegmentTree(capacity: 5, of: Int.self)
        let ST2 = SegmentTree<Int>(capacity: 5)
        
        #expect(ST1[0] == ST2[0])
        #expect(ST1[2] == ST2[4])
    }
    
    @Test("test modifying some elements")
    func elementModifing() {
        var tree: SegmentTree<Int> = [1, 4, 3, 5, 0, 4]
        
        #expect(tree[0] == 1)
        #expect(tree[0] != tree[1])
        
        tree[0] = tree[1]
        
        #expect(tree[0] != 1)
        #expect(tree[0] == tree[1])
    }
    
    @Test("test accessing some elements")
    func elementAccess() {
        let tree: SegmentTree = [1, 4, 3, 5, 0, 4]
        
        #expect(tree[0] == 1)
        #expect(tree[3] == 5)
        #expect(tree[1] == tree[5])
        #expect(tree.first! == 1)
        #expect(tree[0] != tree[1])
    }
    
    @Suite("Range Queries")
    struct rangeQueries {
        @Test("Static Range Min", .tags(.rangeQueries.min, .rangeQueries.static))
        func staticRangeMin() {
            let tree: SegmentTree<MinInt> = [1, 4, -3, 5, 0, 4]
            
            #expect(tree[0..<2] == 1)
            #expect(tree[0..<3] == -3)
            #expect(tree[3...5] == 0)
        }
        
        @Test("Dynamic Range Min", .tags(.rangeQueries.min, .rangeQueries.dynamic))
        func dynamicRangeMin() {
            var tree: SegmentTree<MinInt> = [1, 4, -3, 5, 0, 4]
            
            #expect(tree[0..<2] == 1)
            #expect(tree[0..<3] == -3)
            tree[2] = 2
            #expect(tree[0..<3] == 1)
            #expect(tree[3...5] == 0)
            #expect(tree[0..<2] == tree[0..<3])
            tree[0] = 6
            tree[4] = 9
            #expect(tree[0..<tree.count] == 2)
        }
        
        @Test("Static Range Max", .tags(.rangeQueries.max, .rangeQueries.static))
        func staticRangeMax() {
            let tree: SegmentTree<MaxInt> = [1, 4, -3, 5, 0, 4]
            
            #expect(tree[0..<2] == 4)
            #expect(tree[0..<3] == 4)
            #expect(tree[3...5] == 5)
        }
        
        @Test("Dynamic Range Max", .tags(.rangeQueries.max, .rangeQueries.dynamic))
        func dynamicRangeMax() {
            var tree: SegmentTree<MaxInt> = [1, 4, -3, 5, 0, 4]
            
            #expect(tree[0..<2] == 4)
            #expect(tree[0..<3] == 4)
            tree[2] = 6
            #expect(tree[0..<3] == 6)
            #expect(tree[3...5] == 5)
            #expect(tree[0..<3] == tree[2..<4])
            tree[0] = 6
            tree[4] = 9
            #expect(tree[0..<tree.count] == 9)
        }
        
        @Test("Static Range Sum", .tags(.rangeQueries.sum, .rangeQueries.static))
        func staticRangeSum() {
            let tree: SegmentTree = [1, 4, -3, 5, 0, 4]
            
            #expect(tree[0..<2] == 5)
            #expect(tree[0..<3] == 2)
            #expect(tree[3...5] == 9)
        }
        
        @Test("Dynamic Range Sum", .tags(.rangeQueries.sum, .rangeQueries.dynamic))
        func dynamicRangeSum() {
            var tree: SegmentTree = [1, 4, -3, 5, 0, 4]
            
            #expect(tree[0..<2] == 5)
            #expect(tree[0..<3] == 2)
            tree[2] = 2
            #expect(tree[0..<3] == 7)
            #expect(tree[3...5] == 9)
        }
    }
}

