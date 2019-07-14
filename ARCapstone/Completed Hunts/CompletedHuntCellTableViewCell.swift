//
//  CompletedHuntCellTableViewCell.swift
//  scavengARt
//
//  Created by Rachel on 7/12/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//



import UIKit

// CREATES THE TABLE CELLS FOR THE COMPLETED HUNT
class CompletedHuntCell: UITableViewCell {
    @IBOutlet weak var HuntView: UIImageView!
    @IBOutlet weak var HuntLabel: UILabel!
    @IBOutlet weak var HuntDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
