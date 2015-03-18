//
//  ViewController.swift
//  DreamKatcher2
//
//  Created by bnowak on 9/29/14.
//  Copyright (c) 2014 bnowak. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var dreamListButton: UIBarButtonItem!
    @IBOutlet weak var statsButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var lucidSwitch: UISwitch!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var tagField: UITextField!
    
    var dreamObject: DreamObject = DreamObject()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set delegates
        titleField.delegate = self
        descField.delegate = self
        tagField.delegate = self
        
        //set up background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "dreamkatcher_bg.jpg")!)
        
        //format text fields
        titleField.layer.borderWidth = 1
        titleField.layer.borderColor = UIColor.whiteColor().CGColor
        titleField.layer.cornerRadius = 5
        descField.layer.borderWidth = 1
        descField.layer.borderColor = UIColor.whiteColor().CGColor
        descField.layer.cornerRadius = 5
        tagField.layer.borderWidth = 1
        tagField.layer.borderColor = UIColor.whiteColor().CGColor
        tagField.layer.cornerRadius = 5
        
        //set up tap gesture recognizer to close keyboards
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "dismissAllKeyboards")
        self.view.addGestureRecognizer(tap)

        //keyboard shift for tagField
        tagField.addTarget(self, action: "scootUp:" , forControlEvents: UIControlEvents.EditingDidBegin)
        tagField.addTarget(self, action: "scootDown:" , forControlEvents: UIControlEvents.EditingDidEnd)
        
        //if there is a current dream (coming from list view), populate the fields
        
    }
    
    //dismiss keyboards
    func dismissAllKeyboards() {
        titleField.resignFirstResponder()
        descField.resignFirstResponder()
        tagField.resignFirstResponder()
    }
    
    //move tag field if keyboard pops up
    func scootUp(sender:UIButton!) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {
            self.view.frame.origin.y -= 120
            }, completion: { finished in
            }
        )
    }
    func scootDown(sender:UIButton!) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {
            self.view.frame.origin.y += 120
            }, completion: { finished in
            }
        )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        //if save dream, must do core data stuff
        if (segue.identifier == "saveDream") {
            //make a core data entry
            addDream()
        }
    }
    
    func addDream() {
        
        var createDream = true
        
        if (titleField.text == "") {
            var alert = UIAlertController(title: "Error", message: "Please enter a keyword!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            createDream = false
        }
        if (descField.text == "") {
            var alert = UIAlertController(title: "Error", message: "Please enter a description!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            createDream = false
        }
        if (tagField.text == "") {
            var alert = UIAlertController(title: "Error", message: "Please enter a tag(s)!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            createDream = false
        }
        
        if (createDream == true) {
            //create new dream object
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let context: NSManagedObjectContext = appDelegate.managedObjectContext!
            let entityName: String = "Dream"
            let myEntityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
            var myDream = Dream(entity: myEntityDescription!, insertIntoManagedObjectContext: context)
            
            //update new dream
            myDream.title = titleField.text
            myDream.text = descField.text
            myDream.tags = tagField.text    //needs parsing
            myDream.lucid = lucidSwitch.on
            
            //update dream object as well
            dreamObject.title = titleField.text
            dreamObject.text = descField.text
            dreamObject.tags = tagField.text
            dreamObject.lucid = lucidSwitch.on
            
            //date formatting
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            myDream.date = dateFormatter.stringFromDate(NSDate())   //currently today's date (could be yesterday)?
            
            //save to core data
            context.save(nil)
            
            //clear fields
            titleField.text = ""
            descField.text = ""
            tagField.text = ""
            lucidSwitch.on = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}