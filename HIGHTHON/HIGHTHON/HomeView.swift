//
//  ViewController.swift
//  HIGHTHON
//
//  Created by 이수호 on 2/15/25.
//

import UIKit

class HomeView: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupGestures()
        setupImageTapGesture()
    }
    private func setupGestures() {
        // 왼쪽에서 오른쪽 스와이프 → A 화면으로 이동
        let leftEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        leftEdgePanGesture.edges = .left
        view.addGestureRecognizer(leftEdgePanGesture)
        
        // 오른쪽에서 왼쪽 스와이프 → B 화면으로 이동
        let rightEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        rightEdgePanGesture.edges = .right
        view.addGestureRecognizer(rightEdgePanGesture)
    }
    private func setupImageTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGesture)
        }
        
        @objc private func imageTapped() {
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "ScrollView_1") else { return }
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    
    @objc private func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let progress = min(max(abs(translation.x) / view.bounds.width, 0), 1) // 0 ~ 1 사이 정규화
        
        switch gesture.state {
        case .began:
            feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator?.prepare()
            
        case .changed:
            if progress > 0.3 {
                feedbackGenerator?.impactOccurred()
                feedbackGenerator = nil
            }
            
        case .ended, .cancelled:
            if progress > 0.3 {
                if gesture.edges == .left {
                    presentViewController(x: 4)
                } else if gesture.edges == .right {
                    presentViewController(x: 1)
                }
            }
            
        default:
            break
        }
    }
    
    private func presentViewController(x: Int) {
        tabBarController?.selectedIndex = x
    }
}

