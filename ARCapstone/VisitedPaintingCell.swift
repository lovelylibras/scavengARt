//
//  VisitedPaintingCell.swift
//  scavengARt
//
//  Created by Ahsun on 7/2/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit

// CREATES THE TABLE CELLS FOR THE VISITED VIEW
class VisitedPaintingCell: UITableViewCell {
    @IBOutlet weak var PaintingView: UIImageView!
    @IBOutlet weak var PaintingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
