//
//  DetailsVC.swift
//  FourSquare-Clone-2022
//
//  Created by Murat Sağlam on 4.02.2022.
//

import UIKit
import MapKit
import Parse
class DetailsVC: UIViewController, MKMapViewDelegate{
    
    
    @IBOutlet weak var detailsImageView: UIImageView!
    
    @IBOutlet weak var detailsNameLabel: UILabel!
    
    @IBOutlet weak var detailsTypeLabel: UILabel!
    
    @IBOutlet weak var detailsAtmoshpereLabel: UILabel!
    
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromParse()
        detailsMapView.delegate = self
        
    }
    
    func getDataFromParse()
    {
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground {  (objects, error) in
            if error != nil
            {
                
                
            }
            else
            {
                
                // OBJECT
                
                if objects != nil
                {
                    if objects!.count > 0
                    {
                        let chosenPlaceObject = objects![0]
                        
                        if let placeName = chosenPlaceObject.object(forKey: "name") as? String
                        {
                            self.detailsNameLabel.text = placeName
                            
                        }
                        
                        if let placeType = chosenPlaceObject.object(forKey: "type") as? String
                        {
                            self.detailsTypeLabel.text = placeType
                            
                        }
                        
                        if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String
                        {
                            self.detailsAtmoshpereLabel.text = placeAtmosphere
                            
                        }
                        
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String
                        {
                            if let placeLatitudeDobule = Double(placeLatitude)
                            {
                                self.chosenLatitude = placeLatitudeDobule
                            }
                        }
                        
                        if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String
                        {
                            if let placeLongitude = Double(placeLongitude)
                            {
                                self.chosenLongitude = placeLongitude
                            }
                        }
                        
                        if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject
                        {
                            imageData.getDataInBackground {(data, error ) in
                                if error == nil
                                {
                                    if data != nil
                                    {
                                        self.detailsImageView.image = UIImage(data: data!)
                                    }
                                }
                            }
                        }
                        
                        
                        //MAP
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        
                        let region = MKCoordinateRegion(center: location, span: span)
                        
                        self.detailsMapView.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.detailsNameLabel.text!
                        annotation.subtitle = self.detailsTypeLabel.text!
                        self.detailsMapView.addAnnotation(annotation)
                    }
                    
                }
                
            }
            
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.canShowCallout = true
                let button = UIButton(type: .detailDisclosure)
                pinView?.rightCalloutAccessoryView = button
            } else {
                pinView?.annotation = annotation
            }
            
            return pinView
            
        }
        
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
                let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                
                CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                    if let placemark = placemarks {
                        
                        if placemark.count > 0 {
                            
                            let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                            let mapItem = MKMapItem(placemark: mkPlaceMark)
                            mapItem.name = self.detailsNameLabel.text
                            
                            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                            
                            mapItem.openInMaps(launchOptions: launchOptions)
                        }
                        
                    }
                }
                
            }
        }
    
    
    
}
