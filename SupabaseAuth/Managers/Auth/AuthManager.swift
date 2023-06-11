//
//  AuthManager.swift
//  SupabaseAuth
//
//  Created by Jason Dubon on 5/10/23.
//

import Foundation
import Supabase

struct AppUser {
    let uid: String
    let email: String?
}

class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    let client = SupabaseClient(supabaseURL: URL(string: "https://ixjfvcdmqnhfzdhpcjwv.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml4amZ2Y2RtcW5oZnpkaHBjand2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODM3MjQ2MTksImV4cCI6MTk5OTMwMDYxOX0.JYC-8ibgH6ILDCFozR_dDzlGcPE6v2u1e3WQXza9Ni4", options: SupabaseClientOptions(db: .init(schema: "/rest/v1"), auth: .init(), global: .init(headers: [
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml4amZ2Y2RtcW5oZnpkaHBjand2Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY4MzcyNDYxOSwiZXhwIjoxOTk5MzAwNjE5fQ.e8EhHSa7KK-2eiiwEHSdu_xKlfudgZ6kkK8aud2PvjI",
        "apikey" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml4amZ2Y2RtcW5oZnpkaHBjand2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODM3MjQ2MTksImV4cCI6MTk5OTMwMDYxOX0.JYC-8ibgH6ILDCFozR_dDzlGcPE6v2u1e3WQXza9Ni4",
    ], httpClient: .init())))
    
    
    
    func getCurrentSession() async throws -> AppUser {
        let session = try await client.auth.session
        print(session)
        print(session.user.id)
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    // MARK: Registration
    func registerNewUserWithEmail(email: String, password: String) async throws -> AppUser {
        let regAuthResponse = try await client.auth.signUp(email: email, password: password)
        guard let session = regAuthResponse.session else {
            print("no session when registering user")
            throw NSError()
        }
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    

    // MARK: Sign In
    func signInWithEmail(email: String, password: String) async throws -> AppUser {
        let session = try await client.auth.signIn(email: email, password: password)
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
        
    }
    
    func signInWithApple(idToken: String, nonce: String) async throws -> AppUser {
        let session = try await client.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idToken, nonce: nonce))
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    func signInWithGoogle(idToken: String, nonce: String) async throws -> AppUser {
        try await network(idToken: idToken, nonce: nonce)
        let session = try await client.auth.signInWithIdToken(credentials: .init(provider: .google, idToken: idToken, nonce: nonce))
        print(session)
        print(session.user)
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    func network(idToken: String, nonce: String) async throws {
        let url = URL(string: "https://ixjfvcdmqnhfzdhpcjwv.supabase.co/auth/v1/token?grant_type=id_token")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml4amZ2Y2RtcW5oZnpkaHBjand2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODM3MjQ2MTksImV4cCI6MTk5OTMwMDYxOX0.JYC-8ibgH6ILDCFozR_dDzlGcPE6v2u1e3WQXza9Ni4", forHTTPHeaderField: "apikey")
        
        let json = [
            "id_token": idToken,
            "provider": "google"
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: json)
        print(json)
        print(jsonData)
        urlRequest.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        print(String(data: data, encoding: .utf8))
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
}
