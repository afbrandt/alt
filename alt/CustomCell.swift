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
        self.addObserver(self, forKeyPath: "selected", options: NSKeyValueObservingOptions.New, context: nil)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        NSLog(keyPath)
    }
    
    @IBAction func enableKeyboard(sender: AnyObject) {
        NSLog("enabling keyboard")
    }
    
}
