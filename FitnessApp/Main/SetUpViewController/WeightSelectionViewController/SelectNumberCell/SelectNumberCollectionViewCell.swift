

import UIKit

class SelectNumberCollectionViewCell: UICollectionViewCell {
    
    private let customView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private var isSelectedCell: Bool = false

    struct Constants {
        static let heightDefault: CGFloat = 24
        static let heightSelected: CGFloat = 56
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCustomView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCustomView()
    }
    
    private func setupCustomView() {
        contentView.addSubview(customView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let newHeight: CGFloat = isSelectedCell
            ? Constants.heightSelected
            : Constants.heightDefault
        
        customView.frame = CGRect(
            x: (contentView.bounds.width - 4) / 2,
            y: (contentView.bounds.height - newHeight) / 2,
            width: 3,
            height: newHeight
        )
    }
    
    func configure(number: Int, isSelected: Bool) {
        self.isSelectedCell = isSelected
        setNeedsLayout()
    }
}
