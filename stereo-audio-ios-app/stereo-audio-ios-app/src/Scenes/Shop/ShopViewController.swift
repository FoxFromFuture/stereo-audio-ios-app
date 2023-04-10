//
//  ShopViewController.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

protocol ShopDisplayLogic: AnyObject {
    typealias Model = ShopModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayMainMenuScene(_ viewModel: Model.MainMenu.ViewModel)
    func displayUserProductsList(_ viewModel: Model.UserProducts.ViewModel)
    func displayEnemyProductsList(_ viewModel: Model.EnemyProducts.ViewModel)
    func displayNextProduct(_ viewModel: Model.NextProduct.ViewModel)
    func displayNewProductStatus(_ viewModel: Model.NewProductStatus.ViewModel)
}

final class ShopViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let interactor: ShopBusinessLogic
    private let router: ShopRoutingLogic
    
    private let shopLabel = UILabel()
    private let coinsLabel = UILabel()
    private let enemyButton = UIButton()
    private let userButton = UIButton()
    private let mainMenuButton = UIButton()
    private let productBuySetButton = UIButton()
    private let productNameLabel = UILabel()
    private let productImageView = UIImageView()
    private let rightArrowButton = UIButton()
    private let leftArrowButton = UIButton()
    private var curViewedProductIndex = 0
    private var curLanguage: String?
    private let wallpaper = UIImageView()
    
    // MARK: - LifeCycle
    init(
        router: ShopRoutingLogic,
        interactor: ShopBusinessLogic
    ) {
        self.router = router
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadStart(Model.Start.Request())
    }
    
    // MARK: - Configuration
    private func configureUI() {
        self.view.backgroundColor = .black
        configureWallpaper()
        configureShopLabel()
        configureCoinsLabel()
        configureEnemyButton()
        configureUserButton()
        configureMainMenuButton()
        configureRightArrowButton()
        configureLeftArrowButton()
        configureProductBuySetButton()
        configureProductNameLabel()
        configureProductImageView()
    }
    
    private func configureWallpaper() {
        self.view.addSubview(wallpaper)
        wallpaper.image = UIImage(named: "wallpaper")
        wallpaper.contentMode = .scaleAspectFill
        wallpaper.pin(to: self.view, [.bottom: 0, .left: 0, .right: 0, .top: 0])
    }
    
    private func configureShopLabel() {
        self.view.addSubview(shopLabel)
        shopLabel.pinTop(to: self.view.topAnchor, 50)
        shopLabel.pinCenter(to: self.view.centerXAnchor)
        shopLabel.text = "shopUpper".localize(lng: self.curLanguage ?? Language.en.str)
        shopLabel.textColor = .white
        shopLabel.font = .systemFont(ofSize: 32, weight: .regular)
    }
    
    private func configureCoinsLabel() {
        self.view.addSubview(coinsLabel)
        coinsLabel.pinTop(to: self.view.topAnchor, 100)
        coinsLabel.pinCenter(to: self.view.centerXAnchor)
        coinsLabel.text = "coins".localize(lng: self.curLanguage ?? Language.en.str) + ": \(UserDefaults.standard.integer(forKey: "coins"))"
        coinsLabel.textColor = .white
        coinsLabel.font = .systemFont(ofSize: 24, weight: .regular)
    }
    
    private func configureEnemyButton() {
        self.view.addSubview(enemyButton)
        enemyButton.pinTop(to: self.view.topAnchor, 160)
        enemyButton.pin(to: self.view, [.right: 80])
        enemyButton.setTitle("enemy".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
        enemyButton.setTitleColor(.gray, for: .normal)
        enemyButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        enemyButton.addTarget(self, action: #selector(enemyButtonWasTapped), for: .touchDown)
    }
    
    private func configureUserButton() {
        self.view.addSubview(userButton)
        userButton.pinTop(to: self.view.topAnchor, 160)
        userButton.pin(to: self.view, [.left: 80])
        userButton.setTitle("user".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
        userButton.setTitleColor(.white, for: .normal)
        userButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        userButton.isEnabled = false
        userButton.addTarget(self, action: #selector(userButtonWasTapped), for: .touchDown)
    }
    
    private func configureMainMenuButton() {
        self.view.addSubview(mainMenuButton)
        mainMenuButton.pinBottom(to: self.view.bottomAnchor, 60)
        mainMenuButton.pinCenter(to: self.view.centerXAnchor)
        mainMenuButton.setTitle("mainMenu".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
        mainMenuButton.setTitleColor(.white, for: .normal)
        mainMenuButton.setTitleColor(.gray, for: .highlighted)
        mainMenuButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        mainMenuButton.addTarget(self, action: #selector(mainMenuButtonWasTapped), for: .touchDown)
    }
    
    private func configureRightArrowButton() {
        self.view.addSubview(rightArrowButton)
        rightArrowButton.pinCenter(to: self.view.centerYAnchor)
        rightArrowButton.pin(to: self.view, [.right: 29])
        let image = UIImage(systemName: "arrow.right", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .regular)))
        rightArrowButton.setImage(image, for: .normal)
        rightArrowButton.tintColor = .white
        rightArrowButton.backgroundColor = .clear
        rightArrowButton.addTarget(self, action: #selector(rightArrowButtonWasTapped), for: .touchDown)
    }
    
    private func configureLeftArrowButton() {
        self.view.addSubview(leftArrowButton)
        leftArrowButton.pinCenter(to: self.view.centerYAnchor)
        leftArrowButton.pin(to: self.view, [.left: 29])
        let image = UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .regular)))
        leftArrowButton.setImage(image, for: .normal)
        leftArrowButton.tintColor = .gray
        leftArrowButton.backgroundColor = .clear
        leftArrowButton.isEnabled = false
        leftArrowButton.addTarget(self, action: #selector(leftArrowButtonWasTapped), for: .touchDown)
    }
    
    private func configureProductBuySetButton() {
        self.view.addSubview(productBuySetButton)
        productBuySetButton.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) + 85.0)
        productBuySetButton.pinCenter(to: self.view.centerXAnchor)
        if UserDefaults.standard.string(forKey: "user") == Product.user.productsList[0] {
            productBuySetButton.setTitle("used".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
            productBuySetButton.setTitleColor(.gray, for: .normal)
            productBuySetButton.isEnabled = false
        } else {
            productBuySetButton.setTitle("set".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
            productBuySetButton.setTitleColor(.white, for: .normal)
            productBuySetButton.isEnabled = true
        }
        productBuySetButton.setTitleColor(.gray, for: .highlighted)
        productBuySetButton.titleLabel?.font = .systemFont(ofSize: 32, weight: .regular)
        productBuySetButton.addTarget(self, action: #selector(productBuySetButtonWasTapped), for: .touchDown)
    }
    
    private func configureProductNameLabel() {
        self.view.addSubview(productNameLabel)
        productNameLabel.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) + 18.0)
        productNameLabel.pinCenter(to: self.view.centerXAnchor)
        productNameLabel.text = Product.user.productsList[curViewedProductIndex]
        productNameLabel.textColor = .white
        productNameLabel.font = .systemFont(ofSize: 24, weight: .regular)
    }
    
    private func configureProductImageView() {
        self.view.addSubview(productImageView)
        productImageView.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) - 82.0)
        productImageView.pinCenter(to: self.view.centerXAnchor)
        let image = UIImage(systemName: ProductsManager.shared.getImageName(product: Product.user.productsList[curViewedProductIndex]), withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 62, weight: .regular)))
        productImageView.image = image
        productImageView.tintColor = .white
        productImageView.backgroundColor = .clear
    }
    
    // MARK: - Actions
    private func changeEnemyUserButtonStatusToEnabled(button: UIButton) {
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        button.isEnabled = true
    }
    
    private func changeEnemyUserButtonStatusToDisabled(button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        button.isEnabled = false
    }
    
    private func changeArrowButtonStatusToEnabled(arrowButton: UIButton) {
        arrowButton.tintColor = .white
        arrowButton.isEnabled = true
    }
    
    private func changeArrowButtonStatusToDisabled(arrowButton: UIButton) {
        arrowButton.tintColor = .gray
        arrowButton.isEnabled = false
    }
    
    private func isButtonDisabled(button: UIButton) -> Bool {
        return !button.isEnabled
    }
    
    @objc
    private func mainMenuButtonWasTapped() {
        interactor.loadMainMenuScene(Model.MainMenu.Request())
    }
    
    @objc
    private func userButtonWasTapped() {
        interactor.loadUserProductsList(Model.UserProducts.Request())
    }
    
    @objc
    private func enemyButtonWasTapped() {
        interactor.loadEnemyProductsList(Model.EnemyProducts.Request())
    }
    
    @objc
    private func rightArrowButtonWasTapped() {
        interactor.loadNextProduct(Model.NextProduct.Request(arrowButtonSide: "right", curViewedProductIndex: curViewedProductIndex, isUserButtonPressed: !userButton.isEnabled))
    }
    
    @objc
    private func leftArrowButtonWasTapped() {
        interactor.loadNextProduct(Model.NextProduct.Request(arrowButtonSide: "left", curViewedProductIndex: curViewedProductIndex, isUserButtonPressed: !userButton.isEnabled))
    }
    
    @objc
    private func productBuySetButtonWasTapped() {
        interactor.loadNewProductStatus(Model.NewProductStatus.Request(curViewedProductIndex: curViewedProductIndex, isUserButtonPressed: !userButton.isEnabled))
    }
}

