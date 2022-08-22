//
//  WriteViewController.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/20.
//

import UIKit

import Kingfisher
import RealmSwift // Realm1

class WriteViewController: DiaryBaseViewController {

    let mainView = WriteView()
    let localRealm = try! Realm() // Realm2. Realm 태이블에 데이터를 CRUD할 떄, Realm 테이블 경로에 접근
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(getImage(notification:)), name: Notification.Name("imageSend"), object: nil)
        
        mainView.searchImageButton.addTarget(self, action: #selector(searchImageButtonClicked(_:)), for: .touchUpInside)
        
        mainView.sampleButton.addTarget(self, action: #selector(sampleButtonClicked), for: .touchUpInside)
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    // Realm Create Sample
    @objc func sampleButtonClicked() {
        let task = UserDiary(diaryTitle: "오늘의 일기\(Int.random(in: 1...1000))", content: "일기 테스트 내용", writeDay: Date(), registerDay: Date(), bookMark: false, photoURL: nil) // => record adding
        try! localRealm.write {
            localRealm.add(task) //create
            print("Saved Success")
            dismiss(animated: true)
        }

    }
    
    @objc func getImage(notification: NSNotification) {
        if let url = notification.userInfo?["url"] as? String {
            mainView.searchImageView.kf.setImage(with: URL(string: url))
        }
    }
    
    @objc func searchImageButtonClicked(_ searchButton: UIButton) {
        let vc = SearchImageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
