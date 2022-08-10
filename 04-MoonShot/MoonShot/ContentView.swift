//
//  ContentView.swift
//  MoonShot
//
//  Created by Rich Bobo on 2022/5/18.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingList = false
    
    var body: some View {
        NavigationView{
            Group{
                if showingList{
                    ListLayout()
                }else{
                    GridLayout()
                }
            }
            .toolbar{
                ToolbarItem{
                    Button("Toggle View"){
                        showingList.toggle()
                    }
                }
            }
            .navigationTitle("MoonShot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
