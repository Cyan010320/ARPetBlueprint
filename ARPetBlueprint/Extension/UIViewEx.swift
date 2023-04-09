//
//  UIViewEx.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/4/2.
//

import Foundation
import UIKit

extension UIView {
    func takeScreenshot() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
}
