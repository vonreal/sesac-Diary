//
//  WriteViewController.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/20.
//

import UIKit

import Kingfisher

class WriteViewController: DiaryBaseViewController {

    let mainView = WriteView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(getImage(notification:)), name: Notification.Name("imageSend"), object: nil)
        
        mainView.searchImageButton.addTarget(self, action: #selector(searchImageButtonClicked(_:)), for: .touchUpInside)
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
