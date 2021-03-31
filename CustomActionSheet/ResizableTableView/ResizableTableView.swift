//
//  ResizableTableView.swift
//  CustomActionSheet
//
//  Created by Rangel Cardoso Dias on 27/03/21.
//
import UIKit

/// A view that adjusts his size based on content
public class ResizableTableView: UITableView {
    public override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    public override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }

    public override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
