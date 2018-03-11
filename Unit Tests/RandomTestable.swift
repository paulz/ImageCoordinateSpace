import Quick
import GameKit

func testRandom() -> Int {
    return Int(randomSource.nextInt().magnitude)
}

func randomRect() -> CGRect {
    return CGRect(x: testRandom(), y: testRandom(), width: testRandom(), height: testRandom())
}

var randomSource: GKARC4RandomSource!

class RandomTestable: QuickConfiguration {
    class func previousSource(url seedUrl: URL) -> GKARC4RandomSource? {
        return (try? Data(contentsOf: seedUrl)).flatMap{GKARC4RandomSource(seed: $0)}
    }

    class func createSource(url seedUrl: URL) -> GKARC4RandomSource {
        let source = GKARC4RandomSource()
        try? source.seed.write(to: seedUrl)
        return source
    }

    override class func configure(_ configuration: Configuration) {
        let seedUrl = URL(fileURLWithPath: "/tmp/\(type(of: self)).seed.txt")
        randomSource = previousSource(url: seedUrl) ?? createSource(url: seedUrl)
    }
}
