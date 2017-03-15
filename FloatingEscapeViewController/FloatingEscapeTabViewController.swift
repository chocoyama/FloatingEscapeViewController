//
//  FloatingEscapeTabViewController.swift
//  FloatingEscapeViewController
//
//  Created by takyokoy on 2017/03/15.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

class FloatingEscapeTabViewController: UIViewController, ViewContainerable {
    
    struct Item {
        let viewController: UIViewController
        let tabBarItem: UITabBarItem
    }

    @IBOutlet weak var backContainerView: UIView!
    @IBOutlet weak var frontContainerView: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    
    fileprivate var items = [Item]()
    fileprivate var front: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func set(items: [Item], front: UIViewController) {
        self.items = items
        self.front = front
    }
    
}

extension FloatingEscapeTabViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items?.enumerated().filter{ $0.element == item }.map{ $0.offset }.first
        selectViewController(at: index!)
    }
}

extension FloatingEscapeTabViewController {
    fileprivate func setup() {
        tabBar.delegate = self
        
        let tabBarItems = items.map{ $0.tabBarItem }
        tabBar.setItems(tabBarItems, animated: false)
        tabBar.selectedItem = tabBarItems.first
        selectViewController(at: 0)
        
        displayContentController(content: front!, container: frontContainerView)
    }
    
    fileprivate func selectViewController(at index: Int) {
        displayContentController(content: items[index].viewController, container: backContainerView)
    }
}

extension FloatingEscapeTabViewController {
    class func create() -> FloatingEscapeTabViewController {
        let storyboard = UIStoryboard(name: "FloatingEscapeTabViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FloatingEscapeTabViewController") as! FloatingEscapeTabViewController
    }
}
