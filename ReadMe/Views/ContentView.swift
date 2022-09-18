//
//  ContentView.swift
//  ReadMe
//
//  Created by Adya Naufal Fikri on 17/09/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var library: Library
    @State var showingAddNewBookSheet: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Button {
                    showingAddNewBookSheet = true
                } label: {
                    Spacer()
                    VStack(alignment: .center, spacing: 6) {
                        Image(systemName: "book.circle")
                            .font(.system(size: 60))
                        Text("Add New Book")
                            .font(.title2)
                    }
                    Spacer()
                }
                .buttonStyle(.borderless)
                .padding(.vertical, 8)
                .sheet(isPresented: $showingAddNewBookSheet, content: AddBookView.init)
                
                ForEach(Section.allCases, id: \.self) { section in
                    SectionView(section: section)
                }
            }
            .listStyle(.insetGrouped)
            .toolbar(content: EditButton.init)
            .navigationTitle("My Library")
        }
    }
}

private struct BookRow: View {
    @ObservedObject var book: Book
    @EnvironmentObject var library: Library
    
    var body: some View {
        NavigationLink(destination: DetailView(book: book)) {
            HStack {
                Book.Image(image: library.images[book], title: book.title, size: 80, cornerRadius: 12)
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.title2)
                    Text(book.author)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    if !book.microReview.isEmpty {
                        Spacer()
                        Text(book.microReview)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .lineLimit(1)
            }
            .padding(.vertical)
        }
    }
}

private struct SectionView: View {
    let section: Section
    @EnvironmentObject var library: Library
    
    var title: String {
        switch section {
        case .readMe:
            return "Read Me!"
        case .finished:
            return "Finished!"
        }
    }
    
    var body: some View {
        if let books = library.sortedBooks[section] {
            SwiftUI.Section {
                ForEach(books) { book in
                    BookRow(book: book)
                        .swipeActions(edge: .leading) {
                            Button {
                                withAnimation {
                                    book.readMe.toggle()
                                    library.sortBooks()
                                }
                            } label: {
                                book.readMe
                                ? Label("Finished", systemImage: "bookmark.slash")
                                : Label("Read Me!", systemImage: "bookmark")
                            }
                            .tint(.accentColor)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                guard let index = books.firstIndex(where: { $0.id == book.id }) else { return }
                                withAnimation {
                                    library.deleteBooks(atOffsets: .init(integer: index), section: section)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .onDelete { indexSet in
                    library.deleteBooks(atOffsets: indexSet, section: section)
                }
                .onMove { oldOffsets, newOffset in
                    library.moveBooks(oldOffsets: oldOffsets, newOffset: newOffset, section: section)
                }
            } header: {
                ZStack {
                    Image("BookTexture")
                        .resizable()
                        .scaledToFit()
                    Text(title)
                        .font(.custom("American Typewriter", size: 24))
                        .foregroundColor(.primary)
                }
                .listRowInsets(.init())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Library())
            .previewedInAllColorSchemes
    }
}
