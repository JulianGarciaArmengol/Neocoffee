//
//  delay.swift
//  Neocoffee
//
//  Created by julian.garcia on 06/08/24.
//

import Foundation

public func delay(_ delay: Double, closure: @escaping () -> Void) {
    let deadline = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(
        deadline: deadline,
        execute: closure
    )
}
