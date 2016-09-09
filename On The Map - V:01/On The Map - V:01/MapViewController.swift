
//
//  MapViewController.swift
//  On The Map - V:01
//
//  Created by Sneha gindi on 25/08/16.
//  Copyright © 2016 Sneha gindi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var tab: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.tab != nil {
            self.showOnTheMap(self.tab!)
        } else {
            let actionController = ActionController()
            actionController.taskForGetSL { results in
                print(results)
                let locations = results
                for dictionary in locations! {
                    self.showOnTheMap(dictionary)
                    //                self.mapView.addAnnotations(annotations)
                }
            }
        }
    }
    
    func showOnTheMap(dictionary: NSDictionary){
        
        guard let lat = dictionary["latitude"] as? Double else {
            return
        }
        guard let long = dictionary["longitude"] as? Double else {
            return
        }
        
        let latitude = CLLocationDegrees(lat)
        let longitude = CLLocationDegrees(long)
        
        //coordinate 2D
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let firstN = dictionary["firstName"] as? String
        let lastN = dictionary["lastName"] as? String
        let mediaURL = dictionary["mediaURL"] as? String
        
//        let position: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
//        let theSpan: MKCoordinateSpan = MKCoordinateSpanMake(20,20)
////        let region:MKCoordinateRegion = MKCoordinateRegionMake(position, theSpan)
////        self.mapView.setRegion(region, animated: true)
////        
        //annotations and setting it's properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(firstN!) \(lastN!)"
        annotation.subtitle = mediaURL
        self.mapView.addAnnotation(annotation)
//        annotations.append(annotation)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pin"
        self.mapView.zoomEnabled = true
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as MKAnnotationView?
        
        if pinView == nil {
            
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
    return pinView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped
        control: UIControl) {
    
        if control == view.rightCalloutAccessoryView{
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
}
