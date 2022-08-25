//
//  HomeTableViewCell.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/24.
//

import UIKit

class HomeTableViewCell: DiaryBaseView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let photoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    
    override func configureUI() {
        [titleLabel, dateLabel, contentLabel, photoImageView].forEach { self.addSubview($0) }
    }
    
    override func constraintsUI() {
    }
}
