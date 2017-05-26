//
//  Dictionary+MusicApplication.swift
//  MusicApplication
//
//  Created by Sidramappa Halake on 24/05/17.
//  Copyright © 2017 Sidramappa Halake. All rights reserved.
//

import Foundation

extension Dictionary{

    func getOptionalString(for key: Key) -> String? {
        
        if let value = self[key] as? String {
            return value
        }
        return nil
    }
    
    func getInt(for key: Key) -> Int {
        
        if let value = self[key] as? Int {
            return value
        }
        return 0
    }
}
