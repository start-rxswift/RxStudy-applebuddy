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

// Delegate패턴을 RxSwift 방식으로 확장하는 방법은 크게 두가지가 있습니다.
// 1) ControlEvent로 구현할 수 있다.
// 2) UIControl과 관련 없는 경우 DelegateProxy를 활용할 수 있습니다.

// - EditingDidEegin/End 이벤트를 처리하는 Control이벤트를 구현해보겠습니다.
import RxCocoa
import RxSwift
import UIKit

class CustomControlEventViewController: UIViewController {
    let bag = DisposeBag()

    @IBOutlet var inputField: UITextField!

    @IBOutlet var countLabel: UILabel!

    @IBOutlet var doneButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        inputField.borderStyle = .none
        inputField.layer.borderWidth = 3
        inputField.layer.borderColor = UIColor.gray.cgColor

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: inputField.frame.height))
        inputField.leftView = paddingView
        inputField.leftViewMode = .always

        // 텍스트필드의 입력값 길이에 따라 countLabel 텍스트에 길이를 표시하도록 countLabel.rx.text를 binding 처리한다.
        inputField.rx.text
            .map { $0?.count ?? 0 }
            .map { "\($0)" }
            .bind(to: countLabel.rx.text)
            .disposed(by: bag)

        doneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.inputField.resignFirstResponder()
            })
            .disposed(by: bag)

        // #1)
//        inputField.delegate = self

        // #2)
        // - 여기서 방출되는 속성을 borderColor에 전달해주어야합니다.
        // - 편집이 시작될때, 끝날때의 borderColor를 설정하도록 binding 처리합니다.
        inputField.rx.editingDidBegin
            .map { UIColor.red }
            .bind(to: inputField.rx.borderColor)
            .disposed(by: bag)

        inputField.rx.editingDidEnd
            .map { UIColor.gray }
            .bind(to: inputField.rx.borderColor)
            .disposed(by: bag)
    }
}

// #2
extension Reactive where Base: UITextField {
    var borderColor: Binder<UIColor?> {
        return Binder(base) { textField, color in
            textField.layer.borderColor = color?.cgColor
        }
    }

    var editingDidBegin: ControlEvent<Void> {
        return controlEvent(.editingDidBegin)
    }

    var editingDidEnd: ControlEvent<Void> {
        return controlEvent(.editingDidEnd)
    }
}

//// #1)
// extension CustomControlEventViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.layer.borderColor = UIColor.red.cgColor
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.layer.borderColor = UIColor.gray.cgColor
//    }
// }
