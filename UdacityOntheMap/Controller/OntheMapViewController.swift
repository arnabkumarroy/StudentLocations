//
//  OntheMapViewController.swift
//  UdacityOntheMap
//
//  Created by Arnab Roy on 2/4/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit
import MapKit

class OntheMapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Variables
    var annotations = [MKPointAnnotation]()
    var studentDetails: [StudentPosition] = []
    
    //MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mapView.delegate = self;
        displayStudentLocations()

    }
    
    //GET Student Locations
    
    func displayStudentLocations() {
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=40&order=-updatedAt")!)
         request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
         request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
         let session = URLSession.shared
         let task = session.dataTask(with: request) { data, response, error in
         guard error == nil else {
         UdacityOntheMapClient.sharedInstance().displayError(error: "Something went wrong!", "Please check your network connection or try again later.",self)
         return
         }
         guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
         UdacityOntheMapClient.sharedInstance().displayError(error: "Something went wrong!", "Please check your network connection or try again later.",self)
         return
         }
         let parsedResult: [String:AnyObject]
         do {
         parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
         } catch {
         UdacityOntheMapClient.sharedInstance().displayError(error: "Something went wrong!", "Please check your network connection or try again later.",self)
         return
         }
            
         guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
         UdacityOntheMapClient.sharedInstance().displayError(error: "Something went wrong!", "Please check your network connection or try again later.",self)
         return
         }
            self.studentDetails = StudentPosition.studentPositionsFrom(results: results)
        
         }
        for location in studentDetails {
            let lat = CLLocationDegrees(location.studentLatitude)
            let lon = CLLocationDegrees(location.studentLongitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let first = location.studentFirstName!
            let last = location.studentLastName!
            let url = location.studentURL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = url
            self.annotations.append(annotation)
        }
        performUIUpdatesOnMain {
            self.mapView.delegate = self
            self.mapView.addAnnotations(self.annotations)
        }
        task.resume()
 
        
    }
    
    // MARK: - MKMapViewDelegate Methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let locationURL = view.annotation?.subtitle!
            if (locationURL?.contains("http"))! {
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "OnTheMapWebViewController") as! OnTheMapWebViewController
                viewController.urlString = locationURL!
                self.navigationController!.pushViewController(viewController, animated: true)
            } else {
                UdacityOntheMapClient.sharedInstance().displayError(error: "Invalid URL", "This does not appear to be a valid URL. Please try another student", self)
            }
        }
    }
    
    @IBAction func logoutApplication() {
        UdacityOntheMapClient.sharedInstance().getLogout(nameOfViewController: self)
    }
    
}
