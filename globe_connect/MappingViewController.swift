//
//  MappingViewController.swift
//  globe_connect
//
//  Created by Jonas Torfs on 12/10/15.
//  Copyright © 2015 Jonas Torfs. All rights reserved.
//

import UIKit
import Mapbox

class MappingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mapView = MGLMapView(frame: view.bounds)
        //mapView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        // set the map's center coordinate
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 38.894368,
            longitude: -77.036487),
            zoomLevel: 15, animated: false)
        view.addSubview(mapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
