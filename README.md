# RxSwift Study

<br>
<br>

# RxSwift 스터디 정리

RxSwift의 입문 공부 기록

<br>

# 개요

✓ iOS 프로개발자이신 곰튀김님이 제공하는 RXSwift 4시간안에 끝내기 강의를 통해 RxSwift의 기본을 배우고 기록합니다.<br>
✓ + 공부하는 RxSwift 지식을 붙여 기록합니다.

<br>

# RxSwift 학습 개인 학습 메모 

<br> 

### RxSwift 학습 전 숙지사항 

- Swift Language -> Functional Programming / Protocol Oriented Programming -> RxSwift 
- 학습난이도가 비교적 있는 편
- Observer, Subject, Driver 등의 사용을 위해선 기본적인 Swift 문법은 숙지되어있어야 한다. 

### RxSwift란?

- ReactiveX 라이브러리를 Swift로 구현한 것으로, Observable Stream을 이용한 비동기 API이다.

### 왜 RxSwift를 사용하는가?

- Key Value Observing, Notifications 등, 다양한 상황에서의 구현을 간결하게 표현할 수 있음.
- **보다 단순하고 직관적인 코드를 작성할 수 있음**

### Observable 

- Observable은 이벤트를 전달한다. 
- Next : 방출, Emission (Observer, Subscriber로 전달)
- Error : 에러 발생시 전달, Observable 주기 끝에 실행, Notification
- Completed : 성공적으로 실행 시 전달, Observable 주기 끝에 실행, Notification

### Observer

- Observer를 Subscriber라고도 부른다. 
- Observable을 감시하고 있다가 전달되는 이벤트를 처리한다.
- 이때 Observable을 감시하고 있는 것을 Subscribe라고 한다. 

- * Marble Diagram을 통해 다양한 RxMarble의 작동 과정을 확인 할 수 있다.
    - RxSwift를 공부할 때 큰 도움이 됨



<br>
<br>



## Observable의 생성

~~~ Swift
/// MARK: - Observable의 생성
// Observable을 생성하는 방법은 2가지 방법이 있다.
// * 1번째 방법
// create : Observable 타입 프로토콜에 선언되어있는 타입 메서드, Operator라고도 한다.
// - Observer를 인자로 받아 Disposable을 반환한다 .
Observable<Int>.create { (observer) -> Disposable in
    // observer애서 on 메서드를 호출하고, 구독자로 0이 저장되어있는 next 이벤트가 전달된다.
    observer.on(.next(0))
    
    // 1이 저장되어있는 next 이벤트가 전달된다.
    observer.onNext(1)
    
    // completed이벤트가 전달되고 Observable이 종료된다. 이후 다른 이벤트를 전달할 수는 없다.
    observer.onCompleted()
    
    // Disposables 는 메모리 정리에 필요한 객체이다.
    return Disposables.create()
}

// * 2번째 방법
// from 연산자는 파라미터(인자값)으로 전달받은 값을 순서대로 방출하고 Completed Event를 전달하는 Observable을 생성한다.
// 이처럼 create 이외로도 상황에 따른 다양한 Operator 사용이 가능한다.
Observable.from([0, 1])

// 이벤트 전달 시점은 언제? -> Observer가 Observable을 구독하는 시점에 Next이벤트를 통해 방출 및 Completed이벤트가 전달된다.
~~~

<br>
<br>

## 옵저버의 구독

- 1) 하나의 클로져를 통해 모든 이벤트를 처리하고자 할때는 아래와 같이 구독을 사용할 수 있다


~~~ Swift
import RxSwift
import RxCocoa
observer.subscribe {
    // * subscribe 클로져 내 "== Start ==" 가 연달아 "== End ==" 없이 두번 호출되는 경우는 없다.
    print("== Start ==")
    print($0)
    // 순수 값을 추출하여 출력할 수 있으며, Optional이므로 Optioanl Binding이 필요하다.
    if let value = $0.element {
        print($0)
    }
    print("== End ==")
}

