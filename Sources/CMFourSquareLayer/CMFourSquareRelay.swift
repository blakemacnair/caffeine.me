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
import class CoreLocation.CLLocation

public enum CMFourSquareRelayError: Equatable, Error {
    case couldNotDecodeResponse
    case invalidResponse
    case clientSideError
    case unknown
}

public protocol CMFourSquareRelayProtocol {
    func coffeeShopsNear(location: CLLocation, limit: Int, radius: Int) -> Observable<[Venue]>
}

public final class CMFourSquareRelay: CMFourSquareRelayProtocol {

    // MARK: - Properties

    private let client: HttpClient
    private let disposeBag = DisposeBag()

    private let clientID = "MEKWFEJD1WCVDO4WREKDW0D5VMVACYVQXZVSWEGY5L320CRM"
    private let clientSecret = "1B2NPOFD5BBVCYHYZEZNSXUMZRCZBLX002SOU5XHTY10KEMZ"
    private let version = "20180901"

    // MARK: - Init

    public init() {
        self.client = HttpClient()
    }

    // MARK: - Public

    public func coffeeShopsNear(location: CLLocation,
                                limit: Int = 50,
                                radius: Int = 1000) -> Observable<[Venue]> {
        let params = generateSearchParameters(location: location,
                                              limit: limit,
                                              radius: radius,
                                              categoryID: Category.CoffeeShop.id)

        let url = CMFourSquareURLGenerator.venueSearchEndpoint(parameters: params)
        return client.requestData(url: url)
            .decode(VenueSearchResponse.self)
            .map { $0.response.venues }
            .catchError({ error in
                switch error {
                case HttpClientError.clientSideError(_): return .error(CMFourSquareRelayError.clientSideError)
                case HttpClientError.invalidResponse(_, _): return .error(CMFourSquareRelayError.invalidResponse)
                default: return .error(CMFourSquareRelayError.unknown)
                }
            })
    }

    // MARK: - Private

    private func generateSearchParameters(location: CLLocation,
                                          limit: Int,
                                          radius: Int,
                                          categoryID: String) -> [String: String] {
        let params: [String: String] = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "v": version,
            "ll": "\(location.coordinate.latitude),\(location.coordinate.longitude)",
            "intent": "browse",
            "limit": "\(limit)",
            "radius": "\(radius)",
            "categoryId": categoryID
        ]
        return params
    }
}

private extension Observable where E == Data {
    func decode<T>(_ class: T.Type) -> Observable<T> where T: Codable {
        return self.flatMap { data -> Observable<T> in
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                return .just(response)
            } catch {
                assertionFailure("Error decoding response: \(error.localizedDescription)")
                return .error(CMFourSquareRelayError.couldNotDecodeResponse)
            }
        }
    }
}
