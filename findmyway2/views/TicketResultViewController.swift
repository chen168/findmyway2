//
//  TicketResultViewController.swift
//  findmyway2
//
//  Created by Warren Chen on 12/3/18.
//  Copyright © 2018 Warren Chen. All rights reserved.
//

import UIKit
import SwiftyJSON

class TicketResultViewController: UIViewController {
    
    @IBOutlet weak var pnrLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var pnr = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pnr = getPnr()
        pnrLabel.text = pnr
        
        callFlightAwareApi()
    }
    
    private func getPnr() -> String {
        let defaults = UserDefaults.standard
        
        let pnr = defaults.string(forKey: "pnr")!
        return pnr
    }
    
    private func callFlightAwareApi() {
        let service = FlightAwareServices()
        
        service.getPnr(pnr: pnr, {
            result in
            //print("chen168: \(result)")
            self.resultLabel.text = result["origin"].string
        })
        
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
