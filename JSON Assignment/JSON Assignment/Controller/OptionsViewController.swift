//
//  OptionsViewController.swift
//  JSON Assignment
//
//  Created by Mohamad Nehme on 23/03/2021.
//

import UIKit
import CollectionViewPagingLayout

class OptionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndex = Int ()
    let OptionsURL = "http://127.0.0.1:3000/options"
    var decodedOptionsDataArray = [OptionsData]()
    
    var id = ""
    var created_at = ""
    var investment_type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Goal Status"
        self.navigationController?.navigationBar.topItem?.title = ""
        performRequest()
        //CollectionViewPagingLayout.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "OptionCell", bundle: nil), forCellWithReuseIdentifier: "ReusableCell")
        
        //paging
        let layout = CollectionViewPagingLayout()
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 300.0, height: 300.0)
    }
    
    //MARK: - CollectionView Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decodedOptionsDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell", for: indexPath) as! OptionCell
        cell.optionNameLabel.text = decodedOptionsDataArray[indexPath.row].name
        cell.optionNumberLabel.text = "Option \( indexPath.row + 1)"
        let balance = decodedOptionsDataArray[indexPath.row].risk_score * 1000
        cell.optionBalanceLabel.text = String("$ \(balance)")
        cell.optionDescriptionLabel.text = decodedOptionsDataArray[indexPath.row].short_description
        cell.optionSelectedLabel.text = "Selected"
        
//        if selectedIndex == indexPath.row {
//            cell.optionsView.backgroundColor = .blue
//            cell.optionNameLabel.textColor = .white
//            cell.optionNumberLabel.textColor = .white
//            cell.optionBalanceLabel.textColor = .white
//            cell.optionDescriptionLabel.textColor = .white
//            cell.optionSelectedLabel.textColor = .white
//            cell.optionsSelectedImage.image = #imageLiteral(resourceName: "correct")
//        } else {
//            cell.optionsView.backgroundColor = .white
//            cell.optionNameLabel.textColor = .black
//            cell.optionNumberLabel.textColor = .black
//            cell.optionBalanceLabel.textColor = .black
//            cell.optionDescriptionLabel.textColor = .black
//            cell.optionSelectedLabel.textColor = .black
//            cell.optionsSelectedImage.image = #imageLiteral(resourceName: "false")
//        }
        
        return cell
    }
    
    //MARK: - CollectionView Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
//        self.CollectionViewPagingLayout.configureTapOnCollectionView()
//        collectionView.reloadData()
        //performSegue(withIdentifier: "optionToHistoricalDataSegue", sender: self)
//        func zPosition(progress: CGFloat) -> Int{
//            return indexPath.row
//        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! HistoricalDataViewController
        
        
            destinationVC.id = id
            destinationVC.created_at = created_at
            destinationVC.investment_type = investment_type
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            destinationVC.risk_score = decodedOptionsDataArray[indexPath.item].risk_score
        }
    }
    
    //MARK: - Decoding JSON
    
    func performRequest(){
        if let url = URL(string: OptionsURL) {
            
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
            print(decodedOptionsDataArray[0].short_description)
            print(decodedOptionsDataArray[1].short_description)
            print(decodedOptionsDataArray[2].short_description)
            DispatchQueue.main.async {
                // self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
}
