//
//  CharacterListCollectionViewCell.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import UIKit

class CharacterListCollectionViewCell: UICollectionViewCell
{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textGradientBackground: UIView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroImageView: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        heroImageView.contentMode = .scaleToFill
        setGradientBackground()
        // Initialization code
    }
    
    func setGradientBackground()
    {
        let colorTop =  UIColor.clear.cgColor
        let colorBottom = UIColor.black.cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0, 0.5]
        gradientLayer.frame = self.textGradientBackground.bounds
                
        self.textGradientBackground.layer.insertSublayer(gradientLayer, at:0)
    }

    override func prepareForReuse()
    {
        activityIndicator.isHidden = false
        heroImageView.image = nil
        heroNameLabel.text = ""
    }
    
}
