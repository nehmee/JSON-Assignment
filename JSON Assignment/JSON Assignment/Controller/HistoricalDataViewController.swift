//
//  HistoricalDataViewController.swift
//  JSON Assignment
//
//  Created by Mohamad Nehme on 23/03/2021.
//


import UIKit
import Charts

class HistoricalDataViewController: UIViewController {
    
    @IBOutlet var lineChartView: LineChartView!
    @IBOutlet weak var tableView: UITableView!
    
    var historicalManager = HistoricalManager()
    var id = ""
    var created_at = ""
    var investment_type = ""
    var risk_score = 0
    var myDictionary = [String: String]()
    var keysArray = Array<Any>()
    var valueArray = Array<Any>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        historicalManager.historyDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        appendDictionnary()
        historicalManager.performRequest()
    }
    
    func appendDictionnary(){
        myDictionary["ID"] = id
        myDictionary["Created At"] = created_at
        myDictionary["Investment Type"] = investment_type
        myDictionary["Risk Score"] = String(risk_score)
        keysArray = Array(myDictionary.keys)
        valueArray = Array(myDictionary.values)
        print(myDictionary)
    }
}

//MARK: - Drawing Chart with ChartViewDelegate
extension HistoricalDataViewController: ChartViewDelegate{
    
}

//MARK: - TableView Data Source Methods
extension HistoricalDataViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellNibName, for: indexPath)
        cell.textLabel?.text =  keysArray[indexPath.row] as? String
        cell.detailTextLabel?.text = valueArray[indexPath.row] as? String
        return cell
    }
}

//MARK: - HistoricalDelegate Methods
extension HistoricalDataViewController: HistoricalDelegate {
    func drawChart(sender: HistoricalManager, data: LineChartData) {
        self.lineChartView.data = data
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}






