//
//  UploaderTableViewCell.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 2/8/15.
//  Copyright (c) 2015 Ido Ben-Natan. All rights reserved.
//

import UIKit

class UploaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var uploaderImage: UIImageView!
    @IBOutlet weak var uploaderName: UILabel!
    @IBOutlet weak var uploadedAt: UILabel!
    @IBOutlet weak var numberOfVotes: UILabel!
    @IBAction func votesClicked(sender: UIButton) {
        self.voteHandler(sender)
    }
    
    var voteHandler: (UIButton) -> (Void) = { button in
        println("clicked!!!")
    }
    
    override init?(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
