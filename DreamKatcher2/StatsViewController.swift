//
//  StatsViewController.swift
//  DreamKatcher2
//
//  Created by bnowak on 10/7/14.
//  Copyright (c) 2014 bnowak. All rights reserved.
//

import UIKit
import CoreData

class StatsViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var totalDreams: UILabel!
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var lucidDreams: UILabel!
    @IBOutlet weak var dreamsPerWeek: UILabel!
    
    var dreamList: [Dream] = [Dream]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up background image
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
        
        //now do maths on the dreams
        analyzeDreams()

        // Do any additional setup after loading the view.
    }
    
    func analyzeDreams() {
        
        //init vars
        var dreamCount = 0
        var lucidCount = 0
        var lucidPerWeek: Double = 0.0
        
        var uniqueDays: NSMutableArray = NSMutableArray()
        
        //get dreamCount
        for dream in dreamList {
            dreamCount += 1
            if (dream.lucid == true) {
                lucidCount += 1
            }
            if (!uniqueDays.containsObject(dream.date)) {
                uniqueDays.addObject(dream.date)
            }
        }
        
        //calc lucidPerWeek
        if (uniqueDays.count == 0) {
            lucidPerWeek = 0
        }
        else {
            lucidPerWeek = (Double(lucidCount)/Double(uniqueDays.count))*7.0
        }
        
        totalDreams.text = String(dreamCount)
        days.text = String(uniqueDays.count)
        lucidDreams.text = String(lucidCount)
        dreamsPerWeek.text = String(format: "%0.1f", lucidPerWeek)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
