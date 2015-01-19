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
    
    var cellNumber : Int
    
    // MARK: - Lifecycle methods
    
    required init(coder aDecoder: NSCoder) {
        cellNumber = 0
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addObserver(self, forKeyPath: "hidden", options: NSKeyValueObservingOptions.New, context: nil)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //q&d no animation
        keyboardDescription.hidden = !selected
        
        if (selected) {
            //animate fade in
        } else {
            //animate fade out
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        NSLog(keyboardName.text!)
    }
    
    @IBAction func enableKeyboard(sender: AnyObject) {
        NSLog("enabling keyboard")
    }
    
}
