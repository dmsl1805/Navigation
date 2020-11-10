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
    
    func perform(prop: Prop)
}

public extension Transitioning where Prop == Void {
    func perform() {
        perform(prop: ())
    }
}

// MARK: - View Controller Based

// MARK: Present

public final class PresentTransition<Prop, ViewController>: Transitioning where ViewController: UIViewController {
    private unowned let presentingViewController: ViewController
    private let presentedViewControllerFactory: (Prop) -> UIViewController
    private let sourceViewPath: KeyPath<ViewController, UIView>?
    private let isAnimated: Bool
    private let completion: Completion?

    public init(presentingViewController: ViewController,
                presentedViewControllerFactory: @escaping (Prop) -> UIViewController,
                sourceViewPath: KeyPath<ViewController, UIView>?,
                isAnimated: Bool,
                completion: Completion?) {
        self.presentingViewController = presentingViewController
        self.presentedViewControllerFactory = presentedViewControllerFactory
        self.sourceViewPath = sourceViewPath
        self.isAnimated = isAnimated
        self.completion = completion
    }
    
    public func perform(prop: Prop) {
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
    private let completion: Completion?

    public init(presentedViewController: UIViewController,
                isAnimated: Bool,
                option: Option,
                completion: Completion?) {
        self.presentedViewController = presentedViewController
        self.isAnimated = isAnimated
        self.option = option
        self.completion = completion
    }
    
    public func perform(prop: Void) {
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
    private let completion: Completion?

    public init(presentingViewController: UIViewController,
                presentedViewControllerFactory: @escaping (Prop) -> UIViewController,
                isAnimated: Bool,
                completion: Completion?) {
        self.presentingViewController = presentingViewController
        self.presentedViewControllerFactory = presentedViewControllerFactory
        self.isAnimated = isAnimated
        self.completion = completion
    }
    
    public func perform(prop: Prop) {
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
    private let completion: Completion?

    public init(presentingViewController: UIViewController,
                isAnimated: Bool,
                option: Option,
                completion: Completion?) {
        self.presentingViewController = presentingViewController
        self.isAnimated = isAnimated
        self.option = option
        self.completion = completion
    }
    
    public func perform(prop: Void) {
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
