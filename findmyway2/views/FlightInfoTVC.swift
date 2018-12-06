//
//  FlightInfoTVC.swift
//  findmyway2
//
//  Created by Warren Chen on 12/4/18.
//  Copyright © 2018 Warren Chen. All rights reserved.
//

import UIKit
import SwiftyJSON
import UserNotifications

class FlightInfoTVC: UITableViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var flightNumLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    
    @IBOutlet weak var departureAirportLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var departureGateLabel: UILabel!
    
    @IBOutlet weak var arrivalAirportLabel: UILabel!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var arrivalGateLabel: UILabel!
    
    var dateFormatter = DateFormatter()
    
    var flightInfo: FlightInfo?
    var flightInfoStatusResultJson: JSON!
    
    var updateTimer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        setFlightNum()
        setDepartureDate()

        setFlightInfoStatus()
        
        setBackgroundUpdate()
        
    
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make footerview so it fill up size of the screen
        // The button is aligned to bottom of the footerview
        // using autolayout constraints
        self.tableView.tableFooterView = nil
        self.footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.tableView.frame.size.height - self.tableView.contentSize.height - self.footerView.frame.size.height)
        self.tableView.tableFooterView = self.footerView
    }
 */
    
    func createNotificationForGateChanged(flightNum: Int, oldGate: String, newGate: String) {
        print("createNotificationForGateChanged")
        
        //creating the notification content
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = "Hey there's a gate changed for flight \(flightNum)"
        //content.subtitle = ""
        content.body = "From gate \(oldGate) to \(newGate)"
        content.badge = 1
        
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    
    private func setBackgroundUpdate() {
        updateTimer = Timer.scheduledTimer(timeInterval: 20, target: self,
                                           selector: #selector(getUpdatedFlightStatus), userInfo: nil, repeats: true)
        
        registerBackgroundTask()
    }
    
    @objc func getUpdatedFlightStatus() {
        print("getUpdatedFlightStatus(): \(Date())")
        
        getFlightInfoStatus()
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    private func setFlightInfoStatus() {
        if self.flightInfo != nil {
            self.displayDepartureInfo(flightInfo: flightInfo!)
        
            self.displayDestinationInfo(flightInfo: flightInfo!)
        } else {
            getFlightInfoStatus()
        }
    }
    
    
    private func getFlightInfoStatus() {
        print("getFlightInfoStatus(): calling FlightAware...")
        
        let flightNum = UserDefaultsUtils.getFlightNum()
        let departureDate = UserDefaultsUtils.getDepartureDate()!
        
        let service = FlightAwareServices()
        service.flightInfoStatus(flightNum: flightNum, departure: departureDate, {
            result in
            //print("chen168: \(result)")
            self.flightInfoStatusResultJson = result
            
            if let flightInfoJSON = self.getFlightInfo(byDate: departureDate) {
                // print("found: \(flightInfoJSON)")
            
                self.displayDepartureInfo(flightInfoJSON: flightInfoJSON)
            
                self.displayDestinationInfo(flightInfoJSON: flightInfoJSON)
                
                let flightNum = UserDefaultsUtils.getFlightNum()
                
                let currentDepartureGate = flightInfoJSON["gate_orig"].stringValue
                self.checkDepartureGateChanged(flightNum: flightNum, departureDate: departureDate, currentGate: currentDepartureGate)
                
                self.saveFlightStatus(flightNum: flightNum, flightInfoJSON: flightInfoJSON)
            } else {
                print("getFlightInfo() return null")
            }
        })
    }
 
    private func checkDepartureGateChanged(flightNum: Int, departureDate: Date, currentGate: String) {
        let dao = FlightStatusDAO()
        if let oldFlightInfo = dao.read(byFlightNum: flightNum, byDepartureDate: departureDate) {
            if (oldFlightInfo.departureGate != currentGate) {
                self.createNotificationForGateChanged(flightNum: flightNum, oldGate: oldFlightInfo.departureGate, newGate: currentGate)
            } else {
                print("no gate changed")
            }
        }
    }


    private func setFlightNum() {
        flightNumLabel.text = String(UserDefaultsUtils.getFlightNum())
    }
    
    private func setDepartureDate() {
        let departureDate = UserDefaultsUtils.getDepartureDate()
        
        departureLabel.text = dateFormatter.string(from: departureDate!)
    }
    private func displayDepartureInfo(flightInfo: FlightInfo) {
        departureAirportLabel.text = flightInfo.departureAirport
    
        departureDateLabel.text = flightInfo.departureDate
        departureTimeLabel.text = flightInfo.departureTime
        
        departureGateLabel.text = flightInfo.departureGate
    }
    
    private func displayDestinationInfo(flightInfo: FlightInfo) {
        arrivalAirportLabel.text = flightInfo.arrivalAirport
        
        arrivalDateLabel.text = flightInfo.arrivalDate
        arrivalTimeLabel.text = flightInfo.arrivalTime
        
        arrivalGateLabel.text = flightInfo.arrivalGate
    }
    
    
    private func displayDepartureInfo(flightInfoJSON: JSON) {
        let origin = flightInfoJSON["origin"]
        departureAirportLabel.text = origin["airport_name"].stringValue
        
        let actualDepartureTime = flightInfoJSON["actual_departure_time"]
        departureDateLabel.text = actualDepartureTime["date"].stringValue
        departureTimeLabel.text = actualDepartureTime["time"].stringValue
        
        departureGateLabel.text = flightInfoJSON["gate_orig"].stringValue
    }
    
    private func displayDestinationInfo(flightInfoJSON: JSON) {
        let destination = flightInfoJSON["destination"]
        arrivalAirportLabel.text = destination["airport_name"].stringValue
        
        let actualArrivalTime = flightInfoJSON["actual_arrival_time"]
        arrivalDateLabel.text = actualArrivalTime["date"].stringValue
        arrivalTimeLabel.text = actualArrivalTime["time"].stringValue
        
        arrivalGateLabel.text = flightInfoJSON["gate_dest"].stringValue
    }
    
    private func saveFlightStatus(flightNum: Int, flightInfoJSON: JSON) {
        let origin = flightInfoJSON["origin"]
        let actualDepartureTime = flightInfoJSON["actual_departure_time"]
        // 12/04/2018
        let departureDate = actualDepartureTime["date"].stringValue
        // "01:28PM"
        let departureTime = actualDepartureTime["time"].stringValue
        let departureAirport = origin["airport_name"].stringValue
        let departureGate = flightInfoJSON["gate_orig"].stringValue
        
        
        let destination = flightInfoJSON["destination"]
        let arrivalAirport = destination["airport_name"].stringValue
        let actualArrivalTime = flightInfoJSON["actual_arrival_time"]
        let arrivalDate = actualArrivalTime["date"].stringValue
        let arrivalTime = actualArrivalTime["time"].stringValue
        let arrivalGate = flightInfoJSON["gate_dest"].stringValue
        
        let flightInfo = FlightInfo(flightNum: flightNum, departureAirport: departureAirport, departureDate: departureDate, departureTime: departureTime, departureGate: departureGate, arrivalAirport: arrivalAirport, arrivalDate: arrivalDate, arrivalTime: arrivalTime, arrivalGate: arrivalGate)
        
        
        let dao = FlightStatusDAO()
        
        dao.save(flightInfo: flightInfo)
    }
    
    private func getFlightInfo(byDate: Date) -> JSON? {
        let flightInfoStatusResult = flightInfoStatusResultJson["FlightInfoStatusResult"]
        
        let flights: [SwiftyJSON.JSON] = flightInfoStatusResult["flights"].arrayValue
        
        for flight in flights {
            let estimatedDepartureTime = flight["estimated_departure_time"]
            let dateStr = estimatedDepartureTime["date"].stringValue
            let departureDate = dateStr.asDate
            
            if byDate.isEqual(date: departureDate) {
                return flight
            }
        }
        
        return nil
    }
    
    
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
