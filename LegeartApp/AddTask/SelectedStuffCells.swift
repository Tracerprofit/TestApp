//
//  SelectedStuffCells.swift
//  LegeartApp
//
//  Created by PRGR on 05.03.2022.
//

import UIKit

class SelectedStuffCells: UITableViewCell {
    @IBOutlet var imageLogo: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var circle: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
