//
//  AddressView.swift
//  Cupcake Corner
//
//  Created by Rich Bobo on 2022/6/21.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order : OrderItems
    
    var body: some View {
        Form {
            Section {
                TextField("Name",text: $order.items.name)
                TextField("Street Address", text: $order.items.streetAddress)
                TextField("City", text: $order.items.city)
                TextField("Zip", text: $order.items.zip)
            }
            
            Section{
                NavigationLink {
                    CheckOutView(order: order)
                }label: {
                    Text("Check Out")
                }
            }
            .disabled(order.items.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AddressView(order: OrderItems())
        }
    }
}
