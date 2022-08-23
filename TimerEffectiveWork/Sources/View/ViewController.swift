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
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tintColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var timerDisplay: UITextView = {
        let timerDisplay = UITextView()
        timerDisplay.text = "00:00:\(timeToWork)"
        timerDisplay.textColor = .orange
        timerDisplay.backgroundColor = .black
        timerDisplay.font = UIFont.systemFont(ofSize: 50)
        timerDisplay.translatesAutoresizingMaskIntoConstraints = false
        return timerDisplay
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
        view.addSubview(button)
        view.addSubview(timerDisplay)
    }

    private func setupLayout() {
        button.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        timerDisplay.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.left.equalTo(view).offset(51)
            make.right.equalTo(view).inset(51)
            make.height.equalTo(80)
            make.top.equalTo(view).offset(180)
        }
    }

    var timeToWork = 25
    var timeToRest = 10
    var remaningTime = 25
    var timer: Timer!
    var isStarted: Bool = false
    var isWorkTime: Bool = true

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

