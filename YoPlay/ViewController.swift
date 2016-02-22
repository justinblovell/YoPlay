//
//  ViewController.swift
//  YoPlay
//
//  Created by Justin B Lovell on 1/20/16.
//  Copyright © 2016 Justin B Lovell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var repackDate = NSDate()

    @IBOutlet weak var repackDateField: UITextField!
    
    @IBOutlet weak var imperitiveLabel: UILabel!
    
    @IBOutlet weak var lastDayLabel: UILabel!
    
    @IBOutlet weak var lastDayDisplayLabel: UILabel!
    
    @IBAction func repackDateEditingDidBegin(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func scheduleNotificationButtonPressed(sender: AnyObject) {
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
        
        if settings.types == .None {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let notification = UILocalNotification()
        
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        
        notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
        
        notification.alertAction = "be awesome!"
        
        notification.soundName = UILocalNotificationDefaultSoundName
        
        notification.userInfo = ["CustomField1": "w00t"]
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        repackDate = sender.date
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        repackDateField.text = dateFormatter.stringFromDate(sender.date)
        
        lastDayDisplayLabel.text = dateFormatter.stringFromDate(NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 180, toDate: sender.date, options: NSCalendarOptions(rawValue: 0))!) //Adds 180 days to the date
        
    }
    
//    @IBAction func saveButtonPressed(sender: UIButton) {
//        var dateFormatter = NSDateFormatter() //Creates a formatter
//       
//        dateFormatter.dateFormat = "yyyy-MM-dd" //Sets the format of the date for the formatter
//        
//        let repackDateText = repackDateField.text
//
//
//        let currentRepackDate = dateFormatter.dateFromString(repackDateText!) //Converts the text to the formatted date object
//
//        let futureRepackDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 180, toDate: currentRepackDate!, options: NSCalendarOptions(rawValue: 0)) //Adds 180 days to the date
//        
//        lastDayDisplayLabel.text = dateFormatter.stringFromDate(futureRepackDate!) //Converts the new date back to text to be displayed
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        repackDateField.resignFirstResponder()
    }
    


}

