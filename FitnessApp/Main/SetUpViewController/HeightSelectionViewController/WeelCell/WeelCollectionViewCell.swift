//
//  WeelCollectionViewCell.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 14/3/25.
//

import UIKit

class WeelCollectionViewCell: UICollectionViewCell {
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(lineView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(lineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineView.center = contentView.center
    }
    
    func configure(numbers: Int,isSelected: Bool) {
        lineView.backgroundColor = isSelected ? .white : UIColor.white.withAlphaComponent(0.6)
        let lineWidth = isSelected ? contentView.bounds.width * 0.6 : contentView.bounds.width * 0.3
        lineView.frame = CGRect(
            x: (contentView.bounds.width - lineWidth) / 2,
            y: (contentView.bounds.height - 2) / 2,
            width: lineWidth,
            height: 2
        )
    }
}
