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
        overlayImageView.frame = backgroundImageView.contentSpace().convert(placement, to: view)
    }

    func updateOvelayPositionAnimated() {
        UIView.animate(withDuration: 0.5) {
            self.updateOvelayPosition()
        }
    }

    func nextContentMode() {
        backgroundImageView.contentMode = UIViewContentMode(rawValue: backgroundImageView.contentMode.rawValue + 1)!
    }

    override func viewDidLayoutSubviews() {
        updateOvelayPositionAnimated()
    }

    func showNextContentMode() {
        nextContentMode()
        if backgroundImageView.contentMode == .redraw {
            nextContentMode()
        }
        updateOvelayPositionAnimated()
    }

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        showNextContentMode()
    }

    @IBAction func didTap(_ sender: AnyObject) {
        showNextContentMode()
    }
}