print("===========================")
// 2) 세부적인 구독 처리도 가능
// '$0.element' 같은 방식으로 접근 할 필요 없이 onNext: 클로져 인자값을 통해 element에 바로 접근할 수 있다.
observer.subscribe(onNext: { (element) in
    // 순수 element 값만 출력 되는 것을 확인할 수 있다.
    print(element)
})
~~~

<br>
<br>

## Disposable

- Disposed는 Observer가 전달하는 이벤트가 아니다. 
- 리소스가 해제되는 시점에 자동으로 호출되는 것이 Disposed이다.
  - 하지만, RxSwift 공식 문서에 따르면 Disposed를 정리/명시 해줄 것을 권고한다. 가능한 따르는 것이 좋을 것이다.

<br>

~~~ swift
import RxCocoa
import RxSwift

// 1씩 증가하는 정수를 1초간격으로 출력하는 Observable
// 해당 작업의 종료를 위해서는 Dispose 처리가 필요하다.
let subscription2 = Observable<Int>.interval(.seconds(1),
                                              scheduler: MainScheduler.instance)
.subscribe(onNext: { element in
    // Emmission
    // "Next 1~3" 이 출력
    print("Next",element)
}, onError: { (error) in
    // Notification
    print("Error",error)
}, onCompleted: {
    // Notification
    // Observable 완료 시 실행
    print("Completed")
    
    // Disposed는 Observable이 전달하는 이벤트는 아니다. Observable과 관련된 모든 리소스가 제거된 뒤 호출이 된다.
}) {
    print("Disposed")
}

// Disposable의 dispose() 메서드를 통해 3초 가 지나면 해당 Observable을 Dispose 처리한다.
// 해당 기능은 take, until 등의 Operator 등을 통해서도 구현할 수 있다. 
// 0, 1, 2까지만 출력됨
DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    subscription2.dispose()
}

~~~

<br>

### Subscription Disposable

- Observer 구독시 사용하는 메서드, **subscribe의 반환형은 Disposable(Subscription Disposable)**이다. 
- 크게 리소스 해제와 실행 취소에 사용하는 것이 Subscription Disposable이다.



<br><br>

## DisposeBag

- subscription 시 반환되는 Disposable들을 담는 가방

~~~ swift
import RxSwift
import RxCocoa

var disposeBag = DisposeBag()

// Disposed는 옵저버가 전달하는 이벤트가 아니다.
// -> 리소스가 해제되는 시점에 자동으로 호출되는 것이 Disposed이다.
// * 하지만, RxSwift 공식 문서에서는 Disposed를 정리/명시해줄 것을 권고한다. -> 가능한 따르는 것이 좋음.
Observable.from([1,2,3])
    .subscribe {
        print($0)
}.disposed(by: disposeBag)
// - 위와 같이 disposed(by: bag) 식으로 DisposeBag을 사용할 수 있다.
// - 해당 subscription에서 반환되는 Disposable은 bag(DisposeBag)에 추가된다.
// - 이렇게 추가된 Disposable 들은 DisposeBag이 해제되는 시점에 함께 헤제되게 된다.

// 새로운 DisposeBag()으로 초기화하면 이전까지 담겨있던 Disposable들은 함께 헤제된다.
disposeBag = DisposeBag()
~~~

<br>



## Operator, 연산자

- RxSwift에서 자주 사용 되는 연산자(Operator)
- RxSwift가 제공하는 여러가지 타입 중, ObservableType Protocol이 있다 
  - RxSwift의 근간을 이루는 여러가지 기능이 담겨 있는데 이들을 Operator, 연산자라 한다. 

<br>

### 연산자의 특징

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
<br>

# 곰튀김 RxSwift 강의 정리 
## Part1. Model 

### ReactiveX, RxSwift란? 
- * An API for asynchronous programming with observable streams
  - ➣ 감시 스트림(Observable) 사용 비동기 프로그래밍을 위한 API

