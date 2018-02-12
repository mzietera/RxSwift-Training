//
//  RepositoriesResponse.swift
//  RxSwiftTraining
//
//  Created by Michał Ziętera on 12.02.2018.
//  Copyright © 2018 Michał Ziętera. All rights reserved.
//

import Foundation

struct RepositoriesResponse: Decodable {
    private (set) var repositories: [Repository] = []

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        var itemsContainer = try container.nestedUnkeyedContainer(forKey: .items)
        guard let count = itemsContainer.count, count > 0 else { return }
        while !itemsContainer.isAtEnd {
            let itemContainer = try itemsContainer.nestedContainer(keyedBy: ItemsKeys.self)
            let name = try itemContainer.decode(String.self, forKey: .name)
            let ownerContainer = try itemContainer.nestedContainer(keyedBy: OwnerKeys.self, forKey: .owner)
            let ownerLogin = try ownerContainer.decode(String.self, forKey: .login)
            let repository = Repository(name: name, ownerLogin: ownerLogin)
            repositories.append(repository)
        }
    }
}

extension RepositoriesResponse {
    enum RootKeys: String, CodingKey {
        case items
    }

    enum ItemsKeys: String, CodingKey {
        case name
        case owner
    }

    enum OwnerKeys: String, CodingKey {
        case login
    }
}
