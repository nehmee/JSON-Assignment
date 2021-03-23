//
//  PortfolioViewController.swift
//  JSON Assignment
//
//  Created by Mohamad Nehme on 23/03/2021.
//

import UIKit

class PortfolioViewController: UITableViewController {
    
    let portolioURL = "http://127.0.0.1:3000/portfolios"
    var decodedPortfolioDataArray = [PortfolioData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performRequest()
        self.tableView.tableFooterView = UIView()
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decodedPortfolioDataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioCell", for: indexPath)
        
        cell.textLabel?.text = decodedPortfolioDataArray[indexPath.row].name
        cell.detailTextLabel?.text = String(decodedPortfolioDataArray[indexPath.row].balance) + " $"
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "portfolioToOptionSegue", sender: self)
    }
    
    //MARK: - Decoding JSON
    
    func performRequest(){
        if let url = URL(string: portolioURL) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(portfolioData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(portfolioData: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([PortfolioData].self, from: portfolioData)
            decodedPortfolioDataArray = decodedData
            print(decodedPortfolioDataArray[0])
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
    
}

