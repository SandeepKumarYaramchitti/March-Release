//
//  ViewController.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 3/22/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit
import Firebase
class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Plus Button
    let plusButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Add_user_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handlePlusPhotos), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhotos(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            plusButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
       // plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layer.masksToBounds = true
        plusButton.layer.borderColor = UIColor.white.cgColor
        plusButton.layer.borderWidth = 2
        dismiss(animated: true, completion: nil)
        
    }
    
    //Email UI Text Field
    let emailTextField: UITextField = {
       let textField = UITextField()
       textField.placeholder = "Email"
       textField.borderStyle = .roundedRect
       textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
       return textField
    }()
    //Controls the change state here
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && userNameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
          signUpButton.isEnabled = true
          signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237, alpha: 1)
        }else{
          signUpButton.isEnabled = false
          signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
        }
    }
    
    
    //User Name Text Field
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "User Name"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    //Password Text Field
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    //Sign up Button
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
       button.setTitle("Sign Up", for: .normal)
       button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
       button.layer.cornerRadius = 5
       button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
       button.setTitleColor(.white, for: .normal)
       button.isEnabled = false
       //Add an action to the sign up button
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
       return button
    }()
    
    //Already Have account Button
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributeTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributeTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16),NSAttributedStringKey.foregroundColor: Colors.logoBlueColor]))
        
        button.setAttributedTitle(attributeTitle, for: .normal)
        //button.setTitle("Don't have an account? Sign Up.", for: .normal)
        
        button.addTarget(self, action: #selector(alreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func alreadyHaveAccount(){
        print(123)
        _ = navigationController?.popViewController(animated: true)
    }
    
    //Create user using Firebase  - New Users can use this
    @objc func handleSignUp(){
        
        guard let email = emailTextField.text, email.characters.count > 0  else {return}
        guard let userName = userNameTextField.text, userName.characters.count > 0 else {return}
        guard let password = passwordTextField.text, password.characters.count > 0 else {return}

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Failed to create the user",err)
                return
            }
            print("Succesfully created the user:",user?.uid ?? "")
            
            guard let image = self.plusButton.imageView?.image else {return}
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
            
            let fileName = NSUUID().uuidString
            
            Storage.storage().reference().child("Profile_Images").child(fileName).putData(uploadData, metadata: nil, completion: { (metaData, err) in
                if let err = err {
                    print("Failed to load image",err)
                    return
                }
                
                guard let profileImageURL = metaData?.downloadURL()?.absoluteString else {return}
                print("Sucessfully uploaded the image:",profileImageURL)
                guard let uid = user?.uid else {return}
                
                let dictionaries = ["username": userName, "ProfileImageURL": profileImageURL]
                let values = [uid: dictionaries]
                
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print("Failed to update the data",err)
                        return
                    }
                    print("Sucessfullt saved user info to DB.")
                    //Reset the UI to show the main tab bar controller
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                    mainTabBarController.setUpViewControllers()
                    self.dismiss(animated: true, completion: nil)
                })

            })
            
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(plusButton)  //Add a subview of plus button to the main view
        _ = plusButton.anchor(view.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 100, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 130)
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setUpInputFields()
        
        view.addSubview(alreadyHaveAccountButton)
        _ = alreadyHaveAccountButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    }
    
    //Set up the stackView to load the Email, UserName and Password Text Field
    fileprivate func setUpInputFields(){

        let stackView = UIStackView(arrangedSubviews: [emailTextField,userNameTextField,passwordTextField,signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        _ = stackView.anchor(plusButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 150)
        
    }
}




