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

// MARK: - create operator

// - Observable이 동작하는 방식을 직접 구현하고 싶다면, create 연산자를 사용할 수 있습니다.
// - create 연산자는 Observable을 받아서 Disposable을 반환하는 클로져를 전달합니다.

import RxSwift
import UIKit

/*:
 # create
 */

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

Observable<String>.create { (observer) -> Disposable in

    // 먼저 간단한 url을 생성합니다.
    guard let url = URL(string: "https://www.badApple.com") else {
        // 정상적으로 URL을 얻지 못할 경우, error이벤트를 전달합니다.
        observer.onError(MyError.error)
        // Disposable리턴형일 경우 Disposables.create()를 사용하는 점 명심해야합니다.
        return Disposables.create()
    }

    guard let html = try? String(contentsOf: url, encoding: .utf8) else {
        // 문자열을 얻어오지 못한다면 아까와 동일하게 에러이벤트를 전달합니다.
        observer.onError(MyError.error)
        return Disposables.create()
    }

    // 문자열을 정상적으로 가져왔다면 문자열을 onNext로 전달해 방출합니다.
    observer.onNext(html)

    observer.onNext("After completed")

    // onCompleted 메서드를 호출하면 옵저버로 completed 이벤트가 전달됩니다.
    observer.onCompleted()

    // 이후, Disposables.craete()를 반환하면 모든 리소스가 정리되고, Observable이 정상적으로 종료됩니다.
    return Disposables.create()
}
.subscribe { print($0) }
.disposed(by: disposeBag)

// 이제 생성된 Observable을 구독해보겠습니다.
// 그러면 정상적으로 URL로부터 문자열을 흭득했을 경우 결과값이 출력되는 것을 볼 수 있습니다.
// 만약 정상적으로 결과를 얻지 못했다면 error 이벤트를 방출합니다.
