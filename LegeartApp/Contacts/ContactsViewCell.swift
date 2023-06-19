//
//  ContactsViewCell.swift
//  LegeartApp
//
//  Created by PRGR on 04.02.2022.
//

import UIKit

class ContactsViewCell: UITableViewCell {

    @IBOutlet weak var CellImageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDicr: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
