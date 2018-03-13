import Quick
import GameKit

func nextRandom() -> Int {
    return Int(randomSource.nextInt().magnitude)
}

func nextRandomPoint() -> CGPoint {
    return CGPoint(x: nextRandom(), y: nextRandom())
}

func nextRandomSize() -> CGSize {
    return CGSize(width: nextRandom(), height: nextRandom())
}

func nextRandomRect() -> CGRect {
    return CGRect(x: nextRandom(), y: nextRandom(), width: nextRandom(), height: nextRandom())
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
