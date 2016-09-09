//
//  TabbedViewController.swift
//  On The Map - V:01
//
//  Created by Sneha gindi on 29/08/16.
//  Copyright © 2016 Sneha gindi. All rights reserved.
//

import UIKit

class TabbedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBAction func refreshButton(sender: AnyObject) {
        self.tabbedView.reloadData()
    }
    @IBOutlet weak var tabbedView: UITableView!
    var tabbedResults = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = ActionController().taskForGetSL { results in
            self.tabbedResults = results!
            self.tabbedView.reloadData()
            print(results)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "tabbedViewCell"
        let tab = tabbedResults[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("tabbedViewCell") as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = tab["firstName"] as? String
        cell.detailTextLabel!.text = tab["mediaURL"] as? String
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabbedResults.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        let tabs = tabbedResults[indexPath.row]
        controller.tab = tabs[indexPath.row] as? NSDictionary
        let url  = tabs["mediaURL"] as? String
        var urlStr : NSString = url!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var remoteUrl : NSURL? = NSURL(string: url!)
        
        if UIApplication.sharedApplication().canOpenURL(remoteUrl!) == true
        {
            UIApplication.sharedApplication().openURL(remoteUrl!)
        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    
}
