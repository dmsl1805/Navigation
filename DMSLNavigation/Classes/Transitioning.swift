//
//  Transitioning.swift
//  DMSLNavigation
//
//  Created by Dmytro Shulzhenko on 31.10.2020.
//

import UIKit

public typealias Completion = () -> Void

// MARK: - Transition

public protocol Transitioning {
    associatedtype Prop
    
    func perform(prop: Prop, completion: Completion?)
}

public extension Transitioning {
    func perform(prop: Prop) {
        perform(prop: prop, completion: nil)
    }
}

public extension Transitioning where Prop == Void {
    func perform() {
        perform(prop: ())
    }
    
    func perform(completion: Completion) {
        perform(prop: ()) { }
    }
}

// MARK: - View Controller Based

// MARK: Present

public final class PresentTransition<Prop>: Transitioning {
    private unowned let presentingViewController: UIViewController
    private let presentedViewControllerFactory: (Prop) -> UIViewController
    private let sourceViewPath: KeyPath<UIViewController, UIView>?
    private let isAnimated: Bool
    
    public init(presentingViewController: UIViewController,
                presentedViewControllerFactory: @escaping (Prop) -> UIViewController,
                sourceViewPath: KeyPath<UIViewController, UIView>?,
                isAnimated: Bool) {
        self.presentingViewController = presentingViewController
        self.presentedViewControllerFactory = presentedViewControllerFactory
        self.sourceViewPath = sourceViewPath
        self.isAnimated = isAnimated
    }
    
    public func perform(prop: Prop, completion: Completion?) {
        let viewControllerToPresent = presentedViewControllerFactory(prop)
        sourceViewPath
            .map { presentingViewController[keyPath: $0] }
            .map { viewControllerToPresent.popoverPresentationController?.sourceView = $0 }
        presentingViewController.present(viewControllerToPresent,
                                         animated: isAnimated,
                                         completion: completion)
    }
}

// MARK: Dismiss

public final class DismissTransition: Transitioning {
    public enum Option {
        case current
        case presented
        case currentNavigationStack
        case toRoot
        case currentNavigationStackToRoot
    }
    
    private unowned let presentedViewController: UIViewController
    private let isAnimated: Bool
    private let option: Option
    
    public init(presentedViewController: UIViewController,
                isAnimated: Bool,
                option: Option) {
        self.presentedViewController = presentedViewController
        self.isAnimated = isAnimated
        self.option = option
    }
    
    public func perform(prop: Void, completion: Completion?) {
        switch option {
        case .current:
            presentedViewController.dismiss(animated: isAnimated, completion: completion)
        case .presented:
            presentedViewController.dismissPresented(animated: isAnimated, completion: completion)
        case .currentNavigationStack:
            presentedViewController.dismissCurrentNavigationStack(animated: isAnimated, completion: completion)
        case .toRoot:
            presentedViewController.dismissToRoot(animated: isAnimated, completion: completion)
        case .currentNavigationStackToRoot:
            presentedViewController.dismissCurrentNavigationStackToRoot(animated: isAnimated, completion: completion)
        }
    }
}

// MARK: - Navigation Controller Based

// MARK: Push

public final class NavigationPushTransition<Prop>: Transitioning {
    private unowned let presentingViewController: UIViewController
    private let presentedViewControllerFactory: (Prop) -> UIViewController
    private let isAnimated: Bool
    
    public init(presentingViewController: UIViewController,
                presentedViewControllerFactory: @escaping (Prop) -> UIViewController,
                isAnimated: Bool) {
        self.presentingViewController = presentingViewController
        self.presentedViewControllerFactory = presentedViewControllerFactory
        self.isAnimated = isAnimated
    }
    
    public func perform(prop: Prop, completion: Completion?) {
        guard let navigationController = presentingViewController.navigationController else {
            return assertionFailure("Navigation Controller is missing")
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.pushViewController(presentedViewControllerFactory(prop),
                                                animated: isAnimated)
        CATransaction.commit()
    }
}

// MARK: Pop

public final class NavigationPopTransition: Transitioning {
    public enum Option {
        case pop
        case toIndex(Int)
        case toViewController(UIViewController)
        case toRoot
    }
    
    private unowned let presentingViewController: UIViewController
    private let isAnimated: Bool
    private let option: Option
    
    public init(presentingViewController: UIViewController,
                isAnimated: Bool,
                option: Option) {
        self.presentingViewController = presentingViewController
        self.isAnimated = isAnimated
        self.option = option
    }
    
    public func perform(prop: Void, completion: Completion?) {
        guard let navigationController = presentingViewController.navigationController else {
            return assertionFailure("Navigation Controller is missing")
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        switch option {
        case .pop:
            navigationController.popViewController(animated: isAnimated)
        case let .toIndex(index):
            _ = navigationController.viewControllers
                .element(at: index)
                .map { navigationController.popToViewController($0, animated: isAnimated) }
        case let .toViewController(viewController):
            navigationController.popToViewController(viewController, animated: isAnimated)
        case .toRoot:
            navigationController.popToRootViewController(animated: isAnimated)
        }
        CATransaction.commit()
    }
}
