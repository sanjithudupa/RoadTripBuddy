//
//  RoutingPage.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/21/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct RoutingPage: View {
    @State var starting: String = "";
    @State var target: String = "";
    
    @State private var currentLocation: CLLocationCoordinate2D = .init();
    @State private var region: MKCoordinateRegion = .init();
    
    @State private var targetCoords: CLLocationCoordinate2D = .init()
    @State private var showingMap = false;
    
    
    @State private var calculating: Bool = false;
    @State private var setRoute: MKRoute? = nil;
    
    @EnvironmentObject var env : AppEnvironmentData
    
    var body: some View {
        ZStack {
            VStack {
                Text("Road Trip Planning")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("Where are you headed?")
                
                Spacer()
                    .frame(height: 50)
                
                
                Text("Starting from:")
                HStack {
                    TextField("Starting Location", text: $starting)
                        .padding()
                        .textFieldStyle(.roundedBorder)
                    
                    Button(role: .cancel, action: {
                        starting = "Current Location"
                    }) {
                        Image(systemName: "location.viewfinder")
                            .padding(7.5)
                            .foregroundColor(.white)
                            .background(.orange)
                            .cornerRadius(25)
                    }
                }.padding()
                
                Text("Going to:")
                HStack {
                    TextField("Target Location", text: $target)
                        .padding()
                        .textFieldStyle(.roundedBorder)
                    
                    Button(role: .cancel, action: {
                        showingMap = true;
                    }) {
                        Image(systemName: "mappin.and.ellipse")
                            .padding(7.5)
                            .foregroundColor(.white)
                            .background(.orange)
                            .cornerRadius(25)
                    }
                }.padding()
                
                if (setRoute != nil) {
                    Spacer()
                        .frame(height: 60)
                    Text("Route Info:")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Text("Distance:")
                        Text(String(format: "%.2f miles", (setRoute!.distance.magnitude) * 0.000621371))
                            .foregroundColor(.orange)
                            .fontWeight(.black)
                    }
                    
                    HStack {
                        Text("Travel Time:")
                        Text(String(format: "%.2f hours", (setRoute!.expectedTravelTime.magnitude.truncatingRemainder(dividingBy: 86400)) / 3600))
                            .foregroundColor(.orange)
                            .fontWeight(.black)
                    }
                }

                Spacer()
                
                Button(role: .cancel, action: {
                    if (setRoute != nil) {
                        self.env.currentPage = .Map;
                    }
                }) {
                    Text("Let's go!")
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(20)
                        .frame(width: 200)
                        .background(.orange)
                        .cornerRadius(10)
                        .disabled(setRoute == nil)
                        .padding()
                }
            }
            
            Group {
                VisualEffectView(effect: UIBlurEffect(style: .light))
                    .edgesIgnoringSafeArea(.all)
                
                Text("Tap outside to cancel")
                    .fontWeight(.thin)
                    .offset(y: 250)
            }
            .opacity(showingMap ? 1 : 0)
            .animation(.spring(), value: showingMap)
            .onTapGesture {
                showingMap = false
            }
            
            TargetChooser(region: $region, showing: $showingMap, chosenLocation: $targetCoords)
                .offset(y: showingMap ? 0 : 650)
                .animation(.spring(), value: showingMap)
                .padding()
                .onChange(of: targetCoords.latitude){_ in
                    refreshTargetText()
                }
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .edgesIgnoringSafeArea(.all)
                .opacity(calculating ? 1 : 0)
                .animation(.spring(), value: calculating)
            
            ProgressView()
                .progressViewStyle(.circular)
                .frame(width: 60, height: 60)
                .background(.gray.opacity(0.25))
                .cornerRadius(20)
                .opacity(calculating ? 1 : 0)
                .animation(.spring(), value: calculating)


        }.onAppear {
            
            
//            currentLocation =  CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275);
            
//            LocationManager.getInstance()
            
//            print("calling")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                currentLocation = LocationManager.getInstance().getLocation().coordinate;
                region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                
                
                WeatherManager.getInstance().getConditionsAtTime(location: currentLocation, time: Date(), cb: { conditions in
                    
                    print("Conditions")
                    print(conditions.weathercode)
                    print(conditions.tempFah)
                    
                })

                
//                print("fetched")
                print(currentLocation.latitude)
            }
        }.navigationBarHidden(true).navigationBarTitle("")
    }
    
    func refreshTargetText() {
        LocationManager.getInstance().geocoder.reverseGeocodeLocation(CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)) { placemarks, error in
                if error != nil {
                    target = ""
                } else {
                    if let placemarks = placemarks, let placemark = placemarks.first {
                        target = (placemark.subThoroughfare ?? "") + " " + (placemark.thoroughfare ?? "")
                    } else {
                        target = ""
                    }
                }
            
                calculateRoute()
            }
    }
    
    func calculateRoute() {
        calculating = true;
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: LocationManager.getInstance().getLocation().coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: targetCoords));
        request.transportType = .automobile
        request.requestsAlternateRoutes = false;
        
        let directions = MKDirections(request: request)
        directions.calculate { [] response, error in
            guard let unwrappedResponse = response else { return }
            
            let route = unwrappedResponse.routes.first
            if let route = route {
                SharedData.getInstance().chosenRoute = route
                SharedData.getInstance().startTime = Date()
                calculating = false;
                setRoute = route;
            }
        }
        
        // self.env.currentPage = .Map
    }
    
    func displayRouteInfo() {
        
    }
}

struct RoutingPage_Previews: PreviewProvider {
    static var previews: some View {
        RoutingPage()
    }
}
