//
//  GPXViewController.swift
//  Trax
//
//  Created by Mads Bielefeldt on 06/06/15.
//  Copyright (c) 2015 GN ReSound. All rights reserved.
//

import UIKit
import MapKit

class GPXViewController: UIViewController, MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .Satellite
            mapView.delegate = self
        }
    }
    
    var gpxURL: NSURL? {
        didSet {
            self.clearWaypoints()
            if let url = gpxURL {
                GPX.parse(url) {
                    if let gpx = $0 {
                        self.handleWaypoints(gpx.waypoints)
                    }
                }
            }
        }
    }
    
    private func clearWaypoints() -> Void
    {
        if (mapView?.annotations != nil) {
            mapView.removeAnnotations(mapView.annotations as! [MKAnnotation])
        }
    }
    
    private func handleWaypoints(waypoints: [GPX.Waypoint]) -> Void
    {
        mapView?.addAnnotations(waypoints)
        mapView?.showAnnotations(waypoints, animated: true)
    }
    
    /* this function was introduced to be able to simulate reception of file over airdrop (as this does not currently work with mac running OS X 10.11) */
    private func sendGPXFileURLNotification(name: String) {
        let path: String! = NSBundle.mainBundle().pathForResource(name, ofType: "gpx")
        let url: NSURL! = NSURL(fileURLWithPath: path)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let notification = NSNotification(name: GPXURL.Notification, object: self, userInfo: [GPXURL.Key:url])
        notificationCenter.postNotification(notification)
    }
    
    @IBAction func useStanfordGPXButton()
    {
        self.sendGPXFileURLNotification("stanford")
    }
    
    @IBAction func useVacationGPXButton()
    {
        self.sendGPXFileURLNotification("vacation")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let appDelegate = UIApplication.sharedApplication().delegate
        let mainQueue = NSOperationQueue.mainQueue()
        
        notificationCenter.addObserverForName(GPXURL.Notification, object: nil /*appDelegate*/, queue: mainQueue) { (notification) in
            if let url = notification.userInfo?[GPXURL.Key] as? NSURL {
                self.gpxURL = url
            }
        }
    }
}

