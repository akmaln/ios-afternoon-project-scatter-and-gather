//
//  ViewController.swift
//  ScatterAndGather
//
//  Created by Akmal Nurmatov on 5/12/20.
//  Copyright © 2020 Akmal Nurmatov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var isScattered: Bool = false {
        didSet {
            if isScattered {
                performScatterAnimation()
            } else {
                performGatherAnimation()
            }
        }
    }
    
    let letterLLabel = UILabel()
    let letterALabel = UILabel()
    let letterMLabel = UILabel()
    let letterBLabel = UILabel()
    let letterDLabel = UILabel()
    let letterA2Label = UILabel()
    var lambdaLogoView = UIImageView(image: UIImage(named: "lambda_logo"))
    
    var lambdaLabels: [UILabel] {
        [letterLLabel,letterALabel,letterMLabel,letterBLabel,letterDLabel,letterA2Label]
    }
    
    @IBAction func toggleButtonPressed(_ sender: Any) {
        isScattered.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
    }
    
    private func configureLabels() {
        letterLLabel.text = "L"
        letterALabel.text = "A"
        letterMLabel.text = "M"
        letterBLabel.text = "B"
        letterDLabel.text = "D"
        letterA2Label.text = "A"
        
        
        lambdaLabels.forEach {
            $0.font = .systemFont(ofSize: 50)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let stackView = UIStackView(arrangedSubviews: lambdaLabels)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        
        lambdaLogoView.contentMode = .scaleAspectFit
        lambdaLogoView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        lambdaLogoView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(lambdaLogoView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NSLayoutConstraint(
                item: stackView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: view,
                attribute: .centerY,
                multiplier: 0.5,
                constant: 0
            ),
    
            lambdaLogoView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            lambdaLogoView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            lambdaLogoView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            lambdaLogoView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])
    }
    
    private func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    private func randomMove(for label: UILabel) -> CGAffineTransform {
        let minX = -label.frame.origin.x + self.view.safeAreaInsets.left
        let maxX = self.view.frame.width - (label.frame.origin.x + label.frame.width + self.view.safeAreaInsets.right)
        let x = (CGFloat.random(in: minX...maxX))
        let minY = -label.frame.origin.y + self.view.safeAreaInsets.top
        let maxY = self.view.frame.height - (label.frame.origin.y + label.frame.height + self.view.safeAreaInsets.bottom)
        let y = (CGFloat.random(in: minY...maxY))
        
        return CGAffineTransform(translationX: x, y: y).rotated(by: CGFloat.random(in: -2 * CGFloat.pi...2 * CGFloat.pi))
    }
    
    func performScatterAnimation() {
        let animationBlock = {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.42) {
                    self.lambdaLogoView.alpha = 0
                    for label in self.lambdaLabels {
                        label.transform = self.randomMove(for: label)
                    }
                }
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.42) {
                    for label in self.lambdaLabels {
                        label.layer.backgroundColor = self.randomColor().cgColor
                    }
                }
            }
            UIView.animateKeyframes(withDuration: 4.0,
                                    delay: 0.0,
                                    options: [],
                                    animations: animationBlock)
        }
    
    func performGatherAnimation() {

        let gatherAnimationBlock = {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.lambdaLabels.forEach { label in
                    label.transform = .identity
                    label.layer.backgroundColor = .none
                }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2) {
                self.lambdaLogoView.layer.opacity = 1.0
            }
        }
        
        UIView.animateKeyframes(withDuration: 2,
                                delay: 0,
                                options: [],
                                animations: gatherAnimationBlock,
                                completion: nil)
    }
}
