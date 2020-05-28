
import NaturalLanguage

let text = """
All human beings are born free and equal in dignity and rights.
They are endowed with reason and conscience and should act towards one another in a spirit of brotherhood.
"""

let tokenizer = NLTokenizer(unit: .word)
tokenizer.string = text

tokenizer.enumerateTokens(in: text.startIndex ..< text.endIndex) { tokenRange, _ in
    print(text[tokenRange])
    return true
}

////
////  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
////
////  Permission is hereby granted, free of charge, to any person obtaining a copy
////  of this software and associated documentation files (the "Software"), to deal
////  in the Software without restriction, including without limitation the rights
////  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
////  copies of the Software, and to permit persons to whom the Software is
////  furnished to do so, subject to the following conditions:
////
////  The above copyright notice and this permission notice shall be included in
////  all copies or substantial portions of the Software.
////
////  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
////  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
////  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
////  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
////  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
////  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
////  THE SOFTWARE.
////
//
//// MARK: catchErrorJustReturn 연산자는 catchError 와 달리 에러 발생 시 새로운 옵저버블 대신 기본값을 리턴하는 연산자입니다.
//
// import RxSwift
// import UIKit
//
/// *:
// # catchErrorJustReturn
// */
//
// let bag = DisposeBag()
//
// enum MyError: Error {
//    case error
// }
//
// let subject = PublishSubject<Int>()
//
//// catchErrorJustReturn 연산자는 에러발생시 파라메터로 전달한 값을 전달합니다. 이 값은 subject가 전달하는 타입을 따라갑니다.
// subject
// .catchErrorJustReturn(-1)
//    .subscribe { print($0) }
//    .disposed(by: bag)
//
//// next(-1)
//// completed
// subject.onError(MyError.error)
