//
//  APIController.swift
//  RxSwiftTraining
//
//  Created by Michał Ziętera on 09.02.2018.
//  Copyright © 2018 Michał Ziętera. All rights reserved.
//

import Foundation
import RxSwift

internal final class APIController {
    func fetchResults(`for` searchPhrase: String) -> Observable<Any?> {
        let url = URL(string: "https://api.github.com/search/repositories?q=tetris")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return URLSession.shared.rx.data(request: request).map { (data) -> Any in
            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return json
        }
    }
}
