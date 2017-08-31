//
//  RPRxTableViewController.swift
//  RPRxTableView
//
//  Created by Hoyeon KIM on 2017. 6. 8..
//  Copyright © 2017 rainpour@icloud.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RPRxTableViewController: UIViewController {

    // 꼭 스토리보드에서 UIViewController를 만든 후 TableView를 추가하고 이 해당 아웃렛을 연결해 준 후 사용해야 한다.
    @IBOutlet var tableView: UITableView!

    var refreshControl = UIRefreshControl()
    let disposeBag = DisposeBag()

    var viewModel = RPRxTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    internal func setCommonTableViewActions() {
        self.bindViewModelWithTableView()
        self.setPullToRefreshControl()
        self.setScrollToBottomLoading()
    }

    private func bindViewModelWithTableView() {
        self.viewModel.listItems.asObservable()
            .bind(to: self.tableView.rx.items) { _, _, item in // tableView, index, item
                return self.getTableViewCell(item: item)
            }
            .addDisposableTo(self.disposeBag)
    }

    internal func getTableViewCell(item _: RPRxTableModel) -> UITableViewCell {
        // Override
        return UITableViewCell()
    }

    internal func getNoItemsCell(text: String) -> UITableViewCell {
        let noItemsCell = UITableViewCell.init(style: .default,
                                          reuseIdentifier: "noItemsCell")
        noItemsCell.textLabel?.text = text
        noItemsCell.textLabel?.textColor = UIColor.red
        return noItemsCell
    }

    private func setPullToRefreshControl() {
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            // Fallback on earlier versions
            self.tableView.addSubview(self.refreshControl)
        }
        self.refreshControl.rx
            .controlEvent(.valueChanged)
            .filter {
                self.refreshControl.isRefreshing
            }
            .bind(to: self.viewModel.pullToRefresh)
            .addDisposableTo(self.disposeBag)

        self.viewModel.isEndRefresh
            .bind(onNext: { isEnd in
                if isEnd {
                    self.refreshControl.endRefreshing()
                }
            })
            .addDisposableTo(self.disposeBag)
    }

    private func setScrollToBottomLoading() {
        let marginOfBottomLoading: CGFloat = 40
        self.tableView.rx
            .contentOffset
            .filter({ [unowned self] _ -> Bool in
                return self.tableView.contentSize.height != 0
            })
            .map { [unowned self] offset -> Bool in
                return (offset.y + self.tableView.frame.size.height + marginOfBottomLoading > self.tableView.contentSize.height)
            }
            .subscribe(onNext: { isBottom in
                if isBottom == true {
                    self.viewModel.getTableItems(isFirst: false)
                }
            }, onError: { error in
                preconditionFailure("error[\(error)]")
            })
            .addDisposableTo(self.disposeBag)
    }

    internal func setSelectedTableItem() {
        self.tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.didSelectTableViewCell(indexPath: indexPath)
            })
            .addDisposableTo(self.disposeBag)
    }

    internal func didSelectTableViewCell(indexPath _: IndexPath) {
        // Need Override
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

extension RPRxTableViewController: UITableViewDelegate {

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return 0.01
    }
}
