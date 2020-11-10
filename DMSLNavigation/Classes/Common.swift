//
//  Common.swift
//  DMSLNavigation
//
//  Created by Dmytro Shulzhenko on 31.10.2020.
//

import UIKit

// MARK: UIViewController

extension UIViewController {
    private var rootPresentingViewController: UIViewController? {
        presentingViewController?.rootPresentingViewController ?? self
    }
    
    private var rootPresentingNavigationController: UIViewController? {
        (presentingViewController ?? navigationController)?.rootPresentingNavigationController ?? self
    }
}

extension UIViewController {
    func dismissPresented(animated: Bool,
                          completion: Completion?) {
        guard let presented = presentedViewController else {
            assertionFailure("Presented View Controller is missing")
            return completion?() ?? ()
        }
        presented.dismiss(animated: animated, completion: completion)
    }
    
    func dismissToRoot(animated: Bool = true,
                       completion: Completion?) {
        rootPresentingViewController?.dismiss(animated: animated, completion: completion)
    }
    
    func dismissCurrentNavigationStack(animated: Bool = true,
                                       completion: Completion?) {
        guard let navigation = navigationController else {
            assertionFailure("Navigation Controller is missing")
            return completion?() ?? ()
        }
        navigation.dismiss(animated: animated, completion: completion)
    }
    
    func dismissCurrentNavigationStackToRoot(animated: Bool = true,
                                             completion: Completion?) {
        rootPresentingNavigationController?.dismiss(animated: animated, completion: completion)
    }
}

// MARK: Array

extension Array {
    func element(at index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
