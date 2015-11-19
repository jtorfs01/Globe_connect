//
//  AnotationViewController.swift
//  globe_connect
//
//  Created by Jonas Torfs on 19/10/15.
//  Copyright © 2015 Jonas Torfs. All rights reserved.
//

import UIKit

class AnotationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var selectedPicker = NSString();
    @IBOutlet weak var ActivityPickDate: UIPickerView!
    @IBOutlet weak var activityMeetupLocationTxt: UILabel!
    @IBOutlet weak var activityTitelTxt: UILabel!
    @IBOutlet weak var acceptActivityButton: UIButton!
    @IBOutlet weak var activityDescriptionTxt: UILabel!
    
    var pickerData = [String]()
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedPicker = pickerData[row]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityTitle = NSUserDefaults.standardUserDefaults().objectForKey("Title") as! String
        var activityDescription = NSString();
        var activityMeetupLocation = NSString();
        var activityID = NSInteger();
        var calendarFrom = NSString();
        var calendarTo = NSString();
        var calendarId = NSInteger();
        
        //print(activityTitle);
        do {
            //let data = NSData(contentsOfURL: NSURL(string: "http://localhost/~dentorfs_/get_activity.php")!)
            
            let post:NSString = "name=\(activityTitle)"
            
            NSLog("PostData: %@",post);
            
            //let url:NSURL = NSURL(string: "http://localhost/~dentorfs_/get_activity.php")!
            let url:NSURL = NSURL(string: "https://php-globeconnect.rhcloud.com/get_activity_info.php")!
            
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
            
            if urlData != nil {
            
            let jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers)
               
                
            //alo implement code to make sure that jsonData object is valid.
            for anItem in jsonData as! [Dictionary<String, AnyObject>] {
                activityID = (anItem["ACTIVITY_ID"] as? NSInteger)!;
                activityDescription = (anItem["DESCRIPTION"] as? NSString)!;
                activityMeetupLocation = (anItem["MEETUP_LOCATION"] as? NSString)!;
             }
              
      //      if activityDescription != "" {
                self.activityDescriptionTxt.text = activityDescription as String
                self.activityTitelTxt.text = activityTitle as String;
                self.activityMeetupLocationTxt.text = activityMeetupLocation as String;
                
                
                activityMeetupLocationTxt.requiredHeight(activityMeetupLocation as String)
                
               // activityMeetupLocationTxt.preferredMaxLayoutWidth
                
       //     } else {
                //implement alertview to show result was empty
         //   }
            
            //      id = (jsonData["ACTIVITY_ID"] as? Int)!;
                }
        }   catch let error as NSError {
            print(error)}
        
        
        do {
            //let data = NSData(contentsOfURL: NSURL(string: "http://localhost/~dentorfs_/get_activity.php")!)
            
            let post:NSString = "activityID=\(activityID)"
            
            NSLog("PostData: %@",post);
            
            let url:NSURL = NSURL(string: "http://localhost/~dentorfs_/get_calendar_activity.php")!
            //let url:NSURL = NSURL(string: "https://php-globeconnect.rhcloud.com/get_calendar_activity.php")!
            
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
            
            if ( urlData != nil || urlData != 0 ) {
                let res = response as! NSHTTPURLResponse!;
                
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    if (responseData == "0"){
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Get activity info failed!"
                        alertView.message = "Data could not be retrieved."
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    } else {
                    
                    //let error: NSError?
                    let jsonData = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers))
                    
                    
                    //       let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                    let success = NSInteger();
                   //success = jsonData.valueForKey("success") as! NSInteger
                    //success = responseData.valueForKey("success") as! NSInteger
                    //[jsonData[@"success"] integerValue];
                   print(success)
                    
                    NSLog("Success: %ld", success);
                    
                        for anItem in jsonData as! [Dictionary<String, AnyObject>] {
                            calendarId = (anItem["CALENDAR_ID"] as? NSInteger)!;
                            //calendarFrom = (anItem["DATE_FROM"] as? NSDate)!;
                            //calendarTo = (anItem["DATE_TO"] as? NSDate)!;
                            calendarFrom = (anItem["DATE_FROM"] as? NSString)!;
                            calendarTo = (anItem["DATE_TO"] as? NSString)!;
                            //calendarComment = (anItem["COMMENT"] as? NSString)!;
                        
                            pickerData.append(calendarFrom as String);
                            pickerData.append(calendarTo as String);
                            
                            
                            
                        }
                        ActivityPickDate.textInputContextIdentifier
                        self.ActivityPickDate.dataSource = self
                        self.ActivityPickDate.delegate = self
                        ActivityPickDate.reloadAllComponents()
                    }
                   
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
       // NSUserDefaults.standardUserDefaults().removeObjectForKey("Title");
        // Go back to the previous ViewController
  //    self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func ActivityGoButton(sender: UIButton) {
        let post:NSString = "name=\(selectedPicker)"
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
