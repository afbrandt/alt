//
//  CustomCell.swift
//  alt
//
//  Created by Andrew Brandt on 1/17/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var keyboardName: UILabel!
    @IBOutlet weak var keyboardDescription: UILabel!
    @IBOutlet weak var enableKeyboardButton: UIButton!
    
    // MARK: - Lifecycle methods
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        keyboardDescription.alpha = 0.0
    }

    // MARK: - User interaction methods

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //q&d no animation
        //keyboardDescription.hidden = !selected
        
        if (selected) {
            //animate fade in
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.keyboardDescription?.alpha = 1.0
                return
            })
        } else {
            //animate fade out
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.keyboardDescription?.alpha = 0.0
                return
            })
        }
    }
    
    @IBAction func enableKeyboard(sender: AnyObject) {
        NSLog("enabling keyboard")
    }
    
}
