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
    var cellHeights:[CGFloat]
    var currentCell:Int
    
    var iapHelper:IAPHelper
    
    // MARK: - Lifecycle methods
    
    required init(coder aDecoder: NSCoder) {
    
        //load property list file containing keyboards
        let path = NSBundle.mainBundle().bundlePath + "/Keyboards.plist"
        var pListData = NSArray(contentsOfFile: path)
        keyboardData = pListData as [Dictionary<String,String>]
        
        //initialize array tracking cell heights
        cellHeights = [CGFloat](count: keyboardData.count, repeatedValue: 0)
        currentCell = -1
        
        iapHelper = IAPHelper()
        
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
        let cell = tableView.cellForRowAtIndexPath(indexPath) as CustomCell

        tableView.beginUpdates()
        
        if (currentCell != -1) {
            cellHeights[currentCell] = 0
            
        }
        currentCell = indexPath.row
        cellHeights[currentCell] = 230
        //cell.keyboardContainer.hidden = false
        
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = (40.0 + cellHeights[indexPath.row]) as CGFloat
        return height
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("KeyboardCell", forIndexPath: indexPath) as CustomCell
        
        var keyboardName = keyboardData[indexPath.row]["Name"]
        var keyboardProductName = keyboardData[indexPath.row]["ProductName"]
        //var nib = UINib(nibName: keyboardName, bundle: nil)
        
        cell.keyboardName.text = keyboardName
        cell.keyboardString = keyboardName
        
        cell.productName = keyboardProductName
        cell.helper = iapHelper
        
        //cell.keyboardContainer.addSubview(nib.)
        var nibs = NSBundle.mainBundle().loadNibNamed(keyboardName, owner: self, options: nil)
        cell.keyboardContainer.addSubview(nibs[0] as UIView)
        
        //cell.nib = nibs[0] as UINib
        
        return cell
    }
    
    // MARK: - IAPHelperDelegate methods
    
    func purchaseSuccessful(productString: String) {
        //notify user that purchase was successful, and update ui and keychain
        var notice = UIAlertController(title: "Thank You!", message: "Purchase Successful!", preferredStyle: UIAlertControllerStyle.Alert)
        var action = UIAlertAction(title: "OK", style: .Default) { action -> Void in }
        notice.addAction(action)
        self.presentViewController(notice, animated: true, completion: nil)
    }
    
    func purchaseFailed(productString: String) {
        //notify user that purchase failed
        var notice = UIAlertController(title: "Alert", message: "Purchase Failed!", preferredStyle: UIAlertControllerStyle.Alert)
        var action = UIAlertAction(title: "OK", style: .Default) { action -> Void in }
        notice.addAction(action)
        self.presentViewController(notice, animated: true, completion: nil)
    }
    
    /*
    // MARK: - IAP methods
    
    //called first
    func attemptPurchase(productName: String) {
        if (SKPaymentQueue.canMakePayments()) {
            var productID:NSSet = NSSet(object: productName)
            var productRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID)
            productRequest.delegate = self
            productRequest.start()
        } else {
            //Alert user that purchase cannot be made
        }
    }
    
    //called after delegate method productRequest
    func buyProduct(product: SKProduct) {
        var payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    // MARK: - SKProductsRequestDelegate method
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        var count: Int = response.products.count
        if (count > 0) {
            var validProducts = response.products
            var product = validProducts[0] as SKProduct
            buyProduct(product)
        } else {
            //something went wrong with lookup, try again?
        }
    }
    
    // MARK: - SKPaymentTransactionObserver method
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        for transaction: AnyObject in transactions {
            if let tx: SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch tx.transactionState {
                case .Purchased:
                    
                    break;
                case .Failed:
                    break;
                default:
                    break;
                }
            }
        }
    }
    */
}
