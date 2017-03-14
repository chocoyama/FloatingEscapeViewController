//
//  ContainerViewController.swift
//  FloatingEscapeViewController
//
//  Created by takyokoy on 2017/03/13.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

protocol ContainerControllable: class {
    weak var containerController: ContainerController? { get set }
}

protocol ContainerController: class {
    func showFloatingView()
    func hideFloatingView()
    func putAwayFloatingView()
}

class ContainerViewController: UIViewController {
    
    fileprivate var floatingViewDefaultHeightConstraint: CGFloat = 0
    @IBOutlet weak var floatingViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var floatingViewHeightConstraint: NSLayoutConstraint! {
        didSet { floatingViewDefaultHeightConstraint = floatingViewHeightConstraint.constant }
    }
    @IBOutlet weak var frontContainerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var frontContainerView: UIView!
    @IBOutlet weak var backContainerView: UIView!
    @IBOutlet weak var floatingView: UIView!
    
    fileprivate var backViewController: UIViewController?
    fileprivate var frontViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initailzeForTest()
        setup()
    }
    
    func inject<T: ContainerControllable, U: ContainerControllable>(backViewController: T, frontViewController: U) where T: UIViewController, U: UIViewController {
        backViewController.containerController = self
        frontViewController.containerController = self
        self.backViewController = backViewController
        self.frontViewController = frontViewController
    }
}

extension ContainerViewController: ContainerController {
    func showFloatingView() {
        floatingViewHeightConstraint.constant = floatingViewDefaultHeightConstraint
        floatingViewTopConstraint.constant = 0
        frontContainerViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func hideFloatingView() {
        floatingViewHeightConstraint.constant = 0
        floatingViewTopConstraint.constant = UIScreen.main.bounds.height
        frontContainerViewBottomConstraint.constant = -UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func putAwayFloatingView() {
        floatingViewHeightConstraint.constant = floatingViewDefaultHeightConstraint
        floatingViewTopConstraint.constant = UIScreen.main.bounds.height - floatingViewDefaultHeightConstraint - 20
        frontContainerViewBottomConstraint.constant = -(UIScreen.main.bounds.height - floatingViewDefaultHeightConstraint - 20)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}


extension ContainerViewController {
    @IBAction func didSwipedFloatingView(_ sender: UIPanGestureRecognizer) {
        let translationPoint = sender.translation(in: floatingView)
        let isVerticalSwipe = !(sqrt(translationPoint.x * translationPoint.x) / sqrt(translationPoint.y * translationPoint.y) > 1)
        guard isVerticalSwipe else { return }
        switch sender.state {
        case .changed:
            let transition = translationPoint.y > 0 ? translationPoint.y : UIScreen.main.bounds.height - floatingViewDefaultHeightConstraint + translationPoint.y
            floatingViewTopConstraint.constant = transition
            frontContainerViewBottomConstraint.constant = -transition
        case .ended:
            let threshold = UIScreen.main.bounds.height / 2
            if floatingViewTopConstraint.constant > threshold {
                putAwayFloatingView()
            } else {
                showFloatingView()
            }
        default: break
        }
    }
    
    @IBAction func didTappedFloatingView(_ sender: UITapGestureRecognizer) {
        let isPutAway = frontContainerViewBottomConstraint.constant == 0
        if isPutAway {
            putAwayFloatingView()
        } else {
            showFloatingView()
        }
    }
}

extension ContainerViewController {
    fileprivate func initailzeForTest() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let backViewController = storyboard.instantiateViewController(withIdentifier: "BackViewController") as! BackViewController
        let frontViewController =  storyboard.instantiateViewController(withIdentifier: "FrontViewController") as! FrontViewController
        inject(backViewController: backViewController, frontViewController: frontViewController)
    }
    
    fileprivate func setup() {
        guard let backVC = backViewController, let frontVC = frontViewController else { return }
        displayContentController(content: backVC, container: backContainerView)
        displayContentController(content: frontVC, container: frontContainerView)
        hideFloatingView()
    }
    
    private func displayContentController(content: UIViewController, container: UIView) {
        addChildViewController(content)
        content.view.frame = container.bounds
        container.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    
    private func hideContentController(content: UIViewController) {
        content.willMove(toParentViewController: self)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
}
