//
//  FlightInfoTVC.swift
//  findmyway2
//
//  Created by Warren Chen on 12/4/18.
//  Copyright © 2018 Warren Chen. All rights reserved.
//

import UIKit
import SwiftyJSON

class FlightInfoTVC: UITableViewController {

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
    
    var flightInfoStatusResultJson: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        setFlightNum()
        setDepartureDate()

        setFlightInfoStatus()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func setFlightInfoStatus() {
        let flightNum = UserDefaultsUtils.getFlightNum()
        let departureDate = UserDefaultsUtils.getDepartureDate()
        
        let service = FlightAwareServices()
        service.flightInfoStatus(flightNum: flightNum, departure: departureDate, {
            result in
            //print("chen168: \(result)")
            self.flightInfoStatusResultJson = result
            
            if let flightInfo = self.getFlightInfo(byDate: departureDate) {
                print("found: \(flightInfo)")
            
                self.displayDepartureInfo(flightInfo: flightInfo)
            
                self.displayDestinationInfo(flightInfo: flightInfo)
            } else {
                print("getFlightInfo() return null")
            }
        })
    }

    private func setFlightNum() {
        flightNumLabel.text = UserDefaultsUtils.getFlightNum()
    }
    
    private func setDepartureDate() {
        let departureDate = UserDefaultsUtils.getDepartureDate()
        
        departureLabel.text = dateFormatter.string(from: departureDate)
    }
    
    private func displayDepartureInfo(flightInfo: JSON) {
        let origin = flightInfo["origin"]
        departureAirportLabel.text = "why" // origin["airport_name"].stringValue
        
        let actualDepartureTime = flightInfo["actual_departure_time"]
        departureDateLabel.text = actualDepartureTime["date"].stringValue
        departureTimeLabel.text = actualDepartureTime["time"].stringValue
        
        departureGateLabel.text = flightInfo["gate_orig"].stringValue
    }
    
    private func displayDestinationInfo(flightInfo: JSON) {
        let destination = flightInfo["destination"]
        arrivalAirportLabel.text = destination["airport_name"].stringValue
        
        let actualArrivalTime = flightInfo["actual_arrival_time"]
        arrivalDateLabel.text = actualArrivalTime["date"].stringValue
        arrivalTimeLabel.text = actualArrivalTime["time"].stringValue
        
        arrivalGateLabel.text = flightInfo["gate_dest"].stringValue
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
