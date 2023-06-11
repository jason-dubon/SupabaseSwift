//
//  ToDoViewModel.swift
//  SupabaseAuth
//
//  Created by Jason Dubon on 5/27/23.
//

import UIKit

class ToDoViewModel: ObservableObject {
    
    @Published var todos = [ToDo]()
    
    var mockData = [
        ToDoPayload(text: "Homework", userUid: ""),
        ToDoPayload(text: "Swift", userUid: ""),
        ToDoPayload(text: "Gym", userUid: ""),
        ToDoPayload(text: "Read", userUid: ""),
    ]
    
    // MARK: Create
    func createItem(text: String, uid: String) async throws {
        guard !todos.contains(where: { $0.text.lowercased() == text.lowercased() }) else {
            print("Already in todo list")
            throw NSError()
        }
        let toDo = ToDoPayload(text: text, userUid: uid)
        try await DatabaseManager.shared.createToDoItem(item: toDo)
    }
    
    // MARK: Read
    @MainActor
    func fetchItems(for uid: String) async throws {
        todos = try await DatabaseManager.shared.fetchToDoItems(for: uid)
    }
    
    // MARK: Delete
    @MainActor
    func deleteItem(todo: ToDo) async throws {
        try await DatabaseManager.shared.deleteToDoItem(id: todo.id)
        todos.removeAll(where: {$0.id == todo.id})
    }
    
    func fetchProfilePhoto(for user: AppUser) async throws -> UIImage {
        let data = try await StorageManager.shared.fetchProfilePhoto(for: user)
        guard let image = UIImage(data: data) else {
            throw NSError()
        }
        
        return image
    }
}
