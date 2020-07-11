//
//  NumberCollectionViewCell.swift
//  shiftingGame
//
//  Created by Rodrigo Astorga on 11-07-20.
//  Copyright © 2020 Rodrigo Astorga. All rights reserved.
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell {
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet weak var backgroundViewBorder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundViewBorder.layer.borderColor = UIColor.black.cgColor
        backgroundViewBorder.layer.cornerRadius = 5.0
        backgroundViewBorder.layer.borderWidth = 2.0
    }

}
