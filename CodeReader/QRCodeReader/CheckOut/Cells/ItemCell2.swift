//
//  ItemCell.swift
//
//  Created by Leonardo Moya on 2-12-19.
//  Copyright © 2019 UDLAP. All rights reserved.
//

import UIKit

class ItemCell2: UITableViewCell{
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var noserie: UILabel!
    @IBOutlet weak var val: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        /*
         nombre.adjustsFontForContentSizeCategory = true
         noserie.adjustsFontForContentSizeCategory = true
         val.adjustsFontForContentSizeCategory = true
         */
    }
}

