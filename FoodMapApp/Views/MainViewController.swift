//
//  ViewController.swift
//  FoodMapApp
//
//  Created by Marcus Ong on 23/6/22.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController {


    var locationManager:CLLocationManager!
    var currentLocationStr = "Current location"
    var selectedAnnotation: MKPointAnnotation?
    var descriptionGenerated: String?
    
    var directionsArray: [MKDirections] = []
    
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
        setMapConstraints()
        addFoodLocationPins()
    }
    
    func setMapConstraints() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            
        }
    
//    class foodLocationAnnotation: NSObject, MKAnnotation {
//        // This property must be key-value observable, which the `@objc dynamic` attributes provide.
//        @objc dynamic var coordinate = CLLocationCoordinate2D(
//            latitude: 1.4462692778075756,
//            longitude: 103.80624720281315)
//
//        // Required if you set the annotation view's `canShowCallout` property to `true`
//        var title: String? = NSLocalizedString("Dominos", comment: "SF annotation")
//
//        // This property defined by `MKAnnotation` is not required.
//        var subtitle: String? = NSLocalizedString("Pizza", comment: "SF annotation")
//
//        private func addFoodLocationPins() {
//            let pinA = MKPointAnnotation()
//            pinA.title = self.title
//            pinA.subtitle = self.subtitle
//            pinA.coordinate = CLLocationCoordinate2D(
//                latitude: self.coordinate.latitude,
//                longitude: self.coordinate.longitude)
//            mapView.addAnnotation(pinA)
//        }
    private func addFoodLocationPins() {

        for pin in LocationsDataService.locations {
            let pinnedItem = MKPointAnnotation()
            pinnedItem.title = pin.name
            pinnedItem.subtitle = pin.subName
            pinnedItem.coordinate = pin.coordinates
            mapView.addAnnotation(pinnedItem)
        }
    }
}



extension MainViewController : MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
        // to detect when user pans and action to prevent auto recentering
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))

        // make your class the delegate of the pan gesture
        panGesture.delegate = self

        // add the gesture to the mapView
        mapView.addGestureRecognizer(panGesture)
        
        
    }
    

    //MARK:- CLLocationManagerDelegate Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        

        let mUserLocation:CLLocation = locations[0] as CLLocation

        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        mapView.setRegion(mRegion, animated: true)
        
        //Pin Annotations
        func addUserLocationPin() {
            let startPin = MKPointAnnotation()
            startPin.title = "You"
            startPin.coordinate = CLLocationCoordinate2D(
                latitude: mUserLocation.coordinate.latitude,
                longitude: mUserLocation.coordinate.longitude
                )
            mapView.addAnnotation(startPin)
        }
        addUserLocationPin()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error - locationManager: \(error.localizedDescription)")
        }
    //MARK:- Intance Methods

    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //func to allow for screen panning
    @objc func didDragMap(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {

            locationManager.stopUpdatingLocation()

        }
    }
    
    @objc func detailButtonTapped() {
        
        let pop = Popup()
        let descriptionText = getDescription()
        view.addSubview(pop)
        pop.subtitleLabel.text = descriptionText
        pop.titleLabel.text = selectedAnnotation?.title
        
//        let detailViewController = DetailViewController()
//        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    @objc public func goButtonTapped() {
        getDirections()
    }
    
    //view for annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
            
            if annotationView == nil {
                //create view
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
                
                //detail button to detail view controller
                annotationView?.canShowCallout = true
                
                let detailButton = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = detailButton
                
                detailButton.addTarget(self, action: #selector(MainViewController.detailButtonTapped), for: .touchUpInside)
                
            }
            else {
                annotationView?.annotation = annotation
            }
        switch annotation.title {
        case "You":
            let pinImage = UIImage(named: "You")
            let size = CGSize(width: 34, height: 34)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

            annotationView?.image = resizedImage
        case "Dominos":
            //resizing of image
            let pinImage = UIImage(named: "Pizza")
            let size = CGSize(width: 34, height: 34)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

            annotationView?.image = resizedImage
        default:
            let pinImage = UIImage(named: "Pizza")//edit named to default image once default image achieved
            let size = CGSize(width: 34, height: 34)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

            annotationView?.image = resizedImage
        }
            
            return annotationView
        }
    
    // Direction Polyline Renderer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.lineWidth = 3.8
        renderer.strokeColor = .blue
        
        return renderer
    }
    
    //  Annotation Coordinate Selecector
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? MKPointAnnotation
    }
    
    func getDescription() -> String {
        let selectedLocationCoordinate = selectedAnnotation?.coordinate
        guard selectedLocationCoordinate != nil else {
            return "Coordinates not matched"
        }
        for i in LocationsDataService.locations {
            if i.coordinates.latitude == selectedLocationCoordinate!.latitude && i.coordinates.longitude == selectedLocationCoordinate!.longitude {
                descriptionGenerated = i.description
            } else {
                descriptionGenerated = "error"
            }
        }
        return descriptionGenerated!
    }
    
    // Creates Direction Polyline
    func getDirections() {
        guard let location = locationManager.location?.coordinate else {
            return
        }
        let request = createDirectionRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        print(directionsArray)
        
        directions.calculate { [unowned self] (response, error) in
            // To Do: error handling
            guard let response = response else { return }
            
            for route in response.routes {
//                let timeTaken  = route.expectedTravelTime
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }

    func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate       = selectedAnnotation?.coordinate
        let startingLocation            = MKPlacemark(coordinate: coordinate)
        let destination                 = MKPlacemark(coordinate: destinationCoordinate!)
        
        let request                     = MKDirections.Request()
        request.source                  = MKMapItem(placemark: startingLocation)
        request.destination             = MKMapItem(placemark: destination)
        request.transportType           = .walking
        request.requestsAlternateRoutes = true
        return request
    }
    
    //removes existing routes
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        //cancels all directions in the array
        let _ = directionsArray.map { $0.cancel()}
        directionsArray.removeAll()
    }
    
    //dequeue annotations out of range
    func dequeueAnnotations() {
        
    }
    
}
