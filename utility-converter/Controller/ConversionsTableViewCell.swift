//
//  ConversionsTableViewCell.swift
//  utility-converter
//
//  Created by Vinojini Paramasivam on 21/3/18.
//  Copyright © 2021 Brion Silva. All rights reserved.
//

import UIKit

class ConversionsTableViewCell: UITableViewCell {

    @IBOutlet weak var conversionsIV: UIImageView!
    
    @IBOutlet weak var conversionsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
