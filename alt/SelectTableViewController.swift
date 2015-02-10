//
//  SelectTableViewController.swift
//  alt
//
//  Created by Andrew Brandt on 1/16/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

import UIKit
import Foundation
import StoreKit

//class SelectTableViewController: UITableViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
class SelectTableViewController: UITableViewController, IAPHelperDelegate {

    var keyboardData:[Dictionary<String,String>]
    var purchasedKeyboards:Set<String>
    var cellHeights:[CGFloat]
    var currentCell:Int
    
    var iapHelper:IAPHelper
    var keychainHelper:KeychainHelper
    var activeKeyboard:String!
    
    // MARK: - Lifecycle methods
    
    required init(coder aDecoder: NSCoder) {
    
        //load property list file containing keyboards
        let path = NSBundle.mainBundle().bundlePath + "/Keyboards.plist"
        var pListData = NSArray(contentsOfFile: path)
        keyboardData = pListData as! [Dictionary<String,String>]
        
        //initialize array tracking cell heights
        cellHeights = [CGFloat](count: keyboardData.count, repeatedValue: 0)
        currentCell = -1
        
        var nameBucket = NSUserDefaults(suiteName: "group.alt.shared") as NSUserDefaults!
        activeKeyboard = nameBucket.stringForKey("nib")
        
        iapHelper = IAPHelper()
        keychainHelper = KeychainHelper()
        purchasedKeyboards = KeychainHelper.getAvailableKeyboards() as Set<String>

        super.init(coder: aDecoder)
        
        iapHelper.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNibs()
    }
    
    func loadNibs() {
        //custom cell nib
        var nib = UINib(nibName: "CustomCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "KeyboardCell")
        
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyboardData.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CustomCell

        tableView.beginUpdates()
        
        if (currentCell != -1) {
            cellHeights[currentCell] = 0
        }
        currentCell = indexPath.row
        cellHeights[currentCell] = 230
        
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = (40.0 + cellHeights[indexPath.row]) as CGFloat
        return height
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("KeyboardCell", forIndexPath: indexPath) as! CustomCell
        
        var keyboardName = keyboardData[indexPath.row]["Name"]
        var keyboardProductName = keyboardData[indexPath.row]["ProductName"]
        
        cell.keyboardName.text = keyboardName
        cell.keyboardString = keyboardName
        
        cell.productName = keyboardProductName
        cell.helper = iapHelper
        
        if (purchasedKeyboards.contains(keyboardName!)) {
            cell.enable()
        }
        
        if (keyboardName == activeKeyboard) {
            cell.setActive(true)
        }
        var nibs = NSBundle.mainBundle().loadNibNamed(keyboardName, owner: self, options: nil)
        cell.keyboardContainer.addSubview(nibs[0] as! UIView)
        
        return cell
    }
    
    // MARK: - IAPHelperDelegate methods
    
    func purchaseSuccessful(productString: String) {
        //notify user that purchase was successful, and update ui and keychain
        
        var name: String!
        
        for var i = 0; i < keyboardData.count; i++ {
            if productString == keyboardData[i]["ProductName"] {
                name = keyboardData[i]["Name"]
                var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! CustomCell
                //cell.hasPurchased = true
                cell.enable()
            }
        }
        
        KeychainHelper.setKeyboardAvailable(name)
    }
    
    func purchaseFailed(productString: String) {
        //notify user that purchase failed
        var notice = UIAlertController(title: "Alert", message: "Purchase Failed!", preferredStyle: UIAlertControllerStyle.Alert)
        var action = UIAlertAction(title: "OK", style: .Default) { action -> Void in }
        notice.addAction(action)
        self.presentViewController(notice, animated: true, completion: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "isEnabled" {
            NSLog("noticed change in enabled")
        }
    }
}
