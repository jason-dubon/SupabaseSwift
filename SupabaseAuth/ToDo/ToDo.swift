//
//  ToDo.swift
//  SupabaseAuth
//
//  Created by Jason Dubon on 5/27/23.
//

import Foundation

struct ToDo: Decodable {
    let id: Int
    let createdAt: String
    let text: String
    let userUid: String
}

struct ToDoPayload: Codable {
    let text: String
    let userUid: String
    
    private enum CodingKeys: String, CodingKey {
        case text
        case userUid = "user_uid"
    }
}
