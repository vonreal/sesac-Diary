//
//  UserDiaryRepository.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/26.
//

import Foundation

import RealmSwift

class UserDiaryRepository {
    let localRealm = try! Realm()
    
    func fetch() -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: false)
    }
    
    func fetchSort(_ sort: String) -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: sort, ascending: false)
    }
    
    func fetchFilter() -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS '4'")
    }
        
} 
