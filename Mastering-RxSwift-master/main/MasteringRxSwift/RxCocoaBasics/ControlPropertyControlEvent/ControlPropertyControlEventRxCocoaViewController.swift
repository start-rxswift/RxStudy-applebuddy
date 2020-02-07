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

class ControlPropertyControlEventRxCocoaViewController: UIViewController {
    let disposeBag = DisposeBag()

    @IBOutlet var colorView: UIView!

    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!

    @IBOutlet var redComponentLabel: UILabel!
    @IBOutlet var greenComponentLabel: UILabel!
    @IBOutlet var blueComponentLabel: UILabel!

    @IBOutlet var resetButton: UIButton!

    private func updateComponentLabel() {
        redComponentLabel.text = "\(Int(redSlider.value))"
        greenComponentLabel.text = "\(Int(greenSlider.value))"
        blueComponentLabel.text = "\(Int(blueSlider.value))"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // UI에 bind처리를 하면 항상 올바른 메인스레드에서 안전하게 동작할 수 있다.
        // Slider Bind
        redSlider.rx.value
            .map { "\(Int($0))" }
            .bind(to: redComponentLabel.rx.text)
            .disposed(by: disposeBag)

        greenSlider.rx.value
            .map { "\(Int($0))" }
            .bind(to: greenComponentLabel.rx.text)
            .disposed(by: disposeBag)

        blueSlider.rx.value
            .map { "\(Int($0))" }
            .bind(to: blueComponentLabel.rx.text)
            .disposed(by: disposeBag)

        // CombinLatest 연산자를 활용하면 여러개의 동작을 간결하게 구현할 수 있다.
        // 슬라이더가 드래그 될 때마다 빨/초/파의 슬라이더 값이 하나의 배열로 방출된다.
        Observable.combineLatest([redSlider.rx.value, greenSlider.rx.value, blueSlider.rx.value])
            .map {
                UIColor(red: CGFloat($0[0]) / 255, green: CGFloat($0[1]) / 255, blue: CGFloat($0[2]) / 255, alpha: 1.0)
            }
            .bind(to: colorView.rx.backgroundColor)
            .disposed(by: disposeBag)

        // 초기화버튼이 tap touchUpInside 이벤트 발생 시 적용되는 기능 구현
        // 해당 코드도 메인스레드에서 실행된다.
        // * 단, 도중에 observeOn 등으로 사용 스레드를 변경하게 되면 중간에 서브스레드에서 코드가 동작할 수도 있다.
        resetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.colorView.backgroundColor = UIColor.black
                self?.redSlider.value = 0
                self?.greenSlider.value = 0
                self?.blueSlider.value = 0
                self?.updateComponentLabel()
            })
            .disposed(by: disposeBag)
    }
}
