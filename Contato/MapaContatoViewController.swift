//
//  MapaContatoViewController.swift
//  Contato
//
//  Created by Nando on 08/11/16.
//  Copyright © 2016 Nando. All rights reserved.
//

import UIKit
import MapKit

class MapaContatoViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    let dao = ContatoDAO.sharedInstance()
    let locationManager = CLLocationManager()
    var contatos:[Contato]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapa.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        let botaoLocalizacao = MKUserTrackingBarButtonItem(mapView: self.mapa)
        self.navigationItem.rightBarButtonItem = botaoLocalizacao
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        contatos = dao.list()
        
        self.mapa.addAnnotations(contatos)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mapa.removeAnnotations(contatos)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "pino"
        
        var pino: MKAnnotationView
        
        if let reusableAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            pino = reusableAnnotation //as! MKPinAnnotationView
            
        }else{
            pino = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        let contato = annotation as! Contato
        
        pino.canShowCallout = true
//        pino.tintColor = UIColor.red
//        pino.animatesDrop = true
        
        let pinImage = #imageLiteral(resourceName: "pin")
        
        let size = CGSize(width: 50.0, height: 50.0)
        UIGraphicsBeginImageContext(size)
        pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        pino.image = resizedImage //somente com MKAnnotation
        
        if contato.foto != nil {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32.0, height: 32.0))
            
            imageView.image = contato.foto
            
            pino.leftCalloutAccessoryView = imageView
            
        }
        
        pino.annotation = annotation
        
        
        return pino
    }

   
}
