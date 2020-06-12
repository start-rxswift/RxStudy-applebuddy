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

// MARK: - merge operator

// - merge operator는 여러개의 옵저버블을 순서대로 방출하는 옵저버블을 리턴합니다.
// - merge는 concat과 동작방식이 상이합니다.
import RxSwift
import UIKit

// merge 연산자는 concat 연산자와는 동작방식이 다릅니다. 두개이상의 옵저버블을 병합하고 모든 옵저버블에서 방출하는 요소들을 순서대로 방출하는 옵저버블을 리턴합니다.
/*:
 # merge
 */

let bag = DisposeBag()

enum MyError: Error {
    case error
}

let oddNumbers = BehaviorSubject(value: 1)
let evenNumbers = BehaviorSubject(value: 2)
let negativeNumbers = BehaviorSubject(value: -1)

let source = Observable.of(oddNumbers, evenNumbers, negativeNumbers)

// * maxConcurrent 인자값으로 병합 제한을 둘 수도 있습니다. 병합 제한 수에는 제한이 없습니다.
// - merge에서 병합 제한을 2로 두었으므로 1, 2 두개의 next이벤트만 전달됩니다.
source
    .merge(maxConcurrent: 2)
    .subscribe { print($0) }
    .disposed(by: bag)

// - next 이벤트의 subject가 아닌, subject가 방출하는 항목이 저장되어 있습니다.
oddNumbers.onNext(3) // 3이 전달됩니다.
evenNumbers.onNext(4) // 4가 전달됩니다.

evenNumbers.onNext(6) // 6이 전달됩니다.
oddNumbers.onNext(5) // 5가 전달됩니다.

// - 병햡 제한을 초과한 경우에는 병합대상에서 제외하게 됩니다. 단, 이런 옵저버블을 큐에서 저장하고, 병합대상 중 하나라도 completed 이벤트를 전달하면 순서대로 병합대상으로 추가합니다.
// - 현재는 병합 큐가 가득찼으므로 아래의 negativeNumbers의 next이벤트는 전달되지 않고 대기합니다.
negativeNumbers.onNext(-2)

// - 병합 큐에 있던 oddNumbers가 completed 되었으므로 앞서 대기중이던 negativeNumbers subject가 oddNumber subject 대신 병합 제한 안에 들어가고, next이벤트가 방출됩니다.
//   - negativeNumber subject는 초기값이 있고, 가장 최신의 요소를 방출하는 behaviorSubject이므로 가장 최근에 방출한 -2를 구독자에게 전달합니다.
oddNumbers.onCompleted()

// * Not Completed Yet
negativeNumbers.onCompleted()

// - 만약 completed 이벤트가 구독자에게 전달되기 이전 병합 큐의 어떠한 Observable에서 error 이벤트가 발생했다면
//   -> 구독자에게 error이벤트를 전달하고 이후 더이상 어떠한 이벤트도 전달하지 않습니다.

evenNumbers.onError(MyError.error)
// - 병합 큐의 모든 이벤트가 completed되면 구독자에게 completed 이벤트가 전달됩니다.
evenNumbers.onCompleted()

// oddNumber가 completed 이벤트를 전달하면서 negativeNumber가 구독자에게 전달됩니다.

// onCompleted() 이벤트를 전달하면 더이상 새로운 이벤트를 받지 않습니다.
// oddNumbers.onCompleted()
// oddNumbers.onError(MyError.error)
//
// evenNumbers.onNext(8)
//
// evenNumbers.onCompleted()

// -> merge 연산자는 병합한 모든 Observable로 부터 completed 이벤트를 받은 다음 최종적으로 구독자에게 completed 이벤트가 전달됩니다. 그전까지는 계속해서 next 이벤트를 전달합니다.
