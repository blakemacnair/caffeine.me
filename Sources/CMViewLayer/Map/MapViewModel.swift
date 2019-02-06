//
//  MapViewModel.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa

enum MapViewState {
    case loading
    case ready
}

enum MapViewAction {
    case viewLoaded
}

protocol MapViewModelProtocol {
    var actions: PublishRelay<MapViewAction> { get }
    var state: Driver<MapViewState> { get }
}

struct MapViewModel {
    
}
