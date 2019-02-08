//
//  CodableModelTests.swift
//  CMFourSquareLayerTests
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import XCTest

typealias JSONDictionary = [String: Any]

private class BundleTests {}

extension XCTestCase {

    var mockDataBundle: Bundle {
        let mockDataBundleURL = Bundle(for: BundleTests.self).url(forResource: "json", withExtension: "bundle")
        return Bundle(url: mockDataBundleURL!)!
    }

    /// Decodes an object from a JSON file.
    /// - Note: Will fail test case and throw a `fatalError` if anything goes wrong
    /// - Parameters:
    ///     - type: The type of object (ex: "User.self")
    ///     - jsonFileName: The name of the JSON file (do not include the '.json' extension)
    /// - Returns: A decoded object of type `T`
    func decodeObject<T>(_ type: T.Type, jsonFileName: String) -> T where T: Decodable {
        guard let payloadURL = mockDataBundle.url(forResource: jsonFileName, withExtension: "json") else {
            XCTFail("Could not find json file with name: \(jsonFileName)")
            fatalError()
        }

        do {
            let data = try Data(contentsOf: payloadURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            XCTFail("Could not decode JSON data: \(error)")
            fatalError()
        }
    }

    enum EncodeError: Error {
        case jsonEncodeFailed
    }

    /// Encodes an object to a JSON dictionary
    /// - Note: Will fail test case and throw a `fatalError` if anything goes wrong
    /// - Parameters:
    ///     - type: The type of object to encode (ex: "User.self")
    ///     - object: The object to encode
    /// - Returns: An encoded `JSONDictionary`
    func encodeObject<T>(_ type: T.Type, object: T) -> JSONDictionary where T: Encodable {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(object)
            guard
                let jsonDictionary = try JSONSerialization
                    .jsonObject(with: data,
                                options: .allowFragments) as? JSONDictionary else {
                                    throw EncodeError.jsonEncodeFailed
            }
            return jsonDictionary
        } catch {
            XCTFail("Couldn't unwrap JSON object")
            fatalError()
        }
    }
}
