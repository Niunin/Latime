//
//  NewMessageViewController.swift
//  Project 4
//
//  Created by Andrea Nunti on 21.01.2021.
//

import UIKit

// MARK: - Delegate

protocol InputContainerDelegate: UITextFieldDelegate {
    
    func callImagePicker()
    func removeImage()
    
}

// MARK: - Object

class InputContainer: UIView {
    
    /// Views
    private let titleTextField = UITextField()
    private let callImagePickerButton = UIButton(type: .system)
    private let imagePreview = UIImageView()
    
    /// Hierarchy
    private weak var delegate: InputContainerDelegate!
    private weak var viewController: UIViewController!
    
    /// Geometry
    private var bottomConstraint = NSLayoutConstraint()
    private var imageHeightConstraint = NSLayoutConstraint()
    private var imageTrailingConstrain = NSLayoutConstraint()
    
    // MARK: init - deinit
    
    init(view: UIViewController, delegate: InputContainerDelegate) {
        super.init(frame: .zero)
        viewController = view
        self.delegate = delegate
        setupVeiws()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup views
    
    private func setupVeiws() {
        setupPickImageButton(callImagePickerButton)
        setupTitleTF(titleTextField)
        setupImagePreview(imagePreview)
        setupSelf()
        addSubview(callImagePickerButton)
        addSubview(titleTextField)
        addSubview(imagePreview)
    }
    
    private func setupPickImageButton(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.tintColor = UIColor.myAccent
        button.isUserInteractionEnabled = true
        let logo = UnsplashLogo()
        let layer = logo.draw()
        let image = logo.imageFromLayer(layer: layer)
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
    }
    
    @IBAction private func pickImage() {
        delegate.callImagePicker()
    }
    
    private func setupTitleTF(_ textField: UITextField) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.inputContainerFont
        textField.placeholder = "Mission title"
        textField.textColor = UIColor.myAccent
        textField.adjustsFontForContentSizeCategory = true
        textField.delegate = delegate
    }
    
    private func setupImagePreview(_ imageView: UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        let interaction = UIContextMenuInteraction(delegate: self)
        imageView.addInteraction(interaction)
    }
    
    private func setupSelf() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.myViewBackground
        layer.borderColor = UIColor.myAccentCG
        layer.borderWidth = 0.5
        layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }
    
    // MARK: setup constraints
    
    func setupConstraints() {
        // TODO: I should do it once? Or remove and activate again.
        // TODO: this function is called in wrong place
        bottomConstraint = callImagePickerButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
        imageHeightConstraint = imagePreview.heightAnchor.constraint(equalToConstant: 0)
        imageHeightConstraint.constant = imagePreview.image == nil ? 0 : 50
        imageTrailingConstrain = imagePreview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        
        let constraints = [
            callImagePickerButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            callImagePickerButton.widthAnchor.constraint(equalToConstant: 30),
            callImagePickerButton.heightAnchor.constraint(equalToConstant: 30),
            bottomConstraint,
            
            titleTextField.leadingAnchor.constraint(equalTo: callImagePickerButton.trailingAnchor, constant: 8),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleTextField.bottomAnchor.constraint(equalTo: callImagePickerButton.bottomAnchor),
            titleTextField.heightAnchor.constraint(equalTo: callImagePickerButton.heightAnchor),
            
            imagePreview.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            imageTrailingConstrain,
            imagePreview.bottomAnchor.constraint(equalTo: titleTextField.topAnchor, constant: -10),
            imageHeightConstraint,
            
            leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: -2),
            trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: 2),
            bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor, constant: 2),
            topAnchor.constraint(equalTo: imagePreview.topAnchor, constant: -6)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: configure
    func setTitle(_ title: String?) {
        titleTextField.text = title
    }
    
    func setImage(_ image: UIImage?) {
        UIView.animate(withDuration: 0.25) {
            if let image = image {
                self.imagePreview.image = image
                self.imageHeightConstraint.constant = 50
            } else {
                self.imagePreview.image = nil
                self.imageHeightConstraint.constant = 0
            }
        }
    }

    func setHeight(to height: CGFloat, with duration: Double?) {
        configureContainerHeight(height)
        runHeightChangeAnimation(with: duration)
    }
    
    // MARK: helpers
    
    private func configureContainerHeight(_ height: CGFloat) {
        bottomConstraint.isActive = false
        if height <= 0 {
            setContainerDown()
        } else if titleTextField.isFirstResponder {
            setContainerUp(height)
        }
    }
    
    private func setContainerDown() {
        bottomConstraint = callImagePickerButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
        bottomConstraint.isActive = true
        imagePreview.layer.cornerRadius = 10
        imageHeightConstraint.constant = imagePreview.image != nil ? 50 : 0
    }
    
    private func setContainerUp(_ height: CGFloat) {
        bottomConstraint = callImagePickerButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        bottomConstraint.constant -= height
        bottomConstraint.isActive = true
        
        imagePreview.layer.cornerRadius = 2.5
        imageHeightConstraint.constant = imagePreview.image != nil ? 5 : 0
    }
    
    private func runHeightChangeAnimation(with duration: Double?) {
        if let duration = duration {
            UIView.animate(withDuration: duration) {
                self.viewController.view.layoutIfNeeded()
            }
        } else {
            self.viewController.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - UIContextMenu Delegate

extension InputContainer: UIContextMenuInteractionDelegate {
    private var performRemoveImage: UIAction {
        UIAction(title: "Delete".localized,
                 image: UIImage(systemName: "trash"),
                 attributes: .destructive) { [self] _ in
            delegate.removeImage()
        }
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(  identifier: nil,
                                            previewProvider: nil,
                                            actionProvider: { _ in
                                                let deleteAction = self.performRemoveImage
                                                
                                                return UIMenu(title: NSLocalizedString("", comment: ""),
                                                              children: [deleteAction])
                                            })
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let parameters = UIPreviewParameters()
        let visibleRect: CGRect =  imagePreview.bounds
        let visiblePath = UIBezierPath(roundedRect: visibleRect, cornerRadius: 10.0)
        parameters.visiblePath = visiblePath
        return UITargetedPreview(view: imagePreview, parameters: parameters)
    }
    
}
