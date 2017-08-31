//
//  RPRxTableViewModel.swift
//  RPRxTableView
//
//  Created by Hoyeon KIM on 2017. 6. 18..
//  Copyright © 2017 rainpour@icloud.com. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire

class RPRxTableViewModel: NSObject {

    let MAX_FETCH_COUNT = 20
    var afterPage = 0
    var isStopLoading = false
    var isLoading = false
    var listItems: Variable<[RPRxTableModel]> = Variable([])
    let disposeBag = DisposeBag()

    var pullToRefresh = PublishSubject<Void>()
    var isEndRefresh: Observable<Bool> {
        return self.pullToRefresh.asObservable()
            .flatMapLatest { _ -> Observable<()> in
                return Observable.just(self.refreshTableItems())
            }
            .map { _ -> Bool in
                return true
            }
    }

    func refreshTableItems() {
        // override
    }

    func getTableItems(isFirst _: Bool) {
        // override
    }

    func getListItems(url: String,
                      isFirst: Bool) {
        guard self.canGetItems(isFirst: isFirst) else {
            return
        }
        self.isLoading = true

        if isFirst {
            self.afterPage = 0
        }

        self.requestItems(url: url)
            .subscribe(onNext: { response, json in
                if let jsonObject = json as? [[String: AnyObject]] {
                    if isFirst == true {
                        self.listItems.value.removeAll()
                        if jsonObject.count == 0 {
                            let noItemValue = RPRxTableModel()
                            self.listItems.value.append(noItemValue)
                        }
                    }

                    self.isStopLoading = jsonObject.count < self.MAX_FETCH_COUNT

                    self.afterPage += 1

                    for item in jsonObject {
                        self.setItem(data: item)
                    }
                }
            }, onError: { error in
                preconditionFailure("error[\(error)]")
            }, onCompleted: {
                self.isLoading = false
            })
            .addDisposableTo(self.disposeBag)
    }

    private func canGetItems(isFirst: Bool) -> Bool {
        return (isFirst == true || self.isStopLoading == false) && self.isLoading == false
    }

    private func setItem(data: [String: AnyObject]) {
        if let model = self.getModel(data: data) {
            model.setModel(data: data)
            self.listItems.value.append(model)
        }
    }

    internal func getModel(data: [String: AnyObject]) -> RPRxTableModel? {
        // Child classes have to implement this if needed.
        return nil
    }

    private func requestItems(url: String) -> Observable<(HTTPURLResponse, Any)> {
        let httpMethod: HTTPMethod = .get
        let parameters = self.getListBasicParameter()
        let headers = ["Content-Type": "application/json"]


        return RxAlamofire.requestJSON(httpMethod,
                                       url,
                                       parameters: parameters,
                                       encoding: URLEncoding(),
                                       headers: headers)
    }

    private func getListBasicParameter() -> [String: AnyObject] {
        var parameters = [String: AnyObject]()

        if self.afterPage > 0 {
            parameters["page"] = self.afterPage as AnyObject
        }

        return parameters
    }
}
