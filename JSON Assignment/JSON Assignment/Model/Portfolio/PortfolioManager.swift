//
//  PortfolioManager.swift
//  JSON Assignment
//
//  Created by Mohamad Nehme on 23/03/2021.
//

protocol UpdateDelegate {
    func didUpdate(sender: PortfolioManager)
}

import Foundation
class PortfolioManager {
    var decodedPortfolioDataArray = [PortfolioData]()
    var delegate: UpdateDelegate?
    
    
    //MARK: - Decoding JSON
    func performRequest(){
        if let url = URL(string: K.portolioURL) {
            
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
            //print(decodedPortfolioDataArray[0])
            self.delegate!.didUpdate(sender: self)
        } catch {
            print(error)
        }
    }
    
}
