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

// MARK: - Relay

// - PublishRelay는 PublishSubject를, BehaviorRelay는 BehaviorSubject를 래핑하고 있습니다.
// - Relay의 특징은 completed, error 이벤트 없이 next이벤트만 받고 전달한다는 것 입니다.
// - Relay는 completed, error이벤트는 전달받지도, 하지도 않습니다.
// - 또한 구독자로부터 disposed 되기전까지 계속 이벤트를 처리합니다. 그래서 주로 UI처리에 사용도됩니다.
// - Relay는 RxCocoa 프레임워크를 통해 제공됩니다.

import RxCocoa
import RxSwift
import UIKit

/*:
 # Relay
 */

let disposeBag = DisposeBag()

// - 먼저 PublishRelay를 만들어보겠습니다. 빈생성자로 생성하는 것은 PublishSubject와 동일합니다.
// - Relay에 next 이벤트를 전달할때는 accept 메서드를 사용합니다.
let prelay = PublishRelay<Int>()
prelay.subscribe { print("1: \($0)") }
    .disposed(by: disposeBag)

// 이렇게 accept를 통해 이벤트를 전달하면 구독자에게 이벤트가 전달됩니다.
prelay.accept(1)

// - 이번에는 BehaviorRelay를 만들어봅니다. BehaviorRelay는 BehaviorSubject와 같이 초기값을 받으며 생성됩니다.
let brelay = BehaviorRelay(value: 1)

// BehaviorRelay는 1 대신 새롭게 전달받은 이벤트, 2를 최신값으로 갖습니다.
brelay.accept(2)

// 그러면, 가장 최근의 next 이벤트가 구독자에게 전달됩니다.
brelay.subscribe { print("2: \($0)") }
    .disposed(by: disposeBag)

// BehaviorRelay는 이후 새로운 값을 전달받을 때마다 그 값을 구독자에게 전달합니다.
brelay.accept(3)

// 현재 BehaviorRelay에 저장된 최신값을 value를 통해 얻을 수 있습니다. 이 값은 읽기전용입니다.
// 현재 BehaviorRelay에 저장된 최신값을 바꾸려면 Relay의 next 전달 메서드는 accept를 통해 최신값을 갱신 및 현재 구독자들에게 갱신 된 최신 이벤트를 전달할 수 있습니다.
print(brelay.value)

brelay.accept(4)
brelay.accept(5)
