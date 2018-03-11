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
    override class func configure(_ configuration: Configuration) {
        let seedUrl = URL(fileURLWithPath: "/tmp/\(type(of: self)).seed.txt")
        if let previous = try? Data(contentsOf: seedUrl) {
            randomSource = GKARC4RandomSource(seed: previous)
        } else {
            randomSource = GKARC4RandomSource()
            try? randomSource.seed.write(to: seedUrl)
        }
    }
}
