import UIKit

extension UITextField {
    
    func addDoneButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonAction))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
}
