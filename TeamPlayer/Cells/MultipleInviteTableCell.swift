//
//  MultipleInviteTableCell.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 24/01/22.
//

import UIKit

class MultipleInviteTableCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var cellTxtFeild: UITextField!
    @IBOutlet weak var cellLbl: UILabel!
    
    var row : Int = -1
    var completionHandlerCallback:(([String]?) ->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellTxtFeild.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        if textField.text != "" {
            inviteeName[self.row] = textField.text ?? ""
        }

    }

}
