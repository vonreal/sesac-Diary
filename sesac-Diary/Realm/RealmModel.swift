//
//  RealmModel.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/22.
//

import Foundation

import RealmSwift

// UserDiary: Table name
// @Persisted: Column
class UserDiary: Object {
    @Persisted var diaryTitle: String
    @Persisted var content: String?
    @Persisted var writeDay: Date
    @Persisted var registerDay: Date
    @Persisted var bookMark: Bool
    @Persisted var photoURL: String?
    
    // PK(필수): uuid, objectid, int
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(diaryTitle: String, content: String?, writeDay: Date, registerDay: Date, bookMark: Bool, photoURL: String?) {
        self.init()
        self.diaryTitle = diaryTitle
        self.content = content
        self.writeDay = writeDay
        self.registerDay = registerDay
        self.bookMark = bookMark
        self.photoURL = photoURL
    }
}

