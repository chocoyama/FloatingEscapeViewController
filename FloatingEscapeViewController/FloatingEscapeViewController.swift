//
//  FloatingEscapeViewController.swift
//  FloatingEscapeViewController
//
//  Created by takyokoy on 2017/03/13.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

protocol FloatingEscapeControllable: class {
    weak var floatingEscapeController: FloatingEscapeController? { get set }
}

protocol FloatingEscapeController: class {
    func show()
    func hide(animated: Bool)
    func escape()
}

protocol FloatingEscapeViewControllerDelegate: class {
    func didStartedShowFrontViewController()
    func didStartedHideFrontViewController()
    func didStartedEscapeFrontViewController()
}

class FloatingEscapeViewController: UIViewController {
    
    weak var delegate: FloatingEscapeViewControllerDelegate?
    
    fileprivate var floatingHeight: CGFloat = 0
    fileprivate var topMargin: CGFloat = 0
    fileprivate var floatingBottomMargin: CGFloat = 0
    fileprivate var swipeStartPoint: CGPoint?
    
    @IBOutlet weak var frontContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var frontContainerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var frontContainerView: UIView!
    @IBOutlet weak var backContainerView: UIView!
    
    fileprivate var backViewController: UIViewController?
    fileprivate var frontViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func inject<T: FloatingEscapeControllable, U: FloatingEscapeControllable>
        (backViewController: T,
         frontViewController: U,
         floatingHeight: CGFloat,
         topMargin: CGFloat,
         floatingBottomMargin: CGFloat) where T: UIViewController, U: UIViewController {
        
        backViewController.floatingEscapeController = self
        frontViewController.floatingEscapeController = self
        self.backViewController = backViewController
        self.frontViewController = frontViewController
        self.floatingHeight = floatingHeight
        self.topMargin = topMargin
        self.floatingBottomMargin = floatingBottomMargin
    }
    
}

extension FloatingEscapeViewController: FloatingEscapeController {
    func show() {
        delegate?.didStartedShowFrontViewController()
        frontContainerViewTopConstraint.constant = topMargin
        frontContainerViewBottomConstraint.constant = 0
        layoutWithAnimation()
    }
    
    func hide(animated: Bool) {
        delegate?.didStartedHideFrontViewController()
        frontContainerViewTopConstraint.constant = UIScreen.main.bounds.height
        frontContainerViewBottomConstraint.constant = -UIScreen.main.bounds.height
        if animated {
            layoutWithAnimation()
        }
    }
    
    func escape() {
        delegate?.didStartedEscapeFrontViewController()
        frontContainerViewTopConstraint.constant = UIScreen.main.bounds.height - floatingHeight - 20 - floatingBottomMargin
        frontContainerViewBottomConstraint.constant = -(UIScreen.main.bounds.height - floatingHeight - 20 - floatingBottomMargin)
        layoutWithAnimation()
    }
    
    private func layoutWithAnimation() {
        UIView.animate(
            withDuration: 0.7,
            delay: 0.0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.0,
            options: [],
            animations: { [weak self] in
                self?.view.layoutIfNeeded()
            },
            completion: { (finished) in
                
        }
        )
    }
}


extension FloatingEscapeViewController {
    func didSwipedFrontContainerView(_ sender: UIPanGestureRecognizer) {
        let startLocation = swipeStartPoint ?? sender.location(in: frontContainerView)
        guard startLocation.y <= frontContainerView.bounds.origin.y + floatingHeight else { return }
        
        let translationPoint = sender.translation(in: frontContainerView)
        let isVerticalSwipe = !(sqrt(translationPoint.x * translationPoint.x) / sqrt(translationPoint.y * translationPoint.y) > 1)
        guard isVerticalSwipe else { return }
        
        switch sender.state {
        case .began:
            swipeStartPoint = sender.location(in: frontContainerView)
        case .changed:
            let transition = translationPoint.y > 0 ? translationPoint.y + topMargin : UIScreen.main.bounds.height - floatingHeight + translationPoint.y - topMargin
            frontContainerViewTopConstraint.constant = transition
            frontContainerViewBottomConstraint.constant = -transition
        case .ended:
            let threshold = UIScreen.main.bounds.height / 2
            if frontContainerViewTopConstraint.constant > threshold {
                escape()
            } else {
                show()
            }
            swipeStartPoint = nil
        default: break
        }
    }
    
    func didTappedFrontContainerView(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: frontContainerView)
        guard location.y <= frontContainerView.bounds.origin.y + floatingHeight else { return }
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
        
        frontContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTappedFrontContainerView(_:))))
        frontContainerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.didSwipedFrontContainerView(_:))))
        
        hide(animated: false)
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
