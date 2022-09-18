//
//  Book views.swift
//  ReadMe
//
//  Created by Adya Naufal Fikri on 17/09/22.
//

import SwiftUI

extension Book {
    struct Image: View {
        let image: SwiftUI.Image?
        let title: String
        var size: CGFloat?
        var cornerRadius: CGFloat
        
        var body: some View {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .cornerRadius(cornerRadius)
            } else {
                let symbol = SwiftUI.Image(title: title) ?? SwiftUI.Image(systemName: "book")
                symbol
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .font(Font.title.weight(.light))
                    .foregroundColor(.secondary.opacity(0.5))
            }
        }
    }
}

extension Image {
    init?(title: String) {
        guard let character = title.first,
        case let symbolName = "\(character.lowercased()).square",
        UIImage(systemName: symbolName) != nil
        else {
            return nil
        }
    
        self.init(systemName: symbolName)
    }
}

extension Book.Image {
    init(title: String, size: CGFloat? = nil, cornerRadius: CGFloat = .init()) {
        self.init(image: nil, title: title, size: size, cornerRadius: cornerRadius)
    }
}

extension View {
    var previewedInAllColorSchemes: some View {
        ForEach(ColorScheme.allCases, id: \.self, content: preferredColorScheme)
    }
}

struct Book_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Book.Image(title: Book().title, size: 50)
            Book.Image(title: "")
            Book.Image(title: "📚")
        }
        .previewedInAllColorSchemes
    }
}