### RxSwift와 함께하는 MVVM 패턴
- **MVVM**
  - input이 들어온다 -> View가 반응한다. -> View가 아닌 ViewModel이 어떻게 처리할까 판단한다. -> Model에서 받아온다. 
  - ViewMedel에서 UIKit 관련 UI와 관련되어지는 부분에 대해서 신경쓰고 관리해야 한다.  
  - ViewModel은 View에 종속되어선 안되며 재사용이 가능해야 잘 구현 된 ViewMedel이라 할 수 있다.

- *<출처 : 밀쿄님 RxSwift 강좌>*

<br>

## ReactiveX는 어디서 처음 만들었는가? 
	- MS에서 처음 만들었다.

<br>

## RxSwift의 요소 
	- Observable : 제일 중요한 기능, 이것만 알면 다 쓸 수 있다.
	- Operators : 이걸 쓰면 좀더 효율적으로 구현 가능
	- Scheduler  : 여러군데 활용이 가능
	- Subject  : 무언가 만들 수 있음
	- Single : 가장 중요하지 않음

### ➣ Reactivex.io 홈페이지 내 Resources->Tutorial 을 활용하면 RxSwift 학습자료를 찾아볼 수 있음
### ➣ RxMarble 사이트에서 실제 마블 동작 다이어그램을 확인 가능 : https://rxmarbles.com/

<br>

## RxSwift를 공부하기 전 알아야 할 지식, 비동기(Asynchronization)
* **DispatchQueue에는 크게 sync, async 두가지가 있음. 더 세부적으로 보자면..**
### - Concurrency async
### - Concurrency sync
### - Serial async
### - Serial sync 
총 네가지 분류를 해볼 수 있다.

	* Async한 코드를 보다 간결하게 표현할 수 있는 방법이 바로 RxSwift이다.
	* 비동기 구현내용이 간단할때는 RxSwift와 일반 코드의 차이를 느끼기 힘들다. 
	* 보다 복잡한 구현이 이루어질때 RxSwift가 진가를 발휘한다.
	* 기존 iOS에서 제공하는 Promise kit vs RxSwift 둘다 구현은 가능하다. 하지만 간결함의 차이가 난다.

<br>
<br>

## Part2. Operator, Scheduler 

<br>

### Operator
- Just
  - JUST() 출력결과: print가 바로 실행된다.
  - -> Hello World

- From
  - FROM() 출력결과: 배열의 요소를 하나씩 하나씩 하나씩 차례대로 처리한다.
  - ✓ 작업 완료 후에 completed 분기가 실행이 된다!
   
- Single
  - Single : 하나의 특정 동작만 처리 여러동작 잡히면 에러처리
  - ✓ single()을 실행하기 위해선 작업이 한개만 들어와야 한다!
    
- Map
  - 내려온 작업, 데이터를 하나씩 다른 데이터로 변형시킨다.

- FlatMap
  - 내려온 작업, 데이터를 하나씩 스트림(Stream)으로 변형시킨다.

- Concat
  - 다수의 Observable을 하나로 순서대로 합쳐서 실행한다.

<br>

## Scheduler
	메인스레드를 사용하지 않고 UI처리를 하면 버벅임이 생길 수 있다. 메인스레드에서 동작시켜야 한다.
	현재 메인스레드로 만 전부 진행하기 때문에 실행간 렉이 걸린다. 이때 사용할 수 있는 것이 Scheduler이다.
	
### 'SerialDispatchQueueScheduler : 지정 된 Serial DispatchQueue Scheduler에서 작업을 전송(Dispatch)

### 'ConcurrentDispatchQueueScheduler : Concurrent DispatchQueue 위에서 작업을 전송

### 'OperationQueue Scheduler : 지정 된 NSOperationQueue에서 작업을 전송(Dispatch)

### - .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
	✭ 동시실행이 필요할 때 => 메인스레드 사용 전 동시성 실행 스케줄러 : 
