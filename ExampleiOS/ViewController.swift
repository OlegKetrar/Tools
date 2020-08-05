//
//  ViewController.swift
//  ExampleiOS
//
//  Created by Oleg Ketrar on 13.01.18.
//  Copyright © 2018 Oleg Ketrar. All rights reserved.
//

import UIKit
import Tools

enum Storyboard: String {
    case main = "ViewController"
}

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: StoryboardInitable {
    static var storyboard: Storyboard { .main }
}
