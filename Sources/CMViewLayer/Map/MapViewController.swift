//
//  MapViewController.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa

import MapKit
import RxMKMapView

final class MapViewController: UIViewController {

    private let rootView = MKMapView()

    private let annotationsRelay = BehaviorRelay<[MKPointAnnotation]>(value: [])
    private let disposeBag = DisposeBag()

    convenience init(viewModel: MapViewModelProtocol) {
        self.init(nibName: nil, bundle: nil)

        annotationsRelay
            .asDriver()
            .drive(rootView.rx.annotations)
            .disposed(by: disposeBag)

        bindEvents(to: viewModel)
        bindToState(from: viewModel)
    }

    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        startUpdatingUserLocation()
    }

    // MARK: - Private

    private func startUpdatingUserLocation() {
        rootView.setUserTrackingMode(.follow, animated: true)
        rootView.rx.didUpdateUserLocation
            .subscribe(onNext: { userloc in
                self.rootView.setUserTrackingMode(.follow, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func bindEvents(to viewModel: MapViewModelProtocol) {

    }

    private func bindToState(from viewModel: MapViewModelProtocol) {
        viewModel.state
            .drive(onNext: { [unowned self] state in
                self.configureView(for: state)
            })
            .disposed(by: disposeBag)
    }

    private func configureView(for state: MapViewState) {
        switch state {
        case .loading:
            break
        case .ready(let annotations):
            self.annotationsRelay.accept(annotations)
        }
    }
}
