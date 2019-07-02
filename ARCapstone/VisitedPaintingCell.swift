//
//  VisitedPaintingCell.swift
//  scavengARt
//
//  Created by Ahsun on 7/2/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit

class VisitedPaintingCell: UITableViewCell {
    @IBOutlet weak var PaintingView: UIImageView!
    @IBOutlet weak var PaintingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
