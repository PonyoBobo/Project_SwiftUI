//
//  AddressView.swift
//  Cupcake Corner
//
//  Created by Rich Bobo on 2022/6/21.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order : Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name",text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            
            Section{
                NavigationLink {
                    CheckOutView(order: order)
                }label: {
                    Text("Check Out")
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AddressView(order: Order())
        }
    }
}
