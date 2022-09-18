//
//  DetailView.swift
//  ReadMe
//
//  Created by Adya Naufal Fikri on 17/09/22.
//

import class PhotosUI.PHPickerViewController
import SwiftUI

struct DetailView: View {
    @ObservedObject var book: Book
    @EnvironmentObject var library: Library
    @State var showingImagePicker: Bool = false
    @State var showingDeleteConfirmationDialog: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 16) {
                Button {
                    book.readMe.toggle()
                } label: {
                    Image(systemName: book.readMe ? "bookmark.fill" : "bookmark")
                }
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.title)
                    Text(book.author)
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            VStack {
                Divider()
                    .padding(.vertical)
                TextField("Review...", text: $book.microReview)
                Divider()
                    .padding(.vertical)
                Book.Image(image: library.images[book], title: book.title, cornerRadius: 16)
                HStack(spacing: 24) {
                    if (library.images[book] != nil) {
                        Button("Delete image") {
                            showingDeleteConfirmationDialog = true
                        }
                        .confirmationDialog(
                            "Delete image for \(book.title)",
                            isPresented: $showingDeleteConfirmationDialog
                        ) {
                            Button("Delete", role: .destructive) {
                                library.images[book] = nil
                            }
                        } message: {
                            Text("Delete image for \(book.title)")
                        }
                    }
                    Button("Update image...") {
                        showingImagePicker = true
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        PHPickerViewController.View(image: $library.images[book])
                    }
                }
                .padding()
            }
            Spacer()
        }
        .padding()
        .onDisappear {
            withAnimation {
                library.sortBooks()
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(book: .init())
            .environmentObject(Library())
            .previewedInAllColorSchemes
    }
}
