//
//  WriteView.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/20.
//

import UIKit

import SnapKit

class WriteView: DiaryBaseView {
    
    let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let searchImageButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        config.baseForegroundColor = .black
        config.preferredSymbolConfigurationForImage = imageConfig
        config.image = UIImage(systemName: "magnifyingglass.circle.fill")
        return UIButton(configuration: config)
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력하세요"
        textField.textAlignment = .center
        return textField
    }()
    
    let dateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "날짜를 입력하세요"
        textField.textAlignment = .center
        return textField
    }()

    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func configureUI() {
        [searchImageView, searchImageButton, titleTextField, dateTextField, contentTextView].forEach { self.addSubview($0) }
        self.backgroundColor = .white
    }
    
    override func constraintsUI() {
        searchImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(UIScreen.main.bounds.height / 4)
        }
        
        searchImageButton.snp.makeConstraints { make in
            make.trailing.equalTo(searchImageView).inset(10)
            make.bottom.equalTo(searchImageView).inset(20)
        }

        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(searchImageView.snp.bottom).offset(40)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)

        }

        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(40)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)

        }

        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(40)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
