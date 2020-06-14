

<br>
<br>

# Operator, 연산자

- RxSwift에서 자주 사용 되는 연산자(Operator)
- RxSwift가 제공하는 여러가지 타입 중, ObservableType Protocol이 있다 
  - RxSwift의 근간을 이루는 여러가지 기능이 담겨 있는데 이들을 Operator, 연산자라 한다. 

<br>

## 연산자의 특징

- 대부분의연산자는 Observable상에서 동작하며, Observable을 리턴한다. 
- Observable을 리턴하기 때문의 두개 이상의 다수의 Operator를 동시에 사용할 수 있다. 

~~~ swift
/// MARK: - 연산자의 사용 예시
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

// Operator 중 하나인 take(N)는 Observable이 방출하는 요소 중에서 처음부터 N개의 요소만 전달해주는 연산자이다.
// Operator 중 하나인 filter는 특정 요건을 충족한 요소만 필터링하여 전달해주는 연산자이다.
// 아래 코드는 take(N), filter Operator를 사용하여 1~5번째 까지의 요소 중 2의 배수만 필터링하여 전달해주는 과정이다.
Observable.from([1,2,3,4,5,6,7,8,9])
.take(5)
    .filter { $0.isMultiple(of: 2) }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 위에서 사용한 take, filter 연산자 처럼 연산자를 필요에 따라 불여서 다수 사용이 가능하다.
// * 단, 연산자의 실행 순서에 따라 결과가 달라질 수 있음에 주의해야 한다.
~~~

<br>
<br>

## RxSwift 연산자 별 특징 요약정리
- RxSwift Operator 요약 기록
  - craete(Observable 동작방식 설정)
  - just(요소그대로), of(여러요소그대로), from(배열요소차례대로)
  - range(1…10), generate(for문대체)
  - take(첨부터 지정갯수만큼만 방출)
  - repeatElement(반복 방출)
  - deferred(특정 조건에 따른 Observable 생성)
  - empty(completed 이벤트 전달 옵저버블 방출), error(error 이벤트 전달 옵저버블 방출)
  - ignoreElements(error,completed만전달, next 이벤트 상관없이 결과만 확인하고 싶을때 사용)
  - skip(정수를 받아 지정 갯수만큼 무시후의 요소 방출)
  - skipWhile(클로져받아 true리턴하는 동안 방출되는 요소를 무시, false 이후 요소 방출)
  - skipUntil(trigger역할의 Observable을 인자로받아, trigger 방출 전까지의 원본 옵저버블 방출 요소 무시)
  - take(정수를 받아 지정 갯수만큼 요소를 방출)
  - takeWhile(클로져를 받아 클로져가 true 리턴하는 동안 요소를 방출)
  - takeUntil(trigger Observable의 이벤트 방출전까지 원본 Observable에서 요소를 방출)
  - takeLast(정수를 받아 지정 갯구 만큼의 최신 요소를 저장 및 대기, completed 시 요소방출 / error 시 error만 방출)
  - elementAt(정수를 인자로 받아 특정 인덱스요소만 방출)
  - debounce : 첫 이벤트 후 타이머 발동, 지정 주기동안 이벤트가 발생하면 타이머 초기화, 발생 없어도 타이머 초기화(실시간 검색기능)
  - throttle : 첫 이벤트 후 지정 주기동안 이벤트 무시, latest 값에 따라 방출 이벤트 차이, (단기간의 버튼텝/델리게이트 이벤트 중복방지 처리)
  - combineLatest : 이벤트 발생 시마다 가장 최근의 이벤트로 엮기
  - zip : 같은 순서로 발생한 옵저버블끼리 엮기
  - withLatestFrom : trigger, (인자)data subject -> data subject 이벤트 후 trigger 이벤트 시 data의 최신 이벤트 구독자 전달 + completed 시 data 최신이벤트 구독자 전달
  - sample : data, (인자)trigger subject -> trigger data subject 이벤트 후 trigger 이벤트 시 단 한번 data 최신 이벤트 구독자 전달 + completed시 completed 만 구독자 전달
  - switchLatest : 가장 최근 구독한 옵저버블이 방출하는 최신이벤트를 구독자 전달, completed는 원본 옵저버블이 받을때 구독자 전달, error는 최근 구독한 옵저버블에서 발생시에도 구독자 전달
  - interval operator : 특정 주기 이벤트 방출, 구독 시점마다 timer 시작
  - timer : (지연시간, 반복주기, 스케쥴러), 주기적으로 이벤트 방출
  - timeout : (주기, other, 스케쥴러), 주기 간 이벤트 미발생 시 error, other 지정 시 other 실행 후 completed
  - delay : 방출한 next 이벤트의 전달 시점을 지연
  - delaySubscription : 구독 시점을 지연, 이후 next 이벤트는 지연시키지 않습니다. 
  
