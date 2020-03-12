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

// MARK: - Delegate Proxy
// - 이번시간은 Delegate Proxy에 대해서 공부하겠습니다.
// - Delegate Proxy는 Delegate Pattern의 역할을 대신 해주는 객체입니다.
// - Delegate PRoxy의 적용은 처음에는 어려울 수 있지만, 익숙해진다면 거의 모든 부분의 Delegate Pattern을 적용할 수 있습니다.
// - Delegate Pattern은 많이 활용되고 있지만 RxSwift와는 어울리지 않습니다. 물론 사용할 수는 있습니다.
//   - Delegate Pattern을 그대로 사용할 지, Delegate Proxy를 활용할 지는 여러분 선택에 달려 있습니다.

import CoreLocation
import MapKit
import RxCocoa
import RxSwift
import UIKit

class DelegateProxyViewController: UIViewController {
    let bag = DisposeBag()

    @IBOutlet var mapView: MKMapView!

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 13:20) 먼저 사용자로부터 허용을 요청한 다음, 위치정보를 요청하겠습니다.
        // 현재 위치에 대한 맵, 정보를 확인할 수 있습니다.
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.rx.didUpdateLocations
            .subscribe(onNext: { locations in
                print(locations)
            })
            .disposed(by: bag)
        
        // 아래의 코드로 binding이 되면 업데이트된 위치로 mapView가 설정됩니다.
        locationManager.rx.didUpdateLocations
            .map { $0[0] }
            .bind(to: mapView.rx.center)
            .disposed(by: bag)
    }
}

extension Reactive where Base: MKMapView {
    public var center: Binder<CLLocation> {
        return Binder(base) { _, location in
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.base.setRegion(region, animated: true)
        }
    }
}

// 먼저 Delegate Proxy사용하기 위해 첫번째 extension을 구현해보겠습니다.
// CLLocationManager를 확장하는 첫번째 extension은 아래와 같이 구현합니다.
extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

// 이번에는 Delegate Proxy Class를 구현하겠습니다.
// 보통 Rx접두어로 시작하는게 일반적입니다. 이후 확장클래스명 + DelegateProxy이 붙습니다. 그리고 DelegateProxy를 상속해야합니다.
// DelegateProxy는 제네릭클래스이며, 형식 파라미터 두개를 선언해야합니다. 첫번째는 확장할 클래스, 두번째는 연관된 델리게이트 프로토콜로 선언합니다.
class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    // Proxy Class에 새로운 속성을 추가하겠습니다.
    // 여기에서 weak키워드를 사용해 참조순환문제를 방지할 수 있도록 합니다.
    weak private(set) var locationManager: CLLocationManager?
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }
    
    // 필요한시점에 자동으로 호출이 됩니다. Rx는 내부적으로 Proxy Factory를 가지고 있는데 우리가 구현한 Delegate Proxy가 팩토리에 자동으로 등록이 됩니다. 여기까지가 가장 기본적인 Delegate Proxy 부분입니다.
    static func registerKnownImplementations() {
        self.register {
            RxCLLocationManagerDelegateProxy(locationManager: $0)
        }
    }
}

// 마지막으로 Reactive Extention울 구현하겠습니다.
// 아래와 같이 CLLocationManager를 확장합니다.
// 아래 extension 까지가 필수적으로 구현해야하는 부분입니다.
extension Reactive where Base: CLLocationManager {
    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        // 여기에서 Delegate Proxy instance를 반환해야하는데 한가지 주의할 점이 있습니다.
        // * 새로운 인스턴스를 생성할 수 있는데 내부적으로 여러 문제가 생길 수 있습니다. (두개이상 생성되는 인스턴스 등) 그래서 인스턴스를 생성할때는 생성자를 사용하는 것이 아니라 Proxy(for... 메서드를 사용해야합니다.
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    // 나머지는 필요에 따라 추가합니다.
    // didUpdateLocation method가 호출되면 observable을 통해 새로운 위치정보를 방출하도록 구현해보겠습니다.
    // Delegate 속성 아랫쪽에 새로운 속성을 추가해보겠습니다.
    var didUpdateLocations: Observable<[CLLocation]> {
        // 이제 여기서 Observable을 반환해야 합니다.
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map { parameters in
                return parameters[1] as! [CLLocation]
        }
    }
    // 이제 Delegate Proxy가 잘 작동하는지 확인해보겠습니다.
    // * CLLocationManagerDelegate에는 DidFailErrorWith.. 등의 메서드도 있습니다. 이것 되의 자주자용하는 메서드들을 DelegateProxy를 통해 구현해보시기 바랍니다. 
    
}
