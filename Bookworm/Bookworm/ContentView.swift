//
//  ContentView.swift
//  Bookworm
//
//  Created by Rich Bobo on 2022/6/27.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.createDate),
        SortDescriptor(\.title),
        SortDescriptor(\.author)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView{
            List {
                ForEach(books) { book in
                    NavigationLink {
                        DetailView(book: book)
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                if book.rating == 1 {
                                    Text(book.title ?? "Unknown Title")
                                        .font(.headline)
                                        .foregroundColor(Color.red)
                                }else{
                                    Text(book.title ?? "Unknown Title")
                                        .font(.headline)
                                }
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                //onDelete用于ForEach
                .onDelete(perform: deleteBooks)
            }
                .navigationTitle("Bookworm")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddScreen.toggle()
                        }label: {
                            Label("Add Book", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView()
                }
    }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            //在fetch request中找到要删除的书
            let book = books[offset]
            
            //从上下文中删除这个项目
            moc.delete(book)
        }
        //存储上下文
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
