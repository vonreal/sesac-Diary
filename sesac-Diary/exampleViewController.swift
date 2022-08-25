//
//  exampleViewController.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/25.
//

import UIKit

import RealmSwift
import Zip

// storyboard -> codebase로 구현
class exampleViewController: DiaryBaseViewController {

    let realm = try! Realm()
    
    @IBOutlet weak var backupButton: UIButton!
    @IBOutlet weak var resotreButton: UIButton!
    @IBOutlet weak var backUpList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backUpList.delegate = self
        backUpList.dataSource = self
        
        // realm 저장된 경로
        let folderPath = realm.configuration.fileURL!
        print("realm 저장: \(folderPath)")
    }
    
    @IBAction func backupButtonClicked(_ sender: UIButton) {
        
        var urlPaths = [URL]()
        
        // [1. Document 위치에 백업 파일 확인]
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "Document 위치에 문제가 있습니다.")
            return
        }
        
        //  1-2. path = Document 위치, RealmFile을 가져오기
        let realmFile = path.appendingPathComponent("default.realm")
        
        //  1-3. realmFile이 없을 수도 있음 따라서 유효성을 판단하기
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlertMessage(title: "백업할 파일이 존재하지 않습니다.")
            return
        }
        
        urlPaths.append(URL(string: realmFile.path)!)
        
        // [2. 백업 파일이 있다면 파일 압축: URL]
        // memo. 압축하는 오픈소스를 활용하자. 'swift zip github' https://github.com/marmelroy/Zip
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "SeSACDiary_1")
            print("Archive Location: \(zipFilePath)")
            
            // 3. 압축이 완료될 경우 Activity View Controller 띄우기
            showActivityViewController()
            
        } catch {
            showAlertMessage(title: "압축을 실패했습니다.")
        }
    }
    
    func showActivityViewController() {
        guard let path = documentDirectoryPath() else { // 중복되는 코드 [개선 가능]
            showAlertMessage(title: "Document 위치에 문제가 있습니다.")
            return
        }
        
        let backupFileURL = path.appendingPathComponent("SeSACDiary_1.zip")
        
        // activityItems에 백업한 파일이 존재하는 url을 전달해야 한다.
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        self.present(vc, animated: true)
    }
    
    
    @IBAction func restoreButtonClicked(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
    }
    
}

extension exampleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension exampleViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            showAlertMessage(title: "선택하신 파일에 오류가 있습니다.")
            return
        }
        // print("selectedFileURL :", selectedFileURL)
        // file:///Users/najiun/Library/Developer/CoreSimulator/Devices/6C7071ED-92B6-4C83-AC50-51D509961806/data/Containers/Data/Application/CFA250D8-9CA8-4DC3-9CF5-D969472B1E14/tmp/com.vonreal.sesac-Diary-Inbox/SeSACDiary_1.zip
        
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "Document 위치에 오류가 있습니다.")
            return
        }
        // print("path : ", path)
        // file:///Users/najiun/Library/Developer/CoreSimulator/Devices/6C7071ED-92B6-4C83-AC50-51D509961806/data/Containers/Data/Application/CFA250D8-9CA8-4DC3-9CF5-D969472B1E14/Documents/
        
        // 도큐먼트 url과 선택한 url의 마지막을 합치는 것
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        // print("sandboxFileURL : ", sandboxFileURL)
        // file:///Users/najiun/Library/Developer/CoreSimulator/Devices/6C7071ED-92B6-4C83-AC50-51D509961806/data/Containers/Data/Application/CFA250D8-9CA8-4DC3-9CF5-D969472B1E14/Documents/SeSACDiary_1.zip
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            let fileURL = path.appendingPathComponent("SeSACDiary_1.zip")
            
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
//                    self.changeRootView(HomeViewController().self)

                })
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
        } else {
            do {
                // 파일 앱의 zip -> 도큐먼트 폴더에 복사
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("SeSACDiary_1.zip")
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
//                    self.changeRootView(HomeViewController().self)
                })
                
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
        }
    }
}
