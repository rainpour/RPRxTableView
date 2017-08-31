//
//  SampleViewModel.swift
//  RPRxTableView
//
//  Created by Hoyeon KIM on 2017. 6. 18..
//  Copyright © 2017 rainpour@icloud.com. All rights reserved.
//

import UIKit

class SampleViewModel: RPRxTableViewModel {
    private let URL = "https://api.punkapi.com/v2/beers/"
    
    override func refreshTableItems() {
        super.refreshTableItems()
        self.getListItems(url: URL,
                          isFirst: true)
    }
    
    override func getTableItems(isFirst: Bool) {
        super.getTableItems(isFirst: isFirst)
        self.getListItems(url: URL,
                          isFirst: isFirst)
    }
    
    override func getModel(data: [String: AnyObject]) -> RPRxTableModel? {
        return SampleModel()
    }
}
