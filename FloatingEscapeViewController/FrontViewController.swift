//
//  FrontViewController.swift
//  FloatingEscapeViewController
//
//  Created by takyokoy on 2017/03/14.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController, FloatingEscapeControllable {
    
    weak var floatingEscapeViewController: FloatingEscapeViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTappedHideButton(_ sender: Any) {
        floatingEscapeViewController?.hide()
    }

    @IBAction func didTappedEscapeButton(_ sender: Any) {
        floatingEscapeViewController?.escape()
    }

}