<br>
<br>

## 연산자 종류 

### just 

  - 하나의 항목을 방출하는 Observable을 생성 

~~~ swift
// Operator, just 사용 예시
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let element = "😃"

// element 항목을 방출하는 Observable 생성
Observable.just(element)
  .subscribe { event in print(event) }
  .disposed(by: disposeBag)
// 출력 예시)
// next(😃) 
// completed

Observable.just([1,2,3])
.subscribe { event in print(event) }
.disposed(by: disposeBag)
// 출력 예시)
// next([1,2,3])
// completed
~~~

<br>

- of

  - 배열을 차례대로 방출하는 Observable 생성

~~~ swift
import RxSwift
Observable.if(1, 2, 3) 
.subscribe { element in print(element) }
.disposed(by: disposeBag)
// 출력 예시)
// next(1)
// next(3)
// next(3)
// completed
~~~

    
<br>
  

### from

  - 배열에 포함된 요소를 하나씩 순서대로 방출하는 Observable 생성 

~~~ swift
import RxSwift

let arr = [1,2,3]
Observable.from(arr)
.subscribe { element in print(element) }
.disposed(by: disposeBag)
// 출력 예시)
// next(1)
// next(2)
// next(3)
// completed
~~~

<br>

### single
- 원본 요소 중 첫번째 요소만 방출, 하나의 요소만 방출하는 것을 보장한다. 
  - 만약 하나 이상이 요소를 방출하려 할 시 Error 이벤트 발생
- void / predicate(조건부 클로저) 형태의 사용이 가능하다. 
- predicate 방식으로 조건부 설정 시 sequence 요소들 중 해당 조건이 단 하나일 경우 이상없이 방출이 진행된다. 
- 0개 혹은 두개 이상의 요소를 single을 사용해 방출하려할 시 Error 이벤트 발생

~~~ swift 
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let numbers = [1,2,3,4,5,6,7,8,9,10]

// single() 앞에 하나의 요소, 1만 있으므로 문제없이 하나의 요소 1을 방출한다.
Observable.just(1)
    .single()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 2개 이상의 요소가 있을 경우 error 이벤트가 발생한다.
Observable.from(numbers)
    .single() // 2개이상의 sequence에 single() 사용 시 에러발생 "Sequence contains more than one element."
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// single 연산자에 predicate 방식의 조건을 두어 해당 조건에 맞는 요소가 단 하나일 경우 문제없이 방출한다.
Observable.from(numbers)
    .single { $0 == 5 }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// subject에 사용할 경우, 하나의 요소만 방출되어야 문제없이 completed이벤트를 발생한다.
let subject = PublishSubject<Int>()

subject.single()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(100)
//subject.onNext(80) // "Sequence contains more than one element."
subject.onCompleted()
~~~

<br>

