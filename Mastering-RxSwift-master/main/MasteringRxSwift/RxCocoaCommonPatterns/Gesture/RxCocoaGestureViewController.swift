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

// 이번에는 Rx를 활용해서 Gesture를 사용해보겠습니다.
// 우선 CocoaTouch로 구현된 예제를 보겠습니다.

import RxCocoa
import RxSwift
import UIKit

class RxCocoaGestureViewController: UIViewController {
    let bag = DisposeBag()

    @IBOutlet var targetView: UIView!

    @IBOutlet var panGesture: UIPanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // viewDidLoad에서 이벤트속성에 구독자를 추가하겠습니다.
        targetView.center = view.center
        
        panGesture.rx.event
            .subscribe(onNext: { [unowned self] gesture in
                // 코코아터치와 마찬가지로 center속성을 이동한 거리만큼 업데이트 하겠습니다.
                guard let target = gesture.view else { return }
                let translation = gesture.translation(in: self.view)
                target.center.x += translation.x
                target.center.y += translation.y
                gesture.setTranslation(.zero, in: self.view)
            })
            .disposed(by: bag)
    }
}
