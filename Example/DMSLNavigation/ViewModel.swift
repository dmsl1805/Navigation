//
//  ViewModel.swift
//  DMSLNavigation_Example
//
//  Created by Dmytro Shulzhenko on 31.10.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import RxSwift
import RxCocoa

final class ViewModel: Disposable {
    struct Signals {
        let source: ViewModel
        
        var push: Signal<Void> { source.pushRelay.asSignal() }
        var present: Signal<Void> { source.presentRelay.asSignal() }
        var dismiss: Signal<Void> { source.dismissRelay.asSignal() }
        var dismissToRoot: Signal<Void> { source.dismissToRootRelay.asSignal() }
    }
    
    private let pushRelay = PublishRelay<Void>()
    private let presentRelay = PublishRelay<Void>()
    private let dismissRelay = PublishRelay<Void>()
    private let dismissToRootRelay = PublishRelay<Void>()

    var signals: Signals { Signals(source: self) }
    
    func push() { pushRelay.accept(()) }
    func present() { presentRelay.accept(()) }
    func dismiss() { dismissRelay.accept(()) }
    func dismissToRoot() { dismissToRootRelay.accept(()) }
    
    func dispose() { }
}
