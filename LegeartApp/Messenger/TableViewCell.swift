//
//  TableViewCell.swift
//  LegeartApp
//
//  Created by PRGR on 01.02.2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var LabelName: UILabel!
    @IBOutlet var LabelDiscr: UILabel!
    @IBOutlet var imageName: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
