//
//  FloatingEscapeViewController.swift
//  FloatingEscapeViewController
//
//  Created by takyokoy on 2017/03/13.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

protocol FloatingEscapeControllable: class {
    weak var floatingEscapeViewController: FloatingEscapeViewController? { get set }
}

protocol FloatingEscapeController: class {
    func show()
    func hide()
    func escape()
}

class FloatingEscapeViewController: UIViewController {
    
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
        setup()
    }
    
    func inject<T: FloatingEscapeControllable, U: FloatingEscapeControllable>(backViewController: T, frontViewController: U) where T: UIViewController, U: UIViewController {
        backViewController.floatingEscapeViewController = self
        frontViewController.floatingEscapeViewController = self
        self.backViewController = backViewController
        self.frontViewController = frontViewController
    }
}

extension FloatingEscapeViewController: FloatingEscapeController {
    func show() {
        floatingViewHeightConstraint.constant = floatingViewDefaultHeightConstraint
        floatingViewTopConstraint.constant = 0
        frontContainerViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func hide() {
        floatingViewHeightConstraint.constant = 0
        floatingViewTopConstraint.constant = UIScreen.main.bounds.height
        frontContainerViewBottomConstraint.constant = -UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func escape() {
        floatingViewHeightConstraint.constant = floatingViewDefaultHeightConstraint
        floatingViewTopConstraint.constant = UIScreen.main.bounds.height - floatingViewDefaultHeightConstraint - 20
        frontContainerViewBottomConstraint.constant = -(UIScreen.main.bounds.height - floatingViewDefaultHeightConstraint - 20)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}


extension FloatingEscapeViewController {
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
                escape()
            } else {
                show()
            }
        default: break
        }
    }
    
    @IBAction func didTappedFloatingView(_ sender: UITapGestureRecognizer) {
        let isPutAway = frontContainerViewBottomConstraint.constant == 0
        if isPutAway {
            escape()
        } else {
            show()
        }
    }
}

extension FloatingEscapeViewController {
    fileprivate func setup() {
        guard let backVC = backViewController, let frontVC = frontViewController else { return }
        displayContentController(content: backVC, container: backContainerView)
        displayContentController(content: frontVC, container: frontContainerView)
        hide()
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
