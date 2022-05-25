//
//  ListLayout.swift
//  MoonShot
//
//  Created by Rich Bobo on 2022/5/24.
//

import SwiftUI

struct ListLayout: View {
    let astronauts : [String : Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
        List{
            ForEach(missions) { missions in
                NavigationLink {
                    MissionView(mission: missions, astronauts: astronauts)
                } label: {
                    HStack {
                        Image(missions.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .padding()
                        
                    Spacer()
                        
                        VStack{
                            Text(missions.displayName)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(missions.formattedLaunchDate)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.lightBackground)
                        
                    Spacer()
            
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.lightBackground)
                    )
                }
            }
            .listRowBackground(Color.darkBackground)
    }
        .listStyle(.plain)
}
}

struct ListLayout_Previews: PreviewProvider {
    static var previews: some View {
        ListLayout()
    }
}
