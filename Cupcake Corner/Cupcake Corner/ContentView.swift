//
//  ContentView.swift
//  Cupcake Corner
//
//  Created by Rich Bobo on 2022/6/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var order = OrderItems()
  
    var body: some View {
        NavigationView{
            Form{
                Section{
                    Picker("Select your cake type", selection: $order.items.type) {
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number Of cakes: \(order.items.quantity)",value: $order.items.quantity,in: 3...20)
                }
                
                Section{
                    Toggle("Any special requests?",isOn: $order.items.specialRequestEnabled.animation())
                    
                    if order.items.specialRequestEnabled {
                        Toggle("Add extra sprinkles",isOn: $order.items.addSprinkles)
                        Toggle("Add extra frosting", isOn: $order.items.extraFrosting)
                    }
                }
                
                Section{
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
