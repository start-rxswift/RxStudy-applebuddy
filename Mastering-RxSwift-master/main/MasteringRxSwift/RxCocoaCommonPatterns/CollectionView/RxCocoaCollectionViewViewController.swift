//
import RxCocoa
import RxSwift
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
import UIKit

class RxCocoaCollectionViewViewController: UIViewController {
    let bag = DisposeBag()
    
    @IBOutlet var listCollectionView: UICollectionView!
    
    // Rx에서는 Observable을 CollectionView와 바인딩합니다.
    // 먼저 바인딩할 Observable을 생성하겠습니다.
    let colorObservable = Observable.of(MaterialBlue.allColors)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorObservable.bind(to: listCollectionView.rx.items(cellIdentifier: "colorCell", cellType: ColorCollectionViewCell.self)) { index, color, cell in
            // 재사용큐에 셀을 꺼내고, 타입캐스팅 하는것까지 자동으로 구성되므로 클로져 내에서는 셀 속성을 구성하면 됩니다.
            cell.backgroundColor = color
            cell.hexLabel.text = color.rgbHexString
        }
        .disposed(by: bag)
        
        // 선택이벤트를 처리할때 indexPath가 필요하면 itemSelected, 모델데이터가 필요하면 modelSelected 메서드를 활용할 수 있습니다.
        listCollectionView.rx.modelSelected(UIColor.self)
            .subscribe(onNext: { color in
                print(color.rgbHexString)
            })
            .disposed(by: bag)
        
        // MARK: #1) tableView와 마찬가지로 Cocoa때처럼 delegate를 설정하면 Rx구현 코드가 제대로 적용되지 않습니다.
        // listCollectionView.delegate = self
        
        // MARK: #2) rx.setDelegate(self)로 델리게이트를 설정하면 정상적으로 나머지 Rx코드도 적용이 되는것을 확인할 수 있습니다.
        listCollectionView.rx.setDelegate(self)
            .disposed(by: bag)
    }
}

extension RxCocoaCollectionViewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let value = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing)) / 2
        return CGSize(width: value, height: value)
    }
}
