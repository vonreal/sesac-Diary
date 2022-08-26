//
//  UserDiaryRepository.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/26.
//

import Foundation

import RealmSwift

// 어떤 함수들이 있는지 한눈에 알아볼 수 있돠 (목차같은 너끰?)
protocol UserDiaryRepositoryType {
    func fetch() -> Results<UserDiary>
    func fetchSort(_ sort: String) -> Results<UserDiary>
    func fetchFilter() -> Results<UserDiary>
    func updateBookmark(item: UserDiary)
    func deleteImage(item: UserDiary)
}

class UserDiaryRepository: UserDiaryRepositoryType {
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
    
    func updateBookmark(item: UserDiary) {
        try! localRealm.write {
//                 하나의 레코드에서 특정 컬럼 하나만 변경
            item.bookMark = !item.bookMark  // item.bookmark.toggle() 동일한 코드
            
//                 하나의 테이블에 특정 컬럼 전체 값을 변경
//                self.tasks.setValue(true, forKey: "bookMark")
//                 하나의 레코드에서 여러 컬럼 값을 변경할 수 있다.
//                self.localRealm.create(UserDiary.self, value: ["objectId": self.tasks[indexPath.row].objectId, "content": "변경 테스트", "diaryTitle": "제목임"], update: .modified)
            
            print("Realm Update Succeed, reloadRows 필요")
        }
    }
    
    func deleteImage(item: UserDiary) {
        removeImageFromDocument(filename: "\(item.objectId).jpg")
        try! localRealm.write {
            localRealm.delete(item)
        }
    }
    
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // Document 경로
        let fileURL = documentDirectory.appendingPathComponent(filename)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("\(fileURL) 삭제 성공")
        } catch let error {
            print(error)
        }
    }
        
}
