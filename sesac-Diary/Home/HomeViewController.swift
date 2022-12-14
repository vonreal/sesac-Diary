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

    let repository = UserDiaryRepository()
    
    let tableView: UITableView = {
        let view = UITableView()
        
        view.backgroundColor = .lightGray
        return view
    }()
    
    var tasks: Results<UserDiary>! {
        didSet {
            // 화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요!
            // present, overCurrentContext, overFullScreen > ViewWillAppear X
    //        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDay", ascending: false)
            tableView.reloadData()
            print("Tasks Changed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 데이터 가져오기
        fetchRealm()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        fetchDocumentZipFile()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRealm()
    }
    
    func fetchRealm() {
        // Realm3. Realm 데이터를 정렬해 tasks에 담기
        tasks = repository.fetch()
    }
    
    override func configure() {
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonClicked))
        let backupButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonClicked))
        navigationItem.leftBarButtonItems = [sortButton, filterButton, backupButton]
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func sortButtonClicked() {
        tasks = repository.fetchSort("registerDay")
    }
    
    // realm filter query,NSPredicate
    @objc func filterButtonClicked() {
        tasks = repository.fetchFilter()
    }
    
    @objc func plusButtonClicked() {
        let vc = WriteViewController()
        transition(vc, transitionStyle: .presentFullNavigation)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backupButtonClicked() {
        let sb = UIStoryboard(name: "example", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "exampleViewController") as! exampleViewController
        transition(vc, transitionStyle: .presentFullNavigation)
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
    
    // 참고. TableView Editing Mode
    
    // 테이블 뷰 셀 높이가 작을 경우, 이미지가 없을 때, 시스템 이미지가 아닌 경우
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            
            self.repository.updateBookmark(item: self.tasks[indexPath.row])
            // 1. 스와이프한 셀 하나만 ReloadRows 코드를 구현 -> 상대적 효율성
            // 2. 데이터가 변경됬으니 다시 realm에서 데이터를 가지고오기 => didset 일관적 형태로 갱신
            self.fetchRealm()
        }
        
        let image = tasks[indexPath.row].bookMark ? "heart.fill" : "heart"
        favorite.image = UIImage(systemName: image)
        favorite.backgroundColor = .systemPink
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete =  UIContextualAction(style: .normal, title: "삭제") { action, view, completionHandler in
            
            self.repository.deleteImage(item: self.tasks[indexPath.row])
            
            self.fetchRealm()
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

/*
 도큐먼트에 이미지 저장할 때 주의점, 삭제할 때 데이터만 삭제하는 것이 아니라 도큐먼트 파일까지도 삭제해줘야한다.
 */
