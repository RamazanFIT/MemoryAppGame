//  Piece.swift
//  memoryAppGameHW
//
//  Created by Сырлыбай Рамазан on 27.02.2024.
//

import SwiftUI

struct Piece: Shape {
    var startAngle: Angle = .zero
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        let path = Path { p in
            p.move(to: center)
            p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            p.closeSubpath()
        }
        
        return path
    }
}
