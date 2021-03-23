//
//  HistoricalDataViewController.swift
//  JSON Assignment
//
//  Created by Mohamad Nehme on 23/03/2021.
//

import UIKit
import Charts

class HistoricalDataViewController: UIViewController {
 
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var riskScoreLabel: UILabel!
    @IBOutlet weak var investmentTypeLabel: UILabel!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var decodedHistoricalDataArray = [HistoricalData]()
    var smartWealthValueArray = [Int]()
    var benchmarkValueArray = [Int]()
    
    let historicalURL = "http://127.0.0.1:3000/historical_data"
    var id = ""
    var created_at = ""
    var investment_type = ""
    var risk_score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        idLabel.text = id
        creationDateLabel.text = created_at
        investmentTypeLabel.text = investment_type
        riskScoreLabel.text = String(risk_score)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        performRequest()
    }
    
//MARK: - Decoding JSON
    func performRequest(){
        if let url = URL(string: historicalURL) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(historicalData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(historicalData: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([HistoricalData].self, from: historicalData)
            decodedHistoricalDataArray = decodedData
            print(decodedHistoricalDataArray[0].smartWealthValue)
            
            for i in 0...decodedHistoricalDataArray.count - 1{
                smartWealthValueArray.append(decodedHistoricalDataArray[i].smartWealthValue)
                benchmarkValueArray.append(decodedHistoricalDataArray[i].benchmarkValue)
                //print(smartWealthValueArray)
                //print(benchmarkValueArray)
            }
            DispatchQueue.main.async {
                self.drawChart()
            }
            
        } catch {
            print(error)
        }
    }
}

//MARK: - Drawing Chart with ChartViewDelegate
extension HistoricalDataViewController: ChartViewDelegate{
    func drawChart(){
        let data = LineChartData()
        var lineChartEntry1 = [ChartDataEntry]()

        for i in 0..<smartWealthValueArray.count {
            lineChartEntry1.append(ChartDataEntry(x: Double(i), y: Double(smartWealthValueArray[i]) ))
        }
        let line1 = LineChartDataSet(entries: lineChartEntry1, label: "Smart Wealth Value")
        data.addDataSet(line1)
        if (benchmarkValueArray.count > 0) {
            var lineChartEntry2 = [ChartDataEntry]()
            for i in 0..<benchmarkValueArray.count {
                lineChartEntry2.append(ChartDataEntry(x: Double(i), y: Double(benchmarkValueArray[i]) ))
            }
            let line2 = LineChartDataSet(entries: lineChartEntry2, label: "Bench Mark Value")
        data.addDataSet(line2)
        }
        self.lineChartView.data = data
    }
}
