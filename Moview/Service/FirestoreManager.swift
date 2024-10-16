//
//  FirestoreManager.swift
//  Moview
//
//  Created by 심관혁 on 9/24/24.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

struct UserData: Codable, Identifiable {
    @DocumentID var id: String?
    let displayName: String
    let email: String
    let movies: [Int]
    
    init(id: String? = nil, displayName: String, email: String, movies: [Int] = []) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.movies = movies
    }
}

public final class FirestoreManager: ObservableObject {
    let db = Firestore.firestore()
    
    @Published var favorites: [String] = []
    @Published var userData: UserData = UserData(id: nil, displayName: "Guest", email: "example@example.com")
    
    func resetUserData() {
        DispatchQueue.main.async {
            self.userData = UserData(id: nil, displayName: "Guest", email: "example@example.com", movies: [])
        }
    }
    
    func createUserData(_ userInfo: UserAuthInfo) {
        let displayName = if userInfo.lastName == nil && userInfo.firstName == nil { "이름없음" } else {
            String(userInfo.lastName ?? "") + String(userInfo.firstName ?? "")
        }
        let data: [String: Any] = [
            "uid": userInfo.uid,
            "email": userInfo.email ?? "",
            "firstName": userInfo.firstName ?? "",
            "lastName": userInfo.lastName ?? "",
            "displayName": displayName,
            "movies": []
        ]
        db.collection("users").document(userInfo.uid).setData(data)
    }
    
    func updateUserData(_ uid: String, updateName: String) {
        db.collection("users").document(uid).updateData(["displayName": updateName])
    }
    
    func loadUserData(_ uid: String) {
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                print("User document does not exits")
                return
            }
            
            do {
                let userData = try snapshot.data(as: UserData.self)
                self.userData = userData
            } catch {
                print("Error decoding user data: \(error)")
            }
        }
    }
    
    func deleteUserData(_ uid: String) {
        deleteFavorite(uid)
        db.collection("users").document(uid).delete()
    }
    
    func updateFavorite(_ uid: String, id: Int, title: String, poster_path: String, vote_average: Double) {
        let movie: [String: Any] = [
            "title": title,
            "poster_path": poster_path,
            "vote_average": vote_average
        ]
        let data = db.collection("users").document(uid).collection("favorites").document(String(id))
        
        data.getDocument { (document, error) in
            if let document = document, document.exists {
                data.delete()
            } else {
                data.setData(movie)
            }
        }
        updateUserMovie(uid, updateMovie: id)
    }
    
    func updateUserMovie(_ uid: String, updateMovie: Int) {
        let data = db.collection("users").document(uid)
        
        data.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!["movies"] as! [Int]
                if dataDescription.contains(updateMovie) {
                    self.db.collection("users").document(uid).updateData(["movies": FieldValue.arrayRemove([updateMovie])])
                } else {
                    self.db.collection("users").document(uid).updateData(["movies": FieldValue.arrayUnion([updateMovie])])
                }
            } else {
                self.db.collection("users").document(uid).updateData(["movies": [updateMovie]])
            }
        }
    }
    
    
    func deleteFavorite(_ uid: String, completion: @escaping () -> Void) {
        let favorite = db.collection("users").document(uid).collection("favorites")
        db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let movies = document.data()!["movies"] as! [Int]
                var count = 0
                for movie in movies {
                    favorite.document(String(movie)).delete { error in
                        if let error = error {
                            print("Error deleting document: \(error)")
                        } else {
                            count += 1
                            if count == movies.count {
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteFavorite(_ uid: String) {
        deleteFavorite(uid) {
            self.deleteMovies(uid)
        }
    }
    
    func deleteMovies(_ uid: String) {
        db.collection("users").document(uid).updateData(["movies": []])
    }
    
}
