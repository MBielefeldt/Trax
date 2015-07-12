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
            clearWaypoints()
            if let url = gpxURL {
                GPX.parse(url) {
                    if let gpx = $0 {
                        self.handleWaypoints(gpx.waypoints)
                    }
                }
            }
        }
    }
    
    private func clearWaypoints()
    {
        if mapView?.annotations != nil {
            mapView.removeAnnotations(mapView.annotations as! [MKAnnotation])
        }
    }
    
    private func handleWaypoints(waypoints: [GPX.Waypoint]) -> Void
    {
        mapView?.addAnnotations(waypoints)
        mapView?.showAnnotations(waypoints, animated: true)
    }
    
    private struct Constants {
        static let AnnotationViewReuseIdentifier = "waypoint"
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
        static let ShowImageSegue = "Show Image"
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier)
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        
        view.leftCalloutAccessoryView = nil
        view.rightCalloutAccessoryView = nil
        if let waypoint = annotation as? GPX.Waypoint {
            if waypoint.thumbnailURL != nil {
                view.leftCalloutAccessoryView = UIImageView(frame: Constants.LeftCalloutFrame)
            }
            if waypoint.imageURL != nil {
                view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            }
        }
        
        return view
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!)
    {
        if let waypoint = view.annotation as? GPX.Waypoint {
            if let thumbnailImageView = view.leftCalloutAccessoryView as? UIImageView {
                if let imageData = NSData(contentsOfURL: waypoint.thumbnailURL!) { /* blocks main thread !!! */
                    if let image = UIImage(data: imageData) {
                        thumbnailImageView.image = image
                    }
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!)
    {
        performSegueWithIdentifier(Constants.ShowImageSegue, sender: view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == Constants.ShowImageSegue {
            if let waypoint = (sender as? MKAnnotationView)?.annotation as? GPX.Waypoint {
                if let ivc = segue.destinationViewController as? ImageViewController {
                    ivc.imageURL = waypoint.imageURL
                    ivc.title = waypoint.title
                }
            }
        }
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

