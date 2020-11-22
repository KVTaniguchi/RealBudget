//
//  HorizontalAlignmentExtensions.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 11/22/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation
import SwiftUI

extension HorizontalAlignment {
    struct CenterLine: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
    }
    
    static let centerLine = HorizontalAlignment(CenterLine.self)
}
