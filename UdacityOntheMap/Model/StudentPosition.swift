//
//  StudentPosition.swift
//  UdacityOntheMap
//
//  Created by Arnab Roy on 2/4/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//
import Foundation

struct StudentPosition {
    
    //MARK: - Constants
    let studentUniqueKey: String
    let studentFirstName: String?
    let studentLastName: String?
    let studentLatitude: Double
    let studentLongitude: Double
    let studentMapString: String
    let studentURL: String
    
    static var locations = [StudentPosition]()
    
    static func studentPositions(results: [[String:AnyObject]]) -> [StudentPosition] {
        var studentPositions = [StudentPosition]()
        for result in results {
            studentPositions.append(StudentPosition(dictionary: result))
        }
        return studentPositions
    }
    
    // construct a StudentLocation from a dictionary
    init(dictionary: [String:AnyObject]) {
        if dictionary["uniqueKey"] != nil {
            studentUniqueKey = dictionary["uniqueKey"] as! String
        } else {
            studentUniqueKey = "This is weird"
        }
        if dictionary["firstName"] != nil {
            studentFirstName = dictionary["firstName"] as? String ?? ""
        } else {
            studentFirstName = ""
        }
        if dictionary["lastName"] != nil {
            studentLastName = dictionary["lastName"] as? String ?? ""
        } else {
            studentLastName = ""
        }
        if dictionary["latitude"] != nil {
            studentLatitude = (dictionary["latitude"] as! NSNumber).doubleValue
        } else {
            studentLatitude = 0.00
        }
        if dictionary["longitude"] != nil {
            studentLongitude = (dictionary["longitude"] as! NSNumber).doubleValue
        } else {
            studentLongitude = 0.00
        }
        if dictionary["mapString"] != nil {
            studentMapString = dictionary["mapString"] as! String
        } else {
            studentMapString = ""
        }
        if dictionary["mediaURL"] != nil {
            studentURL = dictionary["mediaURL"] as! String
        } else {
            studentURL = "https://www.google.com/"
        }
    }
}

