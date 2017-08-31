//
//  SampleModel.swift
//  FLTRxTableView
//
//  Created by Hoyeon KIM on 2017. 6. 18..
//  Copyright © 2017년 rainpour@icloud.com. All rights reserved.
//

import UIKit

class SampleModel: RPRxTableModel {
    
    var name = ""
    
    override func setModel(data: [String : AnyObject]) {
        if let name = data["name"] as? String {
            self.name = name
        }
    }
}
