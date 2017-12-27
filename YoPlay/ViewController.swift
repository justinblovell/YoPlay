//
//  ViewController.swift
//  YoPlay
//
//  Created by Justin B Lovell on 1/20/16.
//  Copyright © 2016 Justin B Lovell. All rights reserved.
//

import UIKit
import EventKit
import CoreData

class ViewController: UIViewController {
    var eventStore = EKEventStore()
    var packDate = Date()
    var lastJumpDate = Date()

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
    
    @IBAction func leadTheWayPressed(_ sender: Any) {
        if let url = URL(string: "http://www.leadthewayskydiving.com") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func repackDateEditingDidBegin(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func createReminderButtonPressed(_ sender: AnyObject) {
        let reminder = EKReminder(eventStore: self.eventStore)
        reminder.title = "Reserve repack date"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let dueDateComponents = appDelegate.dateComponentFromNSDate(date: self.lastJumpDate)
        reminder.dueDateComponents = dueDateComponents
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        
        do {
            try self.eventStore.save(reminder, commit: true)
            showSuccessAlert()
        } catch{
            print("Error creating and saving new reminder : \(error)")
        }
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        packDate = sender.date
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        repackDateField.text = dateFormatter.string(from: sender.date)
        
        lastJumpDate = (Calendar.current as NSCalendar).date(byAdding: .day, value: 180, to: sender.date, options: NSCalendar.Options(rawValue: 0))!
        
        lastDayDisplayLabel.text = dateFormatter.string(from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 180, to: sender.date, options: NSCalendar.Options(rawValue: 0))!) //Adds 180 days to the date
        
    }
    
    func showSuccessAlert() {
        let successAlert = UIAlertController(title: "Success!", message: "A reminder was created in the Reminders App.", preferredStyle: UIAlertControllerStyle.alert)
        successAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        present(successAlert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let defaults = UserDefaults.standard
        savedRepackDate?.text = defaults.string(forKey: "MyKey")
        
        eventStore.requestAccess(to: EKEntityType.reminder, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                NSLog("I have access!!")
            } else {
                NSLog("I DO NOT have access!!")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        repackDateField.resignFirstResponder()
    }

}
