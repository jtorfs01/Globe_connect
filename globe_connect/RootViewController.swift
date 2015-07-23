//
//  RootViewController.swift
//  globe_connect
//
//  Created by Jonas Torfs on 27/06/15.
//  Copyright (c) 2015 Jonas Torfs. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {

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
           //code to show home screen when user is already loggedIn.
            
            //Now show login screen for test. (to be deleted)
              self.performSegueWithIdentifier("goto_login", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("goto_login", sender: self);
    }

    @IBAction func LogoutTabbed(sender: UIButton) {
        self.performSegueWithIdentifier("goto_login", sender: self);
    }
}