### range

  -  range(start: 1, count: 10) -> 1부터 시작에서 1씩 증가한 정수가 방출 된 뒤 complted 이벤트가 전달

  -  range는 특정 값으로부터 증가시키면 특정 반복 방출을 실행하나 중간에 증가된 크기를 바꾸거나 감소하는 시퀀스는 생성 불가

    - -> 이때는 대신 generate 를 사용한다.

~~~swift
import RxSwift
import RxCocoa
let disposebag = DisposeBag()
// 1 ... 10 의 Int 값 방출
Observable.range(start: 1, count: 10)
.subscribe { print($0) }
.dispoesd(by: disposeBag)
~~~

<br>

### generate 

  - range 보다 세부적인 sequence tasking 작업이 가능

  - 세부적인 작업을 위한 parameter가 존재 

    - initialState : 시작값을 전달
    - condition : true르 리턴할때만 방출 아니면 complted 이벤트를 전달 및 종료
    - scheduler: scheduler 설정
    - iterate : 보통 값을 증가, 감소 시키는 등의 코드를 전달

~~~swift
import RxSwift
import RxCocoa
import UIKit

let disposeBag = DisposeBag()
let red = "🍎"
let blue = "🥶"

Observable.generate(initialState: 10, condition: { $0 >= 0 }, iterate: { $0 - 2 })
    .subscribe { print($0) }
    .disposed(by: disposeBag)

Observable.generate(initialState: red, condition: { $0.count < 15 }, iterate: { $0.count.isMultiple(of: 2) ? $0+red : $0+blue})
    .subscribe { print($0) }
    .disposed(by: disposeBag)
~~~

<br>

### defered

  - 특정 조건에 따라 Observable을 생성할 수 있게 해주는 Operator

  - deferred 연산자를 사용하면 특정조건 (Condition)에 따라 Observable을 생성 시킬 수 있다.

~~~swift
/// MARK: - Deferred
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let poker = ["❤️", "♦️", "♠️", "☘️"]
let emoji = ["😃", "😂", "🎃", "💀"]
var flag = true

// 문자열을 방출하는 Observable, factory
let factory: Observable<String> = Observable.deferred {
    flag.toggle() // toggle() 실행으로 true -> false로 flag값 변환

    if flag {
        return Observable.from(poker)
    } else { // flag == false로 emoji String이 순차적으로 from operator에 의해 방출
        return Observable.from(emoji)
    }
}

factory
    .subscribe { print($0) }
    .disposed(by: disposeBag)
~~~

<br>    

### create

  - create 연산자는 사용 할 Observable의 동작을 직접 구현하고자 할 때 사용할 수 있다.

~~~swift
/// MARK: - Operator; Craete
//  - create 연산자는 Observable의 동작을 직접 구현하고자 할 때 사용할 수 있다.
import UIKit
import RxSwift

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

// Obervable을 파라미터로 받아서 disposable을 반환하는 클로져를 전달
Observable<String>.create { (observer) -> Disposable in
    guard let url = URL(string: "https://www.apple.com") else {
        // Error 발생 시 Error이벤트를 전달하고 종료 -> error(error)
        observer.onError(MyError.error) // 구독자에게 Error가 전달
        // * Disposable.craete()가 아닌 Disposables.create()로 사용해야 한다.
        return Disposables.create()
    }
    // url을 접근한 뒤 html을 가져와 문자열을 저장한다.
    guard let html = try? String(contentsOf: url, encoding: .utf8) else {
        // Error 발생 시 Error이벤트를 전달하고 종료 -> error(error)
        observer.onError(MyError.error)
        return Disposables.create()
    }

    // 문자열 생성이 정상적으로 진행되었다면, 해당 Observable을 방출
    observer.onNext(html)
    observer.onNext("Will Be Completed")
    observer.onCompleted()

    // ✭ Observable은 error, completed이벤트를 전달한 뒤엔 더이상 이벤트를 전달하지 않는다.
    // Observable을 영원히 실행할 목적이 아니라면, onError, onComplted 둘 중 하나는 꼭 처리해주어 Observable의 동작이 종료될 수 있도록 해야 한다.
    observer.onNext("After Completed")
    return Disposables.create()
}
    .subscribe { print($0) }
    .disposed(by: disposeBag)

