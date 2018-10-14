import Quick
import GameKit

protocol TestableRandom {
    static func nextRandom() -> Self
}

extension Int: TestableRandom {
    static func nextRandom() -> Int {
        return Int(randomSource.nextInt(upperBound: 1000))
    }
}

extension CGFloat: TestableRandom {
    static func nextRandom() -> CGFloat {
        return CGFloat(1000 * randomSource.nextUniform())
    }
}

extension CGPoint: TestableRandom {
    static func nextRandom() -> CGPoint {
        return CGPoint(x: Int.nextRandom(), y: Int.nextRandom())
    }
}

extension CGSize: TestableRandom {
    static func nextRandom() -> CGSize {
        return CGSize(width: Int.nextRandom(), height: Int.nextRandom())
    }
}

extension CGRect: TestableRandom {
    static func nextRandom() -> CGRect {
        return CGRect(x: Int.nextRandom(), y: Int.nextRandom(), width: Int.nextRandom(), height: Int.nextRandom())
    }
}


var randomSource: GKRandomSource!

class RandomTestable: QuickConfiguration {
    class func previousSource(url seedUrl: URL) -> GKRandomSource? {
        return (try? String(contentsOf: seedUrl)).flatMap{UInt64($0.trimmingCharacters(in: .whitespacesAndNewlines))}.flatMap{
            print("Loaded random seed \($0) from \(seedUrl)")
            return GKLinearCongruentialRandomSource(seed: $0)
        }
    }

    class func createSource(url seedUrl: URL) -> GKRandomSource {
        let source = GKLinearCongruentialRandomSource()
        try? String(describing:source.seed).write(to: seedUrl, atomically: true, encoding: .ascii)
        print("Created random seed \(source.seed), save to \(seedUrl)")
        return source
    }

    override class func configure(_ configuration: Configuration) {
        let seedUrl = URL(fileURLWithPath: "/tmp/\(type(of: self)).seed.txt")
        randomSource = previousSource(url: seedUrl) ?? createSource(url: seedUrl)
    }
}
