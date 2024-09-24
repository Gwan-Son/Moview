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
public final class FirestoreManager {
    let db = Firestore.firestore()
    
    func createUserData(_ data: [String: Any]) {
        db.collection("users").addDocument(data: data)
    }
    
    func deleteUserData(_ id: String) {
        db.collection("users").document(id).delete()
    }
    
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
