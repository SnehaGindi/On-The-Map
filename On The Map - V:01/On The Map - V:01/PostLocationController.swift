//
//  PostLocationController.swift
//  On The Map - V:01
//
//  Created by Sneha gindi on 02/09/16.
//  Copyright © 2016 Sneha gindi. All rights reserved.
//

import UIKit
import MapKit

class PostLocationController: UIViewController {
    override func viewDidLoad() {
          self.mapViewSL?.hidden = true
          self.linkTF?.hidden = true
          self.submitBut?.hidden = true
          _ = ActionController().taskForPutSL { (_: [NSDictionary]?) in
            print("Putting Student Location.")
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addressTFOutlet: UITextField!
    @IBOutlet weak var mapViewSL: MKMapView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var submitBut: UIButton!
    @IBOutlet weak var findButton: UIButton!
    
    @IBAction func didSelectFOTM(sender: AnyObject) {
        
        
        let geocoder = CLGeocoder()
        let address = addressTFOutlet.text
        activityIndicator.startAnimating()
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                let alert = UIAlertController(title: "Error", message: "There's been a small problem...", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay! I won't worry. ", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

            }
            if let placemark = placemarks?.first {
                let coordinates = placemark.location?.coordinate
                guard coordinates != nil else {
                    print("Error!")
                    return
                }
                print(coordinates!)
                
                self.mapViewSL?.hidden = false
                self.linkTF.hidden = false
                self.submitBut.hidden = false
                self.findButton.hidden = true
                self.addressTFOutlet?.hidden = true
                self.label.hidden = true
                
                let lat: CLLocationDegrees = (coordinates?.latitude)!
                let long: CLLocationDegrees = (coordinates?.longitude)!
                let position: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
                let theSpan: MKCoordinateSpan = MKCoordinateSpanMake(20, 20)
                
                var region:MKCoordinateRegion = MKCoordinateRegionMake(position, theSpan)
                self.mapViewSL.setRegion(region, animated: true)
                
                var pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
                var objectAnnotation = MKPointAnnotation()
                objectAnnotation.coordinate = pinLocation
                self.mapViewSL.addAnnotation(objectAnnotation)
                print(self.linkTF.text)
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
        })
        
            let controller = storyboard?.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
            print(addressTFOutlet.text!)
            navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func submitButton(sender: AnyObject) {
        if linkTF.text?.characters.count == 0 {
            let alert = UIAlertController(title: "Oops!", message: "Did you forget to type your link?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "I'm on it.", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        } else {
            
        }
        print("Submit Button Pressed")
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        let controller = dismissViewControllerAnimated(true) {
            print("Cancel button pressed")
            }
        }
    
}
