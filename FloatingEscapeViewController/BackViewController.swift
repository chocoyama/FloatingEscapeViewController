//
//  BackViewController.swift
//  FloatingEscapeViewController
//
//  Created by takyokoy on 2017/03/14.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

class BackViewController: UIViewController {
    
    weak var containerController: ContainerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTappedShowButton(_ sender: Any) {
        containerController?.showFloatingView()
    }
    
    @IBAction func didTappedHideButton(_ sender: Any) {
        containerController?.hideFloatingView()
    }
    
}
