//
//  CheckboxAnswerCell.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 27/07/21.
//

import UIKit

class CheckboxAnswerCell: UITableViewCell {

    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
