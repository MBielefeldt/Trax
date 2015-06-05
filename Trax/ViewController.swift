//
//  ViewController.swift
//  Trax
//
//  Created by Mads Bielefeldt on 06/06/15.
//  Copyright (c) 2015 GN ReSound. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let appDelegate = UIApplication.sharedApplication().delegate
        let mainQueue = NSOperationQueue.mainQueue()
        
        notificationCenter.addObserverForName(GPXURL.Notification, object: appDelegate, queue: mainQueue) { (notification) in
            if let url = notification.userInfo?[GPXURL.Key] as? NSURL {
                self.textView.text = "Received \(url)"
            }
        }
    }
}

