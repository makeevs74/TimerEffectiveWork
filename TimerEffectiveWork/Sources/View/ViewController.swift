//
//  ViewController.swift
//  TimerEffectiveWork
//
//  Created by Sergey Makeev on 23.08.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let timeToWork = 25
    let timeToRest = 10
    var remaningTime = 25
    var timer: Timer?
    var isStarted: Bool = false
    var isWorkTime: Bool = true
    var state: TimerStatus = .play

    let shapeLayer = CAShapeLayer()

    enum TimerStatus {
        case resume
        case pause
        case play
    }

    // MARK: - Outlets

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.setTitleColor(UIColor.systemYellow, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tintColor = .orange
        return button
    }()

    private lazy var timerDisplay: UILabel = {
        let timer = UILabel()
        timer.text = "00:00:\(remaningTime)"
        timer.textColor = .orange
        timer.backgroundColor = .black
        timer.textAlignment = .left
        timer.font = UIFont.systemFont(ofSize: 50)
        return timer
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        stack.alignment = .center
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
        view.addSubview(stack)
        stack.addArrangedSubview(timerDisplay)
        stack.addArrangedSubview(button)

        animationCircular(color: .orange)
    }

    private func setupLayout() {
        timerDisplay.snp.makeConstraints { make in
            make.width.equalTo(207)
        }

        stack.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }

    // MARK: - Actions

    @IBAction func fireTimer() {

        if remaningTime > 0 {
            remaningTime -= 1

        } else if remaningTime == 0 {
            timer?.invalidate()
            state = .play
            isStarted = false
            remaningTime = !isWorkTime ? timeToWork : timeToRest
            button.setImage(UIImage(systemName: "play.fill"), for: .normal)
            fireTimerLogic()
        }

        if remaningTime < 10 {
            timerDisplay.text = "00:00:0\(remaningTime)"
        } else {
            timerDisplay.text = "00:00:\(remaningTime)"
        }
    }

    func fireTimerLogic() {
        if isWorkTime {
            isWorkTime = false
            button.tintColor = .systemGreen
            timerDisplay.textColor = .systemGreen
            shapeLayer.strokeColor = UIColor.systemGreen.cgColor
            animationCircular(color: .systemGreen)
        } else {
            isWorkTime = true
            button.tintColor = .orange
            timerDisplay.textColor = .orange
            animationCircular(color: .orange)
        }
    }

    @objc private func buttonPressed() {
        switch state {
        case .play:
            if !isStarted {
                basicAnimation()
                timer = Timer.scheduledTimer(timeInterval: 1,
                                             target: self,
                                             selector: #selector(fireTimer),
                                             userInfo: nil,
                                             repeats: true)
            }
            isStarted = true
            state = .pause
            button.setImage(UIImage(systemName: "pause.fill"), for: .normal)

        case .pause:
            isStarted = false
            state = .resume
            pauseAnimation()
            button.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timer?.invalidate()
        case .resume:
            isStarted = true
            state = .pause
            resumeAnimation()
            button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(fireTimer),
                                         userInfo: nil,
                                         repeats: true)
        }
    }

    func animationCircular(color: UIColor) {
        let center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(arcCenter: center, radius: 138, startAngle: startAngle, endAngle: endAngle, clockwise: false)

        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 21
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = color.cgColor
        view.layer.addSublayer(shapeLayer)
    }

    func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(remaningTime)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }

    private func pauseAnimation() {
        let pauseTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0
        shapeLayer.timeOffset = pauseTime
        }

    private func resumeAnimation() {
        let pauseTime = shapeLayer.timeOffset
        shapeLayer.speed = 1
        shapeLayer.timeOffset = 0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        shapeLayer.beginTime = timeSincePause
    }
}

