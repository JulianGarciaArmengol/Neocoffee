//
//  MapViewController.swift
//  Neocoffee
//
//  Created by julian.garcia on 31/07/24.
//

import UIKit
import MapKit
import Combine
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    private var viewModel = MapViewModel()
    
    var locationManager = CLLocationManager()
    
    var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.42847 , longitude: -99.12766),
        span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    )
    
    private var cancellables = Set<AnyCancellable>()
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.mapType = .mutedStandard
        return map
    }()
    
    private let buttonDissmiss: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.contentVerticalAlignment = .fill
        view.contentHorizontalAlignment = .fill
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setBindings()
        setupMap()
        
        viewModel.getStores()
        
        buttonDissmiss.addAction(
            UIAction(handler: {_ in
                self.dismiss(animated: true)
            }),
            for: .touchUpInside
        )
    }
    
    private func setupViews() {
        view.addSubview(mapView)
        view.addSubview(buttonDissmiss)
        
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            buttonDissmiss.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            buttonDissmiss.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonDissmiss.widthAnchor.constraint(equalToConstant: 25),
            buttonDissmiss.heightAnchor.constraint(equalToConstant: 25),
            
        ])
    }
    
    private func setBindings() {
        viewModel.stores
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink {[weak self] stores in
                stores.forEach { self?.createAnnotation(with: $0) }
            }
            .store(in: &cancellables)
    }
    
    private func setupMap() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        mapView.delegate = self
        mapView.region = mapRegion
        mapView.showsUserLocation = true
    }
    
    private func setRoute(source:CLLocationCoordinate2D, destination:CLLocationCoordinate2D){
        print("calculating route")
        
        let sourcePlaceMark = MKPlacemark(coordinate: source)
        let destinationPlaceMark = MKPlacemark(coordinate: destination)
        let directionRequest = MKDirections.Request()
        
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let direction = MKDirections(request: directionRequest)
        direction.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            for route in directionResonse.routes {
                
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let sourceLocation  = manager.location!.coordinate
        print("location : \(sourceLocation.latitude) \(sourceLocation.longitude)")
        let userLocation = locations.last
        
        let viewRegion = MKCoordinateRegion(
            center: (userLocation?.coordinate)!,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        
        self.mapView.setRegion(viewRegion, animated: true)
        
        if let destination = viewModel.stores.value?.first {
            setRoute(
                source: sourceLocation,
                destination: .init(
                    latitude: destination.latitude,
                    longitude: destination.longitude
                )
            )
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            print("oh si")
            locationManager.startUpdatingLocation()
        } else {
            print("Location not authorized")
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let overlay = overlay as? MKPolyline
        /// define a list of colors you want in your gradient
        let gradientColors = [UIColor(named: "background")!, UIColor(named: "border")!]
        
        /// Initialise a GradientPathRenderer with the colors
        let polylineRenderer = MKGradientPolylineRenderer(overlay: overlay!)
        polylineRenderer.setColors(gradientColors, locations: [0, 1])
    
        /// set a linewidth
        polylineRenderer.lineWidth = 10
        return polylineRenderer
    }
    
    private func createAnnotation(with store: Store) {
        print("creating annotation")
        let annotations = MKPointAnnotation()
        annotations.title = store.name
        annotations.coordinate = .init(latitude: store.latitude, longitude: store.longitude)
        mapView.addAnnotation(annotations)
    }
}
