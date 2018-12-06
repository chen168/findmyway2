//
//  FlightInfoStatusVC.swift
//  findmyway2
//
//  Created by Warren Chen on 12/4/18.
//  Copyright © 2018 Warren Chen. All rights reserved.
//

import UIKit
import UserNotifications



class FlightInfoStatusVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var flightNumTextField: UITextField!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var departureDatePicker: UIDatePicker!
    @IBOutlet weak var flightStatusBtn: UIButton!
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //requesting for authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            print("requestAuthorization failed: \(error)")
        })

        initDepartureDatePicker()
        
        updateDepartureDateLabel(date: self.departureDatePicker.date)
        
        flightStatusBtn.isEnabled = false
        
        flightNumTextField.delegate = self
   
       //  test()
    
    }
    
    private func test() {
        let dao = FlightStatusDAO()
        
       // UserDefaultsUtils.resetDefaults()
       dao.deleteAllData()
        
        
        let flightNum = 168
        let departureAirport = "SFO"
        let departureDate = "12/6/2018"
        let departureTime = "01:28PM"
        let departureGate = "departureGate"
        let arrivalAirport = "SEA"
        let arrivalDate = "12/6/2018"
        let arrivalTime = "06:28PM"
        let arrivalGate = "arrivalGate"
        
        let flightInfo = FlightInfo(flightNum: flightNum, departureAirport: departureAirport, departureDate: departureDate, departureTime: departureTime, departureGate: departureGate, arrivalAirport: arrivalAirport, arrivalDate: arrivalDate, arrivalTime: arrivalTime, arrivalGate: arrivalGate)
        
    //  dao.save(flightInfo: flightInfo)
        
      //  dao.save(flightInfo: flightInfo)
      //  let flightStatus = dao.read(byFlightNum: flightNum, byDepartureDate: departureDate)
    
     //   print("test: \(flightStatus)")
    }
    
    @IBAction func departureDateSelectionChanged(_ sender: UIDatePicker) {
        updateDepartureDateLabel(date: sender.date)
    }
    
    @IBAction func flightStatusBtnTapped(_ sender: UIButton) {
        let flightNum = Int(self.flightNumTextField.text!)!
        
        if (UserDefaultsUtils.getFlightNum() > 0 ) {
            let dao = FlightStatusDAO()
            dao.deleteAllData()
        }
        
        UserDefaultsUtils.saveFlightNum(flightNum: flightNum)
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
      
    }
    */

}
