//
//  FileManager+Extension.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/24.
//

import UIKit

extension UIViewController {
    
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // Document 경로
        return documentDirectory
    }
    
    func loadImageFromDocument(filename: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent(filename)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "star.fill")
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
    
    func saveImageToDocument(filename: String, image: UIImage) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(filename) // 세부 경로. 이미지를 저장할 위치
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error", error)
        }
    }
    
    func fetchDocumentZipFile() {
        do {
            guard let path = documentDirectoryPath() else { return }
            
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            print("docs: ", docs)
            
            let zip = docs.filter { $0.pathExtension == "zip" }
            print("zip: ", zip)
            
            let result = zip.map { $0.lastPathComponent }
            print("result: ", result)
            
            
        } catch {
            print("ERROR")
        }
    }
}

/*
  1) 화면전환구조
  2) protocol 값 전달 + border
  3) ios fileSystem(FileManager)
 
 
  내일 할 일
  1) shopping + 사진
  2) 백업 / 복구 -> 백업/복구 버튼 하나 만들기, 테이블뷰도 하나 만들기
 */
