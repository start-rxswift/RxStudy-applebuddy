//
//  HelloRxCocoaViewController.swift
//  MasteringRxSwift
//
//  Created by Keun young Kim on 26/08/2019.
//  Copyright © 2019 Keun young Kim. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class HelloRxCocoaViewController: UIViewController {
    let bag = DisposeBag()

    @IBOutlet var valueLabel: UILabel!

    @IBOutlet var tapButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
