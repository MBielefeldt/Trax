//
//  ImageViewController.swift
//  Cassini
//
//  Created by Mads Bielefeldt on 30/05/15.
//  Copyright (c) 2015 GN ReSound. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate
{
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private func fetchImage()
    {
        if let url = imageURL {
            spinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            let queue = dispatch_get_global_queue(qos, 0)
            dispatch_async(queue) {
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageURL {
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            spinner?.stopAnimating()
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.00
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return imageView
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)

        if image == nil {
            fetchImage()
        }
    }
}
