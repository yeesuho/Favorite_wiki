//
//  MyView.swift
//  HIGHTHON
//
//  Created by 이수호 on 2/15/25.
//

import UIKit

class MyView: UIViewController {

    @IBOutlet weak var goHome: UIImageView!
    @IBOutlet weak var loginButton: UIButton!  // 로그인 버튼 추가

    private var feedbackGenerator: UIImpactFeedbackGenerator?
    
    var isFromSuccessView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let HomeBtn = UITapGestureRecognizer(target: self, action: #selector(HomeClick))
        goHome.isUserInteractionEnabled = true
        goHome.addGestureRecognizer(HomeBtn)
        
        setupGestures()
        
        
        if isFromSuccessView {
            loginButton.isHidden = true
        }
    }
    
    @objc func HomeClick(sender: UITapGestureRecognizer) {
        tabBarController?.selectedIndex = 0
    }

    private func setupGestures() {
        let leftEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        leftEdgePanGesture.edges = .left
        view.addGestureRecognizer(leftEdgePanGesture)
        
        let rightEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        rightEdgePanGesture.edges = .right
        view.addGestureRecognizer(rightEdgePanGesture)
    }
    
    @objc private func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let progress = min(max(abs(translation.x) / view.bounds.width, 0), 1)
        
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
                    presentViewController(x: 3)
                } else if gesture.edges == .right {
                    presentViewController(x: 0)
                }
            }
            
        default:
            break
        }
    }
    
    private func presentViewController(x: Int) {
        tabBarController?.selectedIndex = x
    }

    @IBAction func goLogin(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "LoginView") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
