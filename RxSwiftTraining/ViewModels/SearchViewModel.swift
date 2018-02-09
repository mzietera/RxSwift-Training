//
//  SearchViewModel.swift
//  RxSwiftTraining
//
//  Created by Michał Ziętera on 09.02.2018.
//  Copyright © 2018 Michał Ziętera. All rights reserved.
//

import Foundation
import RxSwift

internal struct SearchViewModel {
    let searchPhrase = Variable<String>("")

    let apiController = APIController()
    let disposeBag = DisposeBag()

    func didTapSearchButton() {
        print(searchPhrase.value)
        apiController.fetchResults(for: searchPhrase.value)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                    print(response)
                }, onError: { error in
                    print(error)
            })
            .disposed(by: disposeBag)

    }
}
