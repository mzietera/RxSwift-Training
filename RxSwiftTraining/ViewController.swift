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

    @IBOutlet weak var tableView: UITableView!

    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for repositories"
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

        viewModel.repositoriesList.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "RepositoryCell")) { index, model, cell in
                cell.textLabel?.text = model.name
                cell.detailTextLabel?.text = model.ownerLogin
            }
            .disposed(by: disposeBag)
    }
}