### - .observeOn(MainScheduler.instance)
	✭ 메인스레드 동작에 사용되는 스케쥴러 지정 : .observeOn(MainScheduler.instance)를 사용한다.

### - subscribeON
	✓ subscribeOn은 어느 위치에 지정해도 문제없다. 사용하는것이 아닌 사용을 위해 등록만 하는 과정이기 때문이다.
	✓ subscribeOn이후 subscribe가 생기면 그 순간 해당 subscribe는 가장 최근에 지정한 subscribeOn 스케쥴러 정책에 따라 실행된다.

<br>
<br>

## Part3. Subject

<br>

### Subject
- Subject의 종류 : Async Subject, BehaviorSubject, publishSubject, ReplaySubject

- Behavior Subject
  - 스스로 데이터를 발생 가능 + Subscribe 가능 Observable
  - 최초 SubScribe 이후, Default값으로 상태를 지켜보며 기다리다가 어떤 subscribe가 발생하면
    - ➢ 그 Subscribe에 최근 데이터값을 넘겨준다.
    - - 해당 Subject가 종료 되면 이후 라는 스트림에서 Subscribe를 해도 해당 Subject는 종료된다.
    - ✓ Bullet View만 상황을 지켜보다가 Enable or Disable 여부를 판단하여 변경할 수 있다.
    - * (value: false) -> default 값으로 false 설정을 했음을 의미
		
- Behavior Replay 
  - Behavior Wrapper로, 종료 시 Error, Completed를 동반하지 않는다.

- Async Subject
  - 해당 Subject가 종료되는 시점의 맨 마지막 전달된 데이터를 SubScribe한 Stream들에 전달시킨다.

- Publish Subject
  - 데이터가 생성되면 그때 데이터를 전달한다. "최초 Default값이 없다." 
  - 데이터가 생성될 때마다 해당 Subject를 Subscribe한 놈들에게 전부 해당 데이터를 전달한다.

- Replay Subject 
  - 데이터가 생성되면 지금까지 생성했던 데이터를 한꺼번에 전달한다. "최초 Default값이 없다." 
  - 마블 3개가 지나간 뒤 다른 Subscribe가 진행되면 해당 Stream에 이전 마블 3개를 전부 전달한다. 
  - 이후 생성되는 데이터는 동일하게 모든 Stream에 전달된다.

- * Variable -> Deprecated

### Drive
~~~ Swift 
// MainScheduler 등 명시 안하고 메인스레드로 돌려서 UI 등 처리할 수 있는 또 다른 방법 정도로 이해해두면 됨
    viewModel.idBulletVisible
    .asDriver()
    .drive(onNext: idValidView.isHidden = $0)
    .disposed(by: disposeBag)
~~~

<br>
<br>

