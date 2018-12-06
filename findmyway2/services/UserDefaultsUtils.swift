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
    
    func fromISO8601asDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        
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
    
    func toISO8601() -> String {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        dateStringFormatter.timeZone = TimeZone.current
        
        return dateStringFormatter.string(from: self)
    }
}

extension Date {
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
}

struct UserDefaultsConstant {
    static let FLIGHT_NUMBER = "flightNumber"
    static let DEPARTURE_DATE = "departure"
}

class UserDefaultsUtils {
    public static func saveFlightNum(flightNum: Int) {
        let defaults = UserDefaults.standard
        
        defaults.set(flightNum, forKey: UserDefaultsConstant.FLIGHT_NUMBER)
    }
    
    public static func getFlightNum() -> Int {
        let defaults = UserDefaults.standard
        
        return defaults.integer(forKey: UserDefaultsConstant.FLIGHT_NUMBER)
    }
    
    public static func saveDepartureDate(date: Date) {
        let defaults = UserDefaults.standard
        
        defaults.set(date, forKey: UserDefaultsConstant.DEPARTURE_DATE)
    }
    
    public static func getDepartureDate() -> Date? {
        let defaults = UserDefaults.standard
        
        return defaults.object(forKey: UserDefaultsConstant.DEPARTURE_DATE) as? Date ?? nil
    }
    
    public static func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}


