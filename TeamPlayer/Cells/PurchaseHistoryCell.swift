//
//  PurchaseHistoryCell.swift
//  TeamPlayer
//
//  Created by Ashish Nimbria on 12/17/21.
//

import UIKit

class PurchaseHistoryCell: UITableViewCell {

    @IBOutlet weak var cellParticipantLbl: UILabel!
    @IBOutlet weak var cellPlanDetailLbl: UILabel!
    @IBOutlet weak var cellPlanTypeLbl: UILabel!
    @IBOutlet weak var cellAmountLbl: UILabel!
    @IBOutlet weak var cellDateLbl: UILabel!
    @IBOutlet weak var cellTransactionTypeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
