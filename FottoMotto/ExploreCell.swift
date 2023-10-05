//
//  ExploreCell.swift
//  FottoMotto
//
//  Created by Berk Yeteroğlu on 4.10.2023.
//

import UIKit

class ExploreCell: UITableViewCell {

    @IBOutlet weak var postMailText: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleTextField: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
