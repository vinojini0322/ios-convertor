//
//  HistoryTableViewCell.swift
//  UtilityConvertor
//
//  Created by Vinojini Paramasivam on 21/3/8.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var historyConversionText: UILabel!
    @IBOutlet weak var historyTypeIcon: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
}
