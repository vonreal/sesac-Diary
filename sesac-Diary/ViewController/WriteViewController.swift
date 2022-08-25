//
//  WriteViewController.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/20.
//

import UIKit

import Kingfisher
import RealmSwift // Realm1

protocol SelectImageDelegate {
    func sendImageData(image: UIImage)
}

class WriteViewController: DiaryBaseViewController {

    let mainView = WriteView()
    let localRealm = try! Realm() // Realm2. Realm 태이블에 데이터를 CRUD할 떄, Realm 테이블 경로에 접근
    var photoURL = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(getImage(notification:)), name: Notification.Name("imageSend"), object: nil)
        
        mainView.searchImageButton.addTarget(self, action: #selector(searchImageButtonClicked(_:)), for: .touchUpInside)
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancleButtonClicked))
    }
    
    @objc func cancleButtonClicked() {
        self.dismiss(animated: true)
    }
    
    // Realm + 이미지 도큐먼트 저장
    @objc func saveButtonClicked() {
        
        guard let title = mainView.titleTextField.text else {
            print("제목을 입력해주세요.") //showAlertMessage(title: "제목을 입력해주세요", button: "확인")
            return
        }
        
        let task = UserDiary(diaryTitle: title, content: mainView.contentTextView.text!, writeDay: Date(), registerDay: Date(), bookMark: false, photoURL: photoURL) // => record adding
        
        do {
            try localRealm.write {
                localRealm.add(task)
            }
        } catch let error {
            print(error)
        }
        
        if let image = mainView.searchImageView.image {
            saveImageToDocument(filename: "\(task.objectId)", image: image)
        }

//        try! localRealm.write {
//            localRealm.add(task) //create
//            print("Saved Success")
//            dismiss(animated: true)
//        }
        dismiss(animated: true)
    }
    

    
    
    @objc func getImage(notification: NSNotification) {
        if let url = notification.userInfo?["url"] as? String {
            photoURL = url
            mainView.searchImageView.kf.setImage(with: URL(string: url))
        }
    }
    
    @objc func searchImageButtonClicked(_ searchButton: UIButton) {
        let vc = SearchImageViewController()
//        navigationController?.pushViewController(vc, animated: true)
        vc.delegate = self
        transition(vc, transitionStyle: .presentFullNavigation)
    }
}

extension WriteViewController: SelectImageDelegate {
    func sendImageData(image: UIImage) {
        mainView.searchImageView.image = image
        print(#function)
    }
}

/*
 -> delegate pattern 생각하기
    [다른 파일끼리 연결하기]
    1. 프로토콜을 만들고
    2. 전달 받을 곳에서 프로토콜을 채택하고
    3. 전달 할 곳에서 delegate 속성에 1번 프로토콜을 연결시켜준다.
    [값 전달하기]
    4. 전달 할 곳에서 delegate.func()을 통해 원하는 값을 전달하고
    5. 전달 받을 곳에서는 extension으로 해당 함수를 통해 받은 값을 적용해준다.
 */
