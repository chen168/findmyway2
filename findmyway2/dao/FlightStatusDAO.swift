//
//  FlightStatusDAO.swift
//  findmyway2
//
//  Created by Warren Chen on 12/5/18.
//  Copyright © 2018 Warren Chen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FlightStatusDAO {
    static let ENTITY = "FlightStatus"
    
    static let FLIGHT_NUM = "flightNum"
    
    static let DEPARTURE_DATE = "departureDate"
    static let DEPARTURE_TIME = "departureTime"
    static let DEPARTURE_AIRPORT = "departureAirport"
    static let DEPARTURE_GATE = "departureGate"
    
    static let ARRIVAL_DATE = "arrivalDate"
    static let ARRIVAL_TIME = "arrivalTime"
    static let ARRIVAL_AIRPORT = "arrivalAirport"
    static let ARRIVAL_GATE = "arrivalGate"
    
    public func save(flightInfo: FlightInfo) {
        deleteAllData()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: FlightStatusDAO.ENTITY, in: managedContext)!
        let flightStatus = NSManagedObject(entity: entity, insertInto: managedContext)
        
        flightStatus.setValue(flightInfo.flightNum, forKeyPath: FlightStatusDAO.FLIGHT_NUM)
        
        flightStatus.setValue(flightInfo.departureDate, forKey: FlightStatusDAO.DEPARTURE_DATE)
        flightStatus.setValue(flightInfo.departureTime, forKey: FlightStatusDAO.DEPARTURE_TIME)
        flightStatus.setValue(flightInfo.departureAirport, forKey: FlightStatusDAO.DEPARTURE_AIRPORT)
        flightStatus.setValue(flightInfo.departureGate, forKey: FlightStatusDAO.DEPARTURE_GATE)
        
        flightStatus.setValue(flightInfo.arrivalDate, forKey: FlightStatusDAO.ARRIVAL_DATE)
        flightStatus.setValue(flightInfo.arrivalTime, forKey: FlightStatusDAO.ARRIVAL_TIME)
        flightStatus.setValue(flightInfo.arrivalAirport, forKey: FlightStatusDAO.ARRIVAL_AIRPORT)
        flightStatus.setValue(flightInfo.arrivalGate, forKey: FlightStatusDAO.ARRIVAL_GATE)
        
        do {
            try managedContext.save()
            print("FlightStatusDAO.save(): saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func read(byFlightNum: Int, byDepartureDate: Date) -> FlightInfo? {
        if let flightStatus = readManagedObject(byFlightNum: byFlightNum, byDepartureDate: byDepartureDate) {
            
            let myFlightNum = flightStatus.value(forKey: FlightStatusDAO.FLIGHT_NUM) as! Int
            
            let myDepartDate = flightStatus.value(forKey: FlightStatusDAO.DEPARTURE_DATE) as! String
            let myDepartTime = flightStatus.value(forKey: FlightStatusDAO.DEPARTURE_TIME) as! String
            let myDepartureAirport = flightStatus.value(forKey: FlightStatusDAO.DEPARTURE_AIRPORT) as! String
            let myDepartureGate = flightStatus.value(forKey: FlightStatusDAO.DEPARTURE_GATE) as! String
            
            
            let myArrivalDate = flightStatus.value(forKey: FlightStatusDAO.ARRIVAL_DATE) as! String
            let myArrivalTime = flightStatus.value(forKey: FlightStatusDAO.ARRIVAL_TIME) as! String
            let myArrivalAirport = flightStatus.value(forKey: FlightStatusDAO.ARRIVAL_AIRPORT) as! String
            let myArrivalGate = flightStatus.value(forKey: FlightStatusDAO.ARRIVAL_GATE) as! String
            
            print("FlightStatusDAO.read(): FlightInfo found")
            
            return FlightInfo(flightNum: myFlightNum, departureAirport: myDepartureAirport, departureDate: myDepartDate, departureTime: myDepartTime, departureGate: myDepartureGate, arrivalAirport: myArrivalAirport, arrivalDate: myArrivalDate, arrivalTime: myArrivalTime, arrivalGate: myArrivalGate)
        }
        
        print("FlightStatusDAO.read(): FlightInfo NOTfound")
        return nil
    }
    
    public func readManagedObject(byFlightNum: Int, byDepartureDate: Date) -> NSManagedObject? {
        var flightStatusList: [NSManagedObject] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: FlightStatusDAO.ENTITY)
        
        let byDepartureDateStr = byDepartureDate.toISO8601()
        
      //  fetchRequest.predicate = NSPredicate(format: "flightNum == \(byFlightNum) AND departureDateTime = \(byDepartureDateStr)")
        fetchRequest.predicate = NSPredicate(format: "flightNum == \(byFlightNum)")
        
        do {
            flightStatusList = try managedContext.fetch(fetchRequest)
            print("flightStatusList.count=\(flightStatusList.count)")
            
            if (flightStatusList.count == 0) {
                return nil
            }
            
            let flightStatus = flightStatusList[0]
    
            return flightStatus
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            
            return nil
        }
    }
    
    func deleteAllData() {
        print("deleteAllData()")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: FlightStatusDAO.ENTITY)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
            
            try managedContext.save()
        } catch let error {
            print("Detele all data in \(FlightStatusDAO.ENTITY) error :", error)
        }
    }
}
