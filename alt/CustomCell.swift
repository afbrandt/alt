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
    @IBOutlet weak var enableKeyboardButton: UIButton!
    
    @IBOutlet weak var keyboardContainer: UIView!
    
    var nib : UINib
    var keyboardString : String!
    var productName : String!
    
    var helper : IAPHelper!
    
    var hasPurchased : Boolean!
    
    //var normalHeight : CGFloat!
    
    // MARK: - Lifecycle methods
    
    required init(coder aDecoder: NSCoder) {
        nib = UINib()
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //initialize transition frames
        //normalHeight = keyboardContainer.frame.height
        
        //initialize first state
        keyboardContainer.alpha = 0.0
    }

    // MARK: - User interaction methods

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //q&d no animation
        //keyboardDescription.hidden = !selected
        
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
        
        var nameBucket = NSUserDefaults(suiteName: "group.alt.shared") as NSUserDefaults!
        //var name : NSString = keyboardName.text!
        nameBucket.setObject(keyboardString, forKey: "nib")
        
        nameBucket.synchronize()
        
        
        helper.attemptPurchase(productName)
        /**
        if (nameBucket.synchronize()) {
            NSLog("enabled keyboard")
            var nameTest = nameBucket.stringForKey("nib") as String!
            NSLog(nameTest)
        }
        **/

        nameBucket = nil
        //var m = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group alt shared") as NSURL!
        //NSLog(m.path!)
        
        /**
        var pListPath = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent("Plugins/keyboard.appex/Info.plist") as String
        var basePath = NSBundle.mainBundle().bundlePath
        var keyPath = basePath.stringByAppendingPathComponent("Plugins/keyboard.appex/CustomKeyboard.nib") as String
        var nibName = keyboardName.text! as String
        var nibPath = basePath.stringByAppendingPathComponent(nibName.stringByAppendingPathExtension("nib")!) as String
        var fMgr = NSFileManager.defaultManager()
        
        if (!keyPath.isEmpty) {
            var error = NSErrorPointer()
            if (fMgr.fileExistsAtPath(keyPath)) {
                fMgr.removeItemAtPath(keyPath, error: error)
                fMgr.copyItemAtPath(nibPath, toPath: keyPath, error: error)
            }
            if (fMgr.isWritableFileAtPath(keyPath)) {
                fMgr.copyItemAtPath(nibPath, toPath: keyPath, error: error)

                //NSLog("can write to plist")
                //var appex = NSKeyedUnarchiver.unarchiveObjectWithFile(pListPath) as Dictionary<String,String>
                //NSLog(appex["Bundle display name"]!)
            }
            fMgr.copyItemAtPath(nibPath, toPath: keyPath, error: error)
        }
        **/
    }
    
}
