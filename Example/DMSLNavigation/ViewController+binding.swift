//
//  ViewController+binding.swift
//  DMSLNavigation_Example
//
//  Created by Dmytro Shulzhenko on 31.10.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import RxSwift
import RxViewController

// MARK: - Binding
 
// MARK: ViewModel

extension ViewController {
    private func bind(viewModel: ViewModel) {
        bag.insert(
            dismissItem.rx.tap.bind(onNext: viewModel.dismiss),
            dismissToRootItem.rx.tap.bind(onNext: viewModel.dismissToRoot),
            pushButton.rx.tap.bind(onNext: viewModel.push),
            presentButton.rx.tap.bind(onNext: viewModel.present)
        )
    }
}

// MARK: Root

extension ViewController {
    func bindAsRoot(viewModel: ViewModel) {
        rx.viewDidLoad.bind { [unowned self] in
            navigationItem.title = "Root"
            navigationItem.leftBarButtonItems = nil
            
            bind(viewModel: viewModel)
        }.disposed(by: bag)
    }
}

// MARK: Presented

extension ViewController {
    func bindAsPresented(viewModel: ViewModel) {
        rx.viewDidLoad.bind { [unowned self] in
            navigationItem.title = "Presented"
            
            bind(viewModel: viewModel)
        }.disposed(by: bag)
    }
}

// MARK: Pushed

extension ViewController {
    func bindAsPushed(viewModel: ViewModel) {
        rx.viewDidLoad.bind { [unowned self] in
            navigationItem.title = "Pushed"
            
            bind(viewModel: viewModel)
        }.disposed(by: bag)
    }
}
