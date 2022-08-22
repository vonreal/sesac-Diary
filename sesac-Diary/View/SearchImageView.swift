//
//  SearchImageView.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/20.
//

import UIKit

class SearchImageView: UICollectionViewCell {
    static let identifier = "cell2"
    
    let imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.backgroundColor = .lightGray
        img.sizeToFit()
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
