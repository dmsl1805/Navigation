//
//  ViewController+Factory.swift
//  DMSLNavigation_Example
//
//  Created by Dmytro Shulzhenko on 31.10.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import DMSLNavigation
import RxSwift

// MARK: - Factory

// MARK: Root

extension ViewController {
    static func initializeRoot() -> UIViewController {
        // stack

        let (navigation, vc) = stack
        
        // view model
        
        let viewModel = ViewModel()
        vc.bag.insert(viewModel)

        // bind
        
        vc.bindAsRoot(viewModel: viewModel)
        
        // push navigation
        
        vc.bindPush(presentedViewControllerFactory: initializePushed,
                    signal: viewModel.signals.push,
                    bag: vc.bag)
        
        // present navigation
        
        let presentedFactory = { [unowned vc] in initializePresented(presenter: vc) }

        vc.bindPresent(presentedViewControllerFactory: presentedFactory,
                       signal: viewModel.signals.present,
                       bag: vc.bag)
        
        
        return navigation
    }
}

// MARK: Presented

extension ViewController {
    static func initializePresented(presenter: ViewController) -> UIViewController {
        // stack
        
        let (navigation, vc) = stack
        
        // view model
        
        let viewModel = ViewModel()
        vc.bag.insert(viewModel)
                
        // bind
        
        vc.bindAsPresented(viewModel: viewModel)
        
        // push navigation
        
        vc.bindPush(presentedViewControllerFactory: initializePushed,
                    signal: viewModel.signals.push,
                    bag: vc.bag)
        
        // present navigation
        
        vc.bindPresent(presentedViewControllerFactory: { [unowned vc] in initializePresented(presenter: vc) },
                       signal: viewModel.signals.present,
                       bag: vc.bag)
        
        presenter.bindPresent(presentedViewControllerFactory: { [unowned presenter] in initializePresented(presenter: presenter) },
                              signal: viewModel.signals.presentAfterDismiss,
                              bag: presenter.bag)
        
        // dismiss navigation
        
        vc.bindDismiss(signal: viewModel.signals.dismiss,
                       bag: vc.bag,
                       option: .currentNavigationStack)
        
        // dismiss and present navigation
        
        presenter.bindDismiss(signal: viewModel.signals.dismissAndPresent,
                              bag: presenter.bag,
                              option: .presented,
                              completion: viewModel.continueAfterDismiss)
        
        // dismiss to root navigation

        vc.bindDismiss(signal: viewModel.signals.dismissToRoot,
                       bag: vc.bag,
                       option: .currentNavigationStackToRoot)
        
        return navigation
    }
}

// MARK: Pushed

extension ViewController {
    static func initializePushed() -> UIViewController {
        // stack
        
        let (_, vc) = stack
        
        // view model
        
        let viewModel = ViewModel()
        vc.bag.insert(viewModel)
        
        // bind
        
        vc.bindAsPushed(viewModel: viewModel)
        
        // push navigation
        
        vc.bindPush(presentedViewControllerFactory: initializePushed,
                    signal: viewModel.signals.push,
                    bag: vc.bag)
        
        // present navigation
        
        let presentedFactory = { [unowned vc] in initializePresented(presenter: vc) }

        vc.bindPresent(presentedViewControllerFactory: presentedFactory,
                       signal: viewModel.signals.present,
                       bag: vc.bag)
        
        // pop navigation
        
        vc.bindPop(signal: viewModel.signals.dismiss,
                   bag: vc.bag)
        
        // pop to root navigation
        
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
