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
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if control == view.rightCalloutAccessoryView{
            //Perform a segue here to navigate to another viewcontroller
            // On tapping the disclosure button you will get here
            
        }
    }

    
/*    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "viewDetail"){
            var theDestination: AnotationViewController = segue.destinationViewController as! AnotationViewController
            theDestination.getName = (sender as! MKAnnotationView).annotation!.title!
        }
    }*/
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    
        if annotation is MKUserLocation {
            //return nil
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            //println("Pinview was nil")
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        
        let button = UIButton(type: UIButtonType.DetailDisclosure) as UIButton // button with info sign in it
        
        pinView?.rightCalloutAccessoryView = button
        
        
        return pinView
    }
    
    
    
   /* func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Activity"
        
        if annotation.isKindOfClass(Activity.self) {
            if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
                annotationView.annotation = annotation
                return annotationView
            } else {
                let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView.enabled = true
                annotationView.canShowCallout = true
                
                let btn = UIButton(type: .DetailDisclosure)
                annotationView.rightCalloutAccessoryView = btn
                return annotationView
            }
        }
        
        return nil
    }*/
    

    
    //MARK:- Annotations
    
    func getMapAnnotations() -> [Activity] {
    var annotations:Array = [Activity]()
    
        do {
            let data = NSData(contentsOfURL: NSURL(string: "http://localhost/~dentorfs_/get_activity.php")!)
            
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
                
                let anotation = Activity(latitude: latitudeItem, longitude: longtitudeItem)
                anotation.title = name
                anotation.subtitle = description
                
                annotations.append(anotation)
                
                
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
        // Configure the page view controller and add it as a child view controller.
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            let url:NSURL = NSURL(string: "http://localhost/~dentorfs_/get_activity.php")!
            
       //     let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
         //   let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        //    request.HTTPMethod = "POST"
        //    request.HTTPBody = postData
        //    request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        //    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //    request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch let error as NSError {
                reponseError = error
                urlData = nil
            }
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    //let error: NSError?
                   //parseJson();
                    
                    let annotations = getMapAnnotations()
                    // Add mappoints to Map
                    mapView.addAnnotations(annotations)
                    
                    
                    
                  //  let jsonData:NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(urlData!, //options:NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                    
                   //  longtitude = jsonData.valueForKey("LONGTITUDE") as! CLLocationDegrees;
                   // latitude =  jsonData.valueForKey("LATITUDE") as! CLLocationDegrees;
                    let longPress = UILongPressGestureRecognizer(target: self, action: "addNewAnotation:")
                    longPress.minimumPressDuration = 1.0
                    mapView.addGestureRecognizer(longPress)
                    
                    mapView.showsUserLocation = true
 
                    //  let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                    var success:NSInteger
                  //  success = jsonData.valueForKey("success") as! NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                //    NSLog("Success: %ld", success);
                    
                 /*   if(success == 1)
                    {
                       
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
                let alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                
            
            
            // set initial location in Honolulu
         //   let initialLocation:CLLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
            
            
           //code to show mapping screen when user is already loggedIn.
           // self.performSegueWithIdentifier("goto_mapping",sender:self)
            
            //show username on homescreen (test from tutorial) -- TO BE DELETED.
           //  self.UsernameLabel.text = prefs.valueForKey("USERNAME") as? String
            
            //Show login screen for test. -- TO BE DELETED.
            //  self.performSegueWithIdentifier("goto_login", sender: self)
                
            }
        }*/
                }
            }
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
  

