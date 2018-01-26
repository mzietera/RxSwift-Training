import PlaygroundSupport
import RxSwift

enum MyError: Error {
    case anError
}

let disposeBag = DisposeBag()

let one = 1
let two = 2
let three = 3
let observable: Observable<Int> = Observable<Int>.just(one)
let observable2 = Observable.of(one, two, three)
observable2.subscribe { (event) in
    if let element = event.element {
        print(element)
    }
}

let emptyObservable = Observable<Void>.empty()
emptyObservable.subscribe(onNext: { element in
    print(element)
}, onCompleted: {
    print("completed")
})

print("never")
let neverObservable = Observable<Any>.never()
neverObservable.subscribe(
    onNext: { element in
        print(element)
    }, onCompleted: {
        print("Completed")
    }
)

print("range")
let rangeObservable = Observable<Int>.range(start: 1, count: 10)
rangeObservable.subscribe(onNext: { (element) in
    print(element)
}, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

//create
print("create")
let createObservable = Observable<String>.create { (observer) -> Disposable in
    observer.onNext("1")
    observer.onError(MyError.anError)
    observer.onCompleted()
    let nextEvent = Event.next("?")
    observer.on(nextEvent)
    return Disposables.create()
    }.subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Completed") },
        onDisposed: { print("Disposed") })
    .disposed(by: disposeBag)

//deferred
print("deferred")
var flip = false
let factory: Observable<Int> = Observable.deferred {
    flip = !flip
    if flip {
        return Observable.of(1, 2, 3)
    } else {
        return Observable.of(4, 5, 6)
    }
}
for _ in 0...3 {
    factory.subscribe(onNext: {
        print($0, terminator: "")
    })
    .disposed(by: disposeBag)
    print()
}

//challenges
print("never challenge")
let challenge1neverObservable = Observable<Any>.never().do(
    onNext: nil,
    onError: nil,
    onCompleted: nil,
    onSubscribe: {
        print("onSubscribe")
    },
    onSubscribed: {
        print("did subscribe")
    },
    onDispose: nil)

challenge1neverObservable.subscribe(
    onNext: { element in
        print(element)
    }, onCompleted: {
        print("Completed")
    })
    .disposed(by: disposeBag)

////////////////////////////////
print("Chapter 3 - Subjects")

//PublishSubject
let subject = PublishSubject<String>()
subject.onNext("is anyone listening?")

let subscriptionOne = subject.subscribe(
    onNext: { print($0) })
subject.onNext("1")

let subscriptionTwo = subject.subscribe { (event) in
    print("2)", event.element ?? event)
}
subject.onNext("3")
subscriptionOne.dispose()
subject.onNext("4")

subject.onCompleted()
subject.onNext("5")
subscriptionTwo.dispose()

subject.subscribe({
    print("3)", $0.element ?? $0)
    })
    .disposed(by: disposeBag)


//BehaviorSubject
func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}

let behaviorSubject = BehaviorSubject(value: "Initial value")

behaviorSubject.subscribe({
        print(label: "1)", event: $0)
    })
    .disposed(by: disposeBag)


//ReplaySubject

let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
replaySubject.onNext("1")
replaySubject.onNext("2")
replaySubject.onNext("3")

replaySubject.subscribe({
        print(label: "1)", event: $0)
    })
    .disposed(by: disposeBag)

replaySubject.subscribe({
        print(label: "2)", event: $0)
    })
    .disposed(by: disposeBag)

replaySubject.onNext("4")
replaySubject.onError(MyError.anError)
replaySubject.dispose()
replaySubject.subscribe({
        print(label: "3)", event: $0)
    })
    .disposed(by: disposeBag)


//Variables

var variable = Variable("Initial value")

variable.value = "new initial value"
variable.asObservable().subscribe({
        print(label: "1)", event: $0)
    })
    .disposed(by: disposeBag)

variable.value = "1"

variable.asObservable().subscribe({
        print(label: "2)", event: $0)
    })
    .disposed(by: disposeBag)

variable.value = "2"
