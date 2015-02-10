//
//  CustomCell.swift
//  alt
//
//  Created by Andrew Brandt on 1/17/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

import UIKit
import Foundation

class CustomCellObserver: NSObject {
    dynamic var hasPurchased: Bool
    
    override init() {
        hasPurchased = false;
    }
}

class CustomCell: UITableViewCell {

    @IBOutlet weak var keyboardName: UILabel!
    @IBOutlet weak var enableKeyboardButton: UIButton!
    
    @IBOutlet weak var keyboardContainer: UIView!
    
    var keyboardString : String!
    var productName : String!
    
    var helper : IAPHelper!
    
    var observable : CustomCellObserver
    var hasPurchased : Bool
    var isEnabled : Bool
    
    // MARK: - Lifecycle methods
    
    required init(coder aDecoder: NSCoder) {
        observable = CustomCellObserver()
        hasPurchased = false
        isEnabled = false
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //initialize first state
        keyboardContainer.alpha = 0.0
        observable.addObserver(self, forKeyPath: "hasPurchased", options: .New, context: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifiedKeyboardChange:" , name:"keyboard-enabled", object: nil)
    }

    // MARK: - User interaction methods

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if (selected) {
            //animate fade in
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.keyboardContainer?.alpha = 1.0
                return
            })
        } else {
            //animate fade out
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.keyboardContainer?.alpha = 0.0
                return
            })
        }
    }
    
    @IBAction func enableKeyboard(sender: AnyObject) {
        
        if (observable.hasPurchased) {
            var nameBucket = NSUserDefaults(suiteName: "group.alt.shared") as NSUserDefaults!
            isEnabled = true;
            nameBucket.setObject(keyboardString, forKey: "nib")
        
            nameBucket.synchronize()
        } else {
            helper.attemptPurchase(productName)
        }
        self.setActive(true)
    }
    
    func enable() {
        observable.hasPurchased = true
    }
    
    func setActive(active: Bool) {
        if active {
            enableKeyboardButton.setTitle("Selected", forState: .Normal)
            NSNotificationCenter.defaultCenter().postNotificationName("keyboard-enabled", object: keyboardString)
        } else if observable.hasPurchased {
            enableKeyboardButton.setTitle("Enable", forState: .Normal)
        } else {
            enableKeyboardButton.setTitle("Purchase", forState: .Normal)
        }
    }
    
    func notifiedKeyboardChange(message: NSNotification) {
        if let string = message.object as! String! {
            if string == keyboardString {
                NSLog("%@ %@", keyboardString, string)
            } else {
                self.setActive(false)
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    
        if keyPath == "hasPurchased" {
            NSLog("noticed purchase change for keyboard %@", keyboardString)
            enableKeyboardButton.setTitle("Enable", forState: .Normal)
        }
    }
    
}