~~~

<br>

### empty 

  - 어떠한 요소도 방출하지 않는 Operator
  - 어떠한 동작도 진행않고 종료하고자 할 때 사용할 수 있다. 

  ~~~ swift
  /// MARK: - Empty, Error
  //  - 어떠한 요소도 방출하지 않는 Operator, Empty/Error
  
  import UIKit
  import RxSwift
  
  let disposeBag = DisposeBag()
  
  /// MARK: empty
  //  - 요소의 형식은 중요하지 않다. 요소를 방출하지 않기 때문이다.
  //  - 옵저버가 아무런 동작없이 종료해야할 때 사용할 수 있다.
  Observable<Void>.empty()
      .subscribe { print($0) }
      .disposed(by: disposedBag)
  ~~~

<br>


### error

  - 지정한 Error 이벤트를 전달하고 종료하는 Observable을 생성한다.
  - Error처리를 할때 사용한다.

  ~~~swift
  /// MARK: - Operator; Error
  import UIKit
  import RxSwift
  
  let disposeBag = DisposeBag()
  
  enum MyError: Error {
      case error
  }
  
  // - error이벤트를 전달하고 종료하는 Observable을 생성한다.
  // - Error처리를 할때 사용한다.
  Observable<Void>.error(MyError.error)
      .subscribe {. rint($0) }
      .disposed(by: disposeBag)
  // 해당 Observable은 error 이벤트가 전달되고 종료된다.
  
  ~~~

<br>
  
### ignoreElement
  - traits중 하나인 Completable을 반환하는 Operator
  - Completable은 completed, error 와 같은 실패/성공에만 관심있음. next이벤트는 무시하는 놈임.
~~~ swift 
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let fruits = ["apple", "grape", "orange", "staawberry", "banana"]

Observable.from(fruits)
.ignoreElements() // .ignoreElements 연산자의 사용으로, 하단의 출력이 안됨. -> "completed"만 출력 됨
.subscribe { print($0) }
.disposed(by: disposeBag)    
~~~
    
<br>
    
### elementAt 
  - 특정 인덱스의 요소를 방출해주는 Operator
~~~ swift 
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let fruits = ["apple", "grape", "orange", "staawberry", "banana"]

Observable.from(fruits)
    .elementAt(1) // 특정 인덱스의 요소만 방출 후(1 인덱스의 grape 방출), completed 이벤트가 전달된다.
    .subscribe { print($0) }
    .disposed(by: disposeBag)
~~~

<br>

### filter Operator
  - filter 클로저 내 조건을 충족한 경우의 요소만 방출한다. 아래의 경우 2의 배수만 방출한다.
~~~ swift
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let numbers = [1,2,3,4,5,6,7,8,9,10]

// filter 클로저 내 조건을 충족한 경우의 요소만 방출한다. 아래의 경우 2의 배수만 방출한다.
Observable.from(numbers)
    .filter { $0.isMultiple(of: 2) } 
    .subscribe { print($0) }
    .disposed(by: disposeBag)
~~~

### skip
  - 지정한 수만큼의 요소를 무시하고 그 이후의 요소를 방출하는 Operator
~~~ swift 
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let numbers = [1,2,3,4,5,6,7,8,9,0]