## 기타 유용한 RxSwift Library
- RxDataSources : https://github.com/RxSwiftCommunity/RxDataSources
  - 테이블, 컬렉션 뷰의 RxdataSources
  - **기능**
    - 차이점 계산에 대한 0(N) 복잡도 알고리즘
      - 해당 알고리즘은 모든 섹션 및 아이템들이 구체적이며 모호성이 없다고 가정 시 작동한다.
      - 만약 모호성이 존재할 시 갱신 미동작 및 자동적으로 fallbacks(물러남) 처리된다.
    - 섹션으로 구성 된     뷰에 최소한의 명령을 보낼 수 있도록 추가적인 (휴리스틱)직관적 판단을 적용한다. 
      - 비록 실행 시간은 선형으로 진행되지만, 전송되는 명령의 선호되는 갯수는 보통 선형보다 매우 적다.
      * 휴리스틱 : 어떤 사안 또는 상황에 대해 엄밀한 분석에 의하기보다 제한된 정보만으로 즉흥적 · 직관적으로 판단 · 선택하는 의사결정 방식을 의미한다.
      - 가능한 변경횟수를 적은 횟수로 제한하도록 선호된다. 만약 선형적으로 변경횟수가 증가하는 경우, 정상적인 리로드(Reload)를 수행하십시오.
	- 아이템과 섹션구조의 확장(Extending)을 제공한다.
	  - 당신의 아이템은 IdentifiableType, Equatable과 함께, 섹션은 AnimatableSectionModelType과 함께 확장할 수 있다.
	- 섹션, 아이템을 위한 2단계로 계층적 애니메이션의 모든 조합들을 지원한다.
	  - 섹션 애니메이션 : Insert, Delete, Move
	  - 아이템 애니메이션 : Insert, Delete, Move, Reload (만약 이전값이 새로운 값과 다를 경우)
	- 삽입, 리로드, 삭제 등을 위한 조작가능한 애니메이션 타입들(Automatic, Fade, ...
	- 랜덤화된 스트레스 강도 테스트
	- 즉시 사용가능한 편집을 지원
	- UITableView, UICollectionView와 함께 동작
	- * DataBinding + SectionModel을 사용해야만 RxDataSource를 사용 할 수 있다.
 
- RxOptional : .filterNil() 등을 사용하여 쉽게 옵셔널 데이터 처리가 가능하다.
- RxViewController
~~~ Swift 
self.rx.viewWillDisappear.subscribe...
self.rx.viewWillAppear().take(1).subscribe...
// -> (viewWillAppear에 여러번 들러도 한번만 처리하게 하는 기능) 등의 접근 가능- ---- 
~~~

<br>

- RxGesture : 제스쳐기능의 코드부 간략화 가능
~~~ Swift
view.rx
    .anyGesture(.top(), .swipe([up, .down]))
    .when(.recognized)
    .subscribe(onNext: { _ in
    dismiss presented photo
    })
    .disposed(by: disposeBag)
~~~

<br>

<br>
<br>

### RxSwift 사용 간 주의사항
- UI Input 등의 RxSwift 동작은 Complete 되지 않는다
- UI의 Reference Count가 1로 계속 유지 될 수 있다. 
  - * 이로 인한 메모리 누수 방지를 위해 할 수 있는 방법
    - 1) 클로져 내 [weak self]를 고려해야 한다.
    - 2) disposeBag = DisposeBag() 의 활용
### 그 외 주의사항
- do(), subcribe() 사이드이펙트를 건드린다는 것을 명심해야한다. 
	 
<br>
<br>



## 결론
*여러분들은 RxSwift를 4시간만에 끝내기는 커녕 3시간만에 끝내셨습니다(?)*
- ✔︎ 굉장히 다양한 Operator 기능을 통한 활용성
- ✔︎ 커뮤니티가 활성화되어 있어 유용한 외부 라이브러리가 존재
- ✔︎ iOS개발자로서 경쟁력이자 강점이 될 수 있다.
	
#

<br>
<br>

## 라이노님의 RxStudy 발표 내용 정리
### '19. 08. 28.

<br>

### Observable의 Subscribe는 역방향, Event는 정방향?

### ♣︎ Operator란? 
- Observable들을 다루는 메서드
- Observable을 변환, 필터링, 합성하는 등 다양한 Operator가 존재한다. 
원하는 만큼 연쇄적으로 제공 할 수 있다. 

- Observable Class 가 연산자별 로 존재한다. 

- 실제 옵저바블이 creating 연산자를 만들면, 여러개의 연산자가 적용이 되면 서 
구독을 할떄 마지막 옵저버블부터해서(역방향 순서) 차례대로 구독이 된다. ?

- 옵저버블의 이벤트 처리는 맨 처음 연산자 부터 순서대로(정방향 순서) 발생한다. 

<br>

### ♣︎ 생성 연산자
### ➣ from : 컬렉션(배열 등)을 인자로 받아 해당 원소를 하나씩 이벤트로 내보내는 Observable을 만든다. 
Ex)  [1,2,3] 배열이 있다 했을때… 
=> 원소를 하나하나 빼가지고 이벤트를 흘려보낸다.

