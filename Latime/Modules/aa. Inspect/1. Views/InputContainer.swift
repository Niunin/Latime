//
//  NewMessageViewController.swift
//  Project 4
//
//  Created by Andrea Nunti on 21.01.2021.
//

import UIKit



// MARK: - Object

class InputContainer: UIView {
    
    // MARK: Sizes
    
    struct Sizes {
        
        static let textFieldCorner: CGFloat = 12.0
        static let borderWidth: CGFloat = 1.0
        static let textFieldInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        static let topAnchorOffset: CGFloat = 10.0
        static let btmAnchorOffset: CGFloat = 30.0
        static let leadingAnchorOffset: CGFloat = 20.0
        static let trailingAnchorOffset: CGFloat = -20.0
        
        static let verticalSpacing: CGFloat = 8
        static let descriptionIndent: CGFloat = 10
        
    }
    
    /// Views
    private let titleTextField = InputConteinerPaddingTextField(withInsets: Sizes.textFieldInsets)
    private let callImagePickerButton = UIButton(type: .system)
    private let imagePreview = UIImageView()
    
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterial)
        return UIVisualEffectView(effect: blur)
    }()
    
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
        addKeyboardNotificationsObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
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
    
    func configureConstraints() {
        setupConstraints()
        setupBlur()
    }
    
    // MARK: helpers
    
    private func configureContainerHeight(_ height: CGFloat) {
        if height <= 0 {
            setContainerDown()
        } else if titleTextField.isFirstResponder {
            setContainerUp(height)
        }
    }
    
    private func setContainerDown() {
        bottomConstraint.isActive = false
        bottomConstraint = callImagePickerButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
        bottomConstraint.isActive = true
        imagePreview.layer.cornerRadius = 10
        imageHeightConstraint.constant = imagePreview.image != nil ? 50 : 0
        layer.borderWidth = 0
    }
    
    private func setContainerUp(_ height: CGFloat) {
        bottomConstraint.isActive = false
        bottomConstraint = callImagePickerButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        bottomConstraint.constant -= height
        bottomConstraint.isActive = true
        layer.borderWidth = 1
        
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

// MARK: - Setup Views

private extension InputContainer {
    
    func setupVeiws() {
        setupButton(callImagePickerButton)
        setupTitleTF(titleTextField)
        setupImagePreview(imagePreview)
        setupSelf()
        
        addSubview(callImagePickerButton)
        addSubview(titleTextField)
        addSubview(imagePreview)
    }
    
    func setupSelf() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.myViewBackground
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0
        layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }
    
    func setupButton(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        button.layer.cornerRadius = Sizes.textFieldCorner
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.mg1
        button.tintColor = UIColor.mb
        button.isUserInteractionEnabled = true
        
        let image = UIImage(systemName: "paintbrush.fill")
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        
        // Setup the button's context menu directly.
        let inspectAction = self.imageAction()
        let duplicateAction = self.photoAction()
        let deleteAction = self.unsplashAction()
        button.menu = UIMenu(title: "", children: [inspectAction, duplicateAction, deleteAction])
        button.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func pickImage() {
        delegate.callImagePicker()
    }
    
    func setupBlur() {
        addSubview(blurView)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sendSubviewToBack(blurView)
    }
    
    func setupTitleTF(_ textField: UITextField) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.F2
        textField.placeholder = "New time point"
        textField.textColor = UIColor.myAccent
        textField.adjustsFontForContentSizeCategory = true
        textField.delegate = self
        
        textField.backgroundColor = .white
        textField.layer.cornerRadius = Sizes.textFieldCorner
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.borderWidth = 1.5
        textField.layer.masksToBounds = true
    }
    
    func setupImagePreview(_ imageView: UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        let interaction = UIContextMenuInteraction(delegate: self)
        imageView.addInteraction(interaction)
    }
    
    func setupConstraints() {
        
        let mg = layoutMarginsGuide
        let sa = safeAreaLayoutGuide
        
        // TODO: I should do it once? Or remove and activate again.
        // TODO: this function is called in wrong place
        bottomConstraint = callImagePickerButton.bottomAnchor.constraint(equalTo: sa.bottomAnchor, constant: -8)
        imageHeightConstraint = imagePreview.heightAnchor.constraint(equalToConstant: 0)
        imageHeightConstraint.constant = imagePreview.image == nil ? 0 : 50
        imageTrailingConstrain = imagePreview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        
        NSLayoutConstraint.activate([
            callImagePickerButton.leadingAnchor.constraint(equalTo: mg.leadingAnchor,  constant: 8),
            callImagePickerButton.widthAnchor.constraint(equalToConstant: 40),
            callImagePickerButton.heightAnchor.constraint(equalToConstant: 40),
            bottomConstraint,
            
            titleTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: callImagePickerButton.trailingAnchor, multiplier: 1 ),
            titleTextField.trailingAnchor.constraint(equalTo: mg.trailingAnchor, constant: -8),
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
        ])
    }
    
}

// MARK: - Setup Notifications

extension InputContainer {
    
    func addKeyboardNotificationsObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(lowerInputContainer(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(raiseInputContaier(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }
    //
    func removeNotifications() {
        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    @IBAction func lowerInputContainer(notification: NSNotification) {
        changeInputContainerHeight(notification, to: 0)
    }
    
    @IBAction func raiseInputContaier(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardHeight = keyboardFrame?.height ?? 0
        changeInputContainerHeight(notification, to: keyboardHeight)
    }
    
    func changeInputContainerHeight(_ notification: NSNotification, to height: CGFloat) {
        let keyboardAnimationDuration = getKeyboardAnimationDuration(notification)
        setHeight(to: height, with: keyboardAnimationDuration)
    }
    
    func getKeyboardAnimationDuration(_ notification: NSNotification) -> Double? {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        return duration
    }
    
}


// MARK: ContextMenu Protocol Conformance

extension InputContainer: ImagePickerContextMenu {
    func photoPicker() {
        delegate.callCamera()
    }
    
    func imagePicker() {
        delegate.callImagePicker()
    }
    
    func unsplashPicker() {
        delegate.callUnsplash()
    }
    
    func removeImage() {
        delegate.removeImage()
    }
    
}

// MARK: - UI Delegate ContextMenu

extension InputContainer: UIContextMenuInteractionDelegate {
    
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

// MARK: - UI Delegate TextField

extension InputContainer: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        setHeight(to: 0, with: 0.5)
        delegate.titleUpdated(textField.text ?? "")
    }
    
}
