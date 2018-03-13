import Quick
import GameKit

func testRandom() -> Int {
    return Int(randomSource.nextInt().magnitude)
}

func randomRect() -> CGRect {
    return CGRect(x: testRandom(), y: testRandom(), width: testRandom(), height: testRandom())
}

var randomSource: GKRandomSource!

class RandomTestable: QuickConfiguration {
    class func previousSource(url seedUrl: URL) -> GKRandomSource? {
        return (try? String(contentsOf: seedUrl)).flatMap{UInt64($0)}.flatMap{
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
