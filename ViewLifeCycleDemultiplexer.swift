//
//  ViewLifeCycleDemultiplexer.swift
//  See https://github.com/pepaslabs/ViewLifeCycleDemultiplexer
//
//  Created by Jason Pepas on 11/29/15.
//  Copyright © 2015 Jason Pepas. All rights reserved.
//  Released under the terms of the MIT license.
//  See https://opensource.org/licenses/MIT

import UIKit

protocol ModalViewLifeCycleProtocol
{
    func viewWillGetPresented(animated: Bool)
    func viewDidGetPresented(animated: Bool)
    
    func viewWillGetDismissed(animated: Bool)
    func viewDidGetDismissed(animated: Bool)
    
    func viewWillDisappearBeneathModal(animated: Bool)
    func viewDidDisappearBeneathModal(animated: Bool)
    
    func viewWillReappearFromBeneathModal(animated: Bool)
    func viewDidReappearFromBeneathModal(animated: Bool)
}

protocol NavigationViewLifeCycleProtocol
{
    func viewWillGetPushed(animated: Bool)
    func viewDidGetPushed(animated: Bool)
    
    func viewWillGetPopped(animated: Bool)
    func viewDidGetPopped(animated: Bool)
    
    func viewWillDisappearBeneathNavStack(animated: Bool)
    func viewDidDisappearBeneathNavStack(animated: Bool)
    
    func viewWillReappearFromBeneathNavStack(animated: Bool)
    func viewDidReappearFromBeneathNavStack(animated: Bool)
}

class ViewLifeCycleDemultiplexer
{
    var modalDelegate: ModalViewLifeCycleProtocol?
    var navDelegate: NavigationViewLifeCycleProtocol?
    
    convenience init()
    {
        self.init(modalDelegate: nil, navDelegate: nil)
    }
    
    init(modalDelegate: ModalViewLifeCycleProtocol?, navDelegate: NavigationViewLifeCycleProtocol?)
    {
        self.modalDelegate = modalDelegate
        self.navDelegate = navDelegate
    }
    
    func viewWillAppear(viewController vc: UIViewController, animated: Bool)
    {
        if vc.isBeingPresented()
        {
            modalDelegate?.viewWillGetPresented(animated)
        }
        else if let navC = vc.navigationController where navC.isBeingPresented() == true
        {
            modalDelegate?.viewWillGetPresented(animated)
        }
        else if vc.isMovingToParentViewController()
        {
            navDelegate?.viewWillGetPushed(animated)
        }
        else if let _ = vc.presentedViewController
        {
            modalDelegate?.viewWillReappearFromBeneathModal(animated)
        }
        else if let navC = vc.navigationController,
            let coordinator = navC.transitionCoordinator(),
            let fromVC = coordinator.viewControllerForKey(UITransitionContextFromViewControllerKey)
            where navC.viewControllers.contains(fromVC) == false
        {
            // thanks to http://stackoverflow.com/a/26308475
            navDelegate?.viewWillReappearFromBeneathNavStack(animated)
        }
    }
    
    func viewDidAppear(viewController vc: UIViewController, animated: Bool)
    {
        if vc.isBeingPresented()
        {
            modalDelegate?.viewDidGetPresented(animated)
        }
        else if let navC = vc.navigationController where navC.isBeingPresented() == true
        {
            modalDelegate?.viewDidGetPresented(animated)
        }
        else if vc.isMovingToParentViewController()
        {
            navDelegate?.viewDidGetPushed(animated)
        }
        else if let _ = vc.presentedViewController
        {
            modalDelegate?.viewDidReappearFromBeneathModal(animated)
        }
        else if let navC = vc.navigationController,
            let coordinator = navC.transitionCoordinator(),
            let fromVC = coordinator.viewControllerForKey(UITransitionContextFromViewControllerKey)
            where navC.viewControllers.contains(fromVC) == false
        {
            // thanks to http://stackoverflow.com/a/26308475
            navDelegate?.viewDidReappearFromBeneathNavStack(animated)
        }
    }
    
    func viewWillDisappear(viewController vc: UIViewController, animated: Bool)
    {
        if let _ = vc.presentedViewController
        {
            modalDelegate?.viewWillDisappearBeneathModal(animated)
        }
        else if vc.isBeingDismissed()
        {
            modalDelegate?.viewWillGetDismissed(animated)
        }
        else if let navC = vc.navigationController where navC.isBeingDismissed() == true
        {
            modalDelegate?.viewWillGetDismissed(animated)
        }
        else if vc.isMovingFromParentViewController()
        {
            navDelegate?.viewWillGetPopped(animated)
        }
        else if let last = vc.navigationController?.viewControllers.last where last != vc
        {
            navDelegate?.viewWillDisappearBeneathNavStack(animated)
        }
    }
    
    func viewDidDisappear(viewController vc: UIViewController, animated: Bool)
    {
        if let _ = vc.presentedViewController
        {
            modalDelegate?.viewDidDisappearBeneathModal(animated)
        }
        else if vc.isBeingDismissed()
        {
            modalDelegate?.viewDidGetDismissed(animated)
        }
        else if let navC = vc.navigationController where navC.isBeingDismissed() == true
        {
            modalDelegate?.viewDidGetDismissed(animated)
        }
        else if vc.isMovingFromParentViewController()
        {
            navDelegate?.viewDidGetPopped(animated)
        }
        else if let last = vc.navigationController?.viewControllers.last where last != vc
        {
            navDelegate?.viewDidDisappearBeneathNavStack(animated)
        }
    }
}

// default implementations which effectively make these "optional" methods
// see http://stackoverflow.com/a/30744501
extension ModalViewLifeCycleProtocol
{
    func viewWillGetPresented(animated: Bool) {}
    func viewDidGetPresented(animated: Bool) {}
    
    func viewWillGetDismissed(animated: Bool) {}
    func viewDidGetDismissed(animated: Bool) {}
    
    func viewWillDisappearBeneathModal(animated: Bool) {}
    func viewDidDisappearBeneathModal(animated: Bool) {}
    
    func viewWillReappearFromBeneathModal(animated: Bool) {}
    func viewDidReappearFromBeneathModal(animated: Bool) {}
}

// default implementations which effectively make these "optional" methods
// see http://stackoverflow.com/a/30744501
extension NavigationViewLifeCycleProtocol
{
    func viewWillGetPushed(animated: Bool) {}
    func viewDidGetPushed(animated: Bool) {}
    
    func viewWillGetPopped(animated: Bool) {}
    func viewDidGetPopped(animated: Bool) {}
    
    func viewWillDisappearBeneathNavStack(animated: Bool) {}
    func viewDidDisappearBeneathNavStack(animated: Bool) {}
    
    func viewWillReappearFromBeneathNavStack(animated: Bool) {}
    func viewDidReappearFromBeneathNavStack(animated: Bool) {}
}

