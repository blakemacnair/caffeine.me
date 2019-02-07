//
//  CMFourSquareRelay.swift
//  CMFourSquareLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa
import RxHttpClient

public protocol CMFourSquareRelayProtocol {
    var coffeeShopsWithinRadius: Observable<Any> { get }
}

public final class CMFourSquareRelay {
    private let client: HttpClient
    private let disposeBag = DisposeBag()

    private let clientID = "MEKWFEJD1WCVDO4WREKDW0D5VMVACYVQXZVSWEGY5L320CRM"
    private let clientSecret = "1B2NPOFD5BBVCYHYZEZNSXUMZRCZBLX002SOU5XHTY10KEMZ"

    public init() {
        self.client = HttpClient()
        testCall()
    }

    private func testCall() {
        let baseURLString = "https://api.foursquare.com/v2"
        let endpoint = "venues/explore"
        let params: [String: String] = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "v": "20180323",
            "ll": "40.7243,-74.0018",
            "query": "coffee",
            "limit": "1"
        ]

        var url = URL(baseUrl: baseURLString, parameters: params)!
        url.appendPathComponent(endpoint)
        client.requestJson(url: url)
            .subscribe(onNext: { json in
                /* do something with returned data */
                print(json)
            }, onError: { error in
                switch error {
                case HttpClientError.clientSideError(_): break
                case HttpClientError.invalidResponse(_, _): break
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
}
