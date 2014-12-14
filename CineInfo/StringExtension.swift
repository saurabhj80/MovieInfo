//
//  String.swift
//  CineInfo
//
//  Created by Saurabh Jain on 12/13/14.
//  Copyright (c) 2014 Saurabh jain. All rights reserved.
//

import Foundation

extension String{
    
    subscript(r: Range<Int>) -> String?{
        
        if !self.isEmpty{
            
            var start  = advance(startIndex, r.startIndex)
            var end = advance(startIndex, r.endIndex)
            
            return substringWithRange(Range(start: start, end: end))
        }
        
    
        return nil
        
    }
    
    func findIndexOFLetter(letter: String) -> Int?
    {
        var arr : [String] = []
        var index = 0
        
        for character in self
        {
            
            arr.insert(String(character), atIndex: index)
            index++
            
        }
        
        var index1 = 0
        for character in 0..<arr.count
        {
            
            if letter == arr[index1]{
                
                
                return index1
            }
            index1++
            
        }
        
        
        return nil
        
    }
    
}
