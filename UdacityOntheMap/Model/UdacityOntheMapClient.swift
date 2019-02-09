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
            if error == "Oops!" {
                displayError(error: error!, "Please check your network connection or try again later.", viewController)
            } else if error == "Invalid Credentials" {
                displayError(error: error!, "Please check your email and password are correct and try again", viewController)
            } else if error == "Network Issue" {
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
            checkStatusCodeCompletionHandler(false, "Status code other than 2xx!")
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
            parsedResult = try JSONSerialization.jsonObject(with: usableResult, options: .allowFragments) as? [String : AnyObject]
        } catch {
            parseCompletionHandler(nil, "Unable to parse data. wrong JSON")
            return
        }
        parseCompletionHandler(parsedResult, nil)
    }
    
    func parseResult( _ result: Data?, _ error: String?, _ viewController: UIViewController, _ parseResultCompletionHandler: @escaping( _ result: [String:AnyObject]?, _ error: String?) -> Void) {
        let parsedResult: [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as? [String:AnyObject]
        } catch {
            parseResultCompletionHandler(nil, "Unable to parse data. wrong JSON")
            return
        }
        parseResultCompletionHandler(parsedResult, nil)
    }
    
    // MARK: DisplayError
    func displayError(error: String, _ description: String, _ viewController: UIViewController) {
        print(error)
        let alert = UIAlertController(title: error, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        performUIUpdatesOnMain {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
}

