//
//  DisplayFlightInfoVC.swift
//  findmyway2
//
//  Created by Warren Chen on 12/4/18.
//  Copyright © 2018 Warren Chen. All rights reserved.
//

import UIKit

class DisplayFlightInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func getDepartureDate() -> Date {
        let defaults = UserDefaults.standard
        
        let departureDate = defaults.object(forKey: UserDefaultsConstant.DEPARTURE_DATE) as! Date
        return departureDate
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
