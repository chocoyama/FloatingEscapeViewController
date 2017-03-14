//
//  TouchThroughView.swift
//  FloatingEscapeViewController
//
//  Created by takyokoy on 2017/03/14.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

class TouchThroughView: UIView {
    
    weak var viewController: UIViewController?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView =  super.hitTest(point, with: event)
        if hitView == self {
            return viewController?.presentedViewController?.view
        } else {
            return hitView
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }

}
