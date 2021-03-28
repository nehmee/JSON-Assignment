//
//  OptionCell.swift
//  JSON Assignment
//
//  Created by Mohamad Nehme on 23/03/2021.
//

import UIKit
import CollectionViewPagingLayout

class OptionCell: UICollectionViewCell {
    
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var optionNumberLabel: UILabel!
    @IBOutlet weak var optionNameLabel: UILabel!
    @IBOutlet weak var optionBalanceLabel: UILabel!
    @IBOutlet weak var optionDescriptionLabel: UILabel!
    @IBOutlet weak var optionSelectedLabel: UILabel!
    @IBOutlet var lineView: UIView!
    @IBOutlet weak var optionsSelectedImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.optionDescriptionLabel.numberOfLines = 0
        self.optionDescriptionLabel.minimumScaleFactor = 0.1
        self.optionDescriptionLabel.baselineAdjustment = .alignCenters
        self.optionDescriptionLabel.textAlignment  = .center
        self.optionDescriptionLabel.adjustsFontSizeToFitWidth = true
    }
}

extension OptionCell: TransformableView {
    func transform(progress: CGFloat) {
        let transform = CGAffineTransform(translationX: bounds.width/2 * progress, y: 0)
        let alpha = 1 - abs(progress)
        
        contentView.subviews.forEach { $0.transform = transform }
        contentView.alpha = alpha
    }
}
