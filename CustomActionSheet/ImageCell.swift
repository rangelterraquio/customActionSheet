//
//  ImageCell.swift
//  CustomActionSheet
//
//  Created by Rangel Cardoso Dias on 27/03/21.
//

import Foundation
import UIKit

public struct Tag: Hashable {
    
    public var title: String
    public var imageName: String
    public var color: UIColor
    
    public init(title: String, image: String, color: UIColor) {
        self.title = title
        self.imageName = image
        self.color = color
    }
}

class ImageCell: UITableViewCell, ActionSheetCellProtocol {
    
    static var reuseIdentifier: String { return String(describing: ImageCell.self) }
    static var cellHeight: CGFloat = 50
    
    typealias T = Tag
    
    private let label : UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        l.textColor = .black
        l.textAlignment = .center
        return l
    }()
    
    private let iconImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        contentView.addSubview(iconImage)
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImage.centerXAnchor.constraint(equalTo: centerXAnchor,constant: -30),
            iconImage.heightAnchor.constraint(equalToConstant: 30),
            iconImage.widthAnchor.constraint(equalToConstant: 30),
            iconImage.centerYAnchor.constraint(equalTo: centerYAnchor),

            label.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor,constant: 10),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            if selected {
                contentView.backgroundColor = .yellow
                label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            }else {
                contentView.backgroundColor = .white
                label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            }
    }
    
    func config(model: Tag?) {
        label.text = model?.title
        iconImage.image = UIImage(systemName: model?.imageName ?? "")
        iconImage.tintColor = model?.color
        
    }
}
