//
//  AddBookView.swift
//  ReadMe
//
//  Created by Adya Naufal Fikri on 18/09/22.
//

import class PhotosUI.PHPickerViewController
import SwiftUI

struct AddBookView: View {
    @ObservedObject var book: Book = .init(title: "", author: "")
    @State var image: Image? = nil
    @State var showingImagePicker: Bool = false
    @EnvironmentObject var library: Library
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                TextField("Title...", text: $book.title)
                Divider()
                TextField("Author...", text: $book.author)
                Divider()
                    .padding(.vertical)
                TextField("Review...", text: $book.microReview)
                Divider()
                    .padding(.vertical)
                Book.Image(image: image, title: book.title, cornerRadius: 16)
                HStack(spacing: 24) {
                    Button("Update image...") {
                        showingImagePicker = true
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        PHPickerViewController.View(image: $image)
                    }
                }
                .padding()
            }
            .padding()
            .navigationBarTitle("Got a new book?")
            .toolbar {
                ToolbarItem(placement: .status) {
                    Button("Add to Library") {
                        library.addNewBook(book, image: image)
                        dismiss()
                    }
                    .disabled(
                        [book.title, book.author]
                            .contains(where: \.isEmpty)
                    )
                }
            }
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
            .environmentObject(Library())
    }
}
