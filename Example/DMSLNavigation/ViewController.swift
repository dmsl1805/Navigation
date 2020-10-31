//
//  ViewController.swift
//  DMSLNavigation
//
//  Created by dmsl1805 on 10/31/2020.
//  Copyright (c) 2020 dmsl1805. All rights reserved.
//

import UIKit
import RxSwift

final class ViewController: UIViewController {
    let bag = DisposeBag()
    
    @IBOutlet private (set) var dismissItem: UIBarButtonItem!
    @IBOutlet private (set) var dismissToRootItem: UIBarButtonItem!
    
    @IBOutlet private (set) var pushButton: UIButton!
    @IBOutlet private (set) var presentButton: UIButton!
}
