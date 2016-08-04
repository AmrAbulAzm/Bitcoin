//
//  ViewController.swift
//  Number26BitCoin
//
//  Created by Amr AbulAzm on 23/05/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

import UIKit
import SwiftyJSON
import Charts



class ViewController: UIViewController {
    
    var dataObject: DataObject?
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var barChartView2: BarChartView!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let valuesArrayKey = "ValuesArrayKey"
    let keysArrayKey = "KeysArrayKey"
    
    let description1 = "Current Data"
    let description2 = "Last Fetched"
    
    var valuesArray2 : [Double] = []
    var keysArray2 : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        barChartView.backgroundColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1)
        refreshData()
        loadData()
        setChart(keysArray2, values: valuesArray2, barChartView: barChartView, descriptionText: description2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let btn = UIButton(frame: CGRect(x: 0, y: 25, width: self.view.frame.width, height: 50))
        btn.backgroundColor = UIColor(red: 102/255, green: 205/255, blue: 204/255, alpha: 1)
        btn.setTitle("Refresh Data", forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(ViewController.refreshData), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
    }
    
    
    // run api manager and call for plotting the chart
    
    func refreshData() {
        ApiManager.sharedInstance.getBitCoinData { (json: JSON) in
            self.dataObject = DataObject(json: json)
        }
        
        if let dataObject = self.dataObject {
            setChart(keysArray2, values: valuesArray2, barChartView: barChartView, descriptionText: description2)
            setChart(dataObject.keysArray, values: dataObject.valuesArray, barChartView: barChartView2, descriptionText: description1)
        }
        
        cacheData()
    }
    
    // cache and load data
    
    func cacheData() {
        if let dataObject = self.dataObject {
            defaults.setObject(dataObject.valuesArray, forKey: valuesArrayKey)
            defaults.setObject(dataObject.keysArray, forKey: keysArrayKey)
        }
    }
    
    func loadData() {
        valuesArray2 = defaults.objectForKey(valuesArrayKey) as? [Double] ?? [Double]()
        keysArray2 = defaults.objectForKey(keysArrayKey) as? [String] ?? [String]()
        //setChart(keysArray2, values: valuesArray2, barChartView: barChartView)
    }
    
    // plot chart
    func setChart(dataPoints: [String], values: [Double], barChartView: BarChartView, descriptionText : String) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        if let dataObject = self.dataObject {
            let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Bitcoin Value")
            let chartData = BarChartData(xVals: dataObject.keysArray, dataSet: chartDataSet)
            barChartView.data = chartData
            barChartView.descriptionText = descriptionText
            barChartView.noDataTextDescription = ""
            barChartView.animate(xAxisDuration: 4.0, yAxisDuration: 4.0, easingOption: .EaseInBounce)
            chartDataSet.colors = [UIColor(red: 102/255, green: 205/255, blue: 204/255, alpha: 1)]
        }
    }
}

