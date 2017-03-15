//
//  ViewContainerable.swift
//  FloatingEscapeViewController
//
//  Created by takyokoy on 2017/03/15.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

protocol ViewContainerable {}
extension ViewContainerable where Self: UIViewController {
    func displayContentController(content: UIViewController, container: UIView) {
        addChildViewController(content)
        content.view.frame = container.bounds
        container.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    
    func hideContentController(content: UIViewController) {
        content.willMove(toParentViewController: self)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
}
