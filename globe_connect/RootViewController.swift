//
//  RootViewController.swift
//  globe_connect
//
//  Created by Jonas Torfs on 27/06/15.
//  Copyright (c) 2015 Jonas Torfs. All rights reserved.
//

import UIKit
import MapKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {
    
    // MARK: - location manager to authorize user location for Maps app
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {

        //Perform a segue here to navigate to another viewcontroller
            // On tapping the disclosure button you will get here
            if control == annotationView.rightCalloutAccessoryView {
                let title = annotationView.annotation?.title;
                if let titlePin = title {
                    NSUserDefaults.standardUserDefaults().setObject(titlePin, forKey: "Title")}
                self.performSegueWithIdentifier("goto_annotation_info", sender: self)
        }
    }

    
func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    
    let title:NSString = annotation.title!!;
    var activityIdPin = NSInteger();
    let reuseId = "pin"
    var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
    
   
    
        do {
      //let data = NSData(contentsOfURL: NSURL(string: "http://localhost/~dentorfs_/get_activity.php")!)
            
            let post:NSString = "name=\(title)"
         
            NSLog("PostData: %@",post);
       
          //let url:NSURL = NSURL(string: "http://localhost/~dentorfs_/get_activity.php")!
            let url:NSURL = NSURL(string: "https://php-globeconnect.rhcloud.com/get_activity.php")!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!;
            
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
            
            var reponseError: NSError?
            var response: NSURLResponse?
            var urlData: NSData?
            
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch let error as NSError {
                reponseError = error
                urlData = nil
            }
            
            let jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers)
            
            for anItem in jsonData as! [Dictionary<String, AnyObject>] {
                activityIdPin = (anItem["ACTIVITY_ID"] as? NSInteger)!;
                
            if annotation is MKUserLocation {
                    //return nil
                    return nil
                }
                if pinView == nil {
                    //println("Pinview was nil")
                    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    pinView!.canShowCallout = true
                    pinView!.animatesDrop = true
                    pinView!.tag = activityIdPin;
                }
                
                let button = UIButton(type: UIButtonType.DetailDisclosure) as UIButton // button with info sign in it
                pinView?.rightCalloutAccessoryView = button
            }
        
            //      id = (jsonData["ACTIVITY_ID"] as? Int)!;
        }   catch let error as NSError {
            print(error)}
                return pinView

    }


    
func getMapAnnotations() -> [Activity] {
    var annotations:Array = [Activity]()
    
        do {
           
            //let data = NSData(contentsOfURL: NSURL(string: "http://localhost/~dentorfs_/get_activities.php")!)
            let data = NSData(contentsOfURL: NSURL(string: "https://php-globeconnect.rhcloud.com/get_activities.php")!)
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
           
            for anItem in jsonData as! [Dictionary<String, AnyObject>] {
                
                let longtitudeItem = (anItem["LONGTITUDE"] as! NSString).doubleValue;
                let latitudeItem = (anItem["LATITUDE"] as! NSString).doubleValue;
                let name = anItem["NAME"] as! String;
                let description = anItem["DESCRIPTION"] as! String;
                
                // do something with the data retrieved:
                let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
                // let location:CLLocationCoordinate2D = mapView.userLocation.coordinate;
                let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitudeItem , longitude:longtitudeItem)
                let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
                
                mapView.setRegion(theRegion, animated: true)
                
                let annotation = Activity(latitude: latitudeItem, longitude: longtitudeItem)
                annotation.title = name
                annotation.subtitle = description
                              
                annotations.append(annotation)
            }  } catch let error as NSError {
                
                print(error)
        }
        return annotations
  }





    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var UsernameLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidAppear(true)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            
                    let annotations = getMapAnnotations()
                    // Add mappoints to Map
                    mapView.addAnnotations(annotations)
                    
                    
                    let longPress = UILongPressGestureRecognizer(target: self, action: "addNewAnotation:")
                    longPress.minimumPressDuration = 1.0
                    mapView.addGestureRecognizer(longPress)
                    
                    mapView.showsUserLocation = true
 
                    //var success:NSInteger
                              }
            }
    
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func logoutTapped(sender: UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)

    }
}
  

