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

// MARK: Driver

// - Driver는 데이터를 UI에 바인딩하는 직관적/효율적인 방법을 적용한다. 특별한 옵저버블이며, Error메세지를 전달하지않으며 항상 메인스레드에서만 처리된다.
// - 새로운 구독이 시작되면 가장 최근에 전달된 이벤트가 즉시 전달된다.

import RxCocoa
import RxSwift
import UIKit

enum ValidationError: Error {
    case notANumber
}

class DriverViewController: UIViewController {
    let bag = DisposeBag()

    @IBOutlet var inputField: UITextField!

    @IBOutlet var resultLabel: UILabel!

    @IBOutlet var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Driver 사용 예시)

        // 1) Driver 사용시 bind(to:) 대신 drive 메서드를 사용한다.
        // 2) asDriver, drive는 모든 작업이 메인스레드에서 실행되는것을 보장해주므로 이외 별도의 스케쥴러 명시를 해줄 필요가 없다.
        // 3) UI에 asDriver사용 시, Sequence를 공유하기 때문에
        // 4) Driver 사용 시, share() 연산자가 필요없으며, 불필요한 리소스 낭비를 차단해준다는 장점이 있다.
        let result = inputField.rx.text.asDriver()
            .flatMapLatest {
                validateText($0)
                    .asDriver(onErrorJustReturn: false)
            }

        // - result 값에 따라 OK or Error 의 문자열을 생성하고 Label에 바인딩한다.
        result
            .map { $0 ? "Ok" : "Error" }
            .drive(resultLabel.rx.text)
            .disposed(by: bag)

        // - result 값에 따라 빨강, 파랑색을 반환하고 이를 Label backgroundColor에 바인딩한다.
        result
            .map { $0 ? UIColor.blue : UIColor.red }
            .drive(resultLabel.rx.backgroundColor)
            .disposed(by: bag)

        // result 값을 sendButton의 활성화 상태와 바인딩한다. 3
        result
            .drive(sendButton.rx.isEnabled)
            .disposed(by: bag)

        // MARK: - Driver 미사용 예시)

        /*
         let result = inputField.rx.text
             .flatMapLatest { validateText($0)
                                .observeOn(MainScheduler.instance) // UI가 백그라운드 스레드에서 동작하는 잠재적 문제를 해결하기 위해 ObserveOn(MainInstance.instance)를 설정한다.
                                .catchErrorJustReturn(false) } // Error이벤트가 나도 크래시가 발생하지 않도록 설정한다.
             .share() // share() 연산자를 사용하면 모든 구독자가 하나의 Sequence를 공유한다.

         // result 값에 따라 OK or Error 의 문자열을 생성하고 Label에 바인딩한다.
         result
             .map { $0 ? "Ok" : "Error" }
             .bind(to: resultLabel.rx.text)
             .disposed(by: bag)

         // result 값에 따라 빨강, 파랑색을 반환하고 이를 Label backgroundColor에 바인딩한다.
         result
             .map { $0 ? UIColor.blue : UIColor.red }
             .bind(to: resultLabel.rx.backgroundColor)
             .disposed(by: bag)

         // result 값을 sendButton의 활성화 상태와 바인딩한다. 3
         result
             .bind(to: sendButton.rx.isEnabled)
             .disposed(by: bag)
         */
    }
}

// Optional String을 매개변수로 받아 새로운 옵저버블(Observable<Bool>)을 리턴한다.
func validateText(_ value: String?) -> Observable<Bool> {
    return Observable<Bool>.create { observer in
        print("== \(value ?? "") Sequence Start ==")

        defer {
            print("== \(value ?? "") Sequence End ==")
        }

        guard let str = value, let _ = Double(str) else {
            observer.onError(ValidationError.notANumber)
            return Disposables.create()
        }

        observer.onNext(true)
        observer.onCompleted()

        return Disposables.create()
    }
}
