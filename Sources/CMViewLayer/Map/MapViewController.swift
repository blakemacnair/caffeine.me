//
//  MapViewController.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift

import MapKit
import RxMKMapView

final class MapViewController: UIViewController {

    private let rootView = MKMapView()

    private let disposeBag = DisposeBag()

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        let chicagoLocation = CLLocationCoordinate2D(latitude: 41.8781,
                                                     longitude: -87.6298)

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let chicagoRegion = MKCoordinateRegion(center: chicagoLocation, span: span)

        rootView.setRegion(chicagoRegion, animated: true)

        let chicagoAnnotation = MKPointAnnotation()
        chicagoAnnotation.coordinate = chicagoLocation
        chicagoAnnotation.title = "Chicago"
        chicagoAnnotation.subtitle = "Illinois"

        rootView.setUserTrackingMode(.follow, animated: true)

        let annotations = Observable<[MKAnnotation]>.just([chicagoAnnotation])

        annotations.asDriver(onErrorJustReturn: [])
            .drive(rootView.rx.annotations)
            .disposed(by: self.disposeBag)
    }
}
