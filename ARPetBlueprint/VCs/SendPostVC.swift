//
//  SendPostVC.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/9.
//

import UIKit

class SendPostVC: UIViewController, UITableViewDelegate, UITextViewDelegate {
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet weak var textPlaceholder: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        placeholderLabel.isHidden = !titleTextView.text.isEmpty
        titleTextView.delegate = self
        
        textPlaceholder.isHidden = !textView.text.isEmpty
        textView.delegate = self
        
        
        
        let insertPhotoButton = UIButton(type: .system)
        insertPhotoButton.setTitle("Insert Photo", for: .normal)
        insertPhotoButton.addTarget(self, action: #selector(insertPhotoButtonTapped), for: .touchUpInside)
        let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        accessoryView.backgroundColor = .lightGray
        accessoryView.addSubview(insertPhotoButton)
        insertPhotoButton.center = accessoryView.center
        titleTextView.inputAccessoryView = accessoryView

        
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView{
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
        else if textView == self.textView{
            textPlaceholder.isHidden = !textView.text.isEmpty
        }
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView == titleTextView{
            titleTextView.resignFirstResponder()
            
        }
        else if textView == self.textView{
            self.textView.resignFirstResponder()
        }
        
        
        textView.inputAccessoryView = nil
        return true
    }

    @objc func insertPhotoButtonTapped(){}

}
