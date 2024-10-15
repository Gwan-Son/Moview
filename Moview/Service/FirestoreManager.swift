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
    let movies: [UserMovieModel]
    
    init(id: String? = nil, displayName: String, email: String, movies: [UserMovieModel] = []) {
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
        db.collection("users").document(uid).delete()
    }
    
    // 파이어스토어에 데이터 저장할 때 오류 발생 -> 문제점: 컬렉션 내에 필드를 생성하여 만들어야하는데 swift 내에서 별도의 struct를 생성하여 데이터타입 불일치.
    func updateFavorite(_ uid: String, id: Int, title: String, poster_path: String, vote_average: Double) {
        let movie = UserMovieModel(id: id, title: title, poster_path: poster_path, vote_average: vote_average)
        
        let data = db.collection("users").document(uid)
        
        data.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!["movies"] as! [UserMovieModel]
                if dataDescription.contains(where: { $0.id == id }) {
                    self.db.collection("users").document(uid).updateData(["movies": FieldValue.arrayRemove([movie])])
                } else {
                    self.db.collection("users").document(uid).updateData(["movies": FieldValue.arrayUnion([movie])])
                }
            } else {
                self.db.collection("users").document(uid).updateData(["movies": [movie]])
            }
        }
    }
    
//    func updateFavorite(_ uid: String, updateMovie: Int) {
//        let data = db.collection("users").document(uid)
//        
//        data.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data()!["movies"] as! [Int]
//                if dataDescription.contains(updateMovie) {
//                    self.db.collection("users").document(uid).updateData(["movies": FieldValue.arrayRemove([updateMovie])])
//                } else {
//                    self.db.collection("users").document(uid).updateData(["movies": FieldValue.arrayUnion([updateMovie])])
//                }
//            } else {
//                self.db.collection("users").document(uid).updateData(["movies": [updateMovie]])
//            }
//        }
//    }
    
    
    func deleteFavorite(_ uid: String) {
        db.collection("users").document(uid).updateData(["movies": []])
    }
    
    
}
