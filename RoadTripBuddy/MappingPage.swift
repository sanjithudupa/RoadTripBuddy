//
//  MappingPage.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/21/22.
//

import SwiftUI

struct MappingPage: View {
    @EnvironmentObject var env : AppEnvironmentData

    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationBarHidden(true).navigationBarTitle("")
    }
}

struct MappingPage_Previews: PreviewProvider {
    static var previews: some View {
        MappingPage()
    }
}
