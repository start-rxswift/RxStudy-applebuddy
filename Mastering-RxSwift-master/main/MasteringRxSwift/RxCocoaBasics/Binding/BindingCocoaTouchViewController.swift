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

// MARK: Control Event, Control Property

// Control Property 는 제네릭 구조체로 선언되어있다.
// Control Property는 특별한 옵저바블이자 특별한 옵저버이다.

/*
 public protocol ControlPropertyType: ObservableType, ObserverType {
 // ...
 }

 public struct ControlProperty<PropertyType> : ControlPropertyType {
 // ...
 }
 */

// - UI Control
//  - UI Control을 상속받는 UI들은 다양한 이벤트를 전달한다.
//
// - ControlEventType은 옵저버블역할만 수행하며, 옵저버로서의 역할은 수행하지 않는다.

import RxCocoa
import RxSwift
import UIKit

class BindingCocoaTouchViewController: UIViewController {
    @IBOutlet var valueLabel: UILabel!

    @IBOutlet var valueField: UITextField!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        valueLabel.text = ""
        valueLabel.textColor = .black
        valueField.delegate = self
        valueField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        valueField.resignFirstResponder()
    }
}

extension BindingCocoaTouchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {
            return true
        }

        let finalText = (currentText as NSString).replacingCharacters(in: range, with: string)
        valueLabel.text = finalText

        return true
    }
}
