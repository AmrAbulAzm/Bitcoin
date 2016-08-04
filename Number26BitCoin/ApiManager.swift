//
//  ApiManager.swift
//  Number26BitCoin
//
//  Created by Amr AbulAzm on 23/05/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

class ApiManager: NSObject {
    static let sharedInstance = ApiManager()
    
    let baseURL = "https://api.coindesk.com/v1/bpi/historical/close.json?currency=EUR"
    
    func getBitCoinData(onCompletion: (JSON) -> Void) {
        let route = baseURL
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    //  GET Request
    
    private func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error)
                print("Completed")
            } else {
                onCompletion(nil, error)
                print("Error")
            }
        })
        task.resume()
    }
}
