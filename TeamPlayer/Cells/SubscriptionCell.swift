//
//  SubscriptionCell.swift
//  TeamPlayer
//
//  Created by Ashish Nimbria on 12/17/21.
//

import UIKit

class SubscriptionCell: UITableViewCell {


    @IBOutlet weak var cellDurationLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var cellFrequencyLbl: UILabel!
    @IBOutlet weak var cellTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
