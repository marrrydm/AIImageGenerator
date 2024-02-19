//
//  ViewController.swift
//  AIImageGenerator
//
//  Created by Мария Ганеева on 13.02.2024.
//

import EasyTipView
import Kingfisher
import Lottie
import SnapKit
import UIKit

class GenerateController: UIViewController {
    // MARK: - Properties
    private var viewModel: GeneratorViewModel

    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(GenerateCell.self, forCellWithReuseIdentifier: "customCell")
        view.delegate = self
        view.dataSource = self

        return view
    }()

    private let messageTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2.5
        view.returnKeyType = .search
        view.layer.borderColor = UIColor.white.cgColor
        view.text = "Enter your promt.."
        view.textColor = .white
        view.autocorrectionType = .no
        view.keyboardAppearance = .dark
        view.isScrollEnabled = false
        view.font = UIFont(name: "Skia", size: 16)
        view.textContainerInset = UIEdgeInsets(top: 13, left: 10, bottom: 10, right: 40)

        return view
    }()

    private let bgView: GradientView = {
        let view = GradientView()
        view.isUserInteractionEnabled = true

        return view
    }()

    private lazy var saveImageButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrow.down.circle")
        view.tintColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveImageToGallery)))
        view.isUserInteractionEnabled = true

        return view
    }()

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFill

        return view
    }()

    private lazy var backButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrow.backward.circle")
        view.tintColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBack)))
        view.isUserInteractionEnabled = true

        return view
    }()

    private let waitLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 0.918, green: 0.933, blue: 0.925, alpha: 1)
        view.font = UIFont(name: "Skia", size: 18)
        view.text = "Enter a prompt or choose from the list below!"
        view.textAlignment = .center
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping

        return view
    }()

    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "plane")
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.isHidden = true

        return view
    }()

    private var bottomConstraint: NSLayoutConstraint?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupObservers()
        messageTextView.delegate = self
        addCloseButtonToKeyboard()
    }

    // MARK: - Initializers
    init(viewModel: GeneratorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GenerateController {
    // MARK: - UI Setup
    func setupViews() {
        view.addSubviews(bgView, animationView, waitLabel)
        bgView.addSubviews(collectionView, messageTextView, imageView)
        imageView.addSubviews(saveImageButton, backButton)
    }

    func setupConstraints() {
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        waitLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalToSuperview().inset(30)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(waitLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(messageTextView.snp.top).offset(-20)
        }

        messageTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.height.equalTo(40)
        }

        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(waitLabel.snp.centerY)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.height.width.equalTo(30)
        }

        saveImageButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.height.width.equalTo(30)
        }

        bottomConstraint = messageTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        bottomConstraint?.isActive = true
    }
}

private extension GenerateController {
    // MARK: - Observers
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Keyboard Handling
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height
        let spaceAboveKeyboard = view.frame.height - keyboardHeight - (messageTextView.frame.origin.y + messageTextView.frame.height)

        if spaceAboveKeyboard < 0 {
            bottomConstraint?.constant = spaceAboveKeyboard - 20
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        bottomConstraint?.constant = -20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

private extension GenerateController {
    // MARK: - Image Saving
    @objc func saveImageToGallery() {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

        let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
        }

        showAlertSaved()
    }

    // MARK: - Back Button Action
    @objc func tapBack() {
        messageTextView.text = Constants.enter
        waitLabel.text = "Enter a prompt or choose from the list below!"
        imageView.isHidden = !imageView.isHidden
        animationView.isHidden = true
        collectionView.isHidden = !collectionView.isHidden
        messageTextView.isHidden = !messageTextView.isHidden
    }
}

private extension GenerateController {
    // MARK: - Helper Methods
    func showRetryTip() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "Skia", size: 20)!
        preferences.drawing.foregroundColor = .white
        preferences.drawing.backgroundColor = UIColor(hue: 0.76, saturation: 0.99, brightness: 0.6, alpha: 0.7)
        preferences.drawing.textAlignment = .center
        preferences.drawing.arrowHeight = 0
        preferences.animating.showDuration = 0.3

        EasyTipView.show(animated: true, forView: self.messageTextView,
                         withinSuperview: self.view,
                         text: """
                            Oops!
                            There seems to be an error, tap on the message and we'll try again!
                            """,
                         preferences: preferences,
                         delegate: self)
    }

    func showAlertSaved() {
        let alertController = UIAlertController(title: nil, message: "Image saved successfully!", preferredStyle: .alert)

        let attributedMessage = NSAttributedString(string: "Image saved successfully!", attributes: [NSAttributedString.Key.font: UIFont(name: "Skia", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white])
        alertController.setValue(attributedMessage, forKey: "attributedMessage")

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}

private extension GenerateController {
    // MARK: - ViewModel
    func generateImage(fromText text: String) {
        viewModel.generateImageFromText(text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.handleSuccessfulImageGeneration(image)
            case .failure(let error):
                self.handleFailedImageGeneration(withError: error)
            }
        }
    }

    func handleSuccessfulImageGeneration(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
            self.imageView.isHidden = false
            self.imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.imageView.transform = .identity
                self.imageView.snp.remakeConstraints { make in
                    make.edges.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            }) { _ in
                self.animationView.stop()
                self.animationView.isHidden = true
                self.waitLabel.text = "Your image has been generated!"
            }
        }
    }

    func handleFailedImageGeneration(withError error: Error) {
        self.showRetryTip()
    }
}

extension GenerateController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.collectionData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! GenerateCell
        cell.configure(withImage: Constants.collectionData[indexPath.row].0, labelText: Constants.collectionData[indexPath.row].1)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20.0) / 2.1
        return CGSize(width: width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        messageTextView.text = Constants.collectionData[indexPath.row].1
        messageTextView.becomeFirstResponder()
    }
}

extension GenerateController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.enter {
            messageTextView.text = ""
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            messageTextView.text = Constants.enter
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if let newText = textView.text, !newText.isEmpty, newText.contains("\n") {
            animationView.isHidden = !animationView.isHidden
            collectionView.isHidden = !collectionView.isHidden
            animationView.play()
            waitLabel.text = "The generated image will be displayed soon 🙂"
            generateImage(fromText: newText)
            messageTextView.isHidden = !messageTextView.isHidden
            textView.resignFirstResponder()
        }
    }
}

extension GenerateController: EasyTipViewDelegate {
    func easyTipViewDidTap(_ tipView: EasyTipView) { }

    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        generateImage(fromText: messageTextView.text ?? "")
    }
}

private extension GenerateController {
    func addCloseButtonToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [flexibleSpace, closeButton]
        messageTextView.inputAccessoryView = toolbar
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