// MARK: skip operator
// - 지정된 수만큼 무시, 이후의 요소만 방출하는 Operator
Observable.from(numbers)
    .skip(3) // 처음 세개의 요소는 무시하고 4부터 방출
    .subscribe { print($0) }
    .disposed(by: dispos
~~~

<br>

### skipWhile
  - 클로져를 매개변수로 받아 클로저 내 true 리턴 후부터 요소를 방출
~~~ swift
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let numbers = [1,2,3,4,5,6,7,8,9,0]


// MARK: skipWhile
// - 클로져를 매개변수로 받음, 클로저 내 true 리턴 후부터 방출
Observable.from(numbers)
    .skipWhile { !$0.isMultiple(of: 2)} // 2의 배수인 2가 나와 true가 되는 시점부터 방출을 시작한다. 한번의 true 이후에는 조건판별에 상관없이 계속 방출한다.
    .subscribe { print($0) }
    .disposed(by: disposeBag)
~~~

<br>

### skipUntil
  - 다른 Observable을 매개변수로 받는 Operator
  - 매개변수로 받은 Observable이 next 이벤트를 전달하기 전 까지 원본 Observable이 전달하는 이벤트를 무시한다.
    - 이러한 skipUntil Operator의 특성때문에 매개변수로 전달받은 Observable을 trigger라고도 부른다.
~~~ swift
import UIKit
import RxSwift

let disposeBag = DisposeBag()
/// MARK: - skipUntil
//  - 다른 Observable을 매개변수로 받음
//  - 매개변수로 받은 Observable이 next 이벤트를 전달하기 전 까지 원본 Observable이 전달하는 이벤트를 무시한다.
//.   - 이러한 특성때문에 매개변수로 전달받은 Observable을 trigger라고도 부른다.
let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()
subject.skipUntil(trigger)
    .subscribe { print($0) }
.disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(2)
trigger.onNext(0) // 트리거 옵저바블이 next 이벤트를 수행한 뒤에야
subject.onNext(3) // 원본 옵저바블의 next이벤트가 효력을 발휘한다.
~~~

<br>

### take
  - 처음 지정한 갯수만큼 요소를 방출, 이후의 요소는 무시하는 Operator
  - next 이벤트를 제외한 completed, error 이벤트에는 영향을 주지 않는다.
~~~ swift 
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let numbers = [1,2,3,4,5,6,7,8,9,10]

Observable.from(numbers)
    .take(5) // 처음 5개의 요소만 방출
    .subscribe { print($0) }
    .disposed(by: disposeBag)
~~~

<br>

### takeWhile
  - 매개변수로 클로져를 받는다. 
  - 매개변수 클로져 내 조건이 성립하는 동안 방출한다.
  - 만약 조건이 false가 반환되면 이후에는 조건여하에 상관없이 방출을 하지 않는다. 
~~~ swift 
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let numbers = [1,2,3,4,5,6,7,8,9,10]

Observable.from(numbers)
    .takeWhile { !$0.isMultiple(of: 2)} // false반환이 된 이후에는 어떠한것도 방출하지 않는다.
    .subscribe { print($0) }
    .disposed(by: disposeBag)
~~~

<br>

### takeUntil
  - 다른 Observable을 매개변수로 받는다. 
  - 매개변수 Observable(trigger)가 next 이벤트를 실행하기 전까지 요소를 방출한다. 
  - Observable(trigger)가 next이벤트 실행 시 completed 이벤트를 호출하고, 더이상 요소를 방출하지 않는다. 
~~~ swift 
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let numbers = [1,2,3,4,5,6,7,8,9,10]

//  원본 subject, trigger용 subject를 생성한다.
let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject.takeUntil(trigger)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 매개변수로 받은 trigger Observable이 onNext 이벤트를 실행하기 전까지 원본 Observable은 next이벤트가 실행된다.
subject.onNext(1)
subject.onNext(2)

// trigger의 onNext 실행하면 원본 Observable은 completed이벤트를 호출하고, 더이상 요소를 방출하지 않는다.
trigger.onNext(0) // 원본 subject의 completed 이벤트 발생
subject.onNext(3) // 3은 방출하지 않는다.
~~~

<br>

### takeLast
  - 정수를 매개변수로 받아 Observable을 받환한다. 
  - 마지막 값들 중 매개변수 정수값 만큼의 값을 버퍼에 저장 후 방출을 지연한다.
    - 방출은 해당 subject가 completed 이벤트를 발생할 때 진행 된다. 
  - Error 발생 시 버퍼에 저장되었던 요소는 방출되지 않는다. 
~~~ swift 
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let numbers = [1,2,3,4,5,6,7,8,9,10]

/// MARK: takeLast
//  - 정수를 매개변수로 받아 Observable을 반환한다.
//. - 구독자로 전달되는 시점이 completed 이벤트 발생 시점까지 지연된다.
let subject = PublishSubject<Int>()
subject.takeLast(3) // 가장 마지막의 3개의 요소를 버퍼에 저장한다.
    .subscribe { print($0) }
    .disposed(by: disposeBag)

numbers.forEach { subject.onNext($0) }
subject.onNext(11)

// takeLast로 저자한 3개의 요소는 방출이 지연되었다가 onCompleted 메서드 실행 시 방출된다.
subject.onCompleted()

enum MyError: Error {
    case error
}
// takeLast로 저장한 요소는 Error 이벤트 발생 시 방출되지 않는다.
subject.onError(MyError.error)
~~~

<br>

### distinctUntilChanged
  - 동일한 항목이 연속적으로 방출하지 않도록 하는 Operator
~~~ swift
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let numbers = [1,1,3,3,5,6,7,7,7,10]

Observable.from(numbers)
    .distinctUntilChanged() // 동일한 값의 연속적 값을 방지함
    .subscribe { print($0) } // 1,3,5,6,7,10 출력
    .disposed(by: disposeBag)
~~~

<br>

### debounce
- 두개의 매개변수를 받는다.(RxTimeInterval, SchedulerType)
- next 이벤트 이후 지정 시간 내에 방출이 이루어지ㅣ면 다시 타이머를 초기화, 지정 시간 동안 다시 기다린다. 
- 지정 시간(RxTimeInterval) 동안 next이벤트가 발생하지 않으면, 현재까지 받은 요소 중 가장 최신 값을 구독자에게 전달한다. 
- **사용자의 문자열 입력 기능 구현 시 유용하게 사용 가능하다**
  - 사용자의 연속 입력 등의 이벤트 중 불필요한 검색 정보 요충을 처단할 수 있다. 
  
<br>

### throttle
- 3개의 매개변수를 받으며 이중 매개변수 하나(latest)는 안받으면 default값(true)으로 설정된다. 
- throttle 매개변수 : (RxTimeInterval, latest: Bool, Scheduler)
- latest값의 default값은 별도로 지정하지 않을 시, true로 설정된다. 
  - true 설정 시) 지정 된 주기 간격 기준, 가장 최근에 방출한 next 이벤트를 구독자에게 전달한다. 
  - false 설정 시) 지정 된 주기 간격 주기 종료 직후 가장 처음으로 발생하는 next 이벤트를 구독자에게 전달한다.
  
