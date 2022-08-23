//
//  ViewController.swift
//  TimerEffectiveWork
//
//  Created by Sergey Makeev on 23.08.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - Outlets

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.setTitleColor(UIColor.systemYellow, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Hierarchy and Setup

    private func setupHierarchy() {
        view.addSubview(button)
    }

    private func setupLayout() {
        button.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
    }
}

