//
//  AnotationViewController.swift
//  globe_connect
//
//  Created by Jonas Torfs on 19/10/15.
//  Copyright © 2015 Jonas Torfs. All rights reserved.
//

import UIKit

class AnotationViewController: UIViewController {


    @IBOutlet weak var activityMeetupLocationTxt: UILabel!
    @IBOutlet weak var activityTitelTxt: UILabel!
    @IBOutlet weak var acceptActivityButton: UIButton!
    @IBOutlet weak var activityDescriptionTxt: UILabel!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityDescriptionTxt.requiredHeight()
        activityTitelTxt.requiredHeight()
        activityMeetupLocationTxt.requiredHeight()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityTitle = NSUserDefaults.standardUserDefaults().objectForKey("Title") as! String
        var activityDescription = NSString();
        var activityMeetupLocation = NSString();
        
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
                activityDescription = (anItem["DESCRIPTION"] as? NSString)!;
                activityMeetupLocation = (anItem["MEETUP_LOCATION"] as? NSString)!;
                
                
            }
            
      //      if activityDescription != "" {
                self.activityDescriptionTxt.text = activityDescription as String
                self.activityTitelTxt.text = activityTitle as String;
                self.activityMeetupLocationTxt.text = activityMeetupLocation as String;
                
                activityDescriptionTxt.requiredHeight()
                activityTitelTxt.requiredHeight()
                activityMeetupLocationTxt.requiredHeight()
                
               // activityMeetupLocationTxt.preferredMaxLayoutWidth
                
       //     } else {
                //implement alertview to show result was empty
         //   }
            
            //      id = (jsonData["ACTIVITY_ID"] as? Int)!;
                }
        }   catch let error as NSError {
            print(error)}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getName()
    {
    
    }
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
       // NSUserDefaults.standardUserDefaults().removeObjectForKey("Title");
        // Go back to the previous ViewController
  //    self.dismissViewControllerAnimated(true, completion: nil)
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
