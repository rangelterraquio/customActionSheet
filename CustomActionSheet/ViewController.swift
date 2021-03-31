//
//  ViewController.swift
//  CustomActionSheet
//
//  Created by Rangel Cardoso Dias on 27/03/21.
//

import UIKit

class ViewController: UIViewController {
    
    private let open1: UIButton = {
        let btn = UIButton()
        btn.setTitle("Open 1", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(red: 118/255, green: 215/255, blue: 247/255, alpha: 1.0)
        return btn
    }()

    private let open2: UIButton = {
        let btn = UIButton()
        btn.setTitle("Open 2", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .orange
        return btn
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment  = .fill
        stack.distribution = .fill
        stack.spacing = 20
        stack.axis = .vertical
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(vStack)
        
        vStack.addArrangedSubview(open1)
        vStack.addArrangedSubview(open2)
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        open1.translatesAutoresizingMaskIntoConstraints = false
        open2.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            open1.heightAnchor.constraint(equalToConstant: 30),
            open1.widthAnchor.constraint(equalToConstant: 150),
            
            open2.heightAnchor.constraint(equalToConstant: 30),
            open2.widthAnchor.constraint(equalToConstant: 150),
            
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
       
        open1.addTarget(self, action: #selector(didTapOpen1), for: .touchUpInside)
        open2.addTarget(self, action: #selector(didTapOpen2), for: .touchUpInside)
    }


    @objc private func didTapOpen1(){
        
        var setting = CustomActionSheetSettings()
        
        setting.header.backgroundColor = UIColor(red: 118/255, green: 215/255, blue: 247/255, alpha: 1.0)
        
        let actionSheet = CustomActionSheetController<FilterType, FilterCell>(data: FilterType.allCases, settings: setting)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func didTapOpen2(){
        
        var setting = CustomActionSheetSettings.defaultSettings()
       
        setting.header.backgroundColor = .orange
        setting.header.title = "Select a Tag"
        setting.confirmButton.title = "Confirm"

        setting.animation.present.options = .curveLinear
        setting.animation.dismiss.options = .curveLinear
        
        let tags: [Tag] = [Tag(title: "Star", image: "star.fill", color: .orange), Tag(title: "Heart", image: "heart.fill", color: .red), Tag(title: "Cloud", image: "cloud.fill", color: .blue), Tag(title: "Star", image: "moon.stars.fill", color:  .darkGray)]
        
        let actionSheet = CustomActionSheetController<Tag, ImageCell>(data: tags, settings: setting)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    
}

