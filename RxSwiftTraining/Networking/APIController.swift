//
//  APIController.swift
//  RxSwiftTraining
//
//  Created by Michał Ziętera on 09.02.2018.
//  Copyright © 2018 Michał Ziętera. All rights reserved.
//

import Foundation
import RxSwift

enum APIError: Error {
    case parsingError(Error)
    case connectionError(Error)
}

internal final class APIController {
    private let session: URLSession

    init() {
        self.session = URLSession.shared
    }

    func fetchResults(`for` searchPhrase: String) -> Observable<RepositoriesResponse> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            var urlComponents = URLComponents(string: "https://api.github.com/search/repositories")!
            let queryItem = URLQueryItem(name: "q", value: searchPhrase)
            urlComponents.queryItems = [queryItem]
            let url = urlComponents.url!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let task = self?.session.dataTask(with: request, completionHandler: { (data, response, error) in

                if let error = error {
                    observer.onError(APIError.connectionError(error))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(RepositoriesResponse.self, from: data!)
                    observer.onNext(response)
                    observer.onCompleted()
                } catch {
                    observer.onError(APIError.parsingError(error))
                    return
                }
            })

            task?.resume()
            return Disposables.create()
        })
    }
}
