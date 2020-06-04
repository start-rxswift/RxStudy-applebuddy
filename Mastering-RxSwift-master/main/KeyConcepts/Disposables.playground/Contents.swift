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

import RxSwift
import UIKit

/*:
 # Disposables
 */

// - Disposed는 옵저버블이 전달하는 이벤트는 아닙니다.
// parameter로 closure를 전달하면, Observable과 관련된 모든 리소스가 제거된 후에 호출됩니다.

/*
 Observable.from([1, 2, 3])
 .subscribe(onNext: { element in
     print("Next", element)
 }, onError: { error in
     print("Error", error)
 }, onCompleted: {
     print("Completed")
 }, onDisposed: {
     print("Disposed")
 })

 // 결과는 next, completed disposed 순으로 출력됩니다.
 */

/*
 Observable.from([1, 2, 3])
 .subscribe {
     print($0)
 }

 // 두번째 경우에는 disposed 출력이 안되었는데 그럼 리소스가 해제된게 아닐까요? completed, error 이벤트가 전달되면 자동으로 관련 리소스가 해제됩니다. 그러므로 두번째에서도 리소스가 해제됩니다.
 // 앞서 말했듯이 Disposed는 Observable이 전달하는 이벤트가 아닙니다. 앞서 onDisposed의 클로저를 통해 출력한 것은 단지 Disposed가 호출되는 시점에 출력을 한 것 뿐입니다.
 // * RxSwift 문서에는 리소스 정리를 신경쓸 것을 얘기합니다. 이때 사용할 수 있는 것이 Disposable입니다.
 */

// 1) Disposable이 리소스 해제에 사용되는 경우
/*
 let subscription = Observable.from([1, 2, 3])
 .subscribe(onNext: { element in
     print("Next", element)
 }, onError: { error in
     print("Error", error)
 }, onCompleted: {
     print("Completed")
 }, onDisposed: {
     print("Disposed")
 })

 // 아래와 같이 리소스를 해제할 수 있지만 더 나은 방법이있습니다.
 // 더 좋은 방법으로는 disposeBag을 사용하는 방법이 있습니다. disposeBag을 만드는 방법은 단순합니다.
 subscription.dispose()

 var bag = DisposeBag()

 Observable.from([1, 2, 3])
 .subscribe {
     print($0)
 }
 .disposed(by: disposeBag)
 // 위와 같이 parameter로 disposeBag을 전달하면, subscribe가 리턴하는 disposable이 disposeBag에 추가됩니다. disposeBag에 추가되는 disposable은 disposeBag이 해제되는 시점에 함게 해제됩니다. ARC의 autoReleasePool과 비슷한 역할이라 보면 됩니다.
 // 원하는 시점에 disposeBag을 해제하고 싶다면 아래와 같이 작성하면 됩니다. 그렇게 되면 지금까지 disposeBag에 쌓인 리소스가 한꺼번에 해제됩니다.
 disposeBag = DisposeBag()
 */

// 2) Disposable이 실행 취소에 사용되는 경우
let subscription2 = Observable<Int>.interval(.seconds(1),
                                             scheduler: MainScheduler.instance)
    .subscribe(onNext: { element in
        print("Next", element)
    }, onError: { error in
        print("Error", error)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed")
    })

// 1씩 증가하는 정수를 1초 간격으로 방출합니다. 이는 중단없이 반복되는데, 이때 방출을 중단할 수단이 disposed 메서드입니다. disposed 메서드를 호출하겠습니다.

// 아래 코드는 비동기로 작동하여 3초가 지나면 dispose()메서드를 실행해 모든 리소스를 해제합니다.
// 단, dispose() 를 사용하면 completed 이벤트가 전달되지 않습니다. 그러므로, dispose메서드의 사용은 가급적 지양해야 좋습니다.
DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    subscription2.dispose()
}

// Next 0, 1, 2 -> Disposed 출력
