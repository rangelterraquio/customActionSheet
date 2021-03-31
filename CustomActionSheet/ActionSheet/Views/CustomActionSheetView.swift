//
//  CustomActionSheet.swift
//  CustomActionSheet
//
//  Created by Rangel Cardoso Dias on 27/03/21.
//
import UIKit

typealias ActionSheetDataSource = UITableViewDelegate & UITableViewDataSource

public class CustomActionSheetView<Cell: ActionSheetCellProtocol>: UIView {
    
    //MARK: - Views
    private let tableView: ResizableTableView = {
        let tableView = ResizableTableView(frame: .zero)
        tableView.rowHeight = Cell.cellHeight
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.isUserInteractionEnabled = true
        tableView.allowsMultipleSelection = false
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        lbl.textColor = settings.header.textColor
        lbl.text = settings.header.title
        lbl.font = settings.header.font
        return lbl
    }()
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(settings.cancelButton.title, for: .normal)
        btn.titleLabel?.font = settings.cancelButton.font
        btn.setTitleColor(settings.cancelButton.textColor, for: .normal)
        btn.backgroundColor = settings.cancelButton.backGorundColor
        return btn
    }()
    
    private lazy var confirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(settings.confirmButton.title, for: .normal)
        btn.titleLabel?.font = settings.confirmButton.font
        btn.setTitleColor(settings.confirmButton.textColor, for: .normal)
        btn.backgroundColor = settings.confirmButton.backGorundColor
        return btn
    }()
    
    private let headerView = UIView()
    
    private lazy var topConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0)

    public override var intrinsicContentSize: CGSize {
        let contentHeight: CGFloat = Cell.cellHeight * numberOfCells + settings.header.headerHeight + bottomPadding
        return CGSize(width: UIScreen.main.bounds.width, height: contentHeight)
    }
    
    public override func didMoveToSuperview() {
        if let superView = superview {
            topConstraint.isActive = true
            superView.setNeedsLayout()
            superView.layoutIfNeeded()
        }
    }
    
    private var isShowing: Bool = false
    
    public var didTapConfirmButton: (() -> Void)?
    public var didTapCancelButton: (() -> Void)?
    
    weak var dataSource: ActionSheetDataSource? {
        didSet {
            tableView.delegate = dataSource
            tableView.dataSource = dataSource
        }
    }
    
    public var numberOfCells: CGFloat = 0
    private let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    
    private let settings: CustomActionSheetSettings
    
    public init(settings: CustomActionSheetSettings) {
        self.settings = settings
        let frame: CGRect = .init(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height+50), size: CGSize(width: UIScreen.main.bounds.width, height: 50))
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cancelActionSheet() {
        hide { [weak self] (_) in
            self?.didTapCancelButton?()
        }
    }
    
    @objc private func confirmActionSheet() {
        hide { [weak self] (_) in
            self?.didTapConfirmButton?()
        }
    }
}

//MARK: - View Coding
extension CustomActionSheetView: ViewCoding {
    
    public func buildViewHierarchy() {
        addSubview(headerView)
        headerView.addSubview(cancelButton)
        headerView.addSubview(titleLabel)
        headerView.addSubview(confirmButton)
        addSubview(tableView)
    }
    
    public func setupConstraints() {
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: settings.header.headerHeight),
            
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            cancelButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,constant: 16),
            
            confirmButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant: -16),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding)
        ])
    }
    
    public func setupAdditionalConfiguration() {
        invalidateIntrinsicContentSize()
        backgroundColor = .white
        headerView.backgroundColor = settings.header.backgroundColor
        headerView.isHidden = settings.header.isHidden
        
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: settings.tableViewStyle.lateralMargin, bottom: 0, right: settings.tableViewStyle.lateralMargin)
        
        cancelButton.addTarget(self, action: #selector(cancelActionSheet), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmActionSheet), for: .touchUpInside)
    }
}

extension CustomActionSheetView {
    
    public func show(completion: ((Bool)->())? = nil ) {
        
        guard !isShowing else { return }
        
        tableView.reloadData()
        invalidateIntrinsicContentSize()
        
        setNeedsLayout()
        layoutIfNeeded()
        
        tableView.isScrollEnabled = Int(settings.tableViewStyle.maximumHeight) == Int(frame.height)
        alpha = 0
        
        topConstraint.constant = -frame.height
        UIView.animate(withDuration: settings.animation.present.duration,
                       delay: settings.animation.present.delay,
                       options: settings.animation.present.options,
                       animations: {
                        self.alpha = 1
                        self.superview?.setNeedsLayout()
                        self.superview?.layoutIfNeeded()
                       },
                       completion: { finished in
                        self.isShowing = true
                        completion?(finished)
                       })
    }
    
    public func hide(completion: ((Bool)->())? = nil ){
        
        topConstraint.constant = 0
        UIView.animate(withDuration: settings.animation.dismiss.duration,
                       delay: settings.animation.dismiss.delay,
                       options: settings.animation.dismiss.options,
                       animations: {
                        self.alpha = 0
                        self.superview?.setNeedsLayout()
                        self.superview?.layoutIfNeeded()
                       },
                       completion: { finished in
                        self.isShowing = false
                        completion?(finished)
                       })
    }
}




