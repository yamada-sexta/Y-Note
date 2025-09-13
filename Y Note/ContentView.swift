//
//  ContentView.swift
//  Y Note
//

import SwiftUI
import SwiftData

// MARK: - Note Model
@Model
class Note {
    var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    
    init(title: String, content: String, createdAt: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = createdAt
    }
}

// MARK: - ContentView
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.createdAt, order: .reverse) private var notes: [Note]
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(notes) { note in
                    NavigationLink {
                        NoteDetailView(note: note)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(note.title.isEmpty ? "Untitled Note" : note.title)
                                .font(.headline)
                            Text(note.content)
                                .lineLimit(1)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteNotes)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addNote) {
                        Label("New Note", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a note")
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Functions
    private func addNote() {
        withAnimation {
            let newNote = Note(title: "New Note", content: "")
            modelContext.insert(newNote)
        }
    }
    
    private func deleteNotes(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(notes[index])
            }
        }
    }
}

// MARK: - Note Detail View
struct NoteDetailView: View {
    @Bindable var note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Title", text: $note.title)
                .font(.title)
                .padding(.bottom, 4)
            
            Divider()
            
            TextEditor(text: $note.content)
                .padding(.top, 4)
        }
        .padding()
        .navigationTitle(note.title.isEmpty ? "Untitled Note" : note.title)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .modelContainer(for: Note.self, inMemory: true)
}
