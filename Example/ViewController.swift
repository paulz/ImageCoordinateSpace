//
//  ViewController.swift
//  ImageCoordinateSpace
//
//  Created by Paul Zabelin on 2/13/16.
//
//

import UIKit
import ImageCoordinateSpace

class ViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var overlayImageView: UIImageView!
    let placement = CGRect(x: 321/2, y: 102/2, width: 63/2, height: 64/2)

    func updateOvelayPosition() {
        overlayImageView.frame = backgroundImageView.imageCoordinateSpace.convertRect(placement, toCoordinateSpace: view)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateOvelayPosition()
    }

    func nextContentMode() {
        backgroundImageView.contentMode = UIViewContentMode(rawValue: backgroundImageView.contentMode.rawValue + 1)!
    }

    @IBAction func didTap(sender: AnyObject) {
        nextContentMode()
        if backgroundImageView.contentMode == .Redraw {
            nextContentMode()
        }
        UIView.animateWithDuration(0.5) { () -> Void in
            self.updateOvelayPosition()
        }
    }

}

