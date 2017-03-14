//
//  FrontViewController.swift
//  FloatingEscapeViewController
//
//  Created by takyokoy on 2017/03/14.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController {
    
    weak var containerController: ContainerController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func didTappedButton(_ sender: Any) {
        containerController?.putAwayFloatingView()
    }

}
