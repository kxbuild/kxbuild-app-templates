//
//  ViewController.swift
//  __NAME__
//
//  Created on __DATE__.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!

    private var tapCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        greetingLabel.text = "Hello, __NAME__!"
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        tapCount += 1
        greetingLabel.text = "Tapped \(tapCount) time\(tapCount == 1 ? "" : "s")"
    }
}
