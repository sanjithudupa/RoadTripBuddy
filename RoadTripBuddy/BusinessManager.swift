//
//  BusinessManager.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/22/22.
//

import Foundation
import CDYelpFusionKit

// this class manages interfacing with the yelp api and formatting data accordingly
class BusinessManager {
    private static let instance = BusinessManager()
    
    public static func getInstance() -> BusinessManager {
        return instance;
    }
    
    private let yelpAPIClient = CDYelpAPIClient(apiKey: Secret.YELP_API_KEY)
    
    func searchForBusinesses() {
        
    }
}
