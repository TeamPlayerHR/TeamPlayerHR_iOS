//
//  GroupListCell.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 16/08/21.
//

import UIKit

class GroupListCell: UITableViewCell {

    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var benchmarkBtn: UIButton!
    @IBOutlet weak var participantBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
