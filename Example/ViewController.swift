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

    func updateOvelayPositionAnimated() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.updateOvelayPosition()
        }
    }

    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        showNextContentMode()
    }

    func nextContentMode() {
        backgroundImageView.contentMode = UIViewContentMode(rawValue: backgroundImageView.contentMode.rawValue + 1)!
    }

    override func viewDidLayoutSubviews() {
        updateOvelayPositionAnimated()
    }

    func showNextContentMode() {
        nextContentMode()
        if backgroundImageView.contentMode == .Redraw {
            nextContentMode()
        }
        updateOvelayPositionAnimated()
    }

    @IBAction func didTap(sender: AnyObject) {
        showNextContentMode()
    }
}
