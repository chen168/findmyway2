//
//  ViewController.swift
//  findmyway2
//
//  Created by Warren Chen on 12/3/18.
//  Copyright © 2018 Warren Chen. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ticketTextView: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var ticketLabel: UILabel!
    
    var pnrEntered = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ticketTextView.delegate = self
        
        testApiCall()
    }
    
    @IBAction func submitBtnTouched(_ sender: UIButton) {
        updatePnrTextView()
        
        if !isValidPnr() {
            ticketLabel.text = "Invalid PNR"
        } else {
            ticketLabel.text = ""
            pnrEntered = ticketTextView.text!
            
            savePnr(pnr: pnrEntered)
        }
        
    }
    
    private func testApiCall() {
        let service = FlightAwareServices()
       service.callFlightAware()
        /*
        service.getPnr(pnr: pnrEntered, {
            result in
            print("chen168: \(result)")
        })
   */
    }

    
    private func savePnr(pnr: String) {
        let defaults = UserDefaults.standard
        defaults.set(pnr, forKey: "pnr")
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isValidPnr() {
            return true
        } else {
            return false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        ticketTextView.textColor = UIColor.black
        
        return true
    }
    
    private func updatePnrTextView() {
        
        if isValidPnr() {
            ticketTextView.textColor = UIColor.black
        } else {
            ticketTextView.textColor = UIColor.red
        }
        
    }
    
    private func isValidPnr() -> Bool {
        if ticketTextView.text?.count == 6 {
            return true
        } else {
            return false
        }
    }
}

