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

// MARK: - Sharing Subscription

// - 구독공유를 통해 불필요한 구독 이벤트 실행을 방지할 수 있습니다.

import RxSwift
import UIKit

/*:
 # Sharing Subscription
 */

let bag = DisposeBag()

let source = Observable<String>.create { observer in
    let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/string")!
    let task = URLSession.shared.dataTask(with: url) { data, _, _ in
        if let data = data, let html = String(data: data, encoding: .utf8) {
            observer.onNext(html)
        }

        observer.onCompleted()
    }
    task.resume()

    return Disposables.create {
        task.cancel()
    }
}
.debug() // 이벤트 연산 시점을 확인하기 위해 debug operator를 사용하고 있습니다.
.share() // 이때 sh

source.subscribe().disposed(by: bag)

// share() 연산자를 사용하지 않은 경우)
// 구독을 추가할때 구독 공유를 사용하지 않으면 항상 새로운 시퀀스가 시작 됩니다.
source.subscribe().disposed(by: bag)

// share() 연산자를 사용하지 않은 경우)
// 옵저버에 3개의 구독자가 추가되었고, 네트워크 요청도 3번 실행이 됩니다.
// -> 이렇게 되면 클라이언트, 서버 쪽에서 불필요한 리소스를 낭비하게 됩니다.
// * 이런 상황의 불필요한 리소스를 차단하기 위해서는 여러개의 중복 구독을 공유하는 구독 공유를 활용할 수 있습니다.

// share() 연산자를 사용한 경우)
source.subscribe().disposed(by: bag)
