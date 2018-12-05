//
//  UserDefaultsService.swift
//  findmyway2
//
//  Created by Warren Chen on 12/4/18.
//  Copyright © 2018 Warren Chen. All rights reserved.
//

import Foundation

extension String {
    var asDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: self)
        
        return date!
    }
}

extension Date {
    func isEqual(date: Date) -> Bool {
        let order = Calendar.current.compare(self, to: date, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
}

struct UserDefaultsConstant {
    static let FLIGHT_NUMBER = "flightNumber"
    static let DEPARTURE_DATE = "departure"
}

class UserDefaultsUtils {
    public static func saveFlightNum(flightNum: String) {
        let defaults = UserDefaults.standard
        
        defaults.set(flightNum, forKey: UserDefaultsConstant.FLIGHT_NUMBER)
    }
    
    public static func getFlightNum() -> String {
        let defaults = UserDefaults.standard
        
        return defaults.string(forKey: UserDefaultsConstant.FLIGHT_NUMBER) ?? ""
    }
    
    public static func saveDepartureDate(date: Date) {
        let defaults = UserDefaults.standard
        
        defaults.set(date, forKey: UserDefaultsConstant.DEPARTURE_DATE)
    }
    
    public static func getDepartureDate() -> Date {
        let defaults = UserDefaults.standard
        
        return defaults.object(forKey: UserDefaultsConstant.DEPARTURE_DATE) as! Date
    }
}


