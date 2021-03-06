//
//  UdacityOnTheMapConstants.swift
//  UdacityOntheMap
//
//  Created by Arnab Roy on 2/4/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

extension UdacityOntheMapClient {
    
    // MARK: Constants
    struct Constants  { // Rename to urlComponents
        static let ApiScheme = "https"
        static let id = "id"
        static let onTheMapHost = "onthemap-api.udacity.com"
        static let onTheMapSessionPath = "/v1/session"
        static let onTheMapUsersPath = "/v1/users/id"
        static let parseHost = "parse.udacity.com"
        static let parsePath = "/parse/classes/StudentLocation"
    }
    
    struct userId {
        static var userId = "0"
    }
    
    struct REQUEST_KEY {
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let password = "password"
        static let udacity = "udacity"
        static let uniqueKey = "uniqueKey"
        static let username = "username"
    }
    
    struct DUMMY_VALUES {
        static var firstName = "Arnab"
        static var lastName = "Roy"
        static var latitude = 0.00
        static var longitude = 0.00
        static var mapString = "Mexico City"
        static var mediaURL = "https://www.google.com"
        static var password = "password"
        static var uniqueKey = "unIqueKey123"
        static var username = "arnab.roy@gmail.com"
    }
    
    struct Common_HTTPHeaders_Key {
        static let accept = "Accept"
        static let apiKey = "X-Parse-REST-API-Key"
        static let applicationId = "X-Parse-Application-Id"
        static let contentType = "Content-Type"
        static let xsrfToken = "X-XSRF-Token"
    }
    
    struct Common_HTTPValues {
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let json = "application/json"
        static let xsrfToken = "XSRF-TOKEN"
    }
    
    struct JSONResponseKeys {
        static let account = "account"
        static let firstName = "first_name"
        static let key = "key"
        static let lastName = "last_name"
        static let results = "results"
        static let session = "session"
        static let registered = "registered"
        static let error = "error"
    }
    
    struct Methods_TYPE {
        static let delete = "DELETE"
        static let post = "POST"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let limit = "limit"
        static let order = "order"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let limit = "100"
        static let order = "-updatedAt"
    }
}

