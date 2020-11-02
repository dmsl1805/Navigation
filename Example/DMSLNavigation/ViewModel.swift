//
//  ViewModel.swift
//  DMSLNavigation_Example
//
//  Created by Dmytro Shulzhenko on 31.10.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import RxSwift
import RxCocoa
import DMSLNavigation

extension Signals where Source == ViewModel {
    var push: Signal<Void> { source.pushRelay.asSignal() }
    var present: Signal<Void> { source.presentRelay.asSignal() }
    var dismiss: Signal<Void> { source.dismissRelay.asSignal() }
    var dismissToRoot: Signal<Void> { source.dismissToRootRelay.asSignal() }
}

final class ViewModel: Disposable, SignalsSource {
    fileprivate let pushRelay = PublishRelay<Void>()
    fileprivate let presentRelay = PublishRelay<Void>()
    fileprivate let dismissRelay = PublishRelay<Void>()
    fileprivate let dismissToRootRelay = PublishRelay<Void>()
    
    func push() { pushRelay.accept(()) }
    func present() { presentRelay.accept(()) }
    func dismiss() { dismissRelay.accept(()) }
    func dismissToRoot() { dismissToRootRelay.accept(()) }
    
    func dispose() { }
}
