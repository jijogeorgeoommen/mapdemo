//
//  ViewController.swift
//  mapdemo
//
//  Created by JIJO G OOMMEN on 05/08/19.
//  Copyright © 2019 JIJO G OOMMEN. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class ViewController: UIViewController,UITextFieldDelegate,GooglePlacesDelegate {
    
    var mapView : GMSMapView?
    var dropdown : BMGooglePlaces!
    var activeTextField : UITextField!
    
    
    
    
    var arrayPlaces = NSMutableArray()
    var arrayPlacesName = NSMutableArray()
    
    @IBOutlet var textfFieldDestination: UITextField!
    @IBOutlet var viewTextField: UIView!
    @IBOutlet var textFieldSource: UITextField!
    
    let childview = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.showMap()
        
        self.mapView?.addSubview(viewTextField)
        UIApplication.shared.keyWindow!.addSubview(viewTextField)
        
    }
    
    //MARK:- Show Google Map
    func showMap()  {
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), camera: GMSCameraPosition.camera(withLatitude: 8.5297, longitude: 76.9384, zoom: 12.5))
        mapView?.isMyLocationEnabled = true
        self.view.addSubview(mapView!)
        self.view.bringSubviewToFront(self.textFieldSource)
    }
    
    
    
    func fetchlocation(WithCompletion : @escaping ( _ success:Bool, _ arrayResult:NSArray)->Void){
        let searchQuery : SPGooglePlacesAutocompleteQuery = SPGooglePlacesAutocompleteQuery()
        searchQuery.input = activeTextField.text
        searchQuery.fetchPlaces { (places, error) in
            if (error == nil){
                let arraytempplaces : NSArray = places as AnyObject as! NSArray
                if(arraytempplaces.count > 0){
                 self.arrayPlaces.removeAllObjects()
                    for item in arraytempplaces {
                        let googlePlaces = item as! SPGooglePlacesAutocompletePlace
                        self.arrayPlaces.add(googlePlaces)
                        self.arrayPlacesName.add(googlePlaces.name!)
                    }
                    WithCompletion(true,self.arrayPlaces)
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.fetchlocation { (success, arrayResult) in
            if(self.dropdown == nil){
            self.dropdown = BMGooglePlaces(frame:CGRect(x:self.activeTextField.frame.origin.x, y:self.activeTextField.frame.maxY + 10, width : self.activeTextField.frame.width, height : 90))
                self.dropdown?.delegate = self
                self.dropdown.isGooglePlacesData = true
                self.dropdown!.arrayToLoad = self.arrayPlaces.mutableCopy() as? NSMutableArray
                self.activeTextField.superview?.addSubview(self.dropdown!)
            }
            else {
                self.dropdown.reload(self.arrayPlaces as? [Any])
            }
        }
    return true
    }
    
    func selectedPlace(_ place: NSObject!) {
        let selectedPlace = place as! SPGooglePlacesAutocompletePlace
        
        if self.activeTextField.tag == 20 {
            self.textFieldSource.text = selectedPlace.name
        let   srcCooedinates = self.getLocationAddressfromString(selectedPlace.placeId)
            
            print("SOURCE ID : \(srcCooedinates)")
        }
        else if self.activeTextField.tag == 30 {
            self.textfFieldDestination.text = selectedPlace.name
           let   destCooedinates = self.getLocationAddressfromString(selectedPlace.placeId)
            
            print("DESTINATION ID : \(destCooedinates)")
        }
        self.dropdown = nil                                          // connect delegates of textfields in the storyboard
    }
    
    
    func getLocationAddressfromString(_ placeId: String)->CLLocationCoordinate2D{
        var latitude : Double = 0
        var longitude : Double = 0
        var center = CLLocationCoordinate2D()
        let esc_addr : String = placeId.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
         let req = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(String(describing: esc_addr))&key=AIzaSyDEyf9ADzeBh1bRzhU2Cf6o7nb_SsYRNRw"
        let result = try?String(contentsOf: URL(string: req)!, encoding: .utf8)
        
        if result != nil {
             let scanner = Scanner(string: result ?? "")
             if scanner.scanUpTo("\"lat\" :", into: nil) && scanner.scanString("\"lat\" :", into: nil) {
               scanner.scanDouble(&latitude)
                if scanner.scanUpTo("\"lng\" :", into: nil) && scanner.scanString("\"lng\" :", into: nil) {
                    scanner.scanDouble(&longitude)
                    center.latitude = latitude
                    center.longitude = longitude
                    
             
                    
                }
        }
        }
       return center
    }
   
    
    
    
    @IBAction func getDirection(_ sender: Any) {
        
       
    }
    
    
    
    
    
    
    
    
    func loaddata() {
        
//        let src = textFieldSource.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        let des = textfFieldDestination.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//
//        let urlstring = "https://maps.googleapis.com/maps/api/directions/json?origin=8.5686,76.8731&destination=8.5471,76.9139&sensor=true&mode=driving&key=AIzaSyDEyf9ADzeBh1bRzhU2Cf6o7nb_SsYRNRw"
//
//        let url = NSURL(string: urlstring)!
//        let request = URLRequest(url: url as! URL)
//        let urlsession = URLSession.shared
    }
    
}