<br>

### toArray
- 별도의 매개변수 x, Single 타입을 반환하는 연산자
- completed 이벤트 전까지 next 이벤트들을 방출하지 않음
- completed 이벤트가 발생하면 지금까지의 next 이벤트 요소들을 한 배열에 담아 방출함
~~~ swift 
/// MARK: - toArray; Operator
//  - 특별한 매개변수를 받지않으며 Single을 반환하는 연산자
import UIKit
import RxSwift

let disposeBag = DisposeBag()
let numbers = [1,2,3,4,5,6,7,8,9,0]

let subject = PublishSubject<Int>()

subject
.toArray()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// completed 이벤트 전까지 요소는 구독자에게 전달되지 않음
subject.onNext(1)
subject.onNext(2)
// completed 이벤트가 실행되고 나서 그동안의 요소를 배열에 담아 방출함
// [1,2]
subject.onCompleted()
~~~

<br>

### map
- 클로져를 매개변수로 받아 Observable값들을 순차적으로 맵핑한다. 
~~~ swift
/// MARK: - map; Operator
// 클로저를 파라미터로 받는 연산자
// Observable 요소의 값들을 맵핑해주는 연산자.
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()
let skills = ["Swift", "SwiftUI", "RxSwift"]

Observable.from(skills)
    .map { "Hello, \($0)" }
    .subscribe { print($0) }
    .disposed(by: disposeBag)
