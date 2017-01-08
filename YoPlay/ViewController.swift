//
//  ViewController.swift
//  YoPlay
//
//  Created by Justin B Lovell on 1/20/16.
//  Copyright © 2016 Justin B Lovell. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var repackDate = Date()

    @IBOutlet weak var repackDateField: UITextField!
    
    @IBOutlet weak var imperitiveLabel: UILabel!
    
    @IBOutlet weak var lastDayLabel: UILabel!
    
    @IBOutlet weak var lastDayDisplayLabel: UILabel!
    
    @IBOutlet weak var savedRepackDate: UILabel?
    
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.setValue(lastDayDisplayLabel.text, forKey: "MyKey")
        defaults.synchronize()
        savedRepackDate?.text = defaults.string(forKey: "MyKey")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "Reserve",
                                                 in:managedContext)
        
        let reserve = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        
        reserve.setValue(lastDayDisplayLabel.text, forKey: "repackDate")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func repackDateEditingDidBegin(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func scheduleNotificationButtonPressed(_ sender: AnyObject) {
        guard let settings = UIApplication.shared.currentUserNotificationSettings else { return }
        
        if settings.types == UIUserNotificationType() {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        
        let notification = UILocalNotification()
        
        notification.fireDate = repackDate
        
        notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
        
        notification.alertAction = "be awesome!"
        
        notification.soundName = UILocalNotificationDefaultSoundName
        
        notification.userInfo = ["CustomField1": "w00t"]
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        repackDate = sender.date
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        repackDateField.text = dateFormatter.string(from: sender.date)
        
        lastDayDisplayLabel.text = dateFormatter.string(from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 180, to: sender.date, options: NSCalendar.Options(rawValue: 0))!) //Adds 180 days to the date
        
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
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        let defaults = UserDefaults.standard
        savedRepackDate?.text = defaults.string(forKey: "MyKey")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        repackDateField.resignFirstResponder()
    }
    


}

