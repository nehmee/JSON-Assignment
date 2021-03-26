//
//  HistoricalManager.swift
//  JSON Assignment
//
//  Created by Mohamad Nehme on 25/03/2021.
//

protocol HistoricalDelegate {
    func didCall(data: LineChartData)
    func didFailWithError(error: Error)
}

import Foundation
import Charts

class HistoricalManager {
    var historyDelegate: HistoricalDelegate?
    var decodedHistoricalDataArray = [HistoricalData]()
    var smartWealthValueArray = [Int]()
    var benchmarkValueArray = [Int]()
    
    //MARK: - Decoding JSON
    func performRequest(){
        if let url = URL(string: K.historicalURL) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.historyDelegate?.didFailWithError(error: error!)
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
            self.historyDelegate?.didFailWithError(error: error)
        }
    }
    
    func drawChart(){
        let data = LineChartData()
        
        var lineChartEntry1 = [ChartDataEntry]()
        for i in 0..<smartWealthValueArray.count {
            lineChartEntry1.append(ChartDataEntry(x: Double(i), y: Double(smartWealthValueArray[i]) ))
        }
        let line1 = LineChartDataSet(entries: lineChartEntry1, label: "Smart Wealth Value")
        data.addDataSet(line1)
        print(data)
        print(lineChartEntry1)
        
        if (benchmarkValueArray.count > 0) {
            var lineChartEntry2 = [ChartDataEntry]()
            for i in 0..<benchmarkValueArray.count {
                lineChartEntry2.append(ChartDataEntry(x: Double(i), y: Double(benchmarkValueArray[i]) ))
            }
            let line2 = LineChartDataSet(entries: lineChartEntry2, label: "Bench Mark Value")
            data.addDataSet(line2)
            print(lineChartEntry2)
        }
        
        //self.historyDelegate!.didCall(data: data)
        //self.lineChartView.data = data
    }
    
    
    
    
}
