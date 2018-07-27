//
//  searchOutcomeTableCell.swift
//  MyTasteFood
//
//  Created by kibeom lee on 2018. 7. 27..
//  Copyright © 2018년 kibeom lee. All rights reserved.
//

import UIKit

class searchOutcomeTableCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
