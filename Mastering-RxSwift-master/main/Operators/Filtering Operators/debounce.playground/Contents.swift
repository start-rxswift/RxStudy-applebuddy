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

// MARK: - debounce operator

// - debounce 연산자는 (dueTime, scheduler) 인자값을 받습니다.
//   - 첫 이벤트 방출 이후, 지정된 시간 값으로 타이머가 작동됩니다. 지정된 시간 내에 이벤트가 방출 되면 타이머를 초기화 하면 지정 시간 동안 다시 기다립니다.
//   - 지정된 시간 내에 이벤트가 없었다면 가장 최근의 이벤트를 방출 후 다시 타이머가 초기화됩니다.
// - debounce, throttle 연산자는 짧은 시간 반복적인 이벤트를 제어하는데 사용된다는 공통점이 있는 연산자입니다.
// - 하지만 연산의 결과는 둘 다 다르기 때문에 잘 구분해서 사용해야 합니다.
import RxSwift
import UIKit

/*:
 # debounce
 */

let disposeBag = DisposeBag()

let buttonTap = Observable<String>.create { observer in
    // 0.3초 주기로 이벤트를 방출합니다.
    // debounce를 사용하면 첫 이벤트 방출 후 타이머가 시작합니다.
    DispatchQueue.global().async {
        for i in 1 ... 10 {
            observer.onNext("Tap \(i)")
            Thread.sleep(forTimeInterval: 0.3)
        }

        // 1초 대기 후..
        // 이때 debounce를 1초로 지정했다면 가장 최근에 방출한 10 이벤트를 방출합니다. 이후 타이머는 초기화 됩니다.
        Thread.sleep(forTimeInterval: 1)

        // 0.5초 주기로 이벤트를 방출합니다.
        for i in 11 ... 20 {
            observer.onNext("Tap \(i)")
            Thread.sleep(forTimeInterval: 0.5)
        }

        observer.onCompleted()
    }

    return Disposables.create {}
}

buttonTap
    .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
