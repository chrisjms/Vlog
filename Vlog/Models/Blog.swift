//
//  Blog.swift
//  Vlog
//
//  Created by Christopher James on 30/09/2022.
//

import Foundation
import SwiftUI

struct Blog {
    
    var title: String
    var date: String
    var image: UIImage
    var id: String
    var imagePath: String
    var textContent: String
    var paragraphs: [Paragraph]?
    
}

struct Paragraph {
    
    var title: String
    var image: UIImage
    var imagePath: String
    var content: String
    
}
