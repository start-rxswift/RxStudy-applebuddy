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

// MARK: - throttle operator

// - throttle operator는 next이벤트가 전달 된 다음, 지정된 시간 동안 추가 next 이벤트가 전달 되지 않습니다. (지정된 주기 마다 하나씩 전달)
// - throttle operator는 (반복주기, latest(주로 기본값을 사용), scheduler) 의 인자값을 갖습니다.
// - throttle 연산자는 짧은 시간에 사용되는 버튼 탭, 델리게이트 이벤트 등에 중복 호출 방치를 위해 사용할 수 있습니다.
// - debounce 연산자는 검색 기능 등 검색이 끝난 뒤에만 검색기능을 실행하는 등의 구현에 유용하게 사용 될 수 있습니다.
import RxSwift
import UIKit

/*:
 # throttle
 */

let disposeBag = DisposeBag()

let buttonTap = Observable<String>.create { observer in
    // 0.3초 주기로 이벤트를 방춣 합니다.
    // throttle 연산자 사용 시, 이벤트 방출 후 1초 간에는 추가 이벤트를 방출하지 않습니다.
    DispatchQueue.global().async {
        for i in 1 ... 10 {
            observer.onNext("Tap \(i)")
            Thread.sleep(forTimeInterval: 0.3)
        }

        Thread.sleep(forTimeInterval: 1)

        for i in 11 ... 20 {
            observer.onNext("Tap \(i)")
            Thread.sleep(forTimeInterval: 0.5)
        }

        observer.onCompleted()
    }

    return Disposables.create()
}

buttonTap
    .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

func currentTimeString() -> String {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return f.string(from: Date())
}

// 2.5초 단위로 1 ~ 10 이벤트를 방출합니다. 이때 latest 인자값을 true로 주면, 방출 직후의 최신 이벤트를 방출합니다. (0 -> 2 -> 5 -> 7 -> 9)
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .debug()
    .take(10)
    .throttle(.milliseconds(2500), latest: true, scheduler: MainScheduler.instance)
    .subscribe { print(currentTimeString(), $0) }
    .disposed(by: disposeBag)

// - 만약 latest 값을 default or false값을 주면 0 -> 3 -> 6 -> 9의 이벤트가 전달됩니다.
// ★ latest = true 일경우, 방출 될 시기의 가장 최근 이벤트를 방출하는 반면, latest = false일 경우, 방출될 시기 이후 처음 방출되는 이벤트를 방출하기 때문입니다.
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .debug()
    .take(10)
    .throttle(.milliseconds(2500), latest: false, scheduler: MainScheduler.instance)
    .subscribe { print(currentTimeString(), $0) }
    .disposed(by: disposeBag)
//: [Next](@next)
