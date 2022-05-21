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
    
    var body: some View {
        ZStack {
            VStack {
                Text("Where to?")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("Where should we route to?")
                
                Spacer()
                    .frame(height: 50)
                
                
                Text("From:")
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
                
                Text("To:")
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

                Spacer()
                
                
                Button(role: .cancel, action: {}) {
                    Text("Let's go!")
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(20)
                        .frame(width: 200)
                        .background(.orange)
                        .cornerRadius(10)
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


        }.onAppear {
            
            
//            currentLocation =  CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275);
            
//            LocationManager.getInstance()
            
//            print("calling")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                currentLocation = LocationManager.getInstance().getLocation().coordinate;
                region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                
//                print("fetched")
                print(currentLocation.latitude)
            }
        }
    }
    
    func refreshTargetText() {
        LocationManager.getInstance().geocoder.reverseGeocodeLocation(CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)) { placemarks, error in
                if error != nil {
                    target = ""
                } else {
                    if let placemarks = placemarks, let placemark = placemarks.first {
                        target = (placemark.name ?? "") + (placemark.thoroughfare ?? "")
                    } else {
                        target = ""
                    }
                }
            }
    }
}

struct RoutingPage_Previews: PreviewProvider {
    static var previews: some View {
        RoutingPage()
    }
}
