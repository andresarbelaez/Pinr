//
//  DatePickerVC.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/24/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
protocol dateDelegate {
    func dateDismissed(startDate: Date?, endDate: Date?)
}

class DatePickerVC: UIViewController {

    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    var delegate: dateDelegate?
    var startDate: Date?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startDatePickerAction(_ sender: AnyObject) {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.minute = 1
        startDate = startDatePicker.date
        let minDate: Date = calendar.date(byAdding: components, to: startDate!)!
        endDatePicker.minimumDate = minDate
        let minStartDate: Date = calendar.date(byAdding: components, to: Date())!
        startDatePicker.minimumDate = minStartDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        var strDate = dateFormatter.string(from: startDatePicker.date)
        startDateLabel.text = strDate
    }
    
    @IBAction func endDatePickerAction(_ sender: AnyObject) {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.minute = 1
        let minDate: Date = calendar.date(byAdding: components, to: startDate!)!
        endDatePicker.minimumDate = minDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        var strDate = dateFormatter.string(from: endDatePicker.date)
        
        endDateLabel.text = strDate
    }
    
    @IBAction func onCancel(_ sender: AnyObject) {
        dismiss(animated: true) { 
            
        }
    }

    @IBAction func onSubmit(_ sender: AnyObject) {
        dismiss(animated: true) { 
            self.delegate?.dateDismissed(startDate: self.startDatePicker.date, endDate: self.endDatePicker.date)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! CreateEventVC
        vc.startDate = startDatePicker.date as NSDate?
        print("this segue is happening:", startDateLabel.text)
    }
    

}
