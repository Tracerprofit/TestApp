//
//  TasksTabViewCell.swift
//  LegeartApp
//
//  Created by PRGR on 02.02.2022.
//

import UIKit

class TasksTabViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addLine()
        cellView.layer.cornerRadius = 10
    }
    
    
//    for space between cell's
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0))
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func addLine(){
        let lineView = UIView(frame: CGRect(x: 0, y: 100, width: 400, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00).cgColor
        self.contentView.addSubview(lineView)
    }
    
}
