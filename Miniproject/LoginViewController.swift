//
//  LoginViewController.swift
//  Miniproject
//
//  Created by apple on 11/11/24.
//

import Foundation
import UIKit
class LoginViewController : UIViewController {
    
    private var selfies = [UIImage]()
    private var currentOTP : String?

    var user : User?
    
    private let emailTextField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter your Email"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.backgroundColor = .secondarySystemBackground
        return field
        
    }()
    
    private let passwordTextField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter your password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.backgroundColor = .secondarySystemBackground
        field.isSecureTextEntry = true
        return field
        
    }()
    
    private let firstNameTextField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter your First Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.backgroundColor = .secondarySystemBackground
        return field
        
    }()
    
    private let lastNameTextField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter your Last Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.backgroundColor = .secondarySystemBackground
        return field
        
    }()
    
    private let dobTextField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "DOB"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.backgroundColor = .secondarySystemBackground
        return field
        
    }()
    
    private let pincodeTextField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter your pincode"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.backgroundColor = .secondarySystemBackground
        return field
        
    }()
    
    private let datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        return datePicker
    }()
    
    private let aboutMeTextView : UITextView = {
        let field = UITextView()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.text = "write about yourself"
        field.backgroundColor = .secondarySystemBackground
        return field
        
    }()
    
    private let submitButton : UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10

        return button
    }()
    
    private let selfieButton : UIButton = {
        let button = UIButton()
        button.setTitle("Capture Selfie", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10

        return button
    }()
    
    
    
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.synchronize()
        
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameTextField)
        view.addSubview(dobTextField)
        view.addSubview(pincodeTextField)
        view.addSubview(aboutMeTextView)
        view.addSubview(selfieButton)
        view.addSubview(submitButton)
        dobTextField.delegate = self
        dobTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(didSelectDate), for: .valueChanged)
        selfieButton.addTarget(self, action: #selector(captureSelfie), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailTextField.frame = CGRect(x: 20, y: 100, width: view.width - 40 , height: 50)
        passwordTextField.frame = CGRect(x: 20, y: emailTextField.bottom + 10, width: view.width - 40 , height: 50)
        firstNameTextField.frame = CGRect(x: 20, y: passwordTextField.bottom + 10, width: view.width - 40 , height: 50)
        lastNameTextField.frame = CGRect(x: 20, y: firstNameTextField.bottom + 10, width: view.width - 40 , height: 50)
        aboutMeTextView.frame = CGRect(x: 20, y: lastNameTextField.bottom + 10, width: view.width - 40 , height: 100)
        dobTextField.frame = CGRect(x: 20, y: aboutMeTextView.bottom + 10, width: view.width - 40 , height: 50)
        pincodeTextField.frame = CGRect(x: 20, y: dobTextField.bottom + 10, width: view.width - 40 , height: 50)
        selfieButton.frame = CGRect(x: 20, y: pincodeTextField.bottom + 10, width: view.width - 40 , height: 50)
        submitButton.frame = CGRect(x: 20, y: selfieButton.bottom + 10, width: view.width - 40 , height: 50)


    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc private func didSelectDate(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dobTextField.text = formatter.string(from: datePicker.date)
    }
    

}

extension LoginViewController : UITextFieldDelegate,UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 350{
            textView.text = String(textView.text.prefix(350))
        }
    }
    
    
}

extension LoginViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            selfies.append(image)
            dismiss(animated: true)
        }
    }
    @objc private func captureSelfie(){
        if selfies.count < 5 {
            let imagePicker = UIImagePickerController()
            //for simulator i will prefer gallery i.e photoLibrary
            imagePicker.sourceType =  .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }else{
            print("You have reached 5 selfies")
        }
    }
    @objc private func didTapSubmit(){
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty,
              let pinCode = pincodeTextField.text, !lastName.isEmpty,
              let dob = dobTextField.text, !dob.isEmpty,

              let aboutme = aboutMeTextView.text, aboutme.count <= 350,
                selfies.count == 5 else{
            //Show Alert
            showAlert(message: "Please fill out all the fields!")
            return
        }
        if !isValidEmail(email){
            showAlert(message: "Please Enter a Valid Email")
        }
        let user = User(firstName: firstName, lastName: lastName, email: email, pincode: pinCode, dob: dob, aboutMe: aboutme, profilePics: selfies)
        self.user = user
            //OTP implementation
        sendOTPToEmail(email)
    }
    private func showAlert(message : String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    private func isValidEmail(_ email:String) -> Bool{
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
                return emailPredicate.evaluate(with: email)
    }
    private func sendOTPToEmail(_ email:String){
        currentOTP = String(format: "%06d", arc4random_uniform(1000000))
        print("OTP sent to \(email) : \(currentOTP!)")
        
        // implementaion of OTP alert
        showOTPAlert()
    }
    
    private func showOTPAlert(){
        let alert = UIAlertController(title: "Enter OTP", message: "An OTP has been sent to your email. Please enter it below", preferredStyle: .alert)
        alert.addTextField{ textField in
            textField.placeholder = "OTP"
            textField.keyboardType = .numberPad
            
        }
        alert.addAction(UIAlertAction(title: "Verify", style: .default, handler: { [weak self] _ in
            guard let self = self else {
                return
            }
            if let enteredOTP = alert.textFields?.first?.text, enteredOTP == self.currentOTP{
                //Registration complete
                completeRegistration()
                
            }else{
                //Registration failed
                showAlert(message: "Incorrect OTP, Please try again.")
            }
        }))
        present(alert,animated: true)
    }
    private func completeRegistration (){
        print("Registration completed")
        
        let successAlert = UIAlertController(title: "Success", message: "Registration Successfull", preferredStyle: .alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            let profileVC = ViewController()
            profileVC.user = self.user
            self.navigationController?.pushViewController(profileVC, animated: true)
        }))
        present(successAlert, animated: true)
    }
    
}
