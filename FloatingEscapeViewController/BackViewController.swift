//
//  BackViewController.swift
//  FloatingEscapeViewController
//
//  Created by takyokoy on 2017/03/14.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

class BackViewController: UIViewController, FloatingEscapeControllable {
    
    weak var floatingEscapeViewController: FloatingEscapeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTappedShowButton(_ sender: Any) {
        floatingEscapeViewController?.show()
    }
    
    @IBAction func didTappedHideButton(_ sender: Any) {
        floatingEscapeViewController?.hide()
    }
    
}
