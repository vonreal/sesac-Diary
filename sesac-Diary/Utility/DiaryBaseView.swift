//
//  DiaryBaseView.swift
//  sesac-Diary
//
//  Created by 나지운 on 2022/08/20.
//

import UIKit

class DiaryBaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        constraintsUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {}
    func constraintsUI() {}
}
