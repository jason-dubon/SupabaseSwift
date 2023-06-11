//
//  StorageManager.swift
//  SupabaseAuth
//
//  Created by Jason Dubon on 6/1/23.
//

import Foundation
import SupabaseStorage
import Supabase

class StorageManager {
    
    static let shared = StorageManager()
    
    lazy var storage = SupabaseStorageClient(url: "https://SERVER_DETAILS.supabase.co/storage/v1", headers: [
        "Authorization": "Bearer \(secret)",
        "apikey" : apikey,
    ])

    func uploadProfilePhoto(for user: AppUser, photoData: Data) async throws {
        let file = File(name: "profile_photo", data: photoData, fileName: "profile_photo.jpg", contentType: "jpg")
        
        do {
            try await storage.from(id: "images").list(path: "\(user.uid)")
            let result = try await storage.from(id: "images").update(path: "\(user.uid)/profile_photo.jpg", file: file, fileOptions: FileOptions(cacheControl: "2400"))
            print(result)
        } catch {
            let result = try await storage.from(id: "images").upload(path: "\(user.uid)/profile_photo.jpg", file: file, fileOptions: FileOptions(cacheControl: "2400"))
            print(result)
        }
    }
    
    func fetchProfilePhoto(for user: AppUser) async throws -> Data {
        return try await storage.from(id: "images").download(path: "\(user.uid)/profile_photo.jpg")
    }
    
    
    // MARK: This can be ignored and was used for trouble shooting. Leaving it in here for future reference in case debugging is needed. Feel free to remove this section.
    let client = SupabaseClient(supabaseURL: URL(string: "https://ixjfvcdmqnhfzdhpcjwv.supabase.co/storage/v1")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml4amZ2Y2RtcW5oZnpkaHBjand2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODM3MjQ2MTksImV4cCI6MTk5OTMwMDYxOX0.JYC-8ibgH6ILDCFozR_dDzlGcPE6v2u1e3WQXza9Ni4")
    
    let storageClient = SupabaseClient(supabaseURL: URL(string: "https://ixjfvcdmqnhfzdhpcjwv.supabase.co/storage/v1")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml4amZ2Y2RtcW5oZnpkaHBjand2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODM3MjQ2MTksImV4cCI6MTk5OTMwMDYxOX0.JYC-8ibgH6ILDCFozR_dDzlGcPE6v2u1e3WQXza9Ni4")

    func troubleShootingCode() async throws {
        let bucketsOne = try await storageClient.storage.listBuckets()
        print(bucketsOne)
        let bucketsTwo = try await client.storage.listBuckets()
        print(bucketsTwo)
    }
    
    func uploadByHand(data: Data) async throws {
        let url = URL(string: "https://ixjfvcdmqnhfzdhpcjwv.supabase.co/storage/v1/object/public/images/pic.png")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("Bearer 1MBqBiDtq1OT5E5oPJFrIvscFd+UFZfjxXB6qQC16RYO8j54rzHK+NNcCtcG5cc5zofMLaOg0cf1czEdwp9AEg==", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml4amZ2Y2RtcW5oZnpkaHBjand2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODM3MjQ2MTksImV4cCI6MTk5OTMwMDYxOX0.JYC-8ibgH6ILDCFozR_dDzlGcPE6v2u1e3WQXza9Ni4", forHTTPHeaderField: "apikey")
        
        urlRequest.httpBody = data
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        print(String(data: data, encoding: .utf8))
    }
    
}
