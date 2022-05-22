//
//  WeatherManager.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/22/22.
//

import Foundation
import CoreLocation
import Alamofire

class WeatherManager {
    private static let instance = WeatherManager();
    public static func getInstance() -> WeatherManager {
        return instance;
    }
    
    func getConditionsAtTime(location: CLLocationCoordinate2D, time: Date, cb: @escaping (WeatherConditions) -> Void) {
        let request = AF.request("https://api.open-meteo.com/v1/forecast?latitude=" + String(location.latitude) + "&longitude=" + String(location.longitude) + "&hourly=temperature_2m,weathercode&temperature_unit=fahrenheit&timezone=America%2FNew_York")
        
        request.responseDecodable(of: MeteoResponse.self) { response in
            if let data = response.value {
                var index = 0;
                var i = 0;
                
                let df = DateFormatter()
                df.dateFormat = "HH";
                let targetTime = Int(df.string(from: time)) ?? 0;
                
                
                for time in data.hourly.time {
                    let substring = time[time.index(time.index(of: "T")!, offsetBy: 1)..<time.index(of: ":")!]   // ab
                    let thisTime = Int(substring) ?? 0;
                    
                    if (thisTime >= targetTime) {
                        index = i;
                        break;
                    }
                    
                    i += 1;
                }
                
                cb(WeatherConditions(weathercode: data.hourly.weathercode[index], tempFah: data.hourly.temperature2M[index]))
            }
        }
    }
    
    public static let WMO_IMAGE_REFERENCE = [
        0: "sun.max.fill", // clear sky
        1: "cloud.sun.fill", // partly cloudy
        2: "cloud.sun.fill",
        3: "cloud.sun.fill",
        45: "cloud.fog.fill", // fog
        48: "cloud.fog.fill",
        51: "cloud.drizzle.fill", // drizzle
        52: "cloud.drizzle.fill",
        53: "cloud.drizzle.fill",
        61: "cloud.rain.fill", // rain
        63: "cloud.rain.fill",
        65: "cloud.rain.fill",
        66: "cloud.moon.rain.fill", // freezing rain
        67: "cloud.moon.rain.fill",
        71: "cloud.snow.fill", // snow
        73: "cloud.snow.fill",
        75: "cloud.snow.fill",
        95: "cloud.bolt.rain.fill", // thunderstorm
    ]
    
    struct MeteoResponse: Decodable {
        let longitude, elevation: Double
        let hourly: Hourly
        let generationtimeMS: Double
        let utcOffsetSeconds: Int
        let latitude: Double

        enum CodingKeys: String, CodingKey {
            case longitude, elevation, hourly
            case generationtimeMS = "generationtime_ms"
            case utcOffsetSeconds = "utc_offset_seconds"
            case latitude
        }
    }

    struct Hourly: Decodable {
        let weathercode: [Int]
        let time: [String]
        let temperature2M: [Double]

        enum CodingKeys: String, CodingKey {
            case weathercode, time
            case temperature2M = "temperature_2m"
        }
    }
    
    public struct WeatherConditions {
        var weathercode: Int;
        var tempFah: Double;
    }
}
