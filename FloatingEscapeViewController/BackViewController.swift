//
//  BackViewController.swift
//  FloatingEscapeViewController
//
//  Created by takyokoy on 2017/03/14.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

class BackViewController: UIViewController, FloatingEscapeControllable {
    
    class func create() -> BackViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "BackViewController") as! BackViewController
    }
    
    weak var floatingEscapeController: FloatingEscapeController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTappedShowButton(_ sender: Any) {
        floatingEscapeController?.show()
    }
    
    @IBAction func didTappedHideButton(_ sender: Any) {
        floatingEscapeController?.hide(animated: true)
    }
    
}
