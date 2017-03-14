//
//  EntryViewController.swift
//  FloatingEscapeViewController
//
//  Created by takyokoy on 2017/03/14.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTappedEntryButton(_ sender: Any) {
        let vc = floatingEscapeViewController
        vc.inject(backViewController: backViewController, frontViewController: frontViewController, floatingHeight: 44, topMargin: 20, floatingBottomMargin: 0)
        present(vc, animated: true, completion: nil)
    }
    
    var floatingEscapeViewController: FloatingEscapeViewController {
        let storyboard = UIStoryboard(name: "FloatingEscapeViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FloatingEscapeViewController") as! FloatingEscapeViewController
    }
    
    var backViewController: BackViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "BackViewController") as! BackViewController
    }
    
    var frontViewController: FrontViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FrontViewController") as! FrontViewController
    }
    
}
