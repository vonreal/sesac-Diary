//
//  SearchImageViewController.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/20.
//

import UIKit

import Alamofire
import Kingfisher
import SnapKit
import SwiftyJSON

class SearchImageViewController: DiaryBaseViewController {

    let searchImageList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 4
        let width = UIScreen.main.bounds.width - (spacing * 2)
        
        layout.itemSize = CGSize(width: width / 3, height: width / 3)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    
    let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    let searchBar = UISearchBar()
    
    var photos: [String] = []
    var index = 1
    var total = 0
    var search = ""
    var choose = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationUI()
        searchBarUI()
        collectionViewUI()
    }
    
    func navigationUI() {
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(chooseClicked))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
    }

    @objc func chooseClicked() {
        NotificationCenter.default.post(name: Notification.Name("imageSend"), object: nil, userInfo: ["url": photos[choose]])
        navigationController?.popViewController(animated: true)
    }
    
    func searchBarUI() {
        searchBar.delegate = self
        searchBar.placeholder = "검색할 키워드를 입력하세요."
        
        self.view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(0)
        }
        
    }
    func collectionViewUI() {
        self.view.addSubview(searchImageList)
        searchImageList.delegate = self
        searchImageList.dataSource = self
        searchImageList.register(SearchImageView.self, forCellWithReuseIdentifier: "cell2")
        
        searchImageList.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    func requestUnsplashAPI() {
        photos.removeAll()
        let url = EndPoint.unsplash + "?page=\(index)&query=\(search)&client_id=\(APIKey.unsplashAccessKey)"
        
        AF.request(url, method: .get)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let jsonArray = json["results"].arrayValue
                    self.total = json["total"].intValue
                    for json in jsonArray {
                        let thumbURL = json["urls"]["thumb"].stringValue
                        
                        self.photos.append(thumbURL)
                    }
                    self.searchImageList.reloadData()

                case .failure(let error):
                    print(error)
                    break
                }
            }
    }
    
    @objc func closeButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}

//extension SearchImageViewController: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            if indexPath.item == photos.count - 1, index < total{
//                index += 1
//                requestUnsplashAPI()
//            } else {
//                index = 0
//            }
//        }
//    }
//}

extension SearchImageViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let text = searchBar.text {
            self.search = text.trimmingCharacters(in: CharacterSet.whitespaces)
            requestUnsplashAPI()
        }
    }
}

extension SearchImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchImageView.identifier, for: indexPath) as? SearchImageView else { return UICollectionViewCell() }
        cell.imageView.kf.setImage(with: URL(string: photos[indexPath.item]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        choose = indexPath.item
    }
}
