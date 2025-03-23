//
//  ViewController.swift
//  HIGHTHON
//
//  Created by 이수호 on 2/15/25.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class SearchView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var goHome: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var goView: UIImageView!
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let refreshControl = UIRefreshControl()
    
    let imageDict: [String: Int] = [
        "강해린": 0,
        "원하늘": 1,
        "소화기": 2,
        "감자": 3,
        "호시노아이": 4,
        "사쿠라지": 5,
        "키타가와": 6
    ]
    
    @IBOutlet var imageViews: [UIImageView]!
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeTapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeClick))
        goHome.isUserInteractionEnabled = true
        goHome.addGestureRecognizer(homeTapGesture)
        goView.isUserInteractionEnabled = true
        goView.addGestureRecognizer(homeTapGesture)
        
        
        let goViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(goViewTapped))
            goView.isUserInteractionEnabled = true
            goView.addGestureRecognizer(goViewTapGesture)
        
        
        
        setUpTextField()
        self.hideKeyboardWhenTappedAround()
        setupGestures()
        setupRefreshControl()
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            view.addSubview(activityIndicator)
        }
    
    @objc func HomeClick(sender: UITapGestureRecognizer) {
        tabBarController?.selectedIndex = 0
    }
    @objc private func goViewTapped() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "Scroll_h") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func setUpTextField() {
        searchTextField.frame.size.height = 44
        searchTextField.keyboardType = .default
        searchTextField.placeholder = "이름을 검색해 보세요."
        searchTextField.borderStyle = .roundedRect
        searchTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButton(UIButton())
        return true
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
                    presentViewController(x: 0)
                } else if gesture.edges == .right {
                    presentViewController(x: 2)
                }
            }
            
        default:
            break
        }
    }
    
    private func presentViewController(x: Int) {
        tabBarController?.selectedIndex = x
    }
    
    private func setupRefreshControl() {
        scrollView.alwaysBounceVertical = true
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshImages), for: .valueChanged)
    }
    
    @objc private func refreshImages() {
        dismissKeyboard()
        refreshControl.beginRefreshing()
        activityIndicator.startAnimating()
        imageViews.forEach { $0.isHidden = false }
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
        }
        refreshControl.endRefreshing()
        searchTextField.text = ""
        scrollView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.height), animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.imageViews.forEach { $0.isHidden = false }
            UIView.animate(withDuration: 0.3) {
                self.stackView.layoutIfNeeded()
            }
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            self.searchTextField.text = ""
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        guard let searchText = searchTextField.text, !searchText.isEmpty else { return }
        
        if let index = imageDict[searchText] {
            for (i, imageView) in imageViews.enumerated() {
                imageView.isHidden = (i != index)
            }
        } else {
            imageViews.forEach { $0.isHidden = false }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
        }
    }
}
