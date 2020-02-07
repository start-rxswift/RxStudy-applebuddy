//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import RxCocoa
import RxSwift
import UIKit

class BindingRxCocoaViewController: UIViewController {
    @IBOutlet var valueLabel: UILabel!

    @IBOutlet var valueField: UITextField!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        valueLabel.text = ""
        valueField.becomeFirstResponder()
        
        // 메인스레드 동작방법 1)
//                 bind를 통해 rx UI를 메인스레드에서 간편하게 동작시킬 수 있다.
        valueField.rx.text
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 메인스레드 동작방법 2) DispatchQueue 사용
//        valueField.rx.text
//            .subscribe(onNext: { [weak self] str in
//                DispatchQueue.main.async {
//                    self?.valueLabel.text = str
//                }
//            })
//            .disposed(by: disposeBag)
                
                // 메인스레드 동작방법 3) observeOn의 사용
//                valueField.rx.text
//                    .observeOn(MainScheduler.instance)
//                    .subscribe(onNext: { [weak self] str in
//                        self?.valueLabel.text = str
//                    })
//                    .disposed(by: disposeBag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        valueField.resignFirstResponder()
    }
}
