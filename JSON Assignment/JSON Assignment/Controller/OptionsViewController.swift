//
//  OptionsViewController.swift
//  JSON Assignment
//
//  Created by Mohamad Nehme on 23/03/2021.
//

import UIKit
import CollectionViewPagingLayout

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var continueButton: UIButton!
    
    var optionsManager = OptionsManager()
    
    var id = ""
    var created_at = ""
    var investment_type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.isEnabled = false
        self.title = "Goal Status"
        self.navigationController?.navigationBar.topItem?.title = ""
        configureCells()
    }
    
    func configureCells(){
        optionsManager.performRequest()
        //CollectionViewPagingLayout.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: K.optionsCellNibName, bundle: nil), forCellWithReuseIdentifier: K.cellIdentifier)
        
        //paging
        let layout = CollectionViewPagingLayout()
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
    }
}

//MARK: - CollectionView Datasource Methods
extension OptionsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionsManager.decodedOptionsDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellIdentifier, for: indexPath) as! OptionCell
        cell.optionNameLabel.text = optionsManager.decodedOptionsDataArray[indexPath.row].name
        cell.optionNumberLabel.text = "Option \( indexPath.row + 1)"
        let balance = optionsManager.decodedOptionsDataArray[indexPath.row].risk_score * 1000
        cell.optionBalanceLabel.text = String("$ \(balance)")
        cell.optionDescriptionLabel.text = optionsManager.decodedOptionsDataArray[indexPath.row].short_description
        cell.optionSelectedLabel.text = "Selected"
        
        return cell
    }
}

//MARK: - CollectionView Delegate Methods
extension OptionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell:OptionCell = collectionView.cellForItem(at: indexPath)! as! OptionCell
        if selectedCell.optionsView.backgroundColor == .white {
            continueButton.isEnabled = true
            selectedCell.optionsView.backgroundColor = .systemBlue
            selectedCell.optionBalanceLabel.textColor = .white
            selectedCell.optionNameLabel.textColor = .white
            selectedCell.optionNumberLabel.textColor = .white
            selectedCell.optionDescriptionLabel.textColor = .white
            selectedCell.optionSelectedLabel.textColor = .white
            selectedCell.lineView.backgroundColor = .white
            selectedCell.optionsSelectedImage.image = #imageLiteral(resourceName: "correct")
        }
        else {
            continueButton.isEnabled = false
            selectedCell.optionsView.backgroundColor = .white
            selectedCell.optionBalanceLabel.textColor = .black
            selectedCell.optionNameLabel.textColor = .black
            selectedCell.optionNumberLabel.textColor = .black
            selectedCell.optionDescriptionLabel.textColor = .black
            selectedCell.optionSelectedLabel.textColor = .black
            selectedCell.lineView.backgroundColor = .black
            selectedCell.optionsSelectedImage.image = #imageLiteral(resourceName: "false")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell:OptionCell = collectionView.cellForItem(at: indexPath)! as! OptionCell
        selectedCell.optionsView.backgroundColor = .white
        selectedCell.optionBalanceLabel.textColor = .black
        selectedCell.optionNameLabel.textColor = .black
        selectedCell.optionNumberLabel.textColor = .black
        selectedCell.optionDescriptionLabel.textColor = .black
        selectedCell.optionSelectedLabel.textColor = .black
        selectedCell.lineView.backgroundColor = .black
        selectedCell.optionsSelectedImage.image = #imageLiteral(resourceName: "false")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! HistoricalDataViewController
        destinationVC.id = id
        destinationVC.created_at = created_at
        destinationVC.investment_type = investment_type
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            destinationVC.risk_score = optionsManager.decodedOptionsDataArray[indexPath.item].risk_score
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout Methods
extension OptionsViewController: UICollectionViewDelegateFlowLayout{
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        return CGSize(width: 300.0, height: 300.0)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }
}
