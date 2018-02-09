//
//  ViewController.swift
//  RxSwiftTraining
//
//  Created by Michał Ziętera on 19.01.2018.
//  Copyright © 2018 Michał Ziętera. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

internal final class ViewController: UIViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        setupBindings()
    }

    private func setupBindings() {
        searchController.searchBar.rx.text
            .orEmpty
            .bind(to: viewModel.searchPhrase)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.viewModel.didTapSearchButton()
            })
            .disposed(by: disposeBag)
    }
}
