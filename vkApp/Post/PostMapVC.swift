//
//  PostMapVC.swift
//  vkApp
//
//  Created by Андрей Тихонов on 25.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PostMapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var flag = true
    
    let annotation = MKPointAnnotation()
    var myCurrentPlace = ""

    
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()

        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        annotation.title = "Title"
        annotation.subtitle = "subtitle"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        while flag {
        }
        guard let destinationVC = segue.destination as? PostVC else { return }

        if let text = destinationVC.postText.text {
            destinationVC.postText.text = text + "\n" + myCurrentPlace
        } else {
            destinationVC.postText.text = myCurrentPlace
        }
    }

    @IBAction func mapTap(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: mapView)
        let locationCoordinateMap = mapView.convert(touchLocation, toCoordinateFrom: mapView)

        let coordinate = CLLocation(latitude: locationCoordinateMap.latitude, longitude: locationCoordinateMap.longitude)
        getLocationAddress(location: coordinate)
        
        mapView.removeAnnotation(annotation)
        annotation.coordinate = locationCoordinateMap
        mapView.addAnnotation(annotation)
    }
    
    func getLocationAddress(location: CLLocation) {

        var addressString = ""
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (myPlaces, error) in
            
            self?.flag = true
            if error != nil {
                self?.flag = false
                print("\nЧто-то пошло не так\n")
                return
            }
            
            guard let placemark = myPlaces?.first else {
                self?.flag = false
                assertionFailure("\nЧто-то пошло не так (Часть вторая)\n")
                return
            }
            
            var separator = ""
            if let postalCode = placemark.postalCode {
                addressString += separator + postalCode
                separator = ", "
            }
            if let country = placemark.country {
                addressString += separator + country
                separator = ", "
            }
            if let locality = placemark.locality {
                addressString += separator + locality
                separator = ", "
            }
            if let administrativeArea = placemark.administrativeArea {
                if administrativeArea != placemark.locality {
                    addressString += separator + administrativeArea
                    separator = ", "
                }
            }
            if let thoroughfare = placemark.thoroughfare {
                addressString += separator + thoroughfare
                separator = ", "
            }
            if let subThoroughfare = placemark.subThoroughfare {
                addressString += separator + subThoroughfare
                separator = ", "
            }
            self?.flag = false
            self?.myCurrentPlace = addressString
        }
    }
}

extension PostMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let curentLocation = locations.last?.coordinate else { return }
        
        let coordinate = CLLocation(latitude: curentLocation.latitude, longitude: curentLocation.longitude)
        getLocationAddress(location: coordinate)

        let currentRadius: CLLocationDistance = 1000
        let currentRegion = MKCoordinateRegionMakeWithDistance((curentLocation), currentRadius * 2.0, currentRadius * 2.0)
            
        mapView.setRegion(currentRegion, animated: true)
        mapView.showsUserLocation = true

        locationManager.stopUpdatingLocation()
        mapView.removeAnnotation(annotation)
        annotation.coordinate = curentLocation
        mapView.addAnnotation(annotation)
    }
}

