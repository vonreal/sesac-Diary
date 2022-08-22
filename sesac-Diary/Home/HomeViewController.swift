//
//  HomeViewController.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/22.
//

import UIKit

import SnapKit
import RealmSwift

class HomeViewController: DiaryBaseViewController {

    let localRealm = try! Realm()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    var tasks: Results<UserDiary>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 데이터 가져오기
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDay", ascending: false)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
        // 화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요!
        // present, overCurrentContext, overFullScreen > ViewWillAppear X
//        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDay", ascending: false)
        tableView.reloadData()
    }
    
    @objc func plusButtonClicked() {
        let vc = WriteViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = tasks[indexPath.row].diaryTitle
        return cell
    }
}
