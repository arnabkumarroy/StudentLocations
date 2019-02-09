//
//  UdacityOntheMapConvenience.swift
//  UdacityOntheMap
//
//  Created by Arnab Roy on 2/4/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit
import Foundation

extension UdacityOntheMapClient {
    
    func handleRequest( _ request: URLRequest, _ viewController: UIViewController, withCompletionHandler: @escaping( _ result: Data?, _ error: String?) -> Void) -> URLSessionDataTask {
        let request = request
        let task = session.dataTask(with: request) { data, response, error in
            self.checkForErrorInTask(data, response, error: error) { (success, error) in
                self.checkForError(success, error, viewController)
                self.checkStatusCode(data, inResponse: response, error as? Error) { (success, error) in
                    self.checkForError(success, error, viewController)
                    withCompletionHandler(data, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    //MARK: Account Functions
    func taskForLogin(_ viewController: UIViewController) {
        let loginURL = buildURL(Constants.onTheMapHost, withPathExtension: Constants.onTheMapSessionPath)
        var request = URLRequest(url: loginURL)
        request.httpMethod = Methods_TYPE.post
        request.addValue(Common_HTTPValues.json, forHTTPHeaderField: Common_HTTPHeaders_Key.accept)
        request.addValue(Common_HTTPValues.json, forHTTPHeaderField: Common_HTTPHeaders_Key.contentType)
        let body = [REQUEST_KEY.udacity: [DUMMY_VALUES.username: REQUEST_KEY.username, DUMMY_VALUES.password: REQUEST_KEY.password]]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            displayError(error: "Something went wrong!", "Please check your network connection or try again later.", viewController)
            return
        }
        
        handleRequest(request, viewController) { (result, error) in
            self.parseDataFromRange(result, error, viewController) { (result, error) in
                print(result!)
                guard let accountInfo = result![JSONResponseKeys.account] as? [String:AnyObject] else {
                    self.displayError(error: "Oops!", "Please check your network connection or try again later.", viewController)
                    return
                }
                guard let isSignedUp = accountInfo[JSONResponseKeys.registered] as? Bool else {
                    self.displayError(error: "Oops!", "You are not registered. Please register yourself.", viewController)
                    return
                }
                guard let accountId = accountInfo[JSONResponseKeys.key] as? String else {
                    self.displayError(error: "Oops!", "Please check your network connection or try again later.", viewController)
                    return
                }
                userId.userId = accountId
                if isSignedUp {
                    self.getUserDetails(viewController) { (success) in
                        if success {
                            self.getStudentLocationsResult(viewController) { (success) in
                                if success {
                                    performUIUpdatesOnMain {
                                        viewController.performSegue(withIdentifier: "Login", sender: viewController)
                                    }
                                } else {
                                    self.displayError(error: "oops!", "Please check your network connection or try again later.", viewController)
                                }
                            }
                        } else {
                            self.displayError(error: "oops!", "Please check your network connection or try again later.", viewController)
                        }
                    }
                }
            }
        }
    }
    
    
    func getLogout( nameOfViewController viewController: UIViewController) {
        let logoutURL = buildURL(Constants.onTheMapHost, withPathExtension: Constants.onTheMapSessionPath)
        var request = URLRequest(url: logoutURL)
        request.httpMethod = Methods_TYPE.delete
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == Common_HTTPValues.xsrfToken { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: Common_HTTPHeaders_Key.xsrfToken)
        }
        handleRequest(request, viewController) { (result, error) in
            self.parseDataFromRange(result, error, viewController) { (result, error) in
                guard let session = result![JSONResponseKeys.session] as? [String:Any] else {
                    self.displayError(error: "Oops!", "Unable to logout. Please try again later.", viewController)
                    return
                }
                if session.count > 0 {
                    performUIUpdatesOnMain {
                        viewController.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    func getUserDetails( _ viewController: UIViewController, _ userCompletionHandler: @escaping( _ success: Bool) -> Void) {
        let userInfoURL = buildURL(Constants.onTheMapHost, withPathExtension: Constants.onTheMapUsersPath)
        var mutableURL: URL = userInfoURL
        mutableURL = substituteKeyIn(url: userInfoURL, key: Constants.id, value: userId.userId)!
        let request = URLRequest(url: mutableURL)
        handleRequest(request, viewController) { (result, error) in
            self.parseDataFromRange(result, error, viewController) { (result, error) in
                guard let userFirstName = result![JSONResponseKeys.firstName] as? String else {
                    userCompletionHandler(false)
                    return
                }
                UdacityOntheMapClient.DUMMY_VALUES.firstName = userFirstName
                guard let userLastName = result![JSONResponseKeys.lastName] as? String else {
                    userCompletionHandler(false)
                    return
                }
                UdacityOntheMapClient.DUMMY_VALUES.lastName = userLastName
                userCompletionHandler(true)
            }
        }
    }
    
    // MARK: Student Location Functions
    func getStudentLocations( _ viewController: UIViewController, locationsCompletionHandler: @escaping( _ studentPosition: [StudentPosition]) -> Void) {
        let queryItems = [ParameterKeys.limit : ParameterValues.limit, ParameterKeys.order : ParameterValues.order] as [String:AnyObject]
        let studentLocationURL = buildURL(Constants.parseHost, Constants.parsePath, withQueryItems: queryItems)
        var request = URLRequest(url: studentLocationURL)
        request.addValue(Common_HTTPValues.applicationId, forHTTPHeaderField: Common_HTTPHeaders_Key.applicationId)
        request.addValue(Common_HTTPValues.apiKey, forHTTPHeaderField: Common_HTTPHeaders_Key.apiKey)
        handleRequest(request, viewController) { (result, error) in
            self.parseResult(result, error, viewController) { (result, error) in
                guard let results = result![JSONResponseKeys.results] as? [[String:AnyObject]] else {
                    locationsCompletionHandler([StudentPosition]())
                    return
                }
                StudentPosition.locations = StudentPosition.studentPositions(results: results)
                locationsCompletionHandler(StudentPosition.locations)
            }
        }
    }
    
    func getStudentLocationsResult( _ viewController: UIViewController, _ userCompletionHandler: @escaping( _ success: Bool) -> Void){
        let queryItems = [ParameterKeys.limit : ParameterValues.limit, ParameterKeys.order : ParameterValues.order] as [String:AnyObject]
        let studentLocationURL = buildURL(Constants.parseHost, Constants.parsePath, withQueryItems: queryItems)
        var request = URLRequest(url: studentLocationURL)
        request.addValue(Common_HTTPValues.applicationId, forHTTPHeaderField: Common_HTTPHeaders_Key.applicationId)
        request.addValue(Common_HTTPValues.apiKey, forHTTPHeaderField: Common_HTTPHeaders_Key.apiKey)
        handleRequest(request, viewController) { (result, error) in
            self.parseResult(result, error, viewController) { (result, error) in
                guard let results = result![JSONResponseKeys.results] as? [[String:AnyObject]] else {
                    userCompletionHandler(false)
                    return
                }
                StudentPosition.locations = StudentPosition.studentPositions(results: results)
                userCompletionHandler(true)
            }
        }
    }
    
    //MARK: to add by study address
    func addMyAddress( _ viewController: UIViewController) {
        let newLocationURL = buildURL(Constants.parseHost, withPathExtension: Constants.parsePath)
        var request = URLRequest(url: newLocationURL)
        request.httpMethod = Methods_TYPE.post
        request.addValue(Common_HTTPValues.applicationId, forHTTPHeaderField: Common_HTTPHeaders_Key.applicationId)
        request.addValue(Common_HTTPValues.apiKey, forHTTPHeaderField: Common_HTTPHeaders_Key.apiKey)
        request.addValue(Common_HTTPValues.json, forHTTPHeaderField: Common_HTTPHeaders_Key.contentType)
        let body: [String:Any] = [
            REQUEST_KEY.uniqueKey: DUMMY_VALUES.uniqueKey,
            REQUEST_KEY.firstName: DUMMY_VALUES.firstName,
            REQUEST_KEY.lastName: DUMMY_VALUES.lastName,
            REQUEST_KEY.mapString: DUMMY_VALUES.mapString,
            REQUEST_KEY.mediaURL: DUMMY_VALUES.mediaURL,
            REQUEST_KEY.latitude: DUMMY_VALUES.latitude,
            REQUEST_KEY.longitude: DUMMY_VALUES.longitude
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            displayError(error: "Something went wrong!", "Please check your network connection or try again later.", viewController)
            return
        }
        handleRequest(request, viewController) { (result, error) in
            self.parseResult(result, error, viewController) { (result, error) in
                if result!.count > 0 {
                    viewController.dismiss(animated: true)
                } else {
                    self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.", viewController)
                    return
                }
            }
        }
    }
    
}

