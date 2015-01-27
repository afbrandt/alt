//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Andrew Brandt on 1/16/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    //@IBOutlet var nextKeyboardButton: UIButton!
    var mainView: UIView!
    var currentKeyboard: String!

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //var m = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group alt shared") as NSURL!
        //NSLog(m.path!)
        
        
        //check to see if new keyboard was chosen
        let nameBucket = NSUserDefaults(suiteName: "group.alt.shared") as NSUserDefaults!
        let keyboardName = nameBucket.objectForKey("nib") as String!
        NSLog(keyboardName)
        
        if (currentKeyboard == nil) {
            currentKeyboard = keyboardName
        }

        if currentKeyboard == keyboardName {
            var xibViews = NSBundle.mainBundle().loadNibNamed(keyboardName, owner: self, options: nil)
            self.mainView = xibViews[0] as UIView;
            self.view.addSubview(mainView)
        
            /**
            for v in self.mainView.subviews as [UIButton]
            {
                if (v.tag >= 0)
                {
                    v.addTarget(self, action: "btnPressed:", forControlEvents: .TouchUpInside)
                }
                else if (v.tag == -1)
                {
                    v.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
                }
            }
            **/
        }
        
    
        
        /** Perform custom UI setup here
        self.nextKeyboardButton = UIButton.buttonWithType(.System) as UIButton
    
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
    
        var nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        var nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
        **/
    }

    func btnPressed(button: UIButton) {
    
    }
    
    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        //self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}
