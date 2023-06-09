//
//  BaseNavigationController.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/06/10.
//


import UIKit

class c: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarStyle()
    }
    
    private func setupNavigationBarStyle() {
        let mainColor = UIColor.label
        navigationBar.tintColor = mainColor
        navigationBar.prefersLargeTitles = true
        navigationBar.titleTextAttributes = [.foregroundColor: mainColor]
    }
}