### ➣ of : 한개이상의 인자를 받아 해당 원소를 하나씩 이번트로 내보낸다. 
Ex) 가변인자를 받아서, “,”를 기준으로 이벤트를 흘려보낸다.

### ➣ create : 커스텀 Observable을 만들때 사용한다. 
- 이벤트를 지정 + onCompleted까지 직접 지정해주어야 한다. 
  - -> 액션들에 대해 참조가 끊어지면 안되기에 참조 유지를 위해 Disposable객체를 생성해서 넘겨주고, DisposeBag에 넘겨 주어 참조를 유지? 
- Return Disposables.create() 반환하여 Subscription과 연결, 참조를 유지시킨다. (Disposable.create()는 존재하지 않는다.)

### ➣ deferred : 내부 조건에 따라 다른 결과를 만들 수 있다. 
팩토리 클로저를 인자로 받아, 외부 조건에 따라 다른 Observable을 반환하도록 해준다. 

<br>

### 그 외 Operator

- filter 
  - 특정 조건을 충족하는 값만을 필터링 후 새로운 배열값을 반환한다.
- debounce(디바운스)
  - 이벤트가 한번 발생한 뒤 일정 시간을 잰다. 
  - 재는 시간 사이에 다른 이벤트가 발생하지 않아야만 옵저바블을 넘긴다. 
  - 만약 재는 시간 중 다른 이벤트가 발생하면, 다른 이벤트 + debounce이벤트는 씹힌다.
  - UI 터치 등을 여러번이 아닌 한번만 감지해야 할때 등에 사용할 수 있다. 
  - SearchBar 검색 기능 등에도 여러번 검색 되지 않도록 사용할 수 있다. 

- throttle
  - 특정 시간 간격 내 발생하는 이벤트 특정 시간 단위로 시간을 쟤며 체크, 체크 시점에 결과 무조건 방출

~~~ swift
// Timer.throttle(RxTimeInterval.seconds(2), latest: true, scheduler: 
// MainScheduler.instance)….
~~~

<br>

- lastest 옵션이 true? 타이머가 끝나는 시점 발행 된 마지막 값을 가져온다. : 타이머가 끝난 후의 값을 가져온다. 
  -이벤트가 발생하는 시간이 throttle에 떨어지는 시간이 끊어졌을때 그 마지막 값을 가져오는게 true, throttle로 방출하고 다음걸 방출할때 그 값을 가져온게 false

- take
  - take(n): 요소의 앞부터 순서대로 특정 개수(n)의 값을 가져온다. 

- skip
  - skip(n)과 같은 방식으로 사용 
  - 요소 앞부터 특정 갯수를 제외한 값을 가져온다.

- flatmap : 하나의 stream, observable을 반환
  - observable을 한 겹 벗겨내준다. (observable을 평평하게 만든다?)

- flatmapLatest 
  - 가장 마지막으로 추가된 순서의 Observable 이벤트만 subscribe한다.
  
- switchLatest + map

- switchLatest 
  - flatmapLatest에서 map 기능이 빠진 것

- merge 
  - 나오는 대로 함치는 것 그냥 순수하게 두개를 합쳐버림

- combineLatest 
  - 받은 두 개의 Observable중 하나만 변경되면 가장 최근의 두 Observable들을 방출

- zip 
  - Observable이 방출하는 값들을 튜플로 묶어서 내보낸다. 만약 튜플로 묶을 수 없는 값은 버려진다. 

- groupBy 
  - 원소들을 특정 조건에 따라 그룹지어준다. 
  
- servable -> groupedObservable

- buffer 
  - 특정 시간동안 시간이 다되거나 or Count로 요소의 갯수 제한, count만큼 갯수가 차면 방출

- window 
  - buffer와 기능은 동일하나 Observable로 나온다. 시간이 다되거나 or Count 만큼 Observable의 갯수가 차면 방출

- startWith
  - 가변인자를 받아 onNext상황없이 Subscribe가 될때 원하는 값을 실행

