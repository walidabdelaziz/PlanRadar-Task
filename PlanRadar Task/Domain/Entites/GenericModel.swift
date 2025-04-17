//
//  GenericModel.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

import Foundation
class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet { listener?(value) }
    }
    
    init(_ value: T) { self.value = value }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}

class GenericDataSource<T> : NSObject {
    var data: Box<[T]> = Box([])
}

enum GenericData: Codable {
    
    case int(Int), double(Double), string(String)
    
    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
        
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(double)
            return
        }
        
        throw GenericDataError.missingValue
    }
    
    enum GenericDataError:Error {
        case missingValue
    }
}

extension GenericData {
    
    var intValue: Int? {
        switch self {
        case .int(let value): return value
        case .string(let value): return Int(value)
        case .double(let value): return Int(value)
        }
    }
    
    var doubleValue: Double? {
        switch self {
        case .int(let value): return Double(value)
        case .string(let value): return Double(value)
        case .double(let value): return value
        }
    }
    
    var stringValue: String? {
        switch self {
        case .int(let value): return String(value)
        case .string(let value): return value
        case .double(let value): return String(value)
        }
    }
}
