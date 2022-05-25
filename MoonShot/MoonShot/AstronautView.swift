//
//  AstronautView.swift
//  MoonShot
//
//  Created by Rich Bobo on 2022/5/21.
//

import SwiftUI

struct AstronautView: View {
    let astronaut : Astronaut
    
    var body: some View {
        ScrollView{
            VStack{
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                    .padding()
            
                
                Text(astronaut.description)
                    .padding()
            }
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronaut : [String : Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        AstronautView(astronaut : astronaut["aldrin"]! )
            .preferredColorScheme(.dark)
    }
}
