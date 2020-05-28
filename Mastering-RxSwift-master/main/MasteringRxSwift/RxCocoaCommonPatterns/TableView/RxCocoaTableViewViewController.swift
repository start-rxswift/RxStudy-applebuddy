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

class RxCocoaTableViewViewController: UIViewController {
    @IBOutlet var listTableView: UITableView!

    let priceFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = NumberFormatter.Style.currency
        f.locale = Locale(identifier: "Ko_kr")

        return f
    }()

    // * Rx에서는 테이블뷰에 바인딩할 옵저바블이 필요합니다. 그리고 이 옵저버블은 테이블뷰에 표시할 데이터를 방출합니다.
    // * cell의 itemSelected는 셀이 선택될 때 next 이벤트를 방출합니다. 셀을 선택했을 때 indexPath가 필요하다면 이 속성을 활용할 수 있습니다.

    let bag = DisposeBag()

    // 문자열을 생성할때 사용되는 Observable을 생성합니다.
    let nameObservable = Observable.of(appleProducts.map { $0.name })

    // 제품목록을 표시할때 사용되는 Observable을 생성합니다.
    let productObservable = Observable.of(appleProducts)

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         // MARK: - #1
         // main Observable과 tableView 를 바인딩 하겠습니다.
         // 바인딩을 통해 셀에 데이터를 표시합니다.
         nameObservable.bind(to: listTableView.rx.items) { tableView, row, element in
         let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell")!
         cell.textLabel?.text = element
         return cell
         }
         .disposed(by: bag)
         */

        //        // MARK: - #2
        //        // 이번에는 cellIdentifier를 items의 parameter로 전달했습니다.
        //        // 클로져로 전달되는 매개변수는 이전과 좀더 달라집니다.
        //        // #1 에 비해서 훨씬 간결한 코드를 보여줍니다.
        //        nameObservable.bind(to: listTableView.rx.items(cellIdentifier: "standardCell")) { row, element, cell in
        //            cell.textLabel?.text = element
        //        }
        //        .disposed(by: bag)

        // MARK: - #3

        // 이번에는 productObservable과 바인딩 해보겠습니다.
        // #3에서는 커스텀셀(ProductTableViewCell) 을 통해서 제품에 대한 상세정보가 표기됩니다.
        // cellType을 지정해 타입캐스팅을 할 수 있다. 이렇게 이후에 별도의 tableViewCell 타입캐스팅이 불필요해 진다.
        productObservable.bind(to: listTableView.rx.items(cellIdentifier: "productCell", cellType: ProductTableViewCell.self)) { [weak self] _, element, cell in
            cell.categoryLabel.text = element.category
            cell.productNameLabel.text = element.name
            cell.summaryLabel.text = element.summary
            cell.priceLabel.text = self?.priceFormatter.string(for: element.price)
        }
        .disposed(by: bag)

        //        // 매개변수로 Product 타입을 전달했습니다. 이곳에 새로운 구독자를 추가하고 상품이름을 콘솔에 출력하겠습니다.
        //        listTableView.rx.modelSelected(Product.self)
        //            .subscribe(onNext: { product in
        //                // 셀이 선택 되었을때 선택한 셀을 콘솔에 출력합니다.
        //                print(product.name)
        //            })
        //            .disposed(by: bag)
        //
        //        listTableView.rx.itemSelected
        //            .subscribe(onNext: { [weak self] indexPath in
        //                self?.listTableView.deselectRow(at: indexPath, animated: true)
        //            })
        //            .disposed(by: bag)

        // modelSelected, itemSelected를 하나의 작업으로 합쳐서 구현해보겠습니다.
        // 이들은 모두 ControlEvent를 반환합니다. 선택된 셀에 맞는 항상 매칭되는 데이터를 방출합니다. 이 경우 zip 연산자를 활용할 수 있습니다.
        // 선택이벤트를 처리하면서 데이터가 필요하면 modelSelected를 활용합니다. 그게 아니라면 itemSelected를 활용할 수 있습니다. 아래와 같이 zip연산자를 활용해서 동시에 활용할 수도 있습니다.
        Observable.zip(listTableView.rx.modelSelected(Product.self), listTableView.rx.itemSelected)
            .bind { [weak self] product, indexPath in
                self?.listTableView.deselectRow(at: indexPath, animated: true)
                print(product.name)
            }
            .disposed(by: bag)

        // #1 CocoaTouch의 델리게이트 구현 예시)
        // * CocoaTouch 방식으로 델리게이트 패턴을 구현하면, 관련한 Rx코드는 더이상 동작하지 않습니다.

        // listTableView.delegate = self

        // #2 Rx 델리게이트 구현 예시)
        // Rx코드와 델리게이트 함수가 동시에 적용되는 것을 확인할 수 있습니다.
        listTableView.rx.setDelegate(self)
            .disposed(by: bag)
    }
}

extension RxCocoaTableViewViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        print(#function) // tableView(_:didSelectRowAt) 콘솔 출력
    }
}
