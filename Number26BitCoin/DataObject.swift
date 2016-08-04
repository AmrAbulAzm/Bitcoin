//
//  DataObject.swift
//  Number26BitCoin
//
//  Created by Amr AbulAzm on 23/05/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataObject {
    
    
    var valuesArray = [Double]()
    var keysArray = [String]()
    
    
    
    required init(json: JSON) {
        if let results = json["bpi"].dictionary {
            for (key, value) in results {
                valuesArray.append(value.double!)
                keysArray.append(key)
            }
        }
    }
}
