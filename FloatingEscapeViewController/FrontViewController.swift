//
//  FrontViewController.swift
//  FloatingEscapeViewController
//
//  Created by takyokoy on 2017/03/14.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController, FloatingEscapeControllable {
    
    class func create() -> FrontViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FrontViewController") as! FrontViewController
    }
    
    weak var floatingEscapeController: FloatingEscapeController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTappedHideButton(_ sender: Any) {
        floatingEscapeController?.hide(animated: true)
    }

    @IBAction func didTappedEscapeButton(_ sender: Any) {
        floatingEscapeController?.escape()
    }

    @IBAction func didTappedBarButton(_ sender: Any) {
        print("")
    }
}
