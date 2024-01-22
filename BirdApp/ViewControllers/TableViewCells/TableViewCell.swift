//
//  TableViewCell.swift
//  BirdApp
//
//  Created by MacBook Pro on 28/12/2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var certificateLbl: UILabel!
    
    @IBOutlet weak var birdIdLbl: UILabel!
    
    @IBOutlet weak var birdNameLbl: UILabel!
    
    @IBOutlet weak var expireOrsoldUpdateDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
