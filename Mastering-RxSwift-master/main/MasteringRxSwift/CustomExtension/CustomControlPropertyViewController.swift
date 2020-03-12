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

class CustomControlPropertyViewController: UIViewController {
    let bag = DisposeBag()

    @IBOutlet var resetButton: UIBarButtonItem!

    @IBOutlet var whiteSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

//        // #1) 아래의 value값은 값을 방출하는 옵저버블로 사용할 수도 있고, 바인딩 대상이 되는 옵저버로 사용될 수도 있습니다.
//        // Binder로는 쓰기만 사용할때 구현 가능합니다.
//        // 쓰기만 사용할때는 바인더로 구현, 읽기/쓰기가 모두 필요할 경우 ControlProperty로 구현할 수 있습니다.
//        whiteSlider.rx.value
//            .map { UIColor(white: CGFloat($0), alpha: 1.0) }
//            .bind(to: view.rx.backgroundColor)
//            .disposed(by: bag)
//
//        resetButton.rx.tap
//            .map { Float(0.5) }
//            .bind(to: whiteSlider.rx.value)
//            .disposed(by: bag)
//
//        resetButton.rx.tap
//            .map { UIColor(white: 0.5, alpha: 1.0) }
//            .bind(to: view.rx.backgroundColor)
//            .disposed(by: bag)
        
        // color, background 속성을 바인딩하겠습니다.
        // ControlProperty를 통해 backgroundColor, Color 속성을 보다 효율적으로 관리할 수 있습니다.
        whiteSlider.rx.color
            .bind(to: view.rx.backgroundColor)
            .disposed(by: bag)
        
        // 아래와 같이 bind to observer로 두개이상의 옵저버를 전달할 수 있습니다.
        resetButton.rx.tap
            .map { _ in UIColor(white: 0.5, alpha: 1.0) }
            .bind(to: whiteSlider.rx.color.asObserver(), view.rx.backgroundColor.asObserver())
            .disposed(by: bag)
    }
}

extension Reactive where Base: UISlider {
    // #2) ControlProperty의 활용
    var color: ControlProperty<UIColor?> {
        // event parameter : valueChanged로 설정
        // getter : value 속성으로 UIColor를 생성 후 리턴
        // setter : UIColor에서 white 컴포넌트를 추춘 후 value속성에 저장한다.
        return base.rx.controlProperty(editingEvents: .valueChanged, getter: { (slider) in
            UIColor(white: CGFloat(slider.value), alpha: 1.0)
        }) { (slider, color) in
            var white = CGFloat(1)
            color?.getWhite(&white, alpha: nil)
            slider.value = Float(white)
        }
    }
}
