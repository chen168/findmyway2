//
//  DevViewController.swift
//  findmyway2
//
//  Created by Warren Chen on 12/6/18.
//  Copyright © 2018 Warren Chen. All rights reserved.
//

import UIKit

class DevViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetDepartureGateBtnTapped(_ sender: UIButton) {
        let flightNum = UserDefaultsUtils.getFlightNum()
        let departureDate = UserDefaultsUtils.getDepartureDate()!
        
        let dao = FlightStatusDAO()
        if let oldFlightInfo = dao.read(byFlightNum: flightNum, byDepartureDate: departureDate) {
            let updatedGateFlightInfo = FlightInfo(flightNum: flightNum, departureAirport: oldFlightInfo.departureAirport, departureDate: oldFlightInfo.departureDate, departureTime: oldFlightInfo.departureTime, departureGate: "-1", arrivalAirport: oldFlightInfo.arrivalAirport, arrivalDate: oldFlightInfo.arrivalDate, arrivalTime: oldFlightInfo.arrivalTime, arrivalGate: oldFlightInfo.arrivalGate)
            
            dao.save(flightInfo: updatedGateFlightInfo)
        }
        
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
