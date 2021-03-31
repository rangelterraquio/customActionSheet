//
//  ActionSheetCellProtocol.swift
//  CustomActionSheet
//
//  Created by Rangel Cardoso Dias on 27/03/21.
//

import UIKit

public protocol ActionSheetCellProtocol: UITableViewCell {
    associatedtype T
    
    static var cellHeight: CGFloat { get set }
    static var reuseIdentifier: String { get }

    func config(model: T?) -> Void
}

extension ActionSheetCellProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
