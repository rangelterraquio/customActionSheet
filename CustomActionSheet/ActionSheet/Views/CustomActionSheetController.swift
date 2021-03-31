//
//  CustomActionSheetController.swift
//  CustomActionSheet
//
//  Created by Rangel Cardoso Dias on 27/03/21.
//

import UIKit

class CustomActionSheetController<Element ,Cell>:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UIViewControllerTransitioningDelegate,
    UIViewControllerAnimatedTransitioning
    where Cell: ActionSheetCellProtocol, Element == Cell.T {

    //MARK: - Views
    public var actionSheetView: CustomActionSheetView<Cell>!
    
    public lazy var backblurView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()
    
    //MARK: - Views
    private var isPresenting: Bool = false
    
    private var data: [Element] {
        didSet {
            actionSheetView.numberOfCells = CGFloat(data.count)
        }
    }
    
    private var selectedItem: Element?
    
    public var didSelectItem: ((Element?) -> Void)?
    public var didCancel: (() -> Void)?
    
    public var settings: CustomActionSheetSettings
    
    public init(data: [Element], settings: CustomActionSheetSettings = .defaultSettings()) {
        self.data = data
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.view === backblurView {
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - UITableView Delegate & DataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier) as? Cell {
            cell.config(model: data[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = data[indexPath.row]
    }
    
    //MARK: - Custom Transition Delegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        
        isPresenting = !isPresenting
        
        if isPresenting {
            containerView.addSubview(toVC.view)
            actionSheetView.show { (finished) in
                transitionContext.completeTransition(finished)
            }
        } else {
            actionSheetView.hide {(finished) in
                transitionContext.completeTransition(finished)
            }
        }
    }
}

//MARK: - View Coding
extension CustomActionSheetController: ViewCoding {
    
    public func buildViewHierarchy() {
        actionSheetView = CustomActionSheetView<Cell>(settings: settings)
        
        view.addSubview(backblurView)
        view.addSubview(actionSheetView)
    }
    
    func setupConstraints() {
        actionSheetView.translatesAutoresizingMaskIntoConstraints = false
        actionSheetView.heightAnchor.constraint(lessThanOrEqualToConstant: settings.tableViewStyle.maximumHeight).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        backblurView.addGestureRecognizer(tapGesture)
        
        actionSheetView.dataSource = self
        actionSheetView.numberOfCells = CGFloat(data.count)

        actionSheetView.didTapConfirmButton = { [weak self] in
            guard let self = self else { return }
            self.didSelectItem?(self.selectedItem)
            self.dismiss(animated: true, completion: nil)
        }
        
        actionSheetView.didTapCancelButton = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
