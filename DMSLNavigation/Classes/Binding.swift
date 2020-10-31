//
//  Binding.swift
//  DMSLNavigation
//
//  Created by Dmytro Shulzhenko on 31.10.2020.
//

import RxSwift
import RxCocoa

public extension UIViewController {
    func bindNavigation<T, Prop>(signal: Signal<Prop>,
                                 transition: T,
                                 bag: DisposeBag)
    where T: Transitioning,
          T.Prop == Prop {
        signal
            .emit(onNext: transition.perform)
            .disposed(by: bag)
    }
}

// MARK: - View Controller Based

public extension UIViewController {
    
    // MARK: Present
    
    func bindPresent<Prop>(presentedViewControllerFactory: @escaping (Prop) -> UIViewController,
                           signal: Signal<Prop>,
                           bag: DisposeBag,
                           isAnimated: Bool = true,
                           sourceViewPath: KeyPath<UIViewController, UIView>? = nil) {
        let transition = PresentTransition(presentingViewController: self,
                                           presentedViewControllerFactory: presentedViewControllerFactory,
                                           sourceViewPath: sourceViewPath,
                                           isAnimated: isAnimated)
        signal
            .emit(onNext: transition.perform)
            .disposed(by: bag)
    }
    
    // MARK: Dismiss
    
    func bindDismiss(signal: Signal<Void>,
                     bag: DisposeBag,
                     isAnimated: Bool = true,
                     option: DismissTransition.Option = .current) {
        let transition = DismissTransition(presentedViewController: self,
                                           isAnimated: isAnimated,
                                           option: option)
        signal
            .emit(onNext: transition.perform)
            .disposed(by: bag)
    }
}

// MARK: - Navigation Controller Based

public extension UIViewController {
    
    // MARK: Push
    
    func bindPush<Prop>(presentedViewControllerFactory: @escaping (Prop) -> UIViewController,
                        signal: Signal<Prop>,
                        bag: DisposeBag,
                        isAnimated: Bool = true) {
        let transition = NavigationPushTransition(presentingViewController: self,
                                                  presentedViewControllerFactory: presentedViewControllerFactory,
                                                  isAnimated: isAnimated)
        signal
            .emit(onNext: transition.perform)
            .disposed(by: bag)
    }
    
    // MARK: Pop
    
    func bindPop(signal: Signal<Void>,
                 bag: DisposeBag,
                 isAnimated: Bool = true,
                 option: NavigationPopTransition.Option = .pop) {
        let transition = NavigationPopTransition(presentingViewController: self,
                                                 isAnimated: isAnimated,
                                                 option: option)
        signal
            .emit(onNext: transition.perform)
            .disposed(by: bag)
    }
}
