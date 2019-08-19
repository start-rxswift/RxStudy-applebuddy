# RxSwift Study

<br>
<br>

# RxSwif 스터디 정리

RxSwift의 입문 공부 기록

<br>

# 개요

✓ iOS 프로개발자이신 곰튀김님이 제공하는 RXSwift 4시간안에 끝내기 강의를 통해 RxSwift의 기본을 배우고 기록합니다.<br>
✓  공부하는 RxSwift 지식을 붙여 기록합니다.

<br>
<br>

# Part1. Model 

## ReactiveX, RxSwift란? 
	* An API for asynchronous programming with observable streams
	  ➣ 감시 스트림(Observable) 사용 비동기 프로그래밍을 위한 API

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

# Part2. Operator, Scheduler 

<br>

## Operator
### - Just
     JUST() 출력결과: print가 바로 실행된다.
     -> Hello World

### - From

     FROM() 출력결과: 배열의 요소를 하나씩 하나씩 하나씩 차례대로 처리한다.
     ✓ 작업 완료 후에 completed 분기가 실행이 된다!
   
### - Single
     Single : 하나의 특정 동작만 처리 여러동작 잡히면 에러처리
     ✓ single()을 실행하기 위해선 작업이 한개만 들어와야 한다!
    
### - Map : 내려온 작업, 데이터를 하나씩 다른 데이터로 변형시킨다.

### - FlatMap : 내려온 작업, 데이터를 하나씩 스트림(Stream)으로 변형시킨다.

### - Concat : 다수의 Observable을 하나로 순서대로 합쳐서 실행한다.

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

# Part3. Subject

<br>

## Subject
- Subject의 종류 : Async Subject, BehaviorSubject, publishSubject, ReplaySubject

### - Behavior Subject : 스스로 데이터를 발생 가능 + Subscribe 가능 Observable
	- 최초 SubScribe 이후, Default값으로 상태를 지켜보며 기다리다가 어떤 subscribe가 발생하면
	  ➢ 그 Subscribe에 최근 데이터값을 넘겨준다.
	- 해당 Subject가 종료 되면 이후 라는 스트림에서 Subscribe를 해도 해당 Subject는 종료된다.
	✓ Bullet View만 상황을 지켜보다가 Enable or Disable 여부를 판단하여 변경할 수 있다.
		* (value: false) -> default 값으로 false 설정을 했음을 의미

### - Async Subject : 해당 Subject가 종료되는 시점의 맨 마지막 전달된 데이터를 SubScribe한 Stream들에 전달시킨다.

### - Publish Subject : 데이터가 생성되면 그때 데이터를 전달한다. "최초 Default값이 없다." 
	- 데이터가 생성될 때마다 해당 Subject를 Subscribe한 놈들에게 전부 해당 데이터를 전달한다.

### - Replay Subject : 데이터가 생성되면 지금까지 생성했던 데이터를 한꺼번에 전달한다. "최초 Default값이 없다." 
	- 마블 3개가 지나간 뒤 다른 Subscribe가 진행되면 해당 Stream에 이전 마블 3개를 전부 전달한다. 
	- 이후 생성되는 데이터는 동일하게 모든 Stream에 전달된다.

## Drive
	// MainScheduler 등 명시 안하고 메인스레드로 돌려서 UI 등 처리할 수 있는 또 다른 방법 정도로 이해해두면 됨
	    viewModel.idBulletVisible
	    .asDriver()
	    .drive(onNext: idValidView.isHidden = $0)
	    .disposed(by: disposeBag)

<br>
<br>

# 기타 유용한 RxSwift Library
### RxOptional : .filterNil() 등을 사용하여 쉽게 옵셔널 데이터 처리가 가능하다.
### RxViewController :
	self.rx.viewWillDisappear.subscribe...
	self.rx.viewWillAppear().take(1).subscribe...
	// -> (viewWillAppear에 여러번 들러도 한번만 처리하게 하는 기능) 등의 접근 가능- ---- 
### RxGesture : 제스쳐기능의 코드부 간략화 가능
	view.rx
	    .anyGesture(.top(), .swipe([up, .down]))
	    .when(.recognized)
	    .subscribe(onNext: { _ in
	    dismiss presented photo
	    })
	    .disposed(by: disposeBag)

<br>
<br>

# RxSwift 사용 간 주의사항
## UI Input 등의 RxSwift 동작은 Complete 되지 않는다
### UI의 Reference Count가 1로 계속 유지 될 수 있다. 
	* 이로 인한 메모리 누수 방지를 위해 할 수 있는 방법
	 1) 클로져 내 [weak self]를 고려해야 한다.
	 2) disposeBag = DisposeBag() 의 활용
	 
<br>
<br>

# 결론
## 곰튀김님의 맺음말
	여러분들은 RxSwift를 4시간만에 끝내기는 커녕 3시간만에 끝내셨습니다(?)
### ✔︎ 굉장히 다양한 Operator 기능을 통한 활용성
### ✔︎ 커뮤니티가 활성화되어 있어 유용한 외부 라이브러리가 존재
### ✔︎ iOS개발자로서 경쟁력이자 강점이 될 수 있다.
	
#



<br>
