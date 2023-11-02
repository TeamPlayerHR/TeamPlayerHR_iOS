//
//  InviteDataCell.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 28/07/21.
//

import UIKit

class InviteDataCell: UITableViewCell {

    @IBOutlet weak var cellParticipantCountLbl: UILabel!
    @IBOutlet weak var cellTeamLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
