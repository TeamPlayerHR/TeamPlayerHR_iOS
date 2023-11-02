//
//  NewsCell.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 14/12/21.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var cellSubLbl: UILabel!
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