// MARK: - DisplayLogic
extension ShopViewController: ShopDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.curLanguage = viewModel.lng
        self.configureUI()
    }
    
    func displayMainMenuScene(_ viewModel: Model.MainMenu.ViewModel) {
        router.routeToMainMenuViewController()
    }
    
    func displayUserProductsList(_ viewModel: Model.UserProducts.ViewModel) {
        changeEnemyUserButtonStatusToEnabled(button: enemyButton)
        changeEnemyUserButtonStatusToDisabled(button: userButton)
        changeArrowButtonStatusToDisabled(arrowButton: leftArrowButton)
        changeArrowButtonStatusToEnabled(arrowButton: rightArrowButton)
        curViewedProductIndex = 0
        productNameLabel.text = Product.user.productsList[curViewedProductIndex]
        let image = UIImage(systemName: ProductsManager.shared.getImageName(product: Product.user.productsList[curViewedProductIndex]), withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 62, weight: .regular)))
        productImageView.image = image
        if viewModel.isFirstUsed {
            productBuySetButton.setTitle("used".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
            productBuySetButton.setTitleColor(.gray, for: .normal)
            productBuySetButton.isEnabled = false
        } else {
            productBuySetButton.setTitle("set".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
            productBuySetButton.setTitleColor(.white, for: .normal)
            productBuySetButton.isEnabled = true
        }
    }
    
    func displayEnemyProductsList(_ viewModel: Model.EnemyProducts.ViewModel) {
        changeEnemyUserButtonStatusToDisabled(button: enemyButton)
        changeEnemyUserButtonStatusToEnabled(button: userButton)
        changeArrowButtonStatusToDisabled(arrowButton: leftArrowButton)
        changeArrowButtonStatusToEnabled(arrowButton: rightArrowButton)
        curViewedProductIndex = 0
        productNameLabel.text = Product.enemy.productsList[curViewedProductIndex]
        let image = UIImage(named: ProductsManager.shared.getImageName(product: Product.enemy.productsList[curViewedProductIndex]))
        productImageView.image = image
        if viewModel.isFirstUsed {
            productBuySetButton.setTitle("used".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
            productBuySetButton.setTitleColor(.gray, for: .normal)
            productBuySetButton.isEnabled = false
        } else {
            productBuySetButton.setTitle("set".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
            productBuySetButton.setTitleColor(.white, for: .normal)
            productBuySetButton.isEnabled = true
        }
    }
    
    func displayNextProduct(_ viewModel: Model.NextProduct.ViewModel) {
        curViewedProductIndex = viewModel.curViewedProductIndex
        productNameLabel.text = viewModel.productName
        productImageView.image = viewModel.productImage
        if viewModel.isProductBoundaryInList {
            if viewModel.arrowButtonSide == "right" {
                changeArrowButtonStatusToDisabled(arrowButton: rightArrowButton)
            } else {
                changeArrowButtonStatusToDisabled(arrowButton: leftArrowButton)
            }
        }
        if viewModel.arrowButtonSide == "right" {
            if curViewedProductIndex == 1 {
                changeArrowButtonStatusToEnabled(arrowButton: leftArrowButton)
            }
        } else {
            if curViewedProductIndex == Product.user.productsList.count - 2 {
                changeArrowButtonStatusToEnabled(arrowButton: rightArrowButton)
            }
        }
        if viewModel.status == "used" {
            productBuySetButton.setTitle("used".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
            productBuySetButton.setTitleColor(.gray, for: .normal)
            productBuySetButton.isEnabled = false
        } else if viewModel.status == "set" {
            productBuySetButton.setTitle("set".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
            productBuySetButton.setTitleColor(.white, for: .normal)
            productBuySetButton.isEnabled = true
        } else {
            productBuySetButton.setTitle("buy: 1000 coins".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
            productBuySetButton.setTitleColor(.white, for: .normal)
            productBuySetButton.isEnabled = true
        }
    }
    
    func displayNewProductStatus(_ viewModel: Model.NewProductStatus.ViewModel) {
        if viewModel.newStatus == "set" {
            coinsLabel.text = "Coins: \(UserDefaults.standard.integer(forKey: "coins"))"
            productBuySetButton.setTitle("set".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
            productBuySetButton.setTitleColor(.white, for: .normal)
            productBuySetButton.isEnabled = true
        } else if viewModel.newStatus == "used" {
            productBuySetButton.setTitle("used".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
            productBuySetButton.setTitleColor(.gray, for: .normal)
            productBuySetButton.isEnabled = false
        }
    }
}


