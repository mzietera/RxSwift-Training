//
//  ViewController+Alert.swift
//  RxSwiftTraining
//
//  Created by Michał Ziętera on 29.01.2018.
//  Copyright © 2018 Michał Ziętera. All rights reserved.
//

import UIKit
import RxSwift

extension ViewController {

    func showAlert(with title: String?, andMessage msg: String?) -> Observable<Void> {
        let observable = Observable<Void>.create { (observer) -> Disposable in
            let alertCon = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .default) { (action) in
                observer.onCompleted()
            }
            alertCon.addAction(closeAction)
            self.present(alertCon, animated: true, completion: nil)
            return Disposables.create {
                alertCon.dismiss(animated: true, completion: nil)
            }
        }
        return observable
    }

}
