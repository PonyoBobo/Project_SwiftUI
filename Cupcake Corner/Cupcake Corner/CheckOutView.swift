//
//  CheckOutView.swift
//  Cupcake Corner
//
//  Created by Rich Bobo on 2022/6/21.
//

import SwiftUI

struct CheckOutView: View {
    @ObservedObject var order: Order
    
    @State private var stateMessage = ""
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                }placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order"){
                    Task{
                       await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        .alert(stateMessage, isPresented: $showingConfirmation) {
            Button("OK") { }
        }message: {
            Text(confirmationMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode oreder")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodeOrder = try JSONDecoder().decode(Order.self, from: data)
            stateMessage = "Thank You"
            confirmationMessage = "Your order for \(decodeOrder.quantity) x \(Order.types[decodeOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        }catch {
            stateMessage = "Error"
            confirmationMessage = "There was an Error, please try again."
            showingConfirmation = true
            print("Checkout failed")
        }
    }
}

struct CheckOutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutView(order: Order())
    }
}
