//
//  FlightInfoStatusVC.swift
//  findmyway2
//
//  Created by Warren Chen on 12/4/18.
//  Copyright © 2018 Warren Chen. All rights reserved.
//

import UIKit




class FlightInfoStatusVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var flightNumTextField: UITextField!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var departureDatePicker: UIDatePicker!
    @IBOutlet weak var flightStatusBtn: UIButton!
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDepartureDatePicker()
        
        updateDepartureDateLabel(date: self.departureDatePicker.date)
        
        flightStatusBtn.isEnabled = false
        
        flightNumTextField.delegate = self
    }
    
    @IBAction func departureDateSelectionChanged(_ sender: UIDatePicker) {
        updateDepartureDateLabel(date: sender.date)
    }
    
    @IBAction func flightStatusBtnTapped(_ sender: UIButton) {
        UserDefaultsUtils.saveFlightNum(flightNum: self.flightNumTextField.text!)
        UserDefaultsUtils.saveDepartureDate(date: self.departureDatePicker.date)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        flightStatusBtn.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if flightNumTextField.text?.count ?? 0 > 0 {
            flightStatusBtn.isEnabled = true
        } else {
            flightStatusBtn.isEnabled = false
        }
    }
    
    private func initDepartureDatePicker() {
        self.departureDatePicker.minimumDate = Date()
        self.departureDatePicker.date = Date()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
    }
    
    private func updateDepartureDateLabel(date: Date) {
        departureDateLabel.text = dateFormatter.string(from: date)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
