//
//  FilterCell.swift
//  CustomActionSheet
//
//  Created by Rangel Cardoso Dias on 27/03/21.
//

import UIKit



enum FilterType: String, CaseIterable {
    case mostRecently = "Most Recently"
    case mostOlder = "Most Older"
    case postivie = "Positive"
    case negative = "Negative"
}


class FilterCell: UITableViewCell, ActionSheetCellProtocol {
    
    static var reuseIdentifier: String { return String(describing: FilterCell.self) }
    static var cellHeight: CGFloat = 50
    
    typealias T = FilterType
    
    private let selectedSeparator: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    private let label : UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        l.textColor = .black
        l.textAlignment = .center
        return l
    }()
    
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selectedSeparator)
        selectedSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            selectedSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            selectedSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectedSeparator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        contentView.backgroundColor = .white
            if selected {
                label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            }else {
                label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            }
            selectedSeparator.isHidden = !selected
    }
    
    
    
    func config(model: FilterType?) {
        label.text = model?.rawValue
    }
}