~~~

<br>

### flatMap
- Observable 값을 맵핑하여 하나의 Observable 스트림을 반환하는 연산자 
- 변환된 Observable은 값이 갱신될때마다 그 항목을 구독자에게 전달한다. 

~~~ swift 
/// MARK: - flatMap; Operator
// 마블을 맵핑하여 Observable 스트림형태로 반환하는 연산자

import RxSwift
import RxCocoa

let disposeBag = DisposeBag()
let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

let subject = PublishSubject<BehaviorSubject<Int>>()

subject // flatMap으로 맵핑 된 새로운 Observable은 항목이 업데이트 될 때마다 새로운 항목을 방출한다.
    .flatMap { $0.asObservable() }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(a)
subject.onNext(b)
b.onNext(22) // Observable 항목이 최신화 되며 구독자에게 새로운 항목이 전달 된다.
~~~

<br>

### flatMapFirst / flatMapLatest
- flatMap 연산자와 반환, 매개변수 형태는 동일
- flatMapFirst는 맨 처음 mapping으로 변환한 Observable이 방출하는 이벤트만 구독자에게 전달한다. 
- flatMapLatest는 가장 최근(가장 마지막) mapping으로 변환한 Observable이 방출하는 이벤트만 구독자에게 전달한다. 
~~~ swift 
/// MARK: - flatMapFirst / flatMapLatest : Operator
// - 원본 Observable이 방출하는 항목을 Observable로 변환
// - flatMap과 반환, 매개변수 동일

import RxSwift
import RxCocoa

let disposeBag = DisposeBag()
let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

let subject = PublishSubject<BehaviorSubject<Int>>()

subject // flatMap으로 맵핑 된 새로운 Observable은 항목이 업데이트 될 때마다 새로운 항목을 방출한다.
    .flatMapFirst { $0.asObservable() }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// flatMapFirst는 첫번째 변환된 Observable이 방출하는 항목만 구독자에게 전달
subject.onNext(a)
subject.onNext(b) // 첫번째 이후의 방출한 항목은 무시한다.
a.onNext(11) // 맨 처음 변환된 Observable인 a만 방출이 유효
b.onNext(12)

// ✓ flatMapLatest 는 flatMapFirst와 반대로 가장 최근의 변환한 Observable의 방출 항목만 구족자에게 전달
~~~

<br>

### Buffer 
- 특정 주기동안 옵저버블이 방출하는 항목을 수집하여 배열로 방출한다. 
- 매개변수 : 버퍼의 최대 시간길이(timeSpan), 버퍼 크기 카운트(count, 꽉 차면 바로 배열로 방출)
- 만약 지정한 timeSpan 기간 동안 버퍼가 차버린다면? 
  - -> 그 즉시 해당 버퍼는 방출되고 다시 버퍼 시간을 체크 
~~~ swift 
/// MARK: - Buffer : Operator
// 특정 주기동안 옵저버블이 방출하는 학목을 수집하여 배열로 리턴한다.
// 버퍼의 최대 시간길이, 버퍼 카운트 등을 매개변수로 받는다.
import RxSwift

let disposeBag = DisposeBag()

// 2초동안 누적된 버퍼 (buffer(timeSpan: .seconds(2), count: 3, scheduler: MainScheduler.instance)) 를 계속 방출하지않고 최초 5번까지만 방출한다 (take(5)).

