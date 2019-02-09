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
    
    //Display Student location as PIN using MKPointAnnotation
    func displayStudentLocations() {
        UdacityOntheMapClient.sharedInstance().getStudentLocations(self) { (student) in
            self.studentDetails = student
            for location in self.studentDetails {
                let lat = CLLocationDegrees(location.studentLatitude)
                let lon = CLLocationDegrees(location.studentLongitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let studentFirstName = location.studentFirstName!
                let studentLastName = location.studentLastName!
                let url = location.studentURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(studentFirstName) \(studentLastName)"
                annotation.subtitle = url
                self.annotations.append(annotation)
            }
            performUIUpdatesOnMain {
                self.mapView.delegate = self
                self.mapView.addAnnotations(self.annotations)
            }
        }
    }
    
    // MARK: - MKMapViewDelegate Methods to display the PIN
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
    
    // MARK: - MKMapViewDelegate Methods to go to the webpage on click of it.
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
