//
//  Library.swift
//  ReadMe
//
//  Created by Adya Naufal Fikri on 17/09/22.
//

import Combine
import SwiftUI

enum Section: CaseIterable {
    case readMe
    case finished
}

class Library: ObservableObject {
    var sortedBooks: [Section:[Book]] {
        get {
            let groupBooks = Dictionary(grouping: booksCache, by: \.readMe)
            return Dictionary(uniqueKeysWithValues: groupBooks.map {
                (($0  ? .readMe : .finished), $1)
            })
        }
        set {
            booksCache = newValue
                .sorted { $1.key == .finished }
                .flatMap { $0.value }
        }
    }
    
    func sortBooks() {
        booksCache = sortedBooks
            .sorted { $1.key == .finished }
            .flatMap { $0.value }
        objectWillChange.send()
    }
    
    /// Add a new books at the start of library's manually-sorted books
    func addNewBook(_ book: Book, image: Image?) {
        booksCache.insert(book, at: 0)
        images[book] = image
    }
    
    func deleteBooks(atOffsets offsets: IndexSet, section: Section) {
        let booksBeforeDeletion = booksCache
        sortedBooks[section]?.remove(atOffsets: offsets)
        
        for change in booksCache.difference(from: booksBeforeDeletion) {
            if case .remove(_, let deletedBook, _) = change {
                images[deletedBook] = nil
            }
        }
    }
    
    func moveBooks(oldOffsets: IndexSet, newOffset: Int, section: Section) {
        sortedBooks[section]?.move(fromOffsets: oldOffsets, toOffset: newOffset)
    }

    /// An in-memory cache of the manually-sorted books.
    @Published private var booksCache: [Book] = [
        .init(title: "Ein Neues Land", author: "Shaun Tan"),
        .init(title: "Bosch", author: "Laurinda Dixon", microReview: "Earthly delights"),
        .init(title: "Dare to Lead", author: "Brené Brown"),
        .init(title: "Blasting for Optimum Health Recipe Book", author: "NutriBullet"),
        .init(title: "Drinking with the Saints", author: "Michael P. Foley", microReview: "One of my favorites! 😻"),
        .init(title: "A Guide to Tea", author: "Adagio Teas"),
        .init(title: "The Life and Complete Work of Francisco Goya", author: "P. Gassier & J Wilson", microReview: "Book too large for a micro review"),
        .init(title: "Lady Cottington's Pressed Fairy Book", author: "Lady Cottington"),
        .init(title: "How to Draw Cats", author: "Janet Rancan"),
        .init(title: "Drawing People", author: "Barbara Bradley"),
        .init(title: "What to Say When You Talk to Yourself", author: "Shad Helmstetter")
    ]
    
    @Published var images: [Book: Image] = [:]
}
