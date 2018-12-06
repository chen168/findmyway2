//
//  FlightAwareServices.swift
//  findmyway2
//
//  Created by Warren Chen on 12/4/18.
//  Copyright © 2018 Warren Chen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FlightAwareServices {
    public func flightInfoStatus(flightNum: Int, departure: Date, _ callback: @escaping (JSON)->Void) {
        let url = "http://flightxml.flightaware.com/json/FlightXML3/FlightInfoStatus?ident=ASA" + String(flightNum) + "&include_ex_data=true"
        Alamofire.request(url).authenticate(user: "kimate", password: "6ea9e24e929403785d2f2bd99684a76fda3aed14")
            .responseJSON { response in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    //           print("Data: \(utf8Text)") // original server data as UTF8 string
                    
                    if let json = try? JSON(data: data) {
                        callback(json)
                    }
                }
        }
    }

    
    public func callFlightAware() {
        
        Alamofire.request("http://flightxml.flightaware.com/json/FlightXML3/FlightInfoStatus?ident=ASA1388&include_ex_data=true").authenticate(user: "kimate", password: "6ea9e24e929403785d2f2bd99684a76fda3aed14")
            .responseJSON { response in
                
                print(response)
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
        }
    }
   
    public func getPnr(pnr: String, _ callback: @escaping (JSON)->Void) {
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
   //         print("Request: \(String(describing: response.request))")   // original url request
   //         print("Response: \(String(describing: response.response))") // http url response
   //         print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
     //           print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
     //           print("Data: \(utf8Text)") // original server data as UTF8 string
                
                if let json = try? JSON(data: data) {
                    callback(json)
                }
            }
        }
    }

}
