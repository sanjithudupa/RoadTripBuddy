//
//  BusinessViewer.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/22/22.
//

import SwiftUI
import CoreLocation
import CDYelpFusionKit

//struct BusinessViewer: View {
//    var body: some View {
//        Business(name: "Bus", imageURL: "https://s3-media1.fl.yelpcdn.com/bphoto/6jkLUJSr-SjClqg0lWMvCw/o.jpg", link: "https://www.yelp.com/biz/zip-thru-express-car-wash-santa-clara-7?adjust_creative=wcZaj4-V-tkCzktUpVGNgw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=wcZaj4-V-tkCzktUpVGNgw", price: "$$", phone: "+18449478478", rating: 3.5, location: .init())
//    }
//}

extension CDYelpBusiness {
    func getCoordinates() -> CLLocationCoordinate2D {
        var location: CLLocationCoordinate2D = .init();
        
        if let coord = self.coordinates {
            location = CLLocationCoordinate2D(latitude: coord.latitude!, longitude: coord.longitude!)
        } else {
            print("location coords not working")
        }
        
        return location;
    }
}

struct BusinessViewer: View {
    @Binding var businesses: [CDYelpBusiness]
    @State var callback: (String, CLLocationCoordinate2D) -> Void
    
    var body: some View {
        VStack {
            ScrollView() {
                ForEach(0..<businesses.count, id: \.self) { i in
                    Business(business: businesses[i], callback: callback)
                }
            }
            .padding()
//            .frame(width: UIScreen.main.bounds.width)
        }
    }
}

struct Business: View {
    @State var business: CDYelpBusiness
    @State var callback: (String, CLLocationCoordinate2D) -> Void
    
    @State var name: String = "";
    @State var imageURL: URL = .init(string: "https://yelp.com")!;
    @State var link: URL = .init(string: "https://yelp.com")!;
    @State var price: String = "";
    @State var phone: String = "";
    @State var rating: Double = 0;
    @State var location: CLLocationCoordinate2D = .init();
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                ZStack {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .onTapGesture {
                                        UIApplication.shared.open(link)
                                    }
                                    .frame(width: 250)
                            }
                            HStack {
                                Text(phone)
                                    .onTapGesture {
                                        if let url = URL(string: "tel://\(phone)") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                
                                Text(String(format: "%.2f miles away", LocationManager.getInstance().getLocation().distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude)) / 1609))
                            }
                        }
                        .padding()
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(String(rating) + " ⭐")
                                .font(.title3)
                            HStack {
                                
                                Text(price)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                    }
                }.padding(.top)
                Divider()
                    .frame(width: 320)
                AsyncImage(url: imageURL)
                    .frame(width: 350, height: 150)
                    .scaledToFill()
                    .clipped()
                    .onLongPressGesture {
                        callback(name, location)
                    }

            }
            HStack {
                Text("Powered by")
                    .foregroundColor(.white)
                Text("Yelp")
                    .underline()
                    .foregroundColor(.white)
                    .onTapGesture {
                        if let url = URL(string: "https://yelp.com") {
                            UIApplication.shared.open(url)
                        }
                    }
            }.offset(x: 100, y: 90)
        }
        .frame(width: 350, height: 220)
        .cornerRadius(25)
        .shadow(radius: 15)
        .onAppear {
            /*
             
             name: businesses[i].name ?? "Unnamed", imageURL: businesses[i].imageUrl ?? "https://via.placeholder.com/150", link: businesses[i].url ?? "https://yelp.com", price: businesses[i].price ?? "$$", phone: businesses[i].phone ?? "No Phone Listed", rating: businesses[i].rating ?? 0, location:  CLLocationCoordinate2D(latitude: businesses[i].coordinates?.latitude ?? 0, longitude: businesses[i].coordinates?.longitude ?? 0)
             
             
             */
            name = business.name ?? "Unnamed";
            imageURL = business.imageUrl ?? URL(string: "https://via.placeholder.com/150")!;
            link = business.url ?? URL(string: "https://yelp.com")!;
            price = business.price ?? "$$";
            phone = business.phone ?? "No phone listed";
            rating = business.rating ?? 0;
            location = business.getCoordinates()
        }
    }
}

//struct BusinessViewer_Previews: PreviewProvider {
//    static var previews: some View {
//        BusinessViewer()
//    }
//}
