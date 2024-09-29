// The Swift Programming Language
// https://docs.swift.org/swift-book

public struct SegmentTree<Node: STNode>: Collection {
    private var data: [Node]
    private let offset: Int
    private let size: Int
    private let updateType: STUpdateType
    
    public var startIndex: Int { 0 }
    public var endIndex: Int { size }
    public var bounds: Range<Int> { startIndex..<endIndex }
    
    public init(capacity size: Int, of nodeType: Node.Type = Node.self, fill: Node = Node(), updateType: STUpdateType = .immediate) {
        self.offset = if size.nonzeroBitCount == 1 { size }
                      else { 1<<(Int.bitWidth - size.leadingZeroBitCount) }

        self.size = size
        self.data = Array(repeating: fill, count: 2 * self.offset)
        self.updateType = updateType
    }
 
    public subscript(index: Int) -> Node {
        get {
            data[index + self.offset]
        }
        set(newValue) {
            data[index + self.offset] = newValue
            if updateType == .immediate {
                var i = (index + self.offset) / 2
                while (i != 0) {
                    data[i] = Node.Merge(lhs: data[i * 2], rhs: data[i * 2 + 1])
                    i /= 2
                }
            }
        }
    }
    
    private func query(index: Int, bounds: Range<Int>, queryBounds: Range<Int>) -> Node? {
        if queryBounds.contains(bounds) { return data[index] }
        else if !queryBounds.overlaps(bounds) { return nil }
        else {
            let mid = bounds.lowerBound + ((bounds.upperBound - bounds.lowerBound) / 2)
            let lhs = query(index: index * 2,     bounds: bounds.lowerBound..<mid, queryBounds: queryBounds)
            let rhs = query(index: index * 2 + 1, bounds: mid..<bounds.upperBound, queryBounds: queryBounds)
            
            precondition(lhs != nil || rhs != nil,
                         "Unreachable Code: result of overlapping-bounds query function returned nil in both halfs")
            
            guard let lhs else { return rhs }
            guard let rhs else { return lhs }
            
            return Node.Merge(lhs: lhs, rhs: rhs)
        }
    }
    
    public subscript(bounds: Range<Int>) -> Node {
        precondition(self.bounds.contains(bounds), "Range Query on invalid range!")
        return query(index: 1, bounds: 0..<self.offset, queryBounds: bounds) !! "Query on valid range must always return a `Node`"
    }
    
    public subscript(bounds: ClosedRange<Int>) -> Node {
        precondition(self.bounds.contains(bounds), "Range Query on invalid range!")
        return query(index: 1, bounds: 0..<self.offset, queryBounds: bounds.lowerBound..<bounds.upperBound+1) !! "Query on valid range must always return a `Node`"
    }
    
    public func index(after i: Int) -> Int {
        i + 1
    }
    
    public mutating func build() {
        for i in (1..<self.offset).reversed() {
            self.data[i] = Node.Merge(lhs: self.data[i * 2], rhs: self.data[i * 2 + 1])
        }
    }
}

extension SegmentTree: ExpressibleByArrayLiteral  {
    public typealias ArrayLiteralElement = Node
    public init(from elements: [Node], updateType: STUpdateType = .immediate) {
        self.init(capacity: elements.count, updateType: updateType)
        
        for (i, node) in elements.enumerated() {
            self.data[i + self.offset] = node
        }
        
        self.build()
    }
    
    public init(arrayLiteral elements: Node...) {
        self.init(from: elements)
    }
}


public protocol STNode {
    init()
    static func Merge(lhs: Self, rhs: Self) -> Self
}


public enum STUpdateType {
    case immediate
    case manual
}

