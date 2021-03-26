//
//  OptionsManager.swift
//  JSON Assignment
//
//  Created by Mohamad Nehme on 25/03/2021.
//

import Foundation
class OptionsManager {
    var decodedOptionsDataArray = [OptionsData]()
    
    //MARK: - Decoding JSON
    func performRequest(){
        if let url = URL(string: K.OptionsURL) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(optionsData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(optionsData: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([OptionsData].self, from: optionsData)
            decodedOptionsDataArray = decodedData
            //            print(decodedOptionsDataArray[0].short_description)
            //            print(decodedOptionsDataArray[1].short_description)
            //            print(decodedOptionsDataArray[2].short_description)
            DispatchQueue.main.async {
                // self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
}
