//
//  ViewController.swift
//  CineInfo
//
//  Created by Saurabh Jain on 12/12/14.
//  Copyright (c) 2014 Saurabh jain. All rights reserved.
//

import UIKit

class ViewController: UIViewController, IMDBSearchDelegate, UISearchBarDelegate {
    
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var releasedLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var plotLabel: UILabel!
    @IBOutlet var searchIMDB: UISearchBar!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var tomatoMeter: UILabel!
    @IBOutlet var backview: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    lazy var apicon:IMDBSearch = IMDBSearch(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apicon.delegate = self;
        
        let recog = UITapGestureRecognizer(target: self, action: "tapped:")
        self.view.addGestureRecognizer(recog)
        
        self.tomatoMeter.textColor = UIColor(red: 0.984, green: 0.256, blue: 0.184, alpha: 1)
        self.backview.backgroundColor = UIColor(red: 0.988, green: 0.725, blue: 0.200, alpha: 1)
        
        self.titleLabel.text        = "The King of Kong"
        self.subtitle.text          = "A Fistful of Quarters"
        self.releasedLabel.text     = "2007"
        self.ratingLabel.text       = "PG-13"
        self.plotLabel.text         = "Die-hard gamers compete to break world records on classic arcade games."
        self.tomatoMeter.text       = "93%"
        
        self.searchIMDB.keyboardAppearance = UIKeyboardAppearance.Dark
        
        self.activityIndicator.hidden = true
        self.activityIndicator.color = UIColor(red: 0.984, green: 0.256, blue: 0.184, alpha: 1)
    }
    
    override func viewDidAppear(animated: Bool) {

        self.movieImage.layer.cornerRadius = 125
        self.movieImage.image       = UIImage(named: "kofk.png")
        self.blurback(self.movieImage.image!)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func didFinishSearch(result: Dictionary<String, String>) {
        
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
        
        if let s = result["Title"]{
            
            self.ParseTitle(s)
            
        }
        
        self.releasedLabel.text     = result["Released"]
        self.ratingLabel.text       = result["Rated"]
        self.plotLabel.text         = result["Plot"]
        
        if (result["tomatoMeter"] != nil) {
            self.tomatoMeter.text       = result["tomatoMeter"]! + "%"
            
        }
        
        if let str = result["Poster"]{
            
            self.formatImage(str)
        }
    }
    
    
    func ParseTitle(title: String)
    {
        
        var index = title.findIndexOFLetter(":")
        
        if let foundindex = index
        {
            
            var newTitle            = title[0..<foundindex]
            var sub                 = title[foundindex + 2 ..< countElements(title)]
            
            self.titleLabel.text    = newTitle
            self.subtitle.text      = sub
            
        }
            
        else{
            
            self.titleLabel.text    = title
            self.subtitle.text      = ""
            
        }
        
        
    }
    
    func formatImage(str: String)
    {
        
        var url:NSURL! = NSURL(string: str)
        
        var dataimg = NSData(contentsOfURL: url)
        
        self.movieImage.clipsToBounds = true
        
        var q:dispatch_queue_t = dispatch_queue_create("q", nil)
        
        dispatch_async(q, { () -> Void in
            
            self.movieImage.layer.cornerRadius = 125
            
            
        })
        
        if let da = dataimg{
            
            self.movieImage.image = UIImage(data: da)
            
        }
        
        
        
        if let i = self.movieImage.image {
            
            self.blurback(i)
        }
    }
    
    func blurback(img: UIImage)
    {
        
        var frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        
        var imgview = UIImageView(frame: frame)
        imgview.image = img;
        imgview.contentMode = .ScaleAspectFill
        
        var blur = UIBlurEffect(style: .Light)
        var visualView = UIVisualEffectView(effect: blur)
        visualView.frame = frame
        
        var views = [imgview, visualView]
        
        for index in 0..<views.count
        {
            if let old = self.view.viewWithTag(index + 1)
            {
                
                old.removeFromSuperview()
                
            }
            
            
            var v = views[index]
            self.view.insertSubview(v, atIndex: index+1)
            v.tag = index+1
            
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.titleLabel.text = ""
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        self.apicon.searchIMDB(searchBar.text)
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
    }
    
    func tapped(rec: UITapGestureRecognizer){
        
        self.searchIMDB.resignFirstResponder()
    }
    
}