// 만약 지정한 timeSpan 기간 동안 버퍼가 차버린다면?? -> 버퍼가 꽉 차는 즉시 해당 버퍼를 방출한다!
Observable<Int>.interval(
    .seconds(1),
    scheduler: MainScheduler.instance)
    .buffer(timeSpan: .seconds(5), count: 3, scheduler: MainScheduler.instance)
    .take(5)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
~~~

<br>

### Window : Operator
- 특정 시간동안 옵저버블이 방출하는 옵저버블, Inner Observable을 방출한다. 
  - Inner Observable은 체크시간과 관계없이 최대 버퍼크기에 도달시 방출이 된다. 
  - 최대 체크시간이 도달 시 현재 Inner Observable 배열을 방출한다. 
  - 매개변수 : 체크시간간격, 분해할 최대옵저버블 항목 수, 스케쥴러
  
/// MARK: - Window; Operaotr
// 옵저버블이 방출하는 옵저버블을 방출한다. (In a Observable)
// Buffer와 동일하게 최대 버퍼크기에 도달 시 체크 시간과 상관없이 옵저바블을 방출하는 옵저바블(Inner Observable)을 방출한다.
// 매개변수 : 체크 시간 간격, 분해할 최대항목수, 스케쥴러
// * 콘솔에 출력되는 RxSwift.AddRef<Swift.Int> 는 옵저버블이라는 것만 이해하면 문제 없음
~~~ swift 
import RxSwift

let disposeBag = DisposeBag()
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .window(timeSpan: .seconds(5), count: 3, scheduler: MainScheduler.instance)
    .take(5)
    .subscribe { print($0)
        if let observable = $0.element {
            observable.subscribe { print("inner: ", $0) }
        }
    }
    .disposed(by: disposeBag)
~~~

<br>

### GroupBy : Operator
- 옵저버블이 방출하는 요소를 원하는 기준에 따라 그룹핑 하고자 할 때 사용한다. 
- 주로 toArray, flatMap과 함께 사용하면 그룹핑된 옵저버블 요소를 배열로 만들어 사용하곤 한다. 

~~~ swift 
/// MARK: - GroupBy : Operator

import RxSwift

let disposeBag = DisposeBag()
let words = ["apple", "Banana", "Orange", "Cucumber", "WaterMelon", "Peach"]

// 문자열 길이를 기준으로 groupBy를 사용 시, 문자열 길이에 따른 옵저버블 목록이 콘솔에 출력한다.
//Observable.from(words)
//    .groupBy { $0.count }
//    .subscribe(onNext: { groupedObservable in
//        // 문자열 길이에 따라 그룹핑 된 키값, 정보를 콘솔에 출력한다.
//        print("== \(groupedObservable.key)")
//        groupedObservable.subscribe { print(" \($0)") }
//    })
//    .disposed(by: disposeBag)

// MARK: - flatMap, toArray의 사용
// - flatMap, toArray를 사용해 문자열 길이 기준으로 그룹핑 된 요소의 값을 출력한다.
Observable.from(words)
    .groupBy { $0.count }
    .flatMap { $0.toArray() }
    .subscribe {print($0) }
    .disposed(by: disposeBag)

// * 첫번째 문자를 기준으로 그룹핑 한 상태
Observable.from(words)
.groupBy { $0.first ?? Character(" ") }
.flatMap { $0.toArray() }
.subscribe {print($0) }
.disposed(by: disposeBag)
~~~

<br>

### Interval
- disposed 처리 전가지 일정 주기에 맞게 방출을 진행한다. 
- FixedWidthInteger 형식의 정수형 요소를 취급할 수 있다. 
- 새로운 구독자가 생기연 그에 따른 새로운 타이머가 실행된다. 
- 매개변수 : 반복주기, 방출에 사용할 스케쥴러
~~~ swift 
/// MARK: - Interval : Operator
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
~~~ 

