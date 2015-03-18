//
//  DreamListTableViewController.swift
//  DreamKatcher2
//
//  Created by bnowak on 9/29/14.
//  Copyright (c) 2014 bnowak. All rights reserved.
//

import UIKit
import CoreData

class DreamListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    var dreamList: [Dream] = [Dream]()
    var dreamObject: DreamObject!
    
    let tap = UITapGestureRecognizer()

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "dreamkatcher_bg.jpg")!)
        
        //make fetch call to populate dreamList
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Dream")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
        dreamList = fetchedResultController.fetchedObjects as [Dream]
        
        //set up target for search bar
        searchBar.delegate = self
        
        //set up keyboard dismissal
        tap.addTarget(self, action: "dismissAllKeyboards")
        self.view.addGestureRecognizer(tap)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //make fetch based on text in search bar
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Dream")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        //predicate
        let match: NSString = NSString(format: "*%@*", searchBar.text)
        fetchRequest.predicate = NSPredicate(format:"tags like[c] %@ or date like[c] %@", match, match)
        
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
        dreamList = fetchedResultController.fetchedObjects as [Dream]
        
        tableView.reloadData()
    }
    
    func dismissAllKeyboards() {
        searchBar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dreamList.count
    }
    
    //cell height formatting
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dreamCell", forIndexPath: indexPath) as DreamTableViewCell

        cell.titleLabel.text = dreamList[indexPath.row].title
        cell.dateLabel.text = dreamList[indexPath.row].date

        return cell
    }
    
    //segue on cell select
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //populate dream object
        dreamObject = DreamObject()
        dreamObject.title = dreamList[indexPath.row].title
        dreamObject.text = dreamList[indexPath.row].text
        dreamObject.tags = dreamList[indexPath.row].tags
        dreamObject.lucid = dreamList[indexPath.row].lucid
        
        //perform segue
        performSegueWithIdentifier("showDream", sender: "dreamDetail")
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "showDream") {
            let navigationController = segue.destinationViewController as UINavigationController
            let destController = navigationController.viewControllers[0] as DreamDetailViewController
            destController.dreamObject = dreamObject
            NSLog("PASSED DREAM")
        }
    }
    
    //deleting
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            //remove dream from core data
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let context: NSManagedObjectContext = appDelegate.managedObjectContext!
            context.deleteObject(dreamList[indexPath.row] as NSManagedObject)
            context.save(nil)
            
            // Delete the row from the data source
            dreamList.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

}
