//
//  TaskViewCell.swift
//  LegeartApp
//
//  Created by PRGR on 18.02.2022.
//

import UIKit

class TaskViewCell: UITableViewCell {

    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var textOfTask: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var author1: UIImageView!
    @IBOutlet weak var author2: UIImageView!
    @IBOutlet weak var author3: UIImageView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
