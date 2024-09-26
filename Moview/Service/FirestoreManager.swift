//
//  FirestoreManager.swift
//  Moview
//
//  Created by 심관혁 on 9/24/24.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

// TODO: - DB 데이터 생성 메서드 및 삭제 메서드, 유저 데이터 메서드, 게시판 기능
public final class FirestoreManager: ObservableObject {
    @Published var db: Firestore
    
    init() {
        self.db = Firestore.firestore()
    }
    
    func createUserData(_ userInfo: UserAuthInfo) {
        let displayName = String(userInfo.lastName ?? "") + String(userInfo.firstName ?? "")
        let data: [String: Any] = [
            "uid": userInfo.uid,
            "email": userInfo.email ?? "",
            "firstName": userInfo.firstName ?? "",
            "lastName": userInfo.lastName ?? "",
            "displayName": displayName
        ]
        db.collection("users").document(userInfo.uid).setData(data)
    }
    
    func updateUserData(_ uid: String, updateName: String) {
        db.collection("users").document(uid).updateData(["displayName": updateName])
    }
    
    func loadDisplayName(_ uid: String) -> (String, String) {
        var returnName: String = ""
        var returnEmail: String = ""
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            if error == nil && snapshot != nil && snapshot!.data() != nil {
                let data = snapshot!.data()!
                let displayName = data["displayName"]!
                let email = data["email"]!
//                returnName = displayName as! String
//                returnEmail = email as! String
            }
        }
        return (returnName, returnEmail)
    }
    
    func deleteUserData(_ uid: String) {
        db.collection("users").document(uid).delete()
    }
    
    // TODO: - Favorite DB 생성 및 수정, 삭제 메서드
    
    func createFavorite(_ data: [String: Any]) {
        db.collection("movies").addDocument(data: data)
    }
    
    func updateFavorite(_ id: String, _ data: [String: Any]) {
        db.collection("movies").document(id).updateData(data)
    }
    
    func deleteFavorite(_ id: String) {
        db.collection("movies").document(id).delete()
    }
    
    
}
