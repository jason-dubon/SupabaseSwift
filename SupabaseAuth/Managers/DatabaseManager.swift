//
//  DatabaseManager.swift
//  SupabaseAuth
//
//  Created by Jason Dubon on 5/27/23.
//

import Foundation
import Supabase

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    let client = SupabaseClient(supabaseURL: URL(string: "YOUR_SERVER")!, supabaseKey: "YOUR_KEY")
    
    func createToDoItem(item: ToDoPayload) async throws {
        let response = try await client.database.from("todos").insert(values: item).execute()
        print(response)
        print(response.status)
        print(response.underlyingResponse.data)
    }
    
    func fetchToDoItems(for uid: String) async throws -> [ToDo] {
        let response = try await client.database.from("todos").select().equals(column: "user_uid", value: uid).order(column: "created_at", ascending: true).execute()
        let data = response.underlyingResponse.data
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let todos = try decoder.decode([ToDo].self, from: data)
        return todos
    }
    
    func deleteToDoItem(id: Int) async throws {
        let response = try await client.database.from("todos").delete().eq(column: "id", value: id).execute()
        print(response)
        print(response.status)
        print(String(data: response.underlyingResponse.data, encoding: .utf8))
    }
    
}
