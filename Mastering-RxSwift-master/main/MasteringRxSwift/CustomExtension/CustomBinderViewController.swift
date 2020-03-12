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

// CustomBinder는 어떻게 활용될 수 있을까요?
import RxCocoa
import RxSwift
import UIKit

class CustomBinderViewController: UIViewController {
    let bag = DisposeBag()
    
    @IBOutlet var valueLabel: UILabel!
    
    @IBOutlet var colorPicker: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        // #1) selectedSegmentIndex에서 방출하는 인덱스에 맞는 색상을 설정하고 Label의 텍스트 속성에 바인딩하고 있습니다.
        //        colorPicker.rx.selectedSegmentIndex
        //            .map { index -> UIColor in
        //                switch index {
        //                case 0:
        //                    return UIColor.red
        //                case 1:
        //                    return UIColor.green
        //                case 2:
        //                    return UIColor.blue
        //                default:
        //                    return UIColor.black
        //                }
        //            }
        //            .subscribe(onNext: { [weak self] color in
        //                self?.valueLabel.textColor = color
        //            })
        //            .disposed(by: bag)
        //
        //        colorPicker.rx.selectedSegmentIndex
        //            .map { index -> String? in
        //                switch index {
        //                case 0:
        //                    return "Red"
        //                case 1:
        //                    return "Green"
        //                case 2:
        //                    return "Blue"
        //                default:
        //                    return "Unknown"
        //                }
        //            }
        //            .bind(to: valueLabel.rx.text)
        //            .disposed(by: bag)
        colorPicker.rx.selectedSegmentIndex
            .bind(to: valueLabel.rx.segmentedValue)
            .disposed(by: bag)
    }
}

// #2) CustomBinder를 통해 더욱더 간결하게 코드를 구현할 수 있습니다.
extension Reactive where Base: UILabel {
    var segmentedValue: Binder<Int> {
        return Binder(self.base) { label, index in
            switch index {
            case 0:
                label.text = "Red"
                label.textColor = UIColor.red
            case 1:
                label.text = "Green"
                label.textColor = UIColor.green
            case 2:
                label.text = "Blue"
                label.textColor = .blue
            default:
                label.text = "Unknown"
                label.textColor = .black
            }
        }
    }
}
