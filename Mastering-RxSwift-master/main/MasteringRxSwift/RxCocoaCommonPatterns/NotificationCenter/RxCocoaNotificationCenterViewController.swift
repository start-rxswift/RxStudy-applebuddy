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

// Notification이 전달되면 Noti객체가 저장된 Next 이벤트가 방출됩니다. 노티 추가, 삭제에 대한 코드가 기본적으로 구현되어져 CocoaTouch 코드에 비해 비교적 간결한 코드로 구현할 수 있습니다.
import RxCocoa
import RxSwift
import UIKit

class RxCocoaNotificationCenterViewController: UIViewController {
    let bag = DisposeBag()

    @IBOutlet var textView: UITextView!

    @IBOutlet var toggleButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        toggleButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                if self.textView.isFirstResponder {
                    self.textView.resignFirstResponder()
                } else {
                    self.textView.becomeFirstResponder()
                }
            })
            .disposed(by: bag)
        
        // map 연산자를 활용해 노티에 포함된 키보드 높이를 반환합니다.
        // hide Event, 하단 여백을 주기위한 Observable을 merge해서 처리합니다.
        let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 }
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { noti -> CGFloat in 0 }
        
        // 구독자에게 높이값이 전달되며 이제 맵 연산자로 높이값을 inset으로 변환하겠습니다.
        Observable.merge(willShowObservable, willHideObservable)
            .map { [unowned self] height -> UIEdgeInsets in
                var inset = self.textView.contentInset
                inset.bottom = height
                return inset
                // 마지막으로 구독자를 추가하고 전달될 inset을 반영하겠습니다.
        }
        .subscribe(onNext: { [weak self] inset in
            UIView.animate(withDuration: 0.1) {
                // 애니메이션 처리와 함께 inset을 변경
                self?.textView.contentInset = inset
            }
        })
        .disposed(by: bag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if textView.isFirstResponder {
            textView.resignFirstResponder()
        }
    }
}
