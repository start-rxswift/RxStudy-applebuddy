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

// MARK: - Interval : Operator

// - 일정 주기에 맞게 disposed 전까지 계속 방출을 진행한다.
//  - FixedWidthInteger 형식의 정수형 요소를 방출하는데 사용할 수 있다.
//  - 새로운 구독이 시작되면 타이머가 새로 시작된다.
// - 매개변수 : 반복주기, 방출에 사용할 스케쥴러
import RxSwift

// 1초마다 1씩 증가하는 요소를 방출한다.
let disposeBag = DisposeBag()
let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

let subscription = interval.subscribe { print("1 >> \($0)") }

// 비동기 방식으로 5초 뒤 구독을 disposed 처리하기 위한 코드
DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    subscription.dispose()
}

var subscription2: Disposable?

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    // 새로운 구독 시에는,
    subscription2 = interval.subscribe { print("2 >> \($0)") }
}

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    // 7 초 후 disposed 처리
    subscription2?.dispose()
}

///// MARK: - GroupBy : Operator
//// - 옵저버블이 방출하는 요소를 원하는 기준에 따라 그룹핑 하고자 할때 사용한다.
//// - 주로 toArray, flatMap 등을 이용해 그룹핑 된 옵저바블을 하나의 배열로 만들어 사용하곤 한다.
// import RxSwift
//
// let disposeBag = DisposeBag()
// let words = ["apple", "Banana", "Orange", "Cucumber", "WaterMelon", "Peach"]
//
//// 문자열 길이를 기준으로 groupBy를 사용 시, 문자열 길이에 따른 옵저버블 목록이 콘솔에 출력한다.
////Observable.from(words)
////    .groupBy { $0.count }
////    .subscribe(onNext: { groupedObservable in
////        // 문자열 길이에 따라 그룹핑 된 키값, 정보를 콘솔에 출력한다.
////        print("== \(groupedObservable.key)")
////        groupedObservable.subscribe { print(" \($0)") }
////    })
////    .disposed(by: disposeBag)
//
//// MARK: - flatMap, toArray의 사용
//// - flatMap, toArray를 사용해 문자열 길이 기준으로 그룹핑 된 요소의 값을 출력한다.
// Observable.from(words)
//    .groupBy { $0.count }
//    .flatMap { $0.toArray() }
//    .subscribe {print($0) }
//    .disposed(by: disposeBag)
//
//// * 첫번째 문자를 기준으로 그룹핑 한 상태
// Observable.from(words)
// .groupBy { $0.first ?? Character(" ") }
// .flatMap { $0.toArray() }
// .subscribe {print($0) }
// .disposed(by: disposeBag)
