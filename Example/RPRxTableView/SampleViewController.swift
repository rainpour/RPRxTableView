//
//  SampleViewController.swift
//  RPRxTableView
//
//  Created by Hoyeon KIM on 2017. 6. 18..
//  Copyright © 2017 rainpour@icloud.com. All rights reserved.
//

import UIKit

class SampleViewController: RPRxTableViewController {

    private var selectedName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = SampleViewModel()
        self.viewModel.getTableItems(isFirst: true)
        self.setCommonTableViewActions()
        self.setSelectedTableItem()
    }
    
    override func getTableViewCell(item: RPRxTableModel) -> UITableViewCell {
        let cellIdentifier = "cell"
        guard let tableItem = item as? SampleModel else {
            return self.getNoItemsCell(text: "no_entry")
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = tableItem.name
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    override func didSelectTableViewCell(indexPath: IndexPath) {
        // Action When Selected Table Item
        guard let selectedCell = self.tableView.cellForRow(at: indexPath) else {
            return
        }
        
        if let selectedCellText = selectedCell.textLabel?.text {
            self.selectedName = selectedCellText
        }
        
        self.performSegue(withIdentifier: "segueToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetail" {
            if let destinationViewController = segue.destination as? SampleDetailViewController {
                destinationViewController.name = self.selectedName
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

