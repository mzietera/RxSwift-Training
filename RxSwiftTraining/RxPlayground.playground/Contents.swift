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
