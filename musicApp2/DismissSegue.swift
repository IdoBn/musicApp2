//
//  DismissSegue.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 1/24/15.
//  Copyright (c) 2015 Ido Ben-Natan. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    override func perform() {
        let sourceViewController: UIViewController = self.sourceViewController as UIViewController
        sourceViewController.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
