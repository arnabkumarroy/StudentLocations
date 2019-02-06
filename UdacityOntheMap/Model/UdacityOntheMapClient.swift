//
//  UdacityOntheMapClient.swift
//  UdacityOntheMap
//
//  Created by Arnab Roy on 2/4/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//
import UIKit
import Foundation

// MARK: - TMDBClient: NSObject

class UdacityOntheMapClient : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var requestToken: String? = nil
    var sessionID : String? = nil
    var userID : Int? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
//    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
//        
//        /* 1. Set the parameters */
//        var param = parameters
//        param[UdacityOntheMapClient.HTTPValues.apiKey] = UdacityOntheMapClient.HTTPValues.apiKey as AnyObject
//        
//        /* 2/3. Build the URL, Configure the request */
//        let request = URLRequest(url: UdacityOntheMapClient.tmdbURLFromParameters(param as [String:AnyObject], withPathExtension: method))
//        
//        /* 4. Make the request */
//        let task = session.dataTask(with: request) { (data, response, error) in
//            
//            func sendError(error: String) {
//                let userInfo = [NSLocalizedDescriptionKey: error]
//                completionHandlerForGET(nil, NSError(domain: "There was an error with your request: ", code: 1, userInfo: userInfo))
//            }
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                sendError(error: "There was an error with your request: \(error!)")
//                return
//            }
//            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                sendError(error: "Your request returned a status code other than 2xx!")
//                return
//            }
//            
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                sendError(error: "No data was returned by the request!")
//                return
//            }
//            
//            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
//        }
//        task.resume()
//        return task
//    }
//    
//    // MARK: POST
//    
//    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
//        
//        /* 1. Set the parameters */
//        var param = parameters
//        param[TMDBClient.ParameterKeys.ApiKey] = TMDBClient.Constants.ApiKey as AnyObject
//        
//        /* 2/3. Build the URL, Configure the request */
//        var request = URLRequest(url: TMDBClient.tmdbURLFromParameters(param as [String:AnyObject], withPathExtension: method))
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
//        
//        /* 4. Make the request */
//        let task = session.dataTask(with: request) { (data, response, error) in
//            
//            func sendError(error: String) {
//                let userInfo = [NSLocalizedDescriptionKey: error]
//                completionHandlerForPOST(nil, NSError(domain: "There was an error with your request: ", code: 1, userInfo: userInfo))
//            }
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                sendError(error: "There was an error with your request: \(error!)")
//                return
//            }
//            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                sendError(error: "Your request returned a status code other than 2xx!")
//                return
//            }
//            
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                sendError(error: "No data was returned by the request!")
//                return
//            }
//            
//            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
//        }
//        task.resume()
//        return task
//    }
//    
//    
//    
//    // MARK: Helpers
//    
//    // substitute the key for the value that is contained within the method name
//    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
//        if method.range(of: "{\(key)}") != nil {
//            return method.replacingOccurrences(of: "{\(key)}", with: value)
//        } else {
//            return nil
//        }
//    }
//    
//    // given raw JSON, return a usable Foundation object
//    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
//        
//        var parsedResult: AnyObject! = nil
//        do {
//            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
//        } catch {
//            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
//            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
//        }
//        
//        completionHandlerForConvertData(parsedResult, nil)
//    }
//    
//    // create a URL from parameters
//    class func OMTURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
//        
//        var components = URLComponents()
//        components.scheme = UdacityOntheMapClient.Constants.ApiScheme
//        components.host = UdacityOntheMapClient.Constants.ApiHost
//        components.path = UdacityOntheMapClient.Constants.ApiPath + (withPathExtension ?? "")
//        components.queryItems = [URLQueryItem]()
//        
//        for (key, value) in parameters {
//            let queryItem = URLQueryItem(name: key, value: "\(value)")
//            components.queryItems!.append(queryItem)
//        }
//        
//        return components.url!
//    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityOntheMapClient {
        struct Singleton {
            static var sharedInstance = UdacityOntheMapClient()
        }
        return Singleton.sharedInstance
    }
    
    
    // MARK: BuildURL
    func buildURL( _ host: String, withPathExtension: String) -> URL {
        var components = URLComponents()
        components.scheme = UdacityOntheMapClient.Constants.ApiScheme
        components.host = host
        components.path = withPathExtension
        return components.url!
    }
    
    // MARK: AddQueryItems
    func buildURL( _ host: String, _ path: String, withQueryItems: [String:AnyObject]) -> URL {
        var components = URLComponents()
        components.scheme = UdacityOntheMapClient.Constants.ApiScheme
        components.host = host
        components.path = path
        components.queryItems = [URLQueryItem]()
        for (key, value) in withQueryItems {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    // MARK: Substitute key in url (to add user id)
    func substituteKeyIn(url: URL, key: String, value: String) -> URL? {
        let urlString = String(describing: url)
        if urlString.range(of: "\(key)") != nil {
            return URL(string: urlString.replacingOccurrences(of: "\(key)", with: value))
        } else {
            return nil
        }
    }
    
    // MARK: Check for error
    func checkForErrorInTask( _ data: Data?, _ response: URLResponse?, error: Error?, checkForErrorCompletionHandler: @escaping( _ success: Bool, _ error: String?) -> Void) {
        guard error == nil else {
            checkForErrorCompletionHandler(false, "Something went wrong!")
            return
        }
        checkForErrorCompletionHandler(true, nil)
    }
    
    func checkForError( _ success: Bool, _ error: String?, _ viewController: UIViewController) {
        guard error == nil else {
            if error == "Something went wrong!" {
                displayError(error: error!, "Please check your network connection or try again later.", viewController)
            } else if error == "Invalid Credentials" {
                displayError(error: error!, "Please check your email and password are correct and try again", viewController)
            } else if error == "Unable to Connect" {
                displayError(error: error!, "Please check your network connection and try again", viewController)
            } else {
                displayError(error: "Something went wrong!", "Please check your network connection or try again later.", viewController)
            }
            return
        }
    }
    
    // MARK: Check HTTPURLResponse
    func checkStatusCode( _ data: Data?, inResponse: URLResponse?, _ error: Error?, checkStatusCodeCompletionHandler: @escaping( _ success: Bool, _ error: String?) -> Void) {
        guard let statusCode = (inResponse as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 599 else {
            checkStatusCodeCompletionHandler(false, "Your request returned a status code other than 2xx!")
            return
        }
        if statusCode >= 300 && statusCode <= 399 {
            checkStatusCodeCompletionHandler(false, "Something went wrong!")
        } else if statusCode >= 400 && statusCode <= 499 {
            checkStatusCodeCompletionHandler(false, "Invalid Credentials")
        } else if statusCode >= 500 {
            checkStatusCodeCompletionHandler(false, "Unable to Connect")
        }
        checkStatusCodeCompletionHandler(true, nil)
    }
    
    //MARK: ParseResult Functions
    func parseDataFromRange( _ result: Data?, _ error: String?, _ viewController: UIViewController, _ parseCompletionHandler: @escaping( _ result: [String:AnyObject]?, _ error: String?) -> Void) {
        let range = Range(5..<result!.count)
        let usableResult = result!.subdata(in: range)
        let parsedResult: [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: usableResult, options: .allowFragments) as! [String : AnyObject]
        } catch {
            parseCompletionHandler(nil, "Unable to parse data")
            return
        }
        parseCompletionHandler(parsedResult, nil)
    }
    
    func parseResult( _ result: Data?, _ error: String?, _ viewController: UIViewController, _ parseResultCompletionHandler: @escaping( _ result: [String:AnyObject]?, _ error: String?) -> Void) {
        let parsedResult: [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as! [String:AnyObject]
        } catch {
            parseResultCompletionHandler(nil, "Unable to parse data")
            return
        }
        parseResultCompletionHandler(parsedResult, nil)
    }
    
    // MARK: DisplayError
    func displayError(error: String, _ description: String, _ viewController: UIViewController) {
        print(error)
        let alert = UIAlertController(title: error, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        performUIUpdatesOnMain {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
}

