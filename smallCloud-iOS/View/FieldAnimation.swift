//
//  FieldAnimation.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/05/29.
//

import Foundation
import UIKit

private struct Local {
    static let height: CGFloat = 60
    static let tintColorValid: UIColor = .systemGreen
    static let tintColorInValid: UIColor = .systemRed
    static let backgroundColor: UIColor = .systemGray5
    static let foregroundColor: UIColor = .systemGray
}

final class FormFieldView: UIView {

    enum EditState {
        case valid
        case invalid
    }
    
    let label = UILabel()
    let invalidLabel = UILabel()
    var editState = EditState.valid
    var valiException = false
    
    let textField = UITextField()
    
    init(frame: CGRect = .zero, text: String, _ validationException:Bool = false) {
        super.init(frame: frame)
        valiException = validationException
        setup()
        style(placeholder:text)
        layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        style(placeholder:"Email")
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Local.height)
    }
}

extension FormFieldView {
    
    func setup() {
        textField.delegate = self
    }
    
    func style(placeholder:String) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Local.backgroundColor
        layer.cornerRadius = Local.height / 4
        
        // label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.text = placeholder
        
        // invalid
        invalidLabel.translatesAutoresizingMaskIntoConstraints = false
        invalidLabel.textColor = Local.tintColorInValid
        invalidLabel.text = "\(placeholder) is invalid"
        invalidLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        invalidLabel.isHidden = true
        
        // textfield
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = Local.tintColorValid
        textField.isHidden = true
        
        textField.clearButtonMode = .whileEditing
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_: )))
        addGestureRecognizer(tap)
    }
    
    func layout() {
        addSubview(label)
        addSubview(invalidLabel)
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            // label
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            
            // invalidLabel
            invalidLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            invalidLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            
            // textfield
            textField.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: textField.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: textField.bottomAnchor, multiplier: 2),

        ])
    }
    
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizer.State.ended) {
            if editState == .valid {
                enterFieldAnimation()
            }
        }
    }
}

// MARK: - Animations

extension FormFieldView {
    
    func enterFieldAnimation() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1,
                                                       delay: 0,
                                                       options: []) {
            // style
            self.backgroundColor = .white
            self.label.textColor = Local.tintColorValid
            self.layer.borderWidth = 1
            self.layer.borderColor = self.label.textColor.cgColor
            self.textField.tintColor = Local.tintColorValid
            
            // move
            let transpose = CGAffineTransform(translationX: -8, y: -24)
            let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.label.transform = transpose.concatenating(scale)
            
        } completion: { position in
            self.textField.isHidden = false
            self.textField.becomeFirstResponder()
            
        }
    }
}

// MARK: - TextFieldDelegate

extension FormFieldView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true) // Also resign first responder (necessary for initiating other callback delegates).
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let type = label.text else { return }
        
        if text == "" {
            undo()
            return
        }
        
        if isValidValue(text, type:type) {
            // style
            self.backgroundColor = .white
            self.label.textColor = Local.tintColorValid
            self.layer.borderWidth = 1
            self.layer.borderColor = self.label.textColor.cgColor
            self.textField.tintColor = Local.tintColorValid
            invalidLabel.isHidden = true
            label.isHidden = false
        } else {
            if !valiException {
                showInvalidEmailMessage()
                self.textField.becomeFirstResponder()
            }
        }
        
    }
    
    func showInvalidEmailMessage() {
        label.isHidden = true
        invalidLabel.isHidden = false
        layer.borderColor = Local.tintColorInValid.cgColor
        textField.tintColor = Local.tintColorInValid
        editState = .invalid
    }
}

// MARK: - Actions

extension FormFieldView {
    func undo() {
        let size = UIViewPropertyAnimator(duration: 0.1, curve: .linear) {
            // style
            self.backgroundColor = Local.backgroundColor
            self.label.textColor = Local.foregroundColor
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
            
            // visibility
            self.label.isHidden = false
            self.invalidLabel.isHidden = true
            self.textField.isHidden = true
            self.textField.text = ""

            // move
            self.label.transform = .identity
            
            self.editState = .valid
        }
        size.startAnimation()
    }
}

// MARK: - Factories

func makeSymbolButton(systemName: String, target: Any, selector: Selector) -> UIButton {
    let configuration = UIImage.SymbolConfiguration(scale: .large)
    let image = UIImage(systemName: systemName, withConfiguration: configuration)
    
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(target, action: selector, for: .primaryActionTriggered)
    button.setImage(image, for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    
    return button
}

// MARK: Utils

func isValidValue(_ text: String, type:String) -> Bool {
    var regEx = ""

    switch type{
    case "Email":
        regEx = "^([a-zA-Z0-9._-])+@[a-zA-Z0-9.-]+.[a-zA-Z]{3,20}$"
    case "Password":
        regEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,20}$"
    case "Phone":
        regEx = "^01[0-1, 7][0-9]{7,8}$"
    default:
        regEx = "[가-힣A-Za-z]{2,10}"
    }

    let Pred = NSPredicate(format:"SELF MATCHES %@", regEx)

    return Pred.evaluate(with: text)
}

