//
//  MappingPage.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/21/22.
//

import SwiftUI
import MapKit
import CDYelpFusionKit

struct MappingPage: View {
    @EnvironmentObject var env : AppEnvironmentData
    
    @State private var infoAlert = false;
    @State private var showingSteps = false;
    @State private var region = MKCoordinateRegion(SharedData.getInstance().chosenRoute.polyline.boundingMapRect);
    
    @State private var fabSelection = "Cancel"
    let fabActions = ["Cancel", "Gas", "Food", "Hotel", "Stores"]
    
    @State private var asking = false;
    @State private var queryRadius = 0.0;
    
    @State private var loading = false;
    
    @State private var showingBusinesses = false;
    @State private var businesses: [CDYelpBusiness] = [CDYelpBusiness]();
    
//    @State var attachMarker: (String, CLLocationCoordinate2D) -> Void = { _,_  in }
    @State private var annotations = [MKAnnotation]();
    
    var body: some View {
            ZStack {
                MapView(
                    region: $region, annotations: $annotations,
                    inputPolyline: SharedData.getInstance().chosenRoute.polyline
                )
                .edgesIgnoringSafeArea(.all)
                
                ZStack {
                    Picker("FAB", selection: $fabSelection) {
                        ForEach(fabActions, id: \.self) {
                            Text($0)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .frame(width: 60, height: 60)
                    .pickerStyle(.menu)
                    .onChange(of: fabSelection) { _ in
                        if (fabSelection != "Cancel") {
                            asking = true;
                        }
                    }
                    
                    Image(systemName: "plus.app.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.orange)
                        .background(.white)
                        .cornerRadius(15)
                        .allowsHitTesting(false)
                        .shadow(radius: 15)
                }
                .offset(x: -150, y: UIScreen.main.bounds.height/2 - 115)
                
                VStack {
                    Button(role: .cancel, action: resetLocation) {
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.orange)
                            .background(.white)
                            .cornerRadius(30)
                            .shadow(radius: 15)
                    }
                    
                    Button(role: .cancel, action: viewDirections) {
                        Image(systemName: "list.bullet.rectangle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.orange)
                            .background(.white)
                            .cornerRadius(8)
                            .shadow(radius: 15)
                    }.sheet(isPresented: $showingSteps) {
                        VStack {
                            Text("Upcoming Directions:")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .padding()
                            List() {
                                ForEach(rmFirstTwo(steps: SharedData.getInstance().chosenRoute.steps), id: \.self) { step in
                                    
                                    if (!step.instructions.isEmpty) {
                                        VStack {
                                            HStack {
                                                Image(systemName: getImageForStep(step: step.instructions))
                                                    .resizable()
                                                    .frame(width: 25, height: 25)
                                                    .foregroundColor(.orange)
                                                    .shadow(radius: 15)
                                                
                                                Text(step.instructions)
                                                    .font(.title3)
                                                    .shadow(radius: 15)
                                                Spacer()
                                                
                                            }
                                            HStack(alignment: .bottom){
                                                Text(String(format: "%.2f miles", (step.distance.magnitude) * 0.000621371))
                                                    .font(.caption)
                                                    .shadow(radius: 15)
                                                Text(step.notice ?? "")
                                                    .font(.caption)
                                                    .fontWeight(.thin)
                                                    .shadow(radius: 15)
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                                Button(action: {
                                    let url = URL(string: "https://designcode.io")
                                    let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)

                                    UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
                                }) {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "square.and.arrow.up")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 45, height: 45)
                                            .foregroundColor(.orange)
                                            .shadow(radius: 10)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    
                }.offset(x: UIScreen.main.bounds.width/2 - 50, y: UIScreen.main.bounds.height/2 - 150)
                
                Button(role: .cancel, action: { infoAlert = true }) {
                    Image(systemName: "info.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.orange)
                        .background(.white)
                        .cornerRadius(30)
                        .shadow(radius: 15)
                }.offset(x: 45 - UIScreen.main.bounds.width/2, y: 80 - UIScreen.main.bounds.height/2)
                    .alert(isPresented: $infoAlert) {
                        Alert(title: Text("Route Details:"), message: Text(getRouteDescription()), primaryButton: .destructive(Text("End Directions"), action: {
                            self.env.currentPage = .Planning;
                        }), secondaryButton: .default(Text("OK")))
                    }
                
                ZStack {
                    Color.white
                        .frame(width: 145, height: 55)
                        .cornerRadius(15)
                        .shadow(radius: 20)
                    HStack(spacing: 0.5) {
                        Text("ETA: ")
                            .fontWeight(.heavy)
                        Text(getETA())
                    }
                }.offset(x: UIScreen.main.bounds.width/2 - 92.5, y: 80 - UIScreen.main.bounds.height/2)
                
                ZStack {
                    VisualEffectView(effect: UIBlurEffect(style: .light))
                        .edgesIgnoringSafeArea(.all)
                        .opacity(asking ? 1 : 0)
                        .animation(.spring(), value: asking)
                        .onTapGesture {
                            asking = false;
                            fabSelection = "Cancel";
                        }

                    Group {
                        Color.white
                            .frame(width: 300, height: 180)
                            .cornerRadius(15)
                            .shadow(radius: 20)
                        VStack {
                            Text("How far should I search for " + fabSelection.lowercased() + "?")
                                .fontWeight(.semibold)
                            TextField("Distance in Miles", value: $queryRadius, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                                .padding()
                                .frame(width: 280)
                                .shadow(radius: 15)
                            Button(role:.cancel, action: {
                                asking = false;
                                requestFor(requestType: fabSelection)
                            }) {
                                Text("Search")
                                    .foregroundColor(.orange)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .offset(y: asking ? 0 : 550)
                    .animation(.spring(), value: asking)
                }
                
                Group {
                    VisualEffectView(effect: UIBlurEffect(style: .light))
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Searching...")
                            .fontWeight(.thin)
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(width: 60, height: 60)
                            .background(.gray.opacity(0.25))
                            .cornerRadius(20)
                    }
                }
                .opacity(loading ? 1 : 0)
                .animation(.spring(), value: loading)
                .sheet(isPresented: $showingBusinesses) {
                    BusinessViewer(businesses: $businesses, callback: indicateToAttachMarker)
                }
                
            }
            .navigationBarHidden(true).navigationBarTitle("")
    }
    
    func resetLocation() {
        region.center = LocationManager.getInstance().getLocation().coordinate
    }
    
    func getETA() -> String {
        let df = DateFormatter()
        df.dateFormat = "h:mm a"
        return df.string(from: SharedData.getInstance().startTime.addingTimeInterval(SharedData.getInstance().chosenRoute.expectedTravelTime))
    }
    
    func viewDirections() {
        showingSteps = true
    }
    
    func getRouteDescription() -> String {
        let dist = String(format: "%.2f miles", (SharedData.getInstance().chosenRoute.distance.magnitude) * 0.000621371);
        
        let time = String(format: "%.2f hours", (SharedData.getInstance().chosenRoute.expectedTravelTime.magnitude.truncatingRemainder(dividingBy: 86400)) / 3600);
        
        return "Total Distance: " + dist + "\nTotal Time: " + time;
    }
    
    func rmFirstTwo(steps: [MKRoute.Step]) -> [MKRoute.Step] {
        var n = steps
        n.removeFirst(2)
        return n;
    }
    
    func getImageForStep(step: String) -> String {
        if (step.lowercased().contains("keep") || step.lowercased().contains("merge")) {
            return "arrow.up." + (step.lowercased().contains("right") ? "right" : "left")
        } else if (step.lowercased().contains("left")) {
            return "arrow.turn.up.left"
        } else if (step.lowercased().contains("right")) {
            return "arrow.turn.up.right"
        } else if (step.lowercased().contains("exit")) {
            return "arrow.down.right"
        }  else if (step.lowercased().contains("arrive")) {
            return "mappin.and.ellipse"
        }
        return "arrow.up"
    }
    
    func requestFor(requestType: String) {
        loading = true;
        fabSelection = "Cancel";
        let centerPoint = Util.determineSearchPoint(inTheNext: 20)
        
        BusinessManager.getInstance().searchForBusinesses(type: requestType, center: centerPoint, radius: max(queryRadius, 24.8), callback: { bz in
            
            businesses = bz;
            loading = false;
            
            showingBusinesses = true;
        })
    }
    
    func indicateToAttachMarker(s: String, l: CLLocationCoordinate2D) {
        showingBusinesses = false;
        let annotation = MKPointAnnotation();
        annotation.title = s;
        annotation.coordinate = l;
        annotations.append(annotation);
    }
}


struct MapView: UIViewRepresentable {

    @Binding var region: MKCoordinateRegion
    @Binding var annotations: [MKAnnotation]
    let inputPolyline: MKPolyline
    
    var neededAnnotation: MKAnnotation? = nil;
    var mapView: MKMapView = MKMapView();

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true

        let polyline = inputPolyline
        mapView.addOverlay(polyline)
        
//        mapView.addAnnotation(MKCircle(center: polyline.coordinates.last!, radius: 5))
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.addAnnotations(annotations)
        view.region = region
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView

    init(_ parent: MapView) {
        self.parent = parent
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 10
            return renderer
        }
        return MKOverlayRenderer()
    }
}

struct MappingPage_Previews: PreviewProvider {
    static var previews: some View {
        MappingPage()
    }
}

public extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)

        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))

        return coords
    }
}
