//
//  DreamDetailViewController.swift
//  DreamKatcher2
//
//  Created by bnowak on 10/3/14.
//  Copyright (c) 2014 bnowak. All rights reserved.
//

import UIKit

class DreamDetailViewController: UIViewController {
    
    var dreamObject: DreamObject!

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var tagField: UITextField!
    @IBOutlet weak var lucidSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set background
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
        
        //populate fields
        titleField.text = dreamObject.title
        descField.text = dreamObject.text
        tagField.text = dreamObject.tags
        lucidSwitch.on = dreamObject.lucid
        
        NSLog(dreamObject.title)

        // Do any additional setup after loading the view.
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
