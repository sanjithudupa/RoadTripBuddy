//
//  BusinessManager.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/22/22.
//

import Foundation
import CDYelpFusionKit
import CoreLocation

// this class manages interfacing with the yelp api and formatting data accordingly
class BusinessManager {
    private static let instance = BusinessManager()
    
    public static func getInstance() -> BusinessManager {
        return instance;
    }
    
    private let yelpAPIClient = CDYelpAPIClient(apiKey: Secret.YELP_API_KEY)
    private let queryDict = [
        "Gas": "gas stations",
        "Food": "restaurants",
        "Hotel": "hotels",
        "Stores": "shopping"
    ]
    
    func searchForBusinesses(type: String, center: CLLocationCoordinate2D, radius: Double, callback: @escaping ([CDYelpBusiness]) -> Void) {
        yelpAPIClient.cancelAllPendingAPIRequests()
        yelpAPIClient.searchBusinesses(byTerm: queryDict[type],
                                       location: nil,
                                       latitude: center.latitude,
                                       longitude: center.longitude,
                                       radius: max(Int(radius * 1609), 40000),
                                       categories: nil,
                                       locale: .english_unitedStates,
                                       limit: 10,
                                       offset: 0,
                                       sortBy: .rating,
                                       priceTiers: [.oneDollarSign, .twoDollarSigns],
                                       openNow: true,
                                       openAt: nil,
                                       attributes: nil) { (response) in
            if let response = response,
                let businesses = response.businesses,
                businesses.count > 0 {
                print(businesses)
                callback(businesses);
            }
        }
    }
}
