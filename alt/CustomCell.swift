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
    
    var shortFrame, normalFrame : CGRect!
    
    // MARK: - Lifecycle methods
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //initialize transition frames
        normalFrame = keyboardDescription.frame
        shortFrame = CGRectMake(normalFrame.origin.x, normalFrame.origin.y, normalFrame.width, 0)
        
        //initialize first state
        keyboardDescription.alpha = 0.0
        keyboardDescription.frame = shortFrame
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
                self.keyboardDescription?.frame = self.normalFrame
                return
            })
        } else {
            //animate fade out
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.keyboardDescription?.alpha = 0.0
                self.keyboardDescription?.frame = self.shortFrame
                return
            })
        }
    }
    
    @IBAction func enableKeyboard(sender: AnyObject) {
        NSLog("enabling keyboard")
    }
    
}
