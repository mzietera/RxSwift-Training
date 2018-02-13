//
//  SearchViewModel.swift
//  RxSwiftTraining
//
//  Created by Michał Ziętera on 09.02.2018.
//  Copyright © 2018 Michał Ziętera. All rights reserved.
//

import Foundation
import RxSwift

internal final class SearchViewModel {
    let searchPhrase = Variable<String>("")
    let repositoriesList = Variable<[Repository]>([])

    let apiController = APIController()
    let disposeBag = DisposeBag()

    init() {
        setupBindings()
    }

    func didTapSearchButton() {
        print(searchPhrase.value)
        apiController.fetchResults(for: searchPhrase.value)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                    self?.repositoriesList.value = response.repositories
                }, onError: { [weak self] error in
                    self?.repositoriesList.value.removeAll()
            })
            .disposed(by: disposeBag)

    }

    func setupBindings() {

    }
}
