//
//  SearchAllTableViewCell.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 29/3/25.
//

import UIKit

protocol SearchAllTableViewCellDelegate: AnyObject {
    func didTapFavorite(in cell: SearchAllTableViewCell)
}

class SearchAllTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var kcalLabel: UILabel!
    @IBOutlet private weak var titleImage: UIImageView!
    @IBOutlet private weak var favoriteImage: UIImageView!
    
    weak var delegate: SearchAllTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        favoriteImage.image = UIImage(resource: .starOff)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 17, right: 0))
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        self.delegate?.didTapFavorite(in: self)
    }
    
    func configure(model: IndexFitness) {
        titleLabel.text = model.title
        timeLabel.text = model.time
        kcalLabel.text = model.kcal
        titleImage.loadImage(from: model.avatar)
        setFavorite(isFavorite: model.isFavorite)
    }
    
    func setFavorite(isFavorite: Bool) {
        favoriteImage.image = isFavorite ? UIImage(resource: .starOn) : UIImage(resource: .starOff)
    }
}
