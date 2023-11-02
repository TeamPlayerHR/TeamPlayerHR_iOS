//
//  ShowInviteeListCell.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 13/09/21.
//

import UIKit

class ShowInviteeListCell: UITableViewCell {

    @IBOutlet weak var cellStatusLbl: UILabel!
    @IBOutlet weak var cellNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
