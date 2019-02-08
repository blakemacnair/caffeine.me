//
//  VenueDetailViewState.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/7/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import struct CMFourSquareLayer.Venue

enum VenueDetailViewError: Error, Equatable {
    case unknown
}

enum VenueDetailViewState: Equatable {
    case loading
    case ready(Venue)
}

enum VenueDetailViewAction: Equatable {
    case tappedExit
}

enum VenueDetailCoordinatorRequest: Equatable {
    case dismissView
    case displayError(VenueDetailViewError)
}
