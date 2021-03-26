//
//  PortfolioViewController.swift
//  JSON Assignment
//
//  Created by Mohamad Nehme on 23/03/2021.
//

import UIKit

class PortfolioViewController: UITableViewController {
    
    var portfolioManager = PortfolioManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        portfolioManager.delegate = self
        self.title = "Home"
        portfolioManager.performRequest()
        self.tableView.tableFooterView = UIView()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return portfolioManager.decodedPortfolioDataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellNibName, for: indexPath)
        
        cell.textLabel?.text = portfolioManager.decodedPortfolioDataArray[indexPath.row].name
        cell.detailTextLabel?.text = String(portfolioManager.decodedPortfolioDataArray[indexPath.row].balance) + " $"
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.optionSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! OptionsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.id = portfolioManager.decodedPortfolioDataArray[indexPath.row].id
            destinationVC.created_at = portfolioManager.decodedPortfolioDataArray[indexPath.row].created_at
            destinationVC.investment_type = portfolioManager.decodedPortfolioDataArray[indexPath.row].investment_type
        }
    }
}

//MARK: - Update Delegate Methods
extension PortfolioViewController: UpdateDelegate {
    func didUpdate(sender: PortfolioManager) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

