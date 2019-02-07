//
//  MapCoordinator.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa
import RxMKMapView
import MapKit

final class MapCoordinator: BaseCoordinator<Void> {

    private let navigationController: UINavigationController
    private let viewController: UIViewController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewController = UIViewController()

        super.init()

        let view = MKMapView()
        viewController.view = view

        let chicagoLocation = CLLocationCoordinate2D(latitude: 41.8781,
                                                     longitude: -87.6298)

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let chicagoRegion = MKCoordinateRegion(center: chicagoLocation, span: span)

        view.setRegion(chicagoRegion, animated: true)

        let chicagoAnnotation = MKPointAnnotation()
        chicagoAnnotation.coordinate = chicagoLocation
        chicagoAnnotation.title = "Chicago"
        chicagoAnnotation.subtitle = "Illinois"

        let annotations = Observable<[MKAnnotation]>.just([chicagoAnnotation])

        annotations.asDriver(onErrorJustReturn: [])
            .drive(view.rx.annotations)
            .disposed(by: self.disposeBag)
    }

    override func start() -> Signal<Void> {
        navigationController.pushViewController(self.viewController, animated: true)
        return .never()
    }
}
