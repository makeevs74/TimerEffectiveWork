//
//  ViewController.swift
//  TimerEffectiveWork
//
//  Created by Sergey Makeev on 23.08.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var timeToWork = 25
    var timeToRest = 10
    var remaningTime = 25
    var timer: Timer!
    var isStarted: Bool = false
    var isWorkTime: Bool = true

    // MARK: - Outlets

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.setTitleColor(UIColor.systemYellow, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tintColor = .orange

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var timerDisplay: UITextView = {
        let timerDisplay = UITextView()
        timerDisplay.text = "00:00:\(timeToWork)"
        timerDisplay.textColor = .orange
        timerDisplay.backgroundColor = .red
        timerDisplay.textAlignment = .center
        timerDisplay.font = UIFont.systemFont(ofSize: 50)
        timerDisplay.translatesAutoresizingMaskIntoConstraints = false
        return timerDisplay
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Hierarchy and Setup

    private func setupHierarchy() {
//        view.addSubview(button)
//        view.addSubview(timerDisplay)
        view.addSubview(stack)
        stack.addArrangedSubview(button)
        stack.addArrangedSubview(timerDisplay)
    }

    private func setupLayout() {
//        button.snp.makeConstraints { make in
//            make.center.equalTo(view)
//            make.width.equalTo(30)
//            make.height.equalTo(30)
//        }
//
//        timerDisplay.snp.makeConstraints { make in
//            make.centerX.equalTo(view)
//            make.left.equalTo(view).offset(51)
//            make.bottom.equalTo(button.snp.top).offset(-10)
//            make.height.equalTo(60)
//        }

        stack.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.size.height.equalTo(100)
            make.size.width.equalTo(270)
        }
    }

    // MARK: - Actions

    @IBAction func fireTimer() {
        if remaningTime > 0 {
            remaningTime -= 1
        } else if isWorkTime {
            remaningTime = timeToRest
            isWorkTime = false
            button.tintColor = .systemGreen
            timerDisplay.textColor = .systemGreen
        } else if !isWorkTime {
            remaningTime = timeToWork
            isWorkTime = true
            button.tintColor = .orange
            timerDisplay.textColor = .orange
        }
        if remaningTime < 10 {
            timerDisplay.text = "00:00:0\(remaningTime)"
        } else {
            timerDisplay.text = "00:00:\(remaningTime)"
        }
    }

    @objc private func buttonPressed() {
        if !isStarted {
            isStarted = true
            button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(fireTimer),
                                         userInfo: nil,
                                         repeats: true)
        } else if isStarted {
            isStarted = false
            button.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timer.invalidate()
        }
    }
}

