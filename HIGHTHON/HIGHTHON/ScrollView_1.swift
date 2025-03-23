//
//  ScrollView_1.swift
//  HIGHTHON
//
//  Created by 이수호 on 2/16/25.
//

import UIKit

class ScrollView_1: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEdgeGesture()
    }
    
    private func setupEdgeGesture() {
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        edgePanGesture.edges = .left  // 왼쪽 가장자리에서 시작하는 제스처
        view.addGestureRecognizer(edgePanGesture)
    }
    
    @objc private func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let progress = min(max(translation.x / view.bounds.width, 0), 1)  // 진행 정도 (0~1 사이 값)

        switch gesture.state {
        case .began:
            break
        case .changed:
            if progress > 0.3 {  // 30% 이상 스와이프하면 뒤로가기 실행
                tabBarController?.selectedIndex = 0
            }
        case .ended, .cancelled:
            break
        default:
            break
        }
    }
}
