//
//  RadioAnswerCell.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 19/07/21.
//

import UIKit

class RadioAnswerCell: UITableViewCell {

    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
