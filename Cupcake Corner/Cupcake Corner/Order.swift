//
//  Order.swift
//  Cupcake Corner
//
//  Created by Rich Bobo on 2022/6/21.
//

import SwiftUI

class OrderItems: ObservableObject {
    @Published var items = Order()
}

struct Order: Codable {
   
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet{
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool{
        if name.isBlank || streetAddress.isBlank || city.isBlank || zip.isBlank {
            return false
        }
        
        return true
    }
    
    var cost: Double {
        //每个¥2
        var cost = Double(quantity) * 2
        
        //复杂的蛋糕更贵
        cost += (Double(type) / 2)
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        return cost
    }
    
    init(){ }
}

//class Order: ObservableObject, Codable {
//    enum CodingKeys: CodingKey {
//        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
//    }
//
//    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
//
//    @Published var type = 0
//    @Published var quantity = 3
//
//    @Published var specialRequestEnabled = false {
//        didSet{
//            if specialRequestEnabled == false {
//                extraFrosting = false
//                addSprinkles = false
//            }
//        }
//    }
//    @Published var extraFrosting = false
//    @Published var addSprinkles = false
//
//    @Published var name = ""
//    @Published var streetAddress = ""
//    @Published var city = ""
//    @Published var zip = ""
//
//    var hasValidAddress: Bool{
//        if name.isBlank || streetAddress.isBlank || city.isBlank || zip.isBlank {
//            return false
//        }
//
//        return true
//    }
//
//    var cost: Double {
//        //每个¥2
//        var cost = Double(quantity) * 2
//
//        //复杂的蛋糕更贵
//        cost += (Double(type) / 2)
//
//        // $1/cake for extra frosting
//        if extraFrosting {
//            cost += Double(quantity)
//        }
//        // $0.50/cake for sprinkles
//        if addSprinkles {
//            cost += Double(quantity) / 2
//        }
//        return cost
//    }
//
//    init(){ }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(type, forKey: .type)
//        try container.encode(quantity, forKey: .quantity)
//
//        try container.encode(extraFrosting, forKey: .extraFrosting)
//        try container.encode(addSprinkles, forKey: .addSprinkles)
//
//        try container.encode(name, forKey: .name)
//        try container.encode(streetAddress, forKey: .streetAddress)
//        try container.encode(city, forKey: .city)
//        try container.encode(zip, forKey: .zip)
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        type = try container.decode(Int.self, forKey: .type)
//        quantity = try container.decode(Int.self, forKey: .quantity)
//
//        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
//        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
//
//        name = try container.decode(String.self, forKey: .name)
//        streetAddress = try container.decode(String.self, forKey: .streetAddress)
//        city = try container.decode(String.self, forKey: .city)
//        zip = try container.decode(String.self, forKey: .zip)
//    }
//}

//拓展字符串，增加[isBlank]
extension String {
  var isBlank: Bool {
    return allSatisfy({ $0.isWhitespace })
  }
}


