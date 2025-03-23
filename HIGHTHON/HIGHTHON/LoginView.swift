//
//  ViewController.swift
//  HIGHTHON
//
//  Created by 이수호 on 2/15/25.
//

import UIKit

class LoginView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setupKeyboardNotifications()
        setupEdgeGesture()
        self.hideKeyboardWhenTappedAround()
    }

    func setUp() {
        idTextField.delegate = self
        passwordTextField.delegate = self
        
        idTextField.frame.size.height = 44
        passwordTextField.frame.size.height = 44
        idTextField.keyboardType = .emailAddress
        passwordTextField.keyboardType = .default
        idTextField.placeholder = "아이디 입력"
        passwordTextField.placeholder = "비밀번호 입력"
        idTextField.borderStyle = .roundedRect
        passwordTextField.borderStyle = .roundedRect
        idTextField.clearButtonMode = .always
        passwordTextField.clearButtonMode = .always
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == idTextField {
            passwordTextField.becomeFirstResponder()  // 다음 입력 필드로 이동
        } else if textField == passwordTextField {
            loginBtn(UIButton())  // 로그인 버튼 실행
        }
        return true
    }

    @IBAction func loginBtn(_ sender: Any) {
        guard let id = idTextField.text, !id.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "로그인 실패", message: "아이디 또는 비밀번호가 비어있습니다.")
            return
        }

        if id == "hello" && password == "1234" {
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SuccessView") else { return }
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            showAlert(title: "로그인 실패", message: "아이디 또는 비밀번호가 잘못되었습니다.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let bottomInset = keyboardFrame.height
            self.view.frame.origin.y = -bottomInset / 2  // 키보드 높이의 절반만큼 이동
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0  // 원래 위치로 복귀
    }

    @IBAction func goSignUp(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SignUpView") else {return}
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func goHomeView(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "TabBarController") else {return}
                  self.navigationController?.pushViewController(nextVC, animated: true)
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
                navigationController?.popViewController(animated: true)
            }
        case .ended, .cancelled:
            break
        default:
            break
        }
    }
}
