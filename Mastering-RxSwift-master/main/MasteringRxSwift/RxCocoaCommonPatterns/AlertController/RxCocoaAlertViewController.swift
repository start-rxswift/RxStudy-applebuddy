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

import RxCocoa
import RxSwift
import UIKit

class RxCocoaAlertViewController: UIViewController {
    let bag = DisposeBag()

    @IBOutlet var colorView: UIView!

    @IBOutlet var oneActionAlertButton: UIButton!

    @IBOutlet var twoActionsAlertButton: UIButton!

    @IBOutlet var actionSheetButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 버튼을 텝하면 경고창을 표시하겠습니다.
        // 아래와 같이 flatMap으로 설정을 하면 tap속성이 전달하는 이벤트 대신 alertAction의 이벤트가 구독자에게 전달됩니다.

        // MARK: #1) SingleButton AlertAction

        oneActionAlertButton.rx.tap
            .flatMap { [unowned self] in self.info(title: "Current Color", message: self.colorView.backgroundColor?.rgbHexString) }
            .subscribe(onNext: { [unowned self] actionType in
                // ok 액션이 전달되변 배경색 코드를 콘솔에 출력합니다.
                switch actionType {
                case .ok:
                    print(self.colorView.backgroundColor?.rgbHexString ?? "")
                default:
                    break
                }
            })
            .disposed(by: bag)

        // MARK: #2) TwoButton AlertAction

        twoActionsAlertButton.rx.tap
            .flatMap { [unowned self] in self.alert(title: "Reset Color", message: "Reset to black color?") }
            .subscribe(onNext: { [unowned self] actionType in
                switch actionType {
                case .ok:
                    self.colorView.backgroundColor = UIColor.black
                default:
                    break
                }
            })
            .disposed(by: bag)

        // MARK: #3) AlertSheet

        actionSheetButton.rx.tap
            .flatMap { [unowned self] in
                self.colorActionSheet(colors: MaterialBlue.allColors, title: "Change Color", message: "Choose One")
            }
            .subscribe(onNext: { [unowned self] color in
                self.colorView.backgroundColor = color
            })
            .disposed(by: bag)
    }
}

enum ActionType {
    case ok
    case cancel
}

extension UIViewController {
    // 반환타입을 ActionType을 방출하는 옵저버블로 설정했습니다.
    // ActionType은 열거형이고 어떤 버튼을 선택했는지를 판단하는데 사용합니다.

    // MARK: - #1) Rx를 활용해서 title, message, ok 버튼의 AlertController를 띄워보겠습니다.

    func info(title: String, message: String? = nil) -> Observable<ActionType> {
        return Observable.create { [weak self] observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                // ok를 선택했을때 ok에 맞는 이벤트를 실행하고 Completed
                observer.onNext(.ok)
                observer.onCompleted()
            }
            alert.addAction(okAction)
            self?.present(alert, animated: true, completion: nil)

            // 보통 Disposable을 생성해서 리턴하는걸로 끝나는데 생성시점에 클로져를 전달하고 AlertController를 dismiss합니다.
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }

    // MARK: - #2) Rx를 활용해서 title, message, cancel/ok 버튼의 AlertController를 띄워보겠습니다.

    func alert(title: String, message: String? = nil) -> Observable<ActionType> {
        return Observable.create { [weak self] observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                // ok를 선택했을때 ok에 맞는 이벤트를 실행하고 Completed
                observer.onNext(.ok)
                observer.onCompleted()
            }
            alert.addAction(okAction)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                observer.onNext(.cancel)
                observer.onCompleted()
            }
            alert.addAction(cancelAction)

            self?.present(alert, animated: true, completion: nil)

            // 보통 Disposable을 생성해서 리턴하는걸로 끝나는데 생성시점에 클로져를 전달하고 AlertController를 dismiss합니다.
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }

    // Color를 설정하면 설정한 색상에 맞게 View의 BackgroundColor를 설정하는 것이 목표입니다.
    func colorActionSheet(colors: [UIColor], title: String, message: String? = nil) -> Observable<UIColor> {
        return Observable.create { [weak self] observer in

            let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

            for color in colors {
                let colorAction = UIAlertAction(title: color.rgbHexString, style: .default) { _ in
                    observer.onNext(color)
                    observer.onCompleted()
                }
                actionSheet.addAction(colorAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                observer.onCompleted()
            }
            actionSheet.addAction(cancelAction)
            self?.present(actionSheet, animated: true, completion: nil)

            return Disposables.create {
                actionSheet.dismiss(animated: true, completion: nil)
            }
        }
    }
}
