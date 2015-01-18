//
//  SelectTableViewController.swift
//  alt
//
//  Created by Andrew Brandt on 1/16/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

import UIKit

class SelectTableViewController: UITableViewController {

    var keyboardData:[Dictionary<String,String>]
    var cellHeights:[CGFloat]
    var currentCell:Int
    
    required init(coder aDecoder: NSCoder) {
    
        //load property list file containing keyboards
        let path = NSBundle.mainBundle().bundlePath + "/Keyboards.plist"
        var pListData = NSArray(contentsOfFile: path)
        keyboardData = pListData as [Dictionary<String,String>]
        
        //initialize array tracking cell heights
        cellHeights = [CGFloat](count: keyboardData.count, repeatedValue: 0)
        currentCell = -1
        
        super.init(coder: aDecoder)
        
        //NSBundle.mainBundle().loadNibNamed("CustomCell", owner: self, options: nil)
        tableView.registerClass(CustomCell.self, forCellReuseIdentifier: "KeyboardCell")
        
        //let nibPath = NSBundle.mainBundle().bundlePath + "/CustomCell.xib"
        //var nibData = NSData(contentsOfFile: nibPath)
        //var nib = UINib(data: nibData!, bundle: nil)
        //tableView.registerNib(nibs[0], forCellReuseIdentifier: "YJe-TG-LYM-view-uZN-vt-IuR")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyboardData.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)

        tableView.beginUpdates()
        
        if (currentCell != -1) {
            cellHeights[currentCell] = 0
        }
        currentCell = indexPath.row
        cellHeights[currentCell] = 40
        
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = (40.0 + cellHeights[indexPath.row]) as CGFloat
        return height
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("KeyboardCell", forIndexPath: indexPath) as CustomCell
        
        cell.keyboardName.text = keyboardData[indexPath.row]["KeyboardName"]
        //cell.textLabel?.text = keyboardData[indexPath.row]["KeyboardName"]
        
        return cell
    }    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    

}
