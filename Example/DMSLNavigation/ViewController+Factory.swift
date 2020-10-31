//
//  ViewController+Factory.swift
//  DMSLNavigation_Example
//
//  Created by Dmytro Shulzhenko on 31.10.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import DMSLNavigation

// MARK: - Factory

// MARK: Root

extension ViewController {
    static func initializeRoot() -> UIViewController {
        let (navigation, vc) = stack
        let viewModel = ViewModel()
        vc.bag.insert(viewModel)

        vc.bindAsRoot(viewModel: viewModel)
        
        vc.bindPush(presentedViewControllerFactory: initializePushed,
                    signal: viewModel.signals.push,
                    bag: vc.bag)
        
        vc.bindPresent(presentedViewControllerFactory: initializePresented,
                       signal: viewModel.signals.present,
                       bag: vc.bag)
        
        
        return navigation
    }
}

// MARK: Presented

extension ViewController {
    static func initializePresented() -> UIViewController {
        let (navigation, vc) = stack
        let viewModel = ViewModel()
        vc.bag.insert(viewModel)
                
        vc.bindAsPresented(viewModel: viewModel)
        
        vc.bindPush(presentedViewControllerFactory: initializePushed,
                    signal: viewModel.signals.push,
                    bag: vc.bag)
        
        vc.bindPresent(presentedViewControllerFactory: initializePresented,
                       signal: viewModel.signals.present,
                       bag: vc.bag)
        
        vc.bindDismiss(signal: viewModel.signals.dismiss,
                       bag: vc.bag,
                       option: .currentNavigationStack)
        
        vc.bindDismiss(signal: viewModel.signals.dismissToRoot,
                       bag: vc.bag,
                       option: .currentNavigationStackToRoot)
        
        return navigation
    }
}

// MARK: Pushed

extension ViewController {
    static func initializePushed() -> UIViewController {
        let (_, vc) = stack
        let viewModel = ViewModel()
        vc.bag.insert(viewModel)
        
        vc.bindAsPushed(viewModel: viewModel)
        
        vc.bindPush(presentedViewControllerFactory: ViewController.initializePushed,
                    signal: viewModel.signals.push,
                    bag: vc.bag)
        
        vc.bindPresent(presentedViewControllerFactory: ViewController.initializePresented,
                       signal: viewModel.signals.present,
                       bag: vc.bag)
        
        vc.bindPop(signal: viewModel.signals.dismiss,
                   bag: vc.bag)
        
        vc.bindPop(signal: viewModel.signals.dismissToRoot,
                   bag: vc.bag,
                   option: .toRoot)
        
        return vc
    }
    
    private static var stack: (navigation: UINavigationController, vc: ViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        let navigation = initialViewController as! UINavigationController
        let vc = navigation.viewControllers.first as! ViewController
        return (navigation, vc)
    }
}
