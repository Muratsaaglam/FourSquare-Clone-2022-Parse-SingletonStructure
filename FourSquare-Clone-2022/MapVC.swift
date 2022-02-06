//
//  MapVC.swift
//  FourSquare-Clone-2022
//
//  Created by Murat Sağlam on 4.02.2022.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationmanager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MapKit Buttons
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        // Locaiton Verification
        
        mapView.delegate = self
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        
        
        
        //Screen Long PRessed
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
        
        
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer)
    {
        let touches = gestureRecognizer.location(in: self.mapView)
        let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = PlaceModel.sharedInstance.placeName
        annotation.subtitle = PlaceModel.sharedInstance.placeType
        
        self.mapView.addAnnotation(annotation)
        PlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
        PlaceModel.sharedInstance.placeLongitude = String(coordinates.longitude)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    //MapKit Button Func
    @objc func saveButtonClicked()
    {
        
        let placeModel = PlaceModel.sharedInstance
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5)
        {
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
            
        }
        object.saveInBackground{(succes, error) in
            if error != nil
            {
                
                
            }
            else
            {
                
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
                
            }
            
        }
        
        
    }
    
    @objc func backButtonClicked()
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
}
