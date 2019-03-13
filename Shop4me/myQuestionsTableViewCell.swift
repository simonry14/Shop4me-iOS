//
//  myQuestionsTableViewCell.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 6/16/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit

class myQuestionsTableViewCell: UITableViewCell {

    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var questionStatus: UILabel!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var questionName: UILabel!
    
    @IBOutlet weak var questionType: UILabel!
    @IBOutlet weak var sharerEmail: UILabel!
    @IBOutlet weak var sharerName: UILabel!
    @IBOutlet weak var questionId: UILabel!
    @IBOutlet weak var questionDate: UILabel!
    @IBOutlet weak var questionSubject: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
