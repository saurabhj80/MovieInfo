//
//  IMDBSearch.swift
//  CineInfo
//
//  Created by Saurabh Jain on 12/13/14.
//  Copyright (c) 2014 Saurabh jain. All rights reserved.
//

import UIKit

protocol IMDBSearchDelegate
{
    
    func didFinishSearch(result: Dictionary<String, String>)
    
}

class IMDBSearch {
    
    var delegate:IMDBSearchDelegate?
    
    init(delegate: IMDBSearchDelegate?){
        
        self.delegate = delegate;
    }
    
    
    func searchIMDB(content: String)
    {
        
        var content1 = content.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        if let str = content1
        {
            
            var url:NSURL = NSURL(string: "http://www.omdbapi.com/?t=\(str)&r=json&tomatoes=true")!;
            
            var task = NSURLSession.sharedSession().dataTaskWithURL(url)
                {
                    
                    data, response, error ->  Void in
                    
                    
                    if (error != nil){
                        
                        var alert:UIAlertView = UIAlertView(title: "Could not Load Movie Info", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "Ok")
                        
                        alert.show()
                        
                        
                        return
                    }
                    
                    var err:NSError?
                    
                    
                    var jsondata = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as Dictionary<String, String>
                    
                    if (err != nil){
                        
                        println(err!.localizedDescription)
                    }
                    
                    if let del = self.delegate{
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                            del.didFinishSearch(jsondata)
                            
                        })
                    }
                    
                    
                    
            }
            
            task.resume()
            
        }
    }
    
    
}
