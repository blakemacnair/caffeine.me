//
//  Category.swift
//  CMFourSquareLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

public struct Category: Equatable & Codable {
    internal let id: String
    public let name: String
    public let pluralName: String?
    public let shortName: String?
    public let primary: Bool

    public init(id: String,
                name: String,
                pluralName: String? = nil,
                shortName: String? = nil,
                primary: Bool) {
        self.id = id
        self.name = name
        self.pluralName = pluralName
        self.shortName = shortName
        self.primary = primary
    }
}

public extension Category {
    public static let CoffeeShop = Category(id: "4bf58dd8d48988d1e0931735", name: "Coffee Shop", primary: true)
}
