//
//  SearchAllCollectionViewCell.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 30/3/25.
//

import UIKit

protocol SearchAllCollectionViewCellDelegate: AnyObject {
    func didTapFavorite(cell: SearchAllCollectionViewCell)
}

class SearchAllCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleHeaderImage: UIImageView!
    @IBOutlet private weak var favoriteImage: UIImageView!
    @IBOutlet private weak var exerciseTitleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var kcalLabel: UILabel!
    
    weak var delegate: SearchAllCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        self.delegate?.didTapFavorite(cell: self)
    }
    
    func configure(model: IndexFitness) {
        titleHeaderImage.loadImage(from: model.titleHeaderImage)
        exerciseTitleLabel.text = model.titleHeader
        timeLabel.text = model.time
        kcalLabel.text = model.kcal
        setFavorite(isFavorite: model.isFavoriteHeader)
    }
    
    func setFavorite(isFavorite: Bool) {
        favoriteImage.image = isFavorite ? UIImage(resource: .starOn) : UIImage(resource: .starOff)
    }

}
