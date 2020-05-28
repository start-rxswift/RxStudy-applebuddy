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

import NSObject_Rx
import RxCocoa
import RxSwift
import UIKit

enum ApiError: Error {
    case badUrl
    case invalidResponse
    case failed(Int)
    case invalidData
}

class RxCocoaURLSessionViewController: UIViewController {
    @IBOutlet var listTableView: UITableView!

    let list = BehaviorSubject(value: [Book]())

    override func viewDidLoad() {
        super.viewDidLoad()

        list
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { _, element, cell in
                cell.textLabel?.text = element.title
                cell.detailTextLabel?.text = element.desc
            }
            .disposed(by: rx.disposeBag)

        fetchBookList()
    }

    func fetchBookList() {
        // ~11) RxCocoa 기능을 활용해서 코드를 개선해 보겠습니다.
        // - flagMap { ... } : // 이렇게 하면 문자열을 방출하는 옵저바블이 데이터 메서드에서 방출하는 옵저버블로 대체되고, 서버에서 전달된 데이터가 data 형식으로 방출됩니다.
        let response = Observable.just(booksUrlStr)
            .map { URL(string: $0)! }
            .map { URLRequest(url: $0) }
            .flatMap { URLSession.shared.rx.data(request: $0) }
            .map(BookList.parse(data:))
            .asDriver(onErrorJustReturn: [])

        // ~13) 앞에서 보신 코드와 결과는 동일하나, 많이 단순해진 것을 알 수 있습니다.
        // - 위와 같이 반드시 해야하는 것은 아닙니다. 단지 한가지 패턴 중 하나입니다. 지금은 문자열 방출 옵저버블로 시작하는데 반드시 그럴 필요는 없습니다. 여기서 urlRequest 인스턴스를 생성한 뒤 바로 RxCocoa URLSession 내부의 data 메서드로 전달해도 되는데, 이러면 더 간결해 질 수 있습니다.

//        let response = Observable<[Book]>.create { observer in
//
//            guard let url = URL(string: booksUrlStr) else {
//                observer.onError(ApiError.badUrl)
//                return Disposables.create()
//            }
//
//            let session = URLSession.shared
//
//            let task = session.dataTask(with: url) { [weak self] data, response, error in
//
//                if let error = error {
//                    observer.onError(error)
//                    return
//                }
//
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    observer.onError(ApiError.invalidResponse)
//                    return
//                }
//
//                guard (200 ... 299).contains(httpResponse.statusCode) else {
//                    observer.onError(ApiError.failed(httpResponse.statusCode))
//                    return
//                }
//
//                guard let data = data else {
//                    observer.onError(ApiError.invalidData)
//                    return
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let bookList = try decoder.decode(BookList.self, from: data)
//
//                    if bookList.code == 200 {
//                        observer.onNext(bookList.list)
//                    } else {
//                        observer.onNext([])
//                    }
//
//                    observer.onCompleted()
//                } catch {
//                    // ~06) catch 블럭에서는 에러이벤트를 전달합니다.
//                    observer.onError(error)
//                }
//            }
//            task.resume()
//
//            return Disposables.create {
//                // ~06) 보통 Dispose 시점에는 현재 동작하면 task를 취소합니다.
//                task.cancel()
//            }
//        }
//            .asDriver(onErrorJustReturn: []) // driver로 바꾸면 조금더 효율적입니다.
//
//        // 여기에서 driver와 subject를 바인딩 하겠습니다.
//        response
//            .drive(list)
//            .disposed(by: rx.disposeBag)
//
//        // 시퀀스가 시작되는 시점에 true를 방출하고, response에서 next이벤트를 방출하면 그 값을 false으로 바꾸어 줍니다.
//        response
//            .map { _ in false }
//            .startWith(true)
//            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
//            .disposed(by: rx.disposeBag)
    }
}
