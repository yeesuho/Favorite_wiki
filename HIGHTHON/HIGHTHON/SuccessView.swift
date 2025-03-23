//
//  SuccessView.swift
//  HIGHTHON
//
//  Created by 이수호 on 2/16/25.
//

import UIKit




class SuccessView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUping()
        hideKeyboardWhenTappedAround()
    }
    
    func setUping() {
        nameField.delegate = self
        nameField.frame.size.height = 44
        nameField.keyboardType = .default
        nameField.placeholder = "닉네임을 입력하세요."
        nameField.borderStyle = .roundedRect
        nameField.clearButtonMode = .always
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        lgoinSuccess(UIButton())  // Success 버튼 실행
        return true
    }
    
    @IBAction func lgoinSuccess(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "TabBarController") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}



