//****************************************************************************
//
//       Nome: SuperDOMViewController
//  Descrição:
//
//    Criação: 06/12/2017  v1.0    Luís Felipe Polo
// Modificado: 23/07/2018  v1.3.6  Luís Felipe Polo
//             - Usar AssetId como identificador de ativos
//             03/10/2018  v1.3.12  Luís Felipe Polo
//             - Manter a última quantidade informada pelo usuário na boleta
//             06/03/2019  v1.3.52  Guilherme Cardoso Soares
//             - Nova classe de Logs
//             11/03/2019  v1.3.52  Guilherme Cardoso Soares
//             - Incremento e decremento do stepper devem ir para o próximo valor válido (e não variar conforme o lote/incremento)
//             19/03/2019  v1.3.54  Guilherme Cardoso Soares
//             - Novas cores para a boleta do SuperDOM
//             20/03/2019  v1.3.54  Guilherme Cardoso Soares
//             - Novas cores para a boleta do SuperDOM
//             27/03/2019  v1.3.56  Guilherme Cardoso Soares
//             - Nova Classe de Logs: Novas informações sendo registradas
//****************************************************************************

import UIKit
import AudioToolbox
import SwiftUI
import sharedProfitPackage

class SuperDOMViewController: BaseViewController, UITextFieldDelegate, InnerScrollControllerExtension
{
  // MARK: IBOutlets
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var netrixTableView: UITableView!
  @IBOutlet weak var orderEntryView: UIView!
  
  @IBOutlet weak var sellLimitButton: CustomButton!
  @IBOutlet weak var sellMarketButton: CustomButton!
  @IBOutlet weak var invertButton: CustomButton!
  @IBOutlet weak var resetButton: CustomButton!
  @IBOutlet weak var buyLimitButton: CustomButton!
  @IBOutlet weak var buyMarketButton: CustomButton!
  @IBOutlet weak var lbPrice: UILabel!
  @IBOutlet weak var lbQty: UILabel!
  @IBOutlet weak var editOrderView: UIView!
  @IBOutlet weak var editOrderHeight: NSLayoutConstraint!
  @IBOutlet weak var orderEntryHeight: NSLayoutConstraint!
  @IBOutlet weak var headerViewTop: NSLayoutConstraint!
  @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
    
  @IBOutlet weak var editButton: CustomButton!
  @IBOutlet weak var priceLabelEdition: UILabel!
  @IBOutlet weak var qtyLabelEdition: UILabel!
  
  @IBOutlet var headerSwipeBoletaView: UIView!
  @IBOutlet var swipeIndicatorView: UIView!
  @IBOutlet var headerSwipeBoletaHeight: NSLayoutConstraint!
  @IBOutlet var boletaBackgroundView: UIView!
  @IBOutlet var boletaBackgroundHeight: NSLayoutConstraint!
  @IBOutlet var positionView: UIView!
  @IBOutlet var orderTypeBackgroundView: UIView!
  @IBOutlet var orderTypeAndCountLabel: UILabel!
  @IBOutlet var priceLabel: UILabel!
  @IBOutlet var resultLabel: UILabel!
  @IBOutlet var orderTypeTop: NSLayoutConstraint!
  @IBOutlet var positionViewHeight: NSLayoutConstraint!
  @IBOutlet var resultTapView: UIView!
  
  @IBOutlet var footerBottomConstraint: NSLayoutConstraint!
  @IBOutlet var boletaFooterBottomConstraint: NSLayoutConstraint!
  
  // New Stepper Layout Outlets
  @IBOutlet var decrementPriceButtonEntryOrder: CustomButton!
  @IBOutlet var priceTextFieldEntryOrder: ProfitTextField!
  @IBOutlet var incrementPriceButtonEntryOrder: CustomButton!
  var priceEntryOrder: CustomStepper = CustomStepper(min: 0, max: Double.infinity, step: 0.01, initialValue: 0)
  
  @IBOutlet var decrementQtyButtonEntryOrder: CustomButton!
  @IBOutlet var qtyTextFieldEntryOrder: ProfitTextField!
  @IBOutlet var incrementQtyButtonEntryOrder: CustomButton!
  var qtyEntryOrder: CustomStepper = CustomStepper(min: 0, max: Double.infinity, step: 0.01, initialValue: 0)
  
  @IBOutlet var decrementPriceButtonEditOrder: CustomButton!
  @IBOutlet var priceTextFieldEditOrder: ProfitTextField!
  @IBOutlet var incrementPriceButtonEditOrder: CustomButton!
  var priceEditOrder: CustomStepper = CustomStepper(min: 0, max: Double.infinity, step: 0.01, initialValue: 0)
  
  @IBOutlet var decrementQtyButtonEditOrder: CustomButton!
  @IBOutlet var qtyTextFieldEditOrder: ProfitTextField!
  @IBOutlet var incrementQtyButtonEditOrder: CustomButton!
  var qtyEditOrder: CustomStepper = CustomStepper(min: 0, max: Double.infinity, step: 0.01, initialValue: 0)

  @IBOutlet var strategyTitleLabel: UILabel!
  @IBOutlet var strategyTextField: ProfitTextField!
  @IBOutlet var goToStrategyButton: CustomButton!

  @IBOutlet var resultTitleLabel: UILabel!
  @IBOutlet var accountView: UIView!
  @IBOutlet var accountArrowImageView: UIImageView!
  @IBOutlet var accountInformation: UILabel!
  
  // new chart trading
  @IBOutlet weak var boletaNova: UIView!
  
  @IBOutlet weak var dayTradeStackView: UIStackView!
  @IBOutlet weak var dayTradeSwitch: UISwitch!
  @IBOutlet weak var dayTradeLabel: UILabel!
  @IBOutlet weak var dayTradeStackViewHeight: NSLayoutConstraint!
    
  // MARK: - Properties
  var m_aidPreviousAssetId: AssetIdentifier? = nil

  var m_dicOrderBuyQtyByPrice     : [String: QtyAtPriceItem] = [:] // Qtd de compra e tipo das ordens para um determinado nível de preço
  var m_dicOrderSellQtyByPrice    : [String: QtyAtPriceItem] = [:] // Qtd de venda e tipo das ordens para um determinado nível de preço
  var m_dicStrategyBuyQtyByPrice  : [String: QtyAtPriceItem] = [:] // Qtd de compra e tipo das estrategias para um determinado nível de preço
  var m_dicStrategySellQtyByPrice : [String: QtyAtPriceItem] = [:] // Qtd de venda e tipo das estrategis para um determinado nível de preço
  
  var m_arNetrix: [SuperDOMItem] = []

  var m_nFloatDigits: Int = 2
  var m_sMinIncrement = 0.01
  var m_sAvgPrice: Double? = nil
  var m_sSelectedPrice: Double? = nil
  var lastSelectedPrice: Double? = nil
  var m_sdSelectedSide: Side? = nil
  var m_ttTradeType: TradeType? = nil
  var m_nLastTradeQty: Int? = nil
  var m_sLastTrade: Double? = nil
  var m_sLastTradeAprox: Double? = nil
  var netrixCellHeight: CGFloat = 34
  var positionViewOpenHeight: CGFloat = 22
  
  weak var bookViewController: BookViewController? = nil
  var delegateVC: BaseViewController? = nil

  var slideMenu: SlideMenuController!
  // Controla scroll
  var m_bIsScrolling              : Bool                    = false
  var m_nRowsFromCenter           : Int                     = 0
  
  // Edição de preço via longpress and drag and drop
  var m_sEditFromPrice: Double? = nil
  var m_sdEditSide: Side? = nil
  var m_sLongPressCurrentPrice: Double? = nil
  
  // Edição de estratégia via longpress e drag&drop
  var m_sEditStrategyFromPrice: Double? = nil
  var m_sdEditStrategySide: Side? = nil
  var m_sStrategyLongPressCurrentPrice: Double? = nil
  var m_otEditStrategyOrderType: OrderType? = nil
  var m_nEditStrategyQtd: Int = 0
  
  var m_bIsDraggingStrategy: Bool = false

  // Order entry views
  var boletaOriginalY     : CGFloat   = 0
  var orderEntryViewHeight        : CGFloat   = 210
  let editOrderViewHeight         : CGFloat   = 100
  var m_cgpLastTouchLocation      : CGPoint?  = nil
  var viewHeight  : CGFloat = 0
  var m_nEditQty = 0
  var m_otEditOrderType = OrderType.botlimit
  
  var isUsingFractionary: Bool = false
  
  var m_osStatus                : OrderStatus?      = nil
  var m_strStatusDescription    : String?           = nil
  var keyboardIsOpen            : Bool             = false
  var isPositionSimpleOpenResult: Bool             = true
  var boletaIsHidden            : Bool { get {
    return boletaFooterBottomConstraint.constant == orderEntryViewHeight || boletaFooterBottomConstraint.constant == editOrderViewHeight
    }}

  let app = Application.m_application
  
  var m_sMaxPrice : Double? {
    didSet {
      if oldValue != m_sMaxPrice {
        optimizedLoadNetrixData()
      }
    }
  }
  
  var m_sMinPrice : Double? {
    didSet {
      if oldValue != m_sMinPrice {
        optimizedLoadNetrixData()
      }
    }
  }
  
  var contextForLog : String {
    get {
      return "Conta: \(String(describing: account?.strAccountID)), Asset: \(String(describing: m_selectedAsset?.getKey())), PriceEntry: \(priceEntryOrder.value), QtdEntry: \(qtyEntryOrder.value), PriceEdit: \(priceEditOrder.value), QtdEdit: \(qtyEditOrder.value) SwingQty: \(String(describing: account?.GetPosition(a_aidAssetId: m_selectedAsset!)?.getPositionQtyInt()))"
    }
  }
  var lastContentOffset: CGFloat = 0.0
  var lastContentHeight: CGFloat = 0.0
  var setStatusBar: Bool = true
  
  private var account: Account? {
    if let selectedUserWallet: UserWallet = Application.m_application.m_uwSelectedUserWallet {
      return selectedUserWallet
    }
    return Application.m_application.m_acSelectedAccount
  }
  var broker: Broker? {
    guard let account = self.account else { return nil }
    return Application.m_application.m_dicBrokers[account.strBrokerID]
  }
  var isChosenAssetFractionary : Bool = false
  
  var shouldHideInView: [MenuOption] = [.boleta, .superDOM, .charts]

  var showNetrix: Bool {
    (bookViewController?.showNetrix ?? false)
  }
  
  //viewModels
  @available(iOS 13, *) lazy var newOrderEntryViewModel: NewOrderEntryViewModel? = nil
  
  // MARK: - Constraints to be validated
  @IBOutlet var qtyLabelHeaderTopDistance: NSLayoutConstraint!
  @IBOutlet var strategyView: UIView!
  @IBOutlet var strategyWithSize: NSLayoutConstraint!
  @IBOutlet var strategyButtonWithSize: NSLayoutConstraint!
  @IBOutlet var strategyAccountSize: NSLayoutConstraint!
  
  private func showStrategySelectionIfNeeded() {
    let product: Product = Application.m_application.m_userProduct
    if !product.HasOCOStrategy() || Application.m_application.m_userProduct.hasNewChartTrading() {
      strategyTitleLabel.isHidden = true
      strategyView.isHidden = true
      strategyWithSize.isActive = false
      strategyButtonWithSize.isActive = false
      strategyAccountSize.constant = 0
    } else {
      strategyTitleLabel.isHidden = false
      strategyView.isHidden = false
      strategyWithSize.isActive = true
      strategyButtonWithSize.isActive = true
      strategyAccountSize.constant = 7
    }
  }
  
  @objc private func lockStrategySelectionIfNeeded() {
    if Application.m_application.isHB() {
      return
    }
    strategyView.layer.cornerRadius = 4
    strategyView.backgroundColor = .clear
    strategyView.layer.borderWidth = 0
    guard let account = account, let broker = broker, let hasOCOSupport = broker.bHasOCO else {
      // LOCK
      strategyView.isUserInteractionEnabled = false
      strategyView.alpha = 0.5
      return
    }
    strategyView.isUserInteractionEnabled = hasOCOSupport
    strategyView.alpha = hasOCOSupport ? 1 : 0.5
  }
  
  
  // MARK: - Life cycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    if newStockDetailViewController != nil {
      SetupStatusBarView()
      delegateVC = newStockDetailViewController
    } else {
      bookViewController?.SetupStatusBarView()
      delegateVC = bookViewController
    }
    
    setupDayTradeSwitch()
    
    title = Localization.localizedString(key: LocalizationKey.SuperDOM_Title)
    setTitle(a_strTitle: Localization.localizedString(key: LocalizationKey.SuperDOM_Title))
    
    let tapAccount = UITapGestureRecognizer(target: self, action: #selector(tapAccountView(sender:)))
    accountView.addGestureRecognizer(tapAccount)
    accountArrowImageView.isHidden = !Application.m_application.allowSelectAccount()

    /// Remove observer para não alert de senha errada 2 vezes, todas as classes internas já tem esssa notificação
    NotificationCenter.default.removeObserver(self, name: PasswordChangedNotification, object: nil)

    SlideMenuOptions.simultaneousGestureRecognizers = true

    netrixTableView.register(NeTrixTableViewCell.loadNib(), forCellReuseIdentifier: NeTrixTableViewCell.identifier)
    
    netrixTableView.delegate = self

    // Gestures
    let tapKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tapKeyboard)

    let longpress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
    netrixTableView.addGestureRecognizer(longpress)

    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapGesture(sender:)))
    netrixTableView.addGestureRecognizer(tap)
    
    let resultTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onResultTap))
    resultTapView.addGestureRecognizer(resultTap)
    
    let headerSwipeBoletaTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onHeaderSwipeBoletaTap))
    headerSwipeBoletaView.addGestureRecognizer(headerSwipeBoletaTap)

    // Colors
    view.backgroundColor = .none
    netrixTableView.backgroundColor = Colors.BookBackgroundColor //Colors.PosComponentBackgroundColor
    netrixTableView.separatorStyle = .none
    headerView.backgroundColor = Colors.PosComponentBackgroundColor
    priceLabel.textColor = Colors.StrResultFontColor
    orderTypeAndCountLabel.textColor = Colors.StrResultFontColor
    resultTapView.backgroundColor = .none
    
    qtyTextFieldEntryOrder.isQtdField = true

    headerViewHeightConstraint.constant = Sizes.getTitleDefaultBoxHeight(titleType: .columnTitle)
    #if VectorFree
    newOrderEntryViewModel = NewOrderEntryViewModel(source: .superdom, selectedAsset: m_selectedAsset, usesStopOffset: true, newOrderEntryDelegate: self)
    self.setNewChartTradingView()
    #endif
  }
  
  func toggleOrderEntryElements(isHidden: Bool) {
    sellLimitButton?.isHidden = isHidden
    sellMarketButton?.isHidden = isHidden
    invertButton?.isHidden = isHidden
    resetButton?.isHidden = isHidden
    buyLimitButton?.isHidden = isHidden
    buyMarketButton?.isHidden = isHidden
    lbPrice?.isHidden = isHidden
    lbQty?.isHidden = isHidden
    editOrderView?.isHidden = isHidden
    
    decrementPriceButtonEntryOrder?.isHidden = isHidden
    priceTextFieldEntryOrder?.isHidden = isHidden
    incrementPriceButtonEntryOrder?.isHidden = isHidden
    
    decrementQtyButtonEntryOrder?.isHidden = isHidden
    qtyTextFieldEntryOrder?.isHidden = isHidden
    incrementQtyButtonEntryOrder?.isHidden = isHidden
    
    decrementPriceButtonEditOrder?.isHidden = isHidden
    priceTextFieldEditOrder?.isHidden = isHidden
    incrementPriceButtonEditOrder?.isHidden = isHidden
    
    decrementQtyButtonEditOrder?.isHidden = isHidden
    qtyTextFieldEditOrder?.isHidden = isHidden
    incrementQtyButtonEditOrder?.isHidden = isHidden

    strategyView?.isHidden = isHidden
    strategyTitleLabel?.isHidden = isHidden
    strategyTextField?.isHidden = isHidden
    goToStrategyButton?.isHidden = isHidden

    resultTitleLabel?.isHidden = isHidden
    accountView?.isHidden = isHidden
    accountArrowImageView?.isHidden = isHidden
    accountInformation?.isHidden = isHidden
  }

  func setNewChartTradingView() {
    if #available(iOS 14, *), Application.m_application.m_userProduct.hasNewChartTrading() {
      boletaNova?.isHidden = false
      orderEntryView?.isHidden = true
      toggleOrderEntryElements(isHidden: true)

      if let uiView: UIView = getChartTradingUIView() {
        boletaNova?.subviews.forEach({ $0.removeFromSuperview() })
        boletaNova?.addSubview(uiView)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = .clear
        boletaNova?.backgroundColor = .clear
      }
    }
  }
  
  private func getChartTradingUIView() -> UIView? {
    if #available(iOS 14, *) {
      if let viewModel: NewOrderEntryViewModel = newOrderEntryViewModel {
        viewModel.changeAsset(asset: m_selectedAsset)
        viewModel.positionModel?.unsubscribeAll()
        viewModel.positionModel?.selectedAsset = m_selectedAsset
        viewModel.positionModel?.assetChanged()
        let tradingView: ChartTradingView = ChartTradingView(sentOrderAlertModel: viewModel.orderConfirmationControlModel, viewModel: viewModel, chartTradingViewModel: ChartTradingViewModel(usesOnlyDefaultTheme: true, backgroundOpacity: 0.0), orientation: .horizontal, horizontalMargin: 3)
        orderEntryViewHeight = tradingView.getViewHeight()
        return UIHostingController(rootView: tradingView.environmentObject(SwiftUINavigationBridge(navigationController: navigationController ?? UINavigationController()))).view
      }
    }

    return nil
  }

  override func viewWillAppear(_ animated: Bool)
  {
    if let selectedUserWallet: UserWallet = account as? UserWallet, shouldHideInView.contains(where: {$0 == Application.m_application.m_moCurrentView}), selectedUserWallet.wtWalletType == WalletType.wtSignalFollower{
      Application.m_application.selectAccount(a_strBrokerId: selectedUserWallet.strBrokerID, a_strAccount: selectedUserWallet.strAccountID, a_uwUserWallet: nil)
    }
    Common.print("viewWillAppear superDOM")
    assetWillCreate()
    super.viewWillAppear(animated)

    setupDayTradeSwitch()
    configBoleta()

    dayTradeSwitch.isOn = Application.m_application.m_bSwitchDayTradeMode
    
    netrixCellHeight = Application.m_application.isHB() ? 42 : 34
    netrixTableView.estimatedRowHeight = netrixCellHeight
    
    (headerView.viewWithTag(1) as? UILabel)?.setColumnHeaderTitleFormatting(text: Localization.localizedString(key: LocalizationKey.SuperDOM_BuyQty))
    (headerView.viewWithTag(2) as? UILabel)?.setColumnHeaderTitleFormatting(text: Localization.localizedString(key: LocalizationKey.Boleta_Price))
    (headerView.viewWithTag(3) as? UILabel)?.setColumnHeaderTitleFormatting(text: Localization.localizedString(key: LocalizationKey.SuperDOM_SellQty))
    showSelector()

    // edição do textfield via teclado
    priceTextFieldEditOrder.delegate = self
    priceTextFieldEntryOrder.delegate = self
    qtyTextFieldEntryOrder.delegate = self
    qtyTextFieldEditOrder.delegate = self

    Application.m_application.m_oMsgManager.m_strProfitIdLastOrder = nil
    Application.m_application.m_oMsgManager.m_nMsgIdLastOrder = nil
    ///observer para quando o teclado vai aparecer na tela
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    ///observer para quando o teclado vai desaparecer da tela
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)

    setupCustomStepper(decrementButton: decrementPriceButtonEntryOrder, valueField: priceTextFieldEntryOrder, incrementButton: incrementPriceButtonEntryOrder)
    setupCustomStepper(decrementButton: decrementQtyButtonEntryOrder, valueField: qtyTextFieldEntryOrder, incrementButton: incrementQtyButtonEntryOrder)
    setupCustomStepper(decrementButton: decrementPriceButtonEditOrder, valueField: priceTextFieldEditOrder, incrementButton: incrementPriceButtonEditOrder)
    setupCustomStepper(decrementButton: decrementQtyButtonEditOrder, valueField: qtyTextFieldEditOrder, incrementButton: incrementQtyButtonEditOrder)

    strategyTitleLabel.textColor = Colors.clBoletaSuperDOMLabel
    strategyTextField.borderStyle = .none
    strategyTextField.layer.borderWidth = 1.2
    strategyTextField.clipsToBounds = true
    strategyTextField.layer.cornerRadius = 4
    strategyTextField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    strategyTextField.layer.borderColor = Colors.clStepperTextFieldBorderAtSuperDOM.cgColor
    strategyTextField.setLeftPaddingPoints(5)

    dayTradeLabel.attributedText = NSMutableAttributedString(string: Localization.localizedString(key: LocalizationKey.Boleta_DayTrade).uppercased(), attributes: [NSAttributedString.Key.font: Common.font(ofSize: 10, weight: UIFont.Weight.semibold)])
    dayTradeLabel.textColor = Colors.clBoletaSuperDOMLabel
    dayTradeSwitch.isOn = Application.m_application.m_bSwitchDayTradeMode
    
    strategyTextField.delegate = self

    accountInformation.textColor = Colors.PosDefaultColor

    resultTitleLabel.attributedText = NSMutableAttributedString(string: Localization.localizedString(key: LocalizationKey.General_Account).uppercased(), attributes: [NSAttributedString.Key.font: Common.font(ofSize: 10, weight: UIFont.Weight.semibold)])


    strategyTitleLabel.attributedText = NSMutableAttributedString(string: Localization.localizedString(key: LocalizationKey.Boleta_Strategy).uppercased(), attributes: [NSAttributedString.Key.font: Common.font(ofSize: 10, weight: UIFont.Weight.semibold)])
    resultTitleLabel.textColor = Colors.clBoletaSuperDOMLabel


    goToStrategyButton.layer.cornerRadius = 0
    goToStrategyButton.roundCorners(corners: [.topRight, .bottomRight], radius: 2)
    goToStrategyButton.gradientColor = false
    goToStrategyButton.backgroundColor = Colors.clStepperButtonsAtSuperDOM
    goToStrategyButton.bgColor = Colors.clStepperButtonsAtSuperDOM

    accountView.layer.cornerRadius = 4.0
    accountView.layer.borderWidth = 1.2
    accountView.layer.borderColor = Colors.clStepperTextFieldBorderAtSuperDOM.cgColor

    receivedStrategyNotification()
    headerViewTop.constant = 0
    self.accountInformation.text = Localization.localizedString(key: LocalizationKey.SendOrderStatus_NoAccountSelected)

    self.accountView.backgroundColor =  Colors.clStepperTextFieldAtSuperDOM

    updateViewAccount()

    resetButton.setTitle(app.m_bCancelAndClear ? Localization.localizedString(key: LocalizationKey.ChartTrading_CancelAndReset) : Localization.localizedString(key: LocalizationKey.Livro_Reset), for: .normal)

    Application.m_application.m_alertManager.setDelegate(bookViewController ?? self)

    if Application.m_application.m_userProduct.hasSuperDom() && !self.showNetrix
    {
      boletaBackgroundView.isHidden = false
      updateNetrixTableInsets()
      setPositionView()
    } else {
      positionViewHeight.constant = 0
      positionView.isHidden = true
      hideBoleta()
      boletaBackgroundHeight.constant = 0
      boletaBackgroundView.isHidden = true
    }


    if let assetInfo = m_selectedAssetInfo, ExchangeManager.shared.isItReplayMarket(nExchange: assetInfo.m_aidAssetId.m_nMarket.kotlin) == false {
      if let defaultQty = m_selectedAssetInfo?.getQtdDefault(), let assetID = m_selectedAssetInfo?.m_aidAssetId {
        qtyEntryOrder.value = Double(defaultQty)
        qtyTextFieldEntryOrder.text = Common.formatQtyToString(value: Int(qtyEntryOrder.value), forAsset: assetID, makeShort: false)
      }
    }

    self.navigationController?.setStatusBar(backgroundColor: Colors.primaryColor)
    
    if Application.m_application.isGenial() {
      NotificationCenter.default.addObserver(self, selector: #selector(genialSsoErrorAlert), name: GenialSsoError, object: nil)
    }
    
    if #available(iOS 13.0, *) {
      newOrderEntryViewModel?.onAppear()
      self.setNewChartTradingView()
    }
  }
  
  @objc func updateViewAccount() {
    #if targetEnvironment(macCatalyst)
    if account != nil {
      updateAccountInfo()
      return
    }
    #endif
    if let selectedWallet: UserWallet = Application.m_application.m_uwSelectedUserWallet{
      switchAccounts(newAccount: selectedWallet)
    } else if let account = Application.m_application.m_acSelectedAccount {
      switchAccounts(newAccount: account)
    }
  }
  
  func switchAccounts(newAccount: Account) {
    updateAccountInfo()
  }
  
  func updateAccountInfo() {
    guard let account = account, let test = broker?.bTestBroker else { return }
    self.accountInformation.attributedText = account.getAccountInformationAttributedString(forOrderEntry: true)
    
    if test {
      self.accountView.backgroundColor = Colors.clChartTradingTestAccount
    } else {
      self.accountView.backgroundColor = Colors.clStepperTextFieldAtSuperDOM
    }
    self.accountInformation.textColor = Colors.PosDefaultColor
    
    if Application.m_application.m_userProduct.IsBTG()
    {
      Common.setBTGAccountViewColors(view: accountView, label: accountInformation)
    }
    loadAccountDependantInfo()
  }
  
  func loadAccountDependantInfo() {
    loadOrderData()
    if let priceBookAssetID = m_selectedAsset
    {
      setPositionView()
      if let account = account, let position = account.GetPosition(a_aidAssetId: priceBookAssetID) {
        position.addToUpdateList(self)
      }
    }
  }
  
  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    coordinator.animate(alongsideTransition: nil,
      completion: { context in
        if let location = self.m_cgpLastTouchLocation, let indexPath = self.netrixTableView.indexPathForRow(at: location) {
          self.netrixTableView.scrollToRow(at: indexPath, at: .none, animated: false)
        }
      }
    )
  
    if #available(iOS 13, *) {
      newOrderEntryViewModel?.objectWillChange.send()
    }
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: nil,
      completion: { context in
        if let location = self.m_cgpLastTouchLocation, let indexPath = self.netrixTableView.indexPathForRow(at: location) {
          self.netrixTableView.scrollToRow(at: indexPath, at: .none, animated: false)
        }
      })
  }
  
  func addBottomBorderWithColor(view: UIView, color: UIColor) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 5, y: view.frame.size.height, width: view.frame.size.width - 10, height: 1)
    view.layer.addSublayer(border)
  }
  
  func assetWillCreate() {
    
    if let priceBookOrderEntry = app.getDayTradeAssetID(), let priceBook = m_selectedAsset, let stock = m_selectedStock
    {
      isChosenAssetFractionary = stock.isFractionary()
      if priceBookOrderEntry != priceBook
      {
        Common.print("SUPERDOM SENDUNSUBSCRIBE ALL")
        
        if let assetInfo = Application.m_application.m_dicAssetInfo[priceBook.getKey()], assetInfo.hasFractionary() {
          unsubscribeFractionaryStock(assetInfo.getFractionaryAssetId())
        }

        stock.removeFromUpdateList(self)
      }
        
      if m_aidPreviousAssetId != priceBook
      {
        qtyTextFieldEntryOrder.text = ""
        qtyTextFieldEditOrder.text = ""
        m_sSelectedPrice = nil
        hideBoleta()
      }
      
      m_aidPreviousAssetId = priceBook
    }
    
    let app = Application.m_application
    let asset = self.showNetrix ? (app.getPriceBookAssetID() ?? app.getLastAsset()) : (app.getSuperDOMAssetID() ?? app.getLastAsset())
    m_selectedAsset = asset
  }
  
  override func windowCreateStatistics() {
    Statistics.shared.log(type: .stWindowCreate, message: "SuperDOM")
  }

  override func viewDidAppear(_ animated: Bool){
    super.viewDidAppear(animated)

    Common.print("viewDidAppear superDOM")
    if newStockDetailViewController != nil {
      Application.m_application.m_moCurrentView = .superDOM
    }
    m_nRowsFromCenter = 0
    m_sEditFromPrice = nil
    m_sdEditSide = nil
    m_sLongPressCurrentPrice = nil
    m_bIsScrolling = false

    resetButton.isEnabled = true
    invertButton.isEnabled = true

    NotificationCenter.default.removeObserver(self, name: UpdateLastOrderNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: NewOrderNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: NewPositionNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: AssetStateChange, object: nil)
    NotificationCenter.default.removeObserver(self, name: OCOStrategySelectedNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: BrokerInfoUpdatedNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: OCOStrategyNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: AccountChangedNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: AccountReceivedNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(NewOrder), name: NewOrderNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(UpdateLastOrderStatus), name: UpdateLastOrderNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(receivedNewPositionNotification), name: NewPositionNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateViewRightBarButtons), name: AssetStateChange, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(receivedStrategyNotification), name: OCOStrategySelectedNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(lockStrategySelectionIfNeeded), name: BrokerInfoUpdatedNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ocoStrategyChanged), name: OCOStrategyNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(StrategyRejected), name: StrategyRejectedNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(StrategyAlert), name: StrategyAlertNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateViewAccount), name: AccountChangedNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateViewAccount), name: AccountReceivedNotification, object: nil)
    subscribeAll()
  }

  func subscribeAll() {

    m_sMaxPrice = nil
    m_sMinPrice = nil
    loadOrderData()
    
    if let stock = m_selectedStock
    {
      stock.addToUpdateList(self, extra: .PriceBook)
      _ = self.updateTickerButton(a_strTicker: stock.m_aidAssetID.getKey(), setButtonsInBaseVC: false)

      if let assetInfo = m_selectedAssetInfo {
        assetInfo.addToUpdateList(self)
        
        if let minIncrement = assetInfo.sMinPriceIncrementBook {
          m_sMinIncrement = minIncrement
        }
        m_nFloatDigits = assetInfo.nDigitsPrice ?? assetInfo.nFloatDigits
        if let minIncrement = assetInfo.sMinPriceIncrementBook {
          priceEditOrder.stepValue = assetInfo.sMinOrderPriceIncrement ?? Double(minIncrement)
          priceEntryOrder.stepValue = assetInfo.sMinOrderPriceIncrement ?? Double(minIncrement)
        }
        else {
          priceEditOrder.stepValue = assetInfo.sMinOrderPriceIncrement ?? Double(0.01)
          priceEntryOrder.stepValue = assetInfo.sMinOrderPriceIncrement ?? Double(0.01)
        }
        if let lote = assetInfo.nLote{
          qtyEditOrder.stepValue = Double(lote)
          qtyEntryOrder.stepValue = Double(lote)
        }
        if let minQtd = assetInfo.nMinOrderQtd {
          qtyEditOrder.minimumValue = Double(minQtd)
          qtyEntryOrder.minimumValue = Double(minQtd)

        }
        if assetInfo.hasFractionary() {
          subscribeFractionaryStock(assetInfo.getFractionaryAssetId())
        }
      }

      if let price = m_sSelectedPrice
      {
        setSelectedPrice(a_sPrice: price)
        priceTextFieldEntryOrder.text = Common.formatStringfrom(value: price, minDigits: m_nFloatDigits, maxDigits: m_nFloatDigits)
      }
        Common.print("SUPERDOM SENDSUBSCRIBE ALL")
      let extras: [StockUpdateExtras] = [.PriceBook, .Daily, .TinyBook, .Theoric]
      stock.addExtraSubscriptions(self, extras: extras)
      setPositionView()
      
      if let account = account, let position = account.GetPosition(a_aidAssetId: stock.m_aidAssetID) {
        position.addToUpdateList(self)
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool)
  {
    hideBoleta()
    super.viewWillDisappear(animated)
    
    unsubscribeAll()
    
    if Application.m_application.m_moCurrentView != .superDOM
    {
      return
    }

    if newStockDetailViewController == nil {
      replayBarView?.removeFromSuperview()
      NotificationCenter.default.removeObserver(self, name: ReplayFinished, object: nil)

      if let stock = m_selectedStock {
        stock.removeExtraSubscriptions(self, extras: [.PriceBook, .Daily, .Trade, .TinyBook, .Theoric])
      }
    }
    
    NotificationCenter.default.removeObserver(self, name: UpdateLastOrderNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: NewOrderNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: OCOStrategySelectedNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: BrokerInfoUpdatedNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: OCOStrategyNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: NewPositionNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: AssetStateChange, object: nil)
    NotificationCenter.default.removeObserver(self, name: StrategyRejectedNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: StrategyAlertNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: AccountChangedNotification, object: nil)
    if Application.m_application.isGenial() {
      NotificationCenter.default.removeObserver(GenialSsoError)
    }
    
    if #available(iOS 13, *) {
      newOrderEntryViewModel?.onDisappear()
    }
  }

  override func viewDidDisappear(_ animated: Bool)
  {
    super.viewDidDisappear(animated)
    keyboardIsOpen = false

    Application.m_application.m_oMsgManager.m_strProfitIdLastOrder = nil
    Application.m_application.m_oMsgManager.m_nMsgIdLastOrder = nil
    
    delegateVC?.m_messageView?.isHidden = true
  }

  override func viewDidLayoutSubviews()
  {
    Common.print("viewDidLayoutSubviews superDOM")
    super.viewDidLayoutSubviews()
    showStrategySelectionIfNeeded()
    lockStrategySelectionIfNeeded()
    setupBoletaCorners()
    
    self.view.setNeedsUpdateConstraints()
    self.view.layoutIfNeeded()
    self.view.updateConstraintsIfNeeded()
  }

  func setupCustomStepper(decrementButton: CustomButton, valueField: ProfitTextField, incrementButton: CustomButton) {
    decrementButton.layer.cornerRadius = 0
    incrementButton.layer.cornerRadius = 0

    decrementButton.roundCorners(corners: [.topLeft, .bottomLeft], radius: 2)
    incrementButton.roundCorners(corners: [.topRight, .bottomRight], radius: 2)

    decrementButton.bgColor = Colors.clStepperButtonsAtSuperDOM
    decrementButton.tintColor = .white

    incrementButton.bgColor = Colors.clStepperButtonsAtSuperDOM
    incrementButton.tintColor = .white


    valueField.borderStyle = .roundedRect
    valueField.layer.borderWidth = 1.2
    valueField.layer.borderColor = Colors.clStepperTextFieldBorderAtSuperDOM.cgColor
    valueField.backgroundColor = Colors.clStepperTextFieldAtSuperDOM

    _ = valueField.changeClearButton(withColor: .white)

  }

  @IBAction func incButtonDidTap(_ sender: CustomButton) {
    guard let priceBookAssetID = m_selectedAsset else {
      return
    }

    if let info = Application.m_application.m_dicAssetInfo[priceBookAssetID.getKey()] {
      if sender == incrementPriceButtonEntryOrder {
        priceEntryOrder.value += priceEntryOrder.stepValue
        priceEntryOrder.value = info.goToNextValidPrice(a_sPrice: priceEntryOrder.value)
        priceTextFieldEntryOrder.text = Common.formatStringfrom(value: priceEntryOrder.value, minDigits: m_nFloatDigits, maxDigits: m_nFloatDigits)
        m_cgpLastTouchLocation = nil
        setSelectedPrice(a_sPrice: priceEntryOrder.value)
        netrixTableView.optimizedReloadData()
      } else if sender == incrementQtyButtonEntryOrder {
        if Application.m_application.handlesFractionary(), info.hasFractionary(), qtyEntryOrder.value == Double(AssetInfo.bDefaultFractionaryMaxOrderQtd), ExchangeManager.shared.isItReplayMarket(nExchange: info.m_aidAssetId.m_nMarket.kotlin) == false, isChosenAssetFractionary == false, let fracInfo = info.getFractionaryAssetInfo() {
          qtyEntryOrder.value = Double(AssetInfo.bDefaultNonFractionaryMinOrderQtd)
          qtyTextFieldEntryOrder.text = Common.formatQtyToString(value: Int(qtyEntryOrder.value), forAsset: priceBookAssetID, makeShort: false)
          changeAssetToNonFractionary(assetInfo: fracInfo)
        } else {
          qtyEntryOrder.value += qtyEntryOrder.stepValue
          
          if !info.isValidQtd(a_nQtd: Int(qtyEntryOrder.value)) {
            if let fracInfo = app.m_dicAssetInfo[info.getFractionaryAssetId().getKey()], fracInfo.isValidQtd(a_nQtd: Int(qtyEntryOrder.value)) {
              qtyEntryOrder.value = fracInfo.goToPreviousValidQtd(a_nQtd: Int(qtyEntryOrder.value))
            } else if isChosenAssetFractionary {
              qtyEntryOrder.value = Double(info.nMaxOrderQtd ?? AssetInfo.bDefaultFractionaryMaxOrderQtd)
            } else {
              qtyEntryOrder.value = info.goToNextValidQtd(a_nQtd: Int(qtyEntryOrder.value))
            }
          }
          
          qtyTextFieldEntryOrder.text = Common.formatQtyToString(value: Int(qtyEntryOrder.value), forAsset: priceBookAssetID, makeShort: false)
        }
      } else if sender == incrementQtyButtonEditOrder {
        let hasFracOrderOnCurrentPrice = account?.hasFractionaryOrderOnPrice(assetInfo: info, price: priceEditOrder.value)
        if info.isValidQtd(a_nQtd: Int(qtyEntryOrder.value)), info.nLote != nil, hasFracOrderOnCurrentPrice == false {
          qtyEditOrder.value += qtyEditOrder.stepValue
          qtyEditOrder.value = info.goToNextValidQtd(a_nQtd: Int(qtyEditOrder.value))
        } else if info.hasFractionary(), let fracInfo = app.m_dicAssetInfo[info.getFractionaryAssetId().getKey()], let stepValue = fracInfo.nLote, fracInfo.nMaxOrderQtd != nil{
          qtyEditOrder.value += Double(stepValue)
        }

        qtyTextFieldEditOrder.text = Common.formatQtyToString(value: Int(qtyEditOrder.value), forAsset: priceBookAssetID, makeShort: false)
      } else if sender == incrementPriceButtonEditOrder {
        priceEditOrder.value += priceEditOrder.stepValue
        priceEditOrder.value = info.goToNextValidPrice(a_sPrice: priceEditOrder.value)
        priceTextFieldEditOrder.text = Common.formatStringfrom(value: priceEditOrder.value, minDigits: m_nFloatDigits, maxDigits: m_nFloatDigits)
      }
    }
  }

  @IBAction func decButtonDidTap(_ sender: CustomButton) {
    guard let priceBookAssetID = m_selectedAsset else {
      return
    }

    if let info = Application.m_application.m_dicAssetInfo[priceBookAssetID.getKey()] {
      if sender == decrementPriceButtonEntryOrder {
        priceEntryOrder.value -= priceEntryOrder.stepValue
        priceEntryOrder.value = info.goToPreviousValidPrice(a_sPrice: priceEntryOrder.value)
        if priceEntryOrder.value < priceEntryOrder.minimumValue {
          priceEntryOrder.value = priceEntryOrder.minimumValue
        }
        priceTextFieldEntryOrder.text = Common.formatStringfrom(value: priceEntryOrder.value, minDigits: m_nFloatDigits, maxDigits: m_nFloatDigits)
        m_cgpLastTouchLocation = nil
        setSelectedPrice(a_sPrice: priceEntryOrder.value)
        netrixTableView.optimizedReloadData()
      } else if sender == decrementQtyButtonEntryOrder {
        if Application.m_application.handlesFractionary(), info.hasFractionary(), qtyEntryOrder.value == 100, ExchangeManager.shared.isItReplayMarket(nExchange: info.m_aidAssetId.m_nMarket.kotlin) == false {
          qtyEntryOrder.value = 99
          if let fracInfo = app.m_dicAssetInfo[info.getFractionaryAssetId().getKey()], let lote = fracInfo.nLote {
            qtyEntryOrder.stepValue = Double(lote)
          }
          qtyTextFieldEntryOrder.text = Common.formatQtyToString(value: Int(qtyEntryOrder.value), forAsset: priceBookAssetID, makeShort: false)
          changeAssetToFractionary(assetInfo: info)
        } else {
          let newValue = qtyEntryOrder.value - qtyEntryOrder.stepValue
          if newValue <= 0 {
            return
          }
          qtyEntryOrder.value = newValue
          if !info.isValidQtd(a_nQtd: Int(qtyEntryOrder.value)), let fracInfo = app.m_dicAssetInfo[info.getFractionaryAssetId().getKey()], !fracInfo.isValidQtd(a_nQtd: Int(qtyEntryOrder.value)) {
            qtyEntryOrder.value = info.goToPreviousValidQtd(a_nQtd: Int(qtyEntryOrder.value))
            if qtyEntryOrder.value < qtyEntryOrder.minimumValue {
              qtyEntryOrder.value = qtyEntryOrder.minimumValue
            }
          }
          
          qtyTextFieldEntryOrder.text = Common.formatQtyToString(value: Int(qtyEntryOrder.value), forAsset: priceBookAssetID, makeShort: false)
        }
      } else if sender == decrementQtyButtonEditOrder {
        let hasFracOrderOnCurrentPrice = account?.hasFractionaryOrderOnPrice(assetInfo: info, price: priceEditOrder.value)
        if info.isValidQtd(a_nQtd: Int(qtyEntryOrder.value)), let stepValue = info.nLote, let minOrderQtd = info.nMinOrderQtd, hasFracOrderOnCurrentPrice == false {
          qtyEditOrder.value -= Double(stepValue)
          qtyEditOrder.value = info.goToPreviousValidQtd(a_nQtd: Int(qtyEditOrder.value))
          if qtyEditOrder.value < Double(minOrderQtd) {
            qtyEditOrder.value = Double(minOrderQtd)
          }
        } else if info.hasFractionary(), let fracInfo = app.m_dicAssetInfo[info.getFractionaryAssetId().getKey()], let stepValue = fracInfo.nLote, let minOrderQtd = fracInfo.nMinOrderQtd {
          qtyEditOrder.value -= Double(stepValue)
          qtyEditOrder.value = fracInfo.goToPreviousValidQtd(a_nQtd: Int(qtyEditOrder.value))
          if qtyEditOrder.value < Double(minOrderQtd) {
            qtyEditOrder.value = Double(minOrderQtd)
          }
        }
        qtyTextFieldEditOrder.text = Common.formatQtyToString(value: Int(qtyEditOrder.value), forAsset: priceBookAssetID, makeShort: false)
      } else if sender == decrementPriceButtonEditOrder {
        priceEditOrder.value -= priceEditOrder.stepValue
        priceEditOrder.value = info.goToPreviousValidPrice(a_sPrice: priceEditOrder.value)
        if priceEditOrder.value < priceEditOrder.minimumValue {
          priceEditOrder.value = priceEditOrder.minimumValue
        }
        priceTextFieldEditOrder.text = Common.formatStringfrom(value: priceEditOrder.value, minDigits: m_nFloatDigits, maxDigits: m_nFloatDigits)
      }
    }
  }

  // MARK: - ReloadTableView
  @objc private func reloadNetrix() {
    loadNetrixData()
    lastReloadData = Date().timeIntervalSince1970
    bWaitingToReload = false
  }
  
  let waitingToReload : Bool = false
  let lastReload = Date()
  var bWaitingToReload: Bool = false
  var lastReloadData: TimeInterval = 0
  var minDiffToReload: TimeInterval = 0.070

  @objc func optimizedLoadNetrixData()
  {
    let externalAsset = m_selectedAsset
    guard externalAsset == m_selectedAsset else {
      if let asset = externalAsset {
        changeViewAsset(asset)
      }
      return
    }
    let now = Date().timeIntervalSince1970
    let diff = now - lastReloadData
    if diff >= minDiffToReload && !bWaitingToReload {
      lastReloadData = now
      loadNetrixData()
    } else if !bWaitingToReload {
      bWaitingToReload = true
      Timer.scheduledTimer(timeInterval: minDiffToReload - diff, target: self, selector: #selector(self.reloadNetrix), userInfo: nil, repeats: false)
    }
  }
  
  // MARK: - Data
  fileprivate func centerView(offset: Int = 0) {
    if let priceIndex: Int = self.findPrice(a_sPrice: self.m_sLastTrade, arSuperDom: self.m_arNetrix) {
      let nRowIndexPath: IndexPath = IndexPath(row: priceIndex + self.m_nRowsFromCenter + offset, section: 0)
      self.netrixTableView.scrollToRow(at: nRowIndexPath, at: UITableView.ScrollPosition.middle, animated: false)
    }
  }
  
  func loadNetrixData()
  {
    var m_ipCenterIndexPath: IndexPath? = nil
    var arAuxNetrix: [SuperDOMItem] = []
    var minPriceIncrementBook: Double = 0.01
      if let priceBookAssetID = m_selectedAsset, let priceBook = m_selectedStock?.priceBook {
        
        if let sAuxMinPrice = m_selectedAssetInfo?.sMinPriceIncrementBook {
          minPriceIncrementBook = sAuxMinPrice
        } else {
          minPriceIncrementBook = self.m_sMinIncrement
        }
        // Init netrix prices
        guard var maxPrice = self.GetMax() else {
          return
        }

        guard let minPrice = self.GetMin() else {
          return
        }

        maxPrice = Common.roundPriceToNextValidPrice(aidAssetAid: priceBookAssetID, a_sPrice: maxPrice, isBook: true)
        
        var sAuxPrice = maxPrice + minPriceIncrementBook * 5
        var arSuperDomData : [SuperDOMItem] = []
        
        while sAuxPrice > 0 && (sAuxPrice >= minPrice - minPriceIncrementBook * 5 || Common.compareNearlyEqual(a: sAuxPrice, b: minPrice - minPriceIncrementBook * 5)) {
          let domItem = SuperDOMItem(sPrice: sAuxPrice, nQtdBuy: nil, nQtdSell: nil)
          arSuperDomData.append(domItem)
          sAuxPrice -= minPriceIncrementBook
        }
        
        if arSuperDomData.count > 0
        {
          // Update with price book data
          
          var groupedBuyOffers = priceBook.groupedBuyOffers
            if Application.m_application.m_userProduct.IsHomeBroker(){
            groupedBuyOffers = Array(groupedBuyOffers.prefix(Application.m_application.m_userProduct.HBNetrixLimit()))
          }
          
          var indexNetrixArray = 0
          for priceBookOffer in groupedBuyOffers {
            while indexNetrixArray < arSuperDomData.count - 1 {
              if priceBookOffer.price >= arSuperDomData[indexNetrixArray].sPrice { break }
              indexNetrixArray += 1
            }
            
            if abs(arSuperDomData[indexNetrixArray].sPrice - priceBookOffer.price) < minPriceIncrementBook / 2.0 {
              arSuperDomData[indexNetrixArray].nQtdBuy = priceBookOffer.quantity
            } else if indexNetrixArray > 0 && abs(arSuperDomData[indexNetrixArray - 1].sPrice - priceBookOffer.price) < minPriceIncrementBook / 2.0 {
              arSuperDomData[indexNetrixArray - 1].nQtdBuy = priceBookOffer.quantity
            }
          }
          
          var groupedSellOffers = priceBook.groupedSellOffers
             if Application.m_application.m_userProduct.IsHomeBroker(){
             groupedSellOffers = Array(groupedSellOffers.prefix(Application.m_application.m_userProduct.HBNetrixLimit()))
           }
          
          indexNetrixArray = 0
          for priceBookOffer in groupedSellOffers.reversed() {
            while indexNetrixArray < arSuperDomData.count - 1{
              if priceBookOffer.price >= arSuperDomData[indexNetrixArray].sPrice { break }
              indexNetrixArray += 1
            }
            
            if abs(arSuperDomData[indexNetrixArray].sPrice - priceBookOffer.price) < minPriceIncrementBook / 2.0 {
              arSuperDomData[indexNetrixArray].nQtdSell = priceBookOffer.quantity
            } else if indexNetrixArray > 0 && abs(arSuperDomData[indexNetrixArray - 1].sPrice - priceBookOffer.price) < minPriceIncrementBook / 2.0 {
              arSuperDomData[indexNetrixArray - 1].nQtdSell = priceBookOffer.quantity
            }
          }
        }
        
        if let priceIndex = self.findPrice(a_sPrice: self.m_sLastTrade, arSuperDom: arSuperDomData)
        {
          self.m_sLastTradeAprox = arSuperDomData[priceIndex].sPrice
          m_ipCenterIndexPath = IndexPath(row: priceIndex + self.m_nRowsFromCenter, section: 0)
        }
        arAuxNetrix = arSuperDomData
      }
      
        self.updateButtonsText()
        self.m_arNetrix = arAuxNetrix
        self.netrixTableView.reloadData()
  }

  func findPrice(a_sPrice : Double?, arSuperDom : [SuperDOMItem]) -> Int?
  {
    guard let sPrice = a_sPrice else
    {
      return nil
    }
    
    if arSuperDom.count == 0
    {
      return nil
    }
    
    var nStart = 0
    var nEnd = arSuperDom.count - 1
    var i : Int = (nEnd - nStart) / 2 + nStart
    
    while true
    {
      i = (nEnd - nStart) / 2 + nStart
      if arSuperDom[i].sPrice == sPrice
      {
        return i
      }
      else if sPrice < arSuperDom[i].sPrice
      {
        if i == arSuperDom.count - 1 // Maior que o último da lista
        {
          return nil
        }
        else if sPrice > arSuperDom[i + 1].sPrice // Testa se está entre o atual e o seguinte
        {
          return i + 1
        }
        nStart = i + 1
      }
      else if sPrice > arSuperDom[i].sPrice
      {
        if i == 0 // Menor que o primeiro da lista
        {
          return nil
        }
        else if sPrice < arSuperDom[i - 1].sPrice // Testa se está entre o atual e o anterior
        {
          return i
        }
        nEnd = i - 1
      }
    }
  }
  
  func loadOrderData()
  {
    m_dicOrderBuyQtyByPrice = [:]
    m_dicOrderSellQtyByPrice = [:]
    m_dicStrategyBuyQtyByPrice = [:]
    m_dicStrategySellQtyByPrice = [:]
    var orderList: [Order] = []

    if !app.m_userProduct.hasSuperDom()
    {
      return
    }
    
    guard let priceBookAssetID = m_selectedAsset else
    {
      return
    }

    guard let selectedAccount = Application.m_application.m_acSelectedAccount else {
      return
    }
    
    if let walletUser: UserWallet = Application.m_application.m_uwSelectedUserWallet {
      orderList = selectedAccount.GetOrderList(a_aidAssetId: priceBookAssetID).filter({$0.userWalletID == walletUser.nWalletID})
    } else {
      orderList = selectedAccount.GetOrderList(a_aidAssetId: priceBookAssetID)
    }

    var ruleValue : Double = 0
    var rulePercent : Double = 0
    var rulePrice : Double = 0
    for order in orderList.reversed()
    {
      order.addToUpdateList(self)
      
      var fracAssetID: AssetIdentifier? = nil
      if let assetInfo = app.m_dicAssetInfo[priceBookAssetID.getKey()], assetInfo.hasFractionary() {
        fracAssetID = assetInfo.getFractionaryAssetId()
      }

      if let _ = order.osStatus, (order.m_aidAssetId == priceBookAssetID || order.m_aidAssetId == fracAssetID) && order.dtCloseDate == nil // && ![OrderStatus.bstclientcreated, OrderStatus.bsthadescreated].contains(status)
        {
        if var sPrice = order.sPrice, var nQty = order.nQty
          {
          if order.otOrderType == .botstoplimit, let stopPrice = order.sStopPrice
            {
            sPrice = stopPrice
          }

          if let changingPrice = order.sChangingPrice
            {
            sPrice = changingPrice
          }

          if let nCumQty = order.nCumQty
            {
            nQty = nQty - nCumQty
          }
            
          sPrice = Common.truncatePriceToNextValidPrice(aidAssetAid: priceBookAssetID, a_sPrice: sPrice, isBook: true)
            
          if order.sdSide == .bosbuy
            {
            if let item = m_dicOrderBuyQtyByPrice[Common.formatStringfrom(value: sPrice, minDigits: 3, maxDigits: 3)]
              {
              nQty = nQty + item.nQty
            }
            m_dicOrderBuyQtyByPrice[Common.formatStringfrom(value: sPrice, minDigits: 3, maxDigits: 3)] = QtyAtPriceItem(nQty: nQty, otOrderType: order.otOrderType)
            
            var ocoStrategy : StrategyDefinition?
            if let newOCO = order.m_ostNewOCOStrategy
            {
              ocoStrategy = newOCO
            }
            else if let oco = order.m_ostOCOStrategy
            {
              ocoStrategy = oco
            }
              
            if let strategy = ocoStrategy {
              if strategy.enabledGain {
                for rule in strategy.profitRules {
                  if rule.ruleQty > 0 {
                    rulePrice  = sPrice
                    Common.getRulePrice(a_sPrice: &rulePrice, a_sRuleValue: &ruleValue, a_sPercentValue: &rulePercent, a_aidAssetId: order.m_aidAssetId, a_paPriceAdjust: strategy.priceAdjust, a_sDelta: rule.priceDelta, a_sdSide: order.sdSide, a_nRuleQty: rule.ruleQty)
                    if let itemForStrategy = m_dicStrategySellQtyByPrice[Common.formatStringfrom(value: rulePrice, minDigits: 3, maxDigits: 3)] {
                      m_dicStrategySellQtyByPrice[Common.formatStringfrom(value: rulePrice, minDigits: 3, maxDigits: 3)] = QtyAtPriceItem(nQty: itemForStrategy.nQty + rule.ruleQty, otOrderType: .botlimit)
                    } else {
                      m_dicStrategySellQtyByPrice[Common.formatStringfrom(value: rulePrice, minDigits: 3, maxDigits: 3)] = QtyAtPriceItem(nQty: rule.ruleQty, otOrderType: .botlimit)
                    }
                  }
                }
              }
              
              if strategy.enabledLoss {
                for rule in strategy.lossRules {
                  if rule.ruleQty > 0 {
                    rulePrice  = sPrice
                    Common.getRulePrice(a_sPrice: &rulePrice, a_sRuleValue: &ruleValue, a_sPercentValue: &rulePercent, a_aidAssetId: order.m_aidAssetId, a_paPriceAdjust: strategy.priceAdjust, a_sDelta: rule.stopDelta, a_sdSide: order.sdSide, a_nRuleQty: rule.ruleQty)
                    if let itemForStrategy = m_dicStrategySellQtyByPrice[Common.formatStringfrom(value: rulePrice, minDigits: 3, maxDigits: 3)] {
                      m_dicStrategySellQtyByPrice[Common.formatStringfrom(value: rulePrice, minDigits: 3, maxDigits: 3)] = QtyAtPriceItem(nQty: itemForStrategy.nQty + rule.ruleQty, otOrderType: .botstoplimit)
                    } else {
                      m_dicStrategySellQtyByPrice[Common.formatStringfrom(value: rulePrice, minDigits: 3, maxDigits: 3)] = QtyAtPriceItem(nQty: rule.ruleQty, otOrderType: .botstoplimit)
                    }
                  }
                }
              }
            }
          } else if order.sdSide == .bossell {
            if let item = m_dicOrderSellQtyByPrice[Common.formatStringfrom(value: sPrice, minDigits: 3, maxDigits: 3)] {
              nQty = nQty + item.nQty
            }
            m_dicOrderSellQtyByPrice[Common.formatStringfrom(value: sPrice, minDigits: 3, maxDigits: 3)] = QtyAtPriceItem(nQty: nQty, otOrderType: order.otOrderType)
            
            var ocoStrategy : StrategyDefinition?
            if let newOCO = order.m_ostNewOCOStrategy
            {
              ocoStrategy = newOCO
            }
            else if let oco = order.m_ostOCOStrategy
            {
              ocoStrategy = oco
            }
            
            if let strategy = ocoStrategy {
              if strategy.enabledGain {
                for rule in strategy.profitRules {
                  if rule.ruleQty > 0 {
                    rulePrice  = sPrice
                    Common.getRulePrice(a_sPrice: &rulePrice, a_sRuleValue: &ruleValue, a_sPercentValue: &rulePercent, a_aidAssetId: order.m_aidAssetId, a_paPriceAdjust: strategy.priceAdjust, a_sDelta: rule.priceDelta, a_sdSide: order.sdSide, a_nRuleQty: rule.ruleQty)
                    if let itemForStrategy = m_dicStrategyBuyQtyByPrice[Common.formatStringfrom(value: rulePrice, minDigits: 3, maxDigits: 3)] {
                      m_dicStrategyBuyQtyByPrice[Common.formatStringfrom(value: rulePrice, minDigits: 3, maxDigits: 3)] = QtyAtPriceItem(nQty: itemForStrategy.nQty + rule.ruleQty, otOrderType: .botlimit)
                    } else {
                      m_dicStrategyBuyQtyByPrice[Common.formatStringfrom(value: rulePrice, minDigits: 3, maxDigits: 3)] = QtyAtPriceItem(nQty: rule.ruleQty, otOrderType: .botlimit)
                    }
                  }
                }
              }
              
              if strategy.enabledLoss {
                for rule in strategy.lossRules {
                  if rule.ruleQty > 0 {
                    rulePrice  = sPrice
                    Common.getRulePrice(a_sPrice: &rulePrice, a_sRuleValue: &ruleValue, a_sPercentValue: &rulePercent, a_aidAssetId: order.m_aidAssetId, a_paPriceAdjust: strategy.priceAdjust, a_sDelta: rule.stopDelta, a_sdSide: order.sdSide, a_nRuleQty: rule.ruleQty)
                    if let itemForStrategy = m_dicStrategyBuyQtyByPrice[Common.formatStringfrom(value: rulePrice, minDigits: 3, maxDigits: 3)] {
                      m_dicStrategyBuyQtyByPrice[Common.formatStringfrom(value: rulePrice, minDigits: 3, maxDigits: 3)] = QtyAtPriceItem(nQty: itemForStrategy.nQty + rule.ruleQty, otOrderType: .botstoplimit)
                    } else {
                      m_dicStrategyBuyQtyByPrice[Common.formatStringfrom(value: rulePrice, minDigits: 3, maxDigits: 3)] = QtyAtPriceItem(nQty: rule.ruleQty, otOrderType: .botstoplimit)
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  
  func cancelStrategyAt(price: Double?, with side : Side) {
    guard let sPrice = price else { return }
    guard let account = account else { return }
    guard let priceBookAssetID = m_selectedAsset else { return }
    
    guard let _ = Application.m_application.m_strSignature else
    {
      if let parentVC = bookViewController {
        parentVC.showPasswordView(callback: { self.cancelStrategyAt(price: price, with : side) })
      } else if let parentVC = newStockDetailViewController {
        parentVC.showPasswordView(callback: { self.cancelStrategyAt(price: price, with: side)})
      }
      return
    }
    
    account.cancelStrategiesAtPrice(a_aidAssetId: priceBookAssetID, a_sPrice: sPrice, a_sdStrategySide: side)
  }
  
  private func editStrategy(a_sOldPrice : Double, a_sNewPrice: Double, a_sdStrategySide: Side) {
    
    guard let account = account else { return }
    guard let priceBookAssetID = m_selectedAsset else { return }
    
    guard let _ = Application.m_application.m_strSignature else {
      if let parentVC = bookViewController {
        parentVC.showPasswordView(callback: { self.editStrategy(a_sOldPrice: a_sOldPrice, a_sNewPrice: a_sNewPrice, a_sdStrategySide: a_sdStrategySide) })
      } else if let parentVC = newStockDetailViewController {
        parentVC.showPasswordView(callback: { self.editStrategy(a_sOldPrice: a_sOldPrice, a_sNewPrice: a_sNewPrice, a_sdStrategySide: a_sdStrategySide) })
      }
      return
    }
    
    account.editStrategiesAtPrice(a_aidAssetId: priceBookAssetID, a_sOldPrice: a_sOldPrice, a_sNewPrice: a_sNewPrice, a_sdStrategySide: a_sdStrategySide)
  }

  // MARK: - Update interface
  @objc func NewOrder(note: NSNotification)
  {
    loadOrderData()
    netrixTableView.reloadData()
  }

  @objc func ocoStrategyChanged()
  {
    loadOrderData()
    netrixTableView.reloadData()
  }
  
  func updateViewOnOrderPropertyChanged(property: OrderProperty,
    value: AnyObject?,
    reference: AnyObject)
  {
    
    if property != .lastUpdate {
      return
    }

    loadOrderData()
    netrixTableView.reloadData()
    if let price = m_sSelectedPrice {
      setSelectedPrice(a_sPrice: price)
      priceTextFieldEntryOrder.text = Common.formatStringfrom(value: price, minDigits: m_nFloatDigits, maxDigits: m_nFloatDigits)
    }
  }

  func updateViewOnPropertyChanged(property: PriceBookProperty,
                                   value: AnyObject?,
                                   reference: AnyObject?)
  {
    optimizedLoadNetrixData()
  }

  func updateViewOnInfoPropertyChanged(property: AssetInfoProperty, value: AnyObject?, reference: AnyObject)
  {
    if let info = reference as? AssetInfo {
      m_nFloatDigits = info.nDigitsPrice ?? info.nFloatDigits
      if let minIncrement = info.sMinPriceIncrementBook {
        m_sMinIncrement = minIncrement
        priceEditOrder.stepValue = info.sMinOrderPriceIncrement ?? Double(minIncrement)
        priceEntryOrder.stepValue = info.sMinOrderPriceIncrement ?? Double(minIncrement)
      }
      qtyEntryOrder.value = Double(info.getQtdDefault())
      netrixTableView.reloadData()
    }
  }
  
  func hideBoleta(centerTableView: Bool = true) {
    self.dismissKeyboard()
    self.lastSelectedPrice = m_sSelectedPrice
    self.m_sSelectedPrice = nil
    self.m_sdEditSide = nil
    self.hideOrderEntry()
    self.hideEditOrder()
    if centerTableView {
      self.m_nRowsFromCenter = 0
    }

    self.updateNetrixTableInsets()
  }
  
  override func setHomeIndicatorHidden(){
    NotificationCenter.default.post(name: HomeIndicatorAutoHiddenNotification, object: false)
  }
  
  private func updateNetrixTableInsets() {
    let bottomInset = orderEntryHeight.constant + editOrderHeight.constant + positionViewHeight.constant + headerSwipeBoletaHeight.constant + getSafeAreaHeight()
    boletaBackgroundHeight.constant = bottomInset
    netrixTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset - boletaFooterBottomConstraint.constant, right: 0)
  }
  
  @objc func keyboardWillAppear(notification: NSNotification) {
     animatingKeyboardTransition(show: true, notification: notification)
     keyboardIsOpen = true
   }

   @objc func keyboardWillDisappear(notification: NSNotification) {
     animatingKeyboardTransition(show: false, notification: notification)
     keyboardIsOpen = false
   }
   
   func animatingKeyboardTransition(show: Bool, notification: NSNotification) {
     var duration: Double = 0.3
     var animationCurve: Double = 0
     var animationOptions: UIView.AnimationOptions = .curveLinear
     let replayHeight = bookViewController?.replayBarView?.frame.height ?? newStockDetailViewController?.replayBarView?.frame.height
     let constant = show ? self.getKeyboardHeight(notification) - self.getSafeAreaHeight() - (replayHeight ?? 0) : 0

     if let userInfo = notification.userInfo{
       if let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber{
            duration = keyboardAnimationDuration.doubleValue
          }
       
       if let keyboardAnimationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber{
           animationCurve = keyboardAnimationCurve.doubleValue
         }
     }
     
     switch UIView.AnimationCurve.init(rawValue: Int(animationCurve)){
       case .easeInOut: animationOptions = .curveEaseInOut
       case .easeIn: animationOptions = .curveEaseIn
       case .easeOut: animationOptions = .curveEaseOut
       default: animationOptions = .curveLinear
     }

     UIView.animate(withDuration: duration, delay: .zero, options: animationOptions, animations: {
      if !self.boletaIsHidden {
       self.boletaFooterBottomConstraint.constant = -constant
       self.view.layoutIfNeeded()
      }
     }) { _ in
       self.updateNetrixTableInsets()
     }
   }
   
   func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
     var keyboardHeight: CGFloat = 0

     guard let userInfo = notification.userInfo else {
       return keyboardHeight
     }

     if userInfo.keys.contains(UIResponder.keyboardFrameEndUserInfoKey) {
       if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
         let keyboardRectangle = keyboardFrame.cgRectValue
         keyboardHeight = keyboardRectangle.height
       }
     }
     return keyboardHeight
   }
   
   override func getSafeAreaHeight() -> CGFloat {
     var safeAreaBottom: CGFloat = 0
     if #available(iOS 11.0, *) {
       let replayBarHeight: CGFloat
       let stockDetailReplayBarHeight: CGFloat
       if let replayBar: UIView = bookViewController?.replayBarView {
         replayBarHeight = replayBar.frame.height
       } else {
         replayBarHeight = 0
       }
       //verifica se tem replay em algum dos delegates
       if let stockDetailBar: UIView = newStockDetailViewController?.replayBarView {
         stockDetailReplayBarHeight = stockDetailBar.frame.height
       } else {
         stockDetailReplayBarHeight = 0
       }
       
       if stockDetailReplayBarHeight + replayBarHeight <= 0 {
         if let windowBottomInset: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
           //safeAreaInsets do self.view no willAppear ainda não está correto
           safeAreaBottom = windowBottomInset
         } else {
           safeAreaBottom = view.safeAreaInsets.bottom
         }
       }
     }
     return safeAreaBottom
   }
  
  // MARK: - Gestures

  @objc private func tapAccountView(sender: UIView)
  {
    Nelogger.shared.log("AccountView @ SuperDOMViewController did Tap")
    bookViewController?.openAccountSelector(oldSegueIdentifier: "goToAccountFromSuperDOM")
    newStockDetailViewController?.openAccountSelector(oldSegueIdentifier: "goToAccountFromSuperDOM")
  }

  //****************************************************************************
  //
  //       Nome: tapSymbolView
  //  Descrição: tap na view que contém o ativo selecionado
  //
  //    Criação: 29/09/2017 v1.0 Luís Felipe Polo
  // Modificado:
  //
  //****************************************************************************
  @objc override func tapSymbolView(sender: UIView)
  {
    bookViewController?.performSegue(withIdentifier: "goToSetSymbolFromSuperDOM", sender: self)
    m_sSelectedPrice = nil
    hideBoleta()
  }
  
  @objc private func onResultTap() {
    isPositionSimpleOpenResult = !isPositionSimpleOpenResult
    setPositionView()
  }
  
  private func setPriceOnBoleta(_ price: Double) {
    if #available(iOS 13, *), let asset: AssetIdentifier = m_selectedAsset {
      let roundedPrice: Double = Common.roundPriceToNextValidPrice(aidAssetAid: asset, a_sPrice: price)
      newOrderEntryViewModel?.chartLongPressEditPrice(price: roundedPrice)
    }
    priceTextFieldEntryOrder.text = Common.formatStringfrom(value: price, minDigits: m_nFloatDigits, maxDigits: m_nFloatDigits)
    
  }
  
  @objc private func onHeaderSwipeBoletaTap() {
    if boletaIsHidden {
      if let price: Double = lastSelectedPrice {
        setSelectedPrice(a_sPrice: price)
        setPriceOnBoleta(price)
      } else {
        if #available(iOS 13, *) {
          newOrderEntryViewModel?.setType(type: .botmarket)
        }
        showOrderEntry()
      }
    }
  }

  func getIndexAtLocation(location: CGPoint) -> Int
  {
    let pos = (location.y - netrixTableView.contentOffset.y) / netrixCellHeight
    var result: Int
    if let visibleRows = netrixTableView.indexPathsForVisibleRows
      {
      result = visibleRows[0].row + Int(round(pos)) //+ 1
    }
    else
    {
      result = Int(pos) //+ 1
    }

    if result < 0
      {
      return 0
    }
    else if result >= m_arNetrix.count
      {
      return m_arNetrix.count - 1
    }
    return result
  }

  func dismissStatus()
  {
    if editOrderHeight.constant == 0 && orderEntryHeight.constant == 0
      {
    }
  }

  @objc func dismissKeyboard()
  {
    view.endEditing(true)
    keyboardIsOpen = false
  }

  @objc func onTapGesture(sender: UITapGestureRecognizer)
  {
    if keyboardIsOpen == true {
      dismissKeyboard()
      Common.print("ontapgesture")
    } else {
      if !Application.m_application.m_userProduct.hasSuperDom() {
        return
      }
      
      let locationInView = sender.location(in: netrixTableView)
      if let indexPath = netrixTableView.indexPathForRow(at: locationInView) {
        if let price = m_sSelectedPrice, Common.compareNearlyEqual(a: m_arNetrix[indexPath.row].sPrice, b: price) { // Deselect
          hideBoleta(centerTableView: false)
          lastSelectedPrice = nil
          dismissKeyboard()
        } else {
          m_cgpLastTouchLocation = locationInView
          let price: Double = m_arNetrix[indexPath.row].sPrice
          setSelectedPrice(a_sPrice: price)
          self.setPriceOnBoleta(price)
        }
          netrixTableView.reloadData()
      }
    }

  }
  
  @IBAction func dayTradeValueChanged(switchView: UISwitch) {
    let isDayTrade: Bool = switchView.isOn
    Application.m_application.m_bSwitchDayTradeMode = isDayTrade
  }

  @objc func onLongPressGesture(sender: UILongPressGestureRecognizer)
  {
    let locationInView = sender.location(in: netrixTableView)

    switch sender.state
    {
    case .began:
      self.hideBoleta(centerTableView: false)
      if let indexPath = netrixTableView.indexPathForRow(at: locationInView)
        {
        initDragOrder(a_superDomItem: m_arNetrix[indexPath.row], location: locationInView)
      }
      break

    case .changed:
      if m_bIsDraggingStrategy {
        guard let _ = m_sEditStrategyFromPrice, let _ = m_sdEditStrategySide else {
          return
        }
      } else {
        guard let _ = m_sEditFromPrice, let _ = m_sdEditSide else {
          return
        }
      }

      if let indexPath = netrixTableView.indexPathForRow(at: locationInView)
        {
        if var visibleRows = netrixTableView.indexPathsForVisibleRows
          {
          let index = getIndexAtLocation(location: locationInView)
          m_sLongPressCurrentPrice = m_arNetrix[index].sPrice
          netrixTableView.reloadData()

          visibleRows.removeFirst()
          visibleRows.removeLast()
          if visibleRows.contains(indexPath) == false
            {
            var direction: Int = 0
            if indexPath.row < visibleRows[0].row
              {
              direction = -1
            }
            else
            {
              direction = 1
            }
            let nextIndexPath = IndexPath(row: indexPath.row + direction, section: indexPath.section)
            if indexPathIsValid(indexPath: nextIndexPath)
              {
              netrixTableView.scrollToRow(at: nextIndexPath, at: .none, animated: false)
            }
          }
        }
      }
      break

    case .ended:
      if m_bIsDraggingStrategy {
        guard let initPrice = m_sEditStrategyFromPrice, let editSide = m_sdEditStrategySide else {
          return
        }
        
        endDragStrategy(from: initPrice, to: m_arNetrix[getIndexAtLocation(location: locationInView)].sPrice, on: editSide)
        loadOrderData()
        netrixTableView.reloadData()
        
      } else {
        guard let initPrice = m_sEditFromPrice, let editSide = m_sdEditSide else {
          return
        }


        editPrice(a_sdSide: editSide, a_sOldPrice: initPrice, a_sNewPrice: m_arNetrix[getIndexAtLocation(location: locationInView)].sPrice)
        loadOrderData()
        netrixTableView.reloadData()
      }
      self.showNavigationBar()
      break

    default:
      break
    }
  }
  
  private func endDragStrategy(from initPrice : Double, to newPrice : Double, on side : Side) {
    // End longpress gesture cleaning variables
    m_bIsDraggingStrategy = false
    m_sdEditStrategySide = nil
    m_nEditStrategyQtd = 0
    m_otEditStrategyOrderType = nil
    m_sLongPressCurrentPrice = nil
    
    editStrategy(a_sOldPrice: initPrice, a_sNewPrice: newPrice, a_sdStrategySide: side)
    
    m_sEditStrategyFromPrice = nil
  }

  func initDragOrder(a_superDomItem: SuperDOMItem, location: CGPoint) {
    var qtdBuy: Int = 0
    var qtdSell: Int = 0
    var qtdBuyStrategy: Int = 0
    var qtdSellStrategy: Int = 0
    
    let strOrderPrice = Common.formatStringfrom(value: a_superDomItem.sPrice, minDigits: 3, maxDigits: 3)
    if let qtd = m_dicOrderBuyQtyByPrice[strOrderPrice]?.nQty
    {
      qtdBuy = qtd
    }

    if let qtd = m_dicOrderSellQtyByPrice[strOrderPrice]?.nQty
    {
      qtdSell = qtd
    }

    if let qtd = m_dicStrategyBuyQtyByPrice[strOrderPrice]?.nQty
    {
      qtdBuyStrategy = qtd
    }
    
    if let qtd = m_dicStrategySellQtyByPrice[strOrderPrice]?.nQty
    {
      qtdSellStrategy = qtd
    }
    
    if qtdBuy > 0 && qtdSell > 0 { // ordens de compra e venda na mesma linha
      if location.x > netrixTableView.frame.width / 2 {
        qtdBuy = 0 // Ignora qtde de compra
      } else {
        qtdSell = 0 // Ignora qtde de venda
      }
    }
    else if qtdBuy > 0 && qtdSellStrategy > 0 && location.x > netrixTableView.frame.width * 2 / 3 {
      qtdBuy = 0 // Ignora qtde de compra
    }
    else if qtdSell > 0 && qtdBuyStrategy > 0 && location.x < netrixTableView.frame.width / 3 {
      qtdSell = 0 // Ignora qtde de venda
    }

    m_nEditQty = 0

    if qtdBuy > 0 {
      AudioServicesPlaySystemSound(1520)
      if let otType = m_dicOrderBuyQtyByPrice[strOrderPrice]?.otOrderType
      {
        m_otEditOrderType = otType
      }
      m_sEditFromPrice = a_superDomItem.sPrice
      m_sdEditSide = .bosbuy
      m_nEditQty = qtdBuy
      m_bIsDraggingStrategy = false
    } else if qtdSell > 0 {
      AudioServicesPlaySystemSound(1520)
      if let otType = m_dicOrderSellQtyByPrice[strOrderPrice]?.otOrderType
      {
        m_otEditOrderType = otType
      }
      m_sEditFromPrice = a_superDomItem.sPrice
      m_sdEditSide = .bossell
      m_nEditQty = qtdSell
      m_bIsDraggingStrategy = false
    } else {
      initDragStrategy(a_superDomItem: a_superDomItem, location: location)
    }

    netrixTableView.reloadData()
  }
  
  func initDragStrategy(a_superDomItem: SuperDOMItem, location: CGPoint) {
    var qtdBuy: Int = 0
    var qtdSell: Int = 0
    
    let strOrderPrice = Common.formatStringfrom(value: a_superDomItem.sPrice, minDigits: 3, maxDigits: 3)
    if let qtd = m_dicStrategyBuyQtyByPrice[strOrderPrice]?.nQty {
      qtdBuy = qtd
    }
    
    if let qtd = m_dicStrategySellQtyByPrice[strOrderPrice]?.nQty {
      qtdSell = qtd
    }
    
    if qtdBuy > 0 && qtdSell > 0 { // estratégias de compra e venda na mesma linha
      if location.x > netrixTableView.frame.width / 2 {
        qtdBuy = 0 // Ignora qtde de compra
      } else {
        qtdSell = 0 // Ignora qtde de venda
      }
    }
    
    if qtdBuy > 0 {
      AudioServicesPlaySystemSound(1520)
      m_sEditStrategyFromPrice = a_superDomItem.sPrice
      m_otEditStrategyOrderType = m_dicStrategyBuyQtyByPrice[strOrderPrice]?.otOrderType
      m_sdEditStrategySide = .bosbuy
      m_nEditStrategyQtd = qtdBuy
      m_bIsDraggingStrategy = true
    } else if qtdSell > 0 {
      AudioServicesPlaySystemSound(1520)
      m_sEditStrategyFromPrice = a_superDomItem.sPrice
      m_otEditStrategyOrderType = m_dicStrategySellQtyByPrice[strOrderPrice]?.otOrderType
      m_sdEditStrategySide = .bossell
      m_nEditStrategyQtd = qtdSell
      m_bIsDraggingStrategy = true
    } else {
      m_sEditStrategyFromPrice = nil
      m_otEditStrategyOrderType = nil
      m_sdEditStrategySide = nil
      m_nEditStrategyQtd = 0
      m_bIsDraggingStrategy = false
    }
    
  }
  
  private func showOrderEntry() {
    UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
      self.orderEntryView.isHidden = false
      self.orderEntryHeight.constant = self.orderEntryViewHeight
      self.editOrderHeight.constant = 0
      self.toggleOrderEntryElements(isHidden: Application.m_application.m_userProduct.hasNewChartTrading())
      self.editOrderView.isHidden = true
      if !self.keyboardIsOpen {
        self.boletaFooterBottomConstraint.constant = 0
      }
    }, completion: nil)
  }
  
  private func showEditOrder() {
    UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
      self.orderEntryView.isHidden = true
      self.orderEntryHeight.constant = 0
      self.editOrderView.isHidden = false
      self.editOrderHeight.constant = self.editOrderViewHeight
      self.toggleOrderEntryElements(isHidden: false)
      if !self.keyboardIsOpen {
        self.boletaFooterBottomConstraint.constant = 0
      }
    }, completion: nil)
    
  }
  
  private func hideOrderEntry() {
    UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
      self.orderEntryView.isHidden = true
      self.orderEntryHeight.constant = self.orderEntryViewHeight
      self.boletaFooterBottomConstraint.constant = self.orderEntryViewHeight
      self.view.layoutIfNeeded()
    }, completion: nil)
    
  }
  
  private func hideEditOrder() {
    UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
      self.editOrderView.isHidden = true
      self.editOrderHeight.constant = 0
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
  
  private func move(to point: CGPoint, view: UIView, originalY: CGFloat, resetPosition: Bool = false) {
    if view.frame.minY + point.y < originalY || self.boletaFooterBottomConstraint.constant + point.y < 0 && !resetPosition {
      return
    }
    UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
      if resetPosition {
        if self.editOrderHeight.constant == 0 && self.m_sSelectedPrice == nil {
          if let lastValue: Double = self.lastSelectedPrice {
            self.setSelectedPrice(a_sPrice: lastValue)
            self.setPriceOnBoleta(lastValue)
            self.netrixTableView.reloadData()
          } else {
            if #available(iOS 13, *) {
              self.newOrderEntryViewModel?.setType(type: .botmarket)
            }
            self.showOrderEntry()
          }

        } else {
          self.hideBoleta(centerTableView: false)
        }
        self.updateNetrixTableInsets()
      } else {
        self.boletaFooterBottomConstraint.constant += point.y
      }
    }, completion: nil)
    
  }
    
  @objc private func panBoletaBar(_ sender: UIPanGestureRecognizer) {
    guard let view = sender.view /*, !orderEntryView.isHidden || !editOrderView.isHidden */ else { return }
    let location = sender.location(in: sender.view)
    let diff = view.frame.minY - boletaOriginalY
    
    if sender.state == .began {
      var increment: CGFloat = 0
      if orderEntryHeight.constant + editOrderHeight.constant == 0 || orderEntryHeight.constant == self.boletaFooterBottomConstraint.constant && editOrderHeight.constant == 0 {
        increment = orderEntryViewHeight
        orderEntryView.isHidden = false
      }
      self.boletaOriginalY = view.frame.minY - increment
    } else if sender.state == .changed {
      move(to: location, view: view, originalY: boletaOriginalY)
    } else if sender.state == .ended {
      let height = self.boletaBackgroundView.frame.height
      if diff > height / 2 {
        self.hideBoleta(centerTableView: false)
      } else {
        move(to: CGPoint(x: 0, y: -diff), view: view, originalY: boletaOriginalY, resetPosition: true)
      }
    }
  }

  // MARK: - Navigation

  @IBAction func unwindToSuperDOM(segue: UIStoryboardSegue)
  {
    if let vc = segue.source as? SetAssetViewController, let stock = vc.m_stkSelected
    {
      qtyTextFieldEntryOrder.text = ""
      isChosenAssetFractionary = stock.isFractionary()
      changeViewAsset(stock.m_aidAssetID)
    }
  }

  func changeAssetToNonFractionary(assetInfo: AssetInfo) {
    if let info = assetInfo.getNonFractionaryAssetInfo() {
      qtyTextFieldEntryOrder.backgroundColor = Colors.clStepperTextFieldAtSuperDOM
      if let lote = info.nLote {
        qtyEntryOrder.stepValue = Double(lote)
      }
      isUsingFractionary = false
    }
  }
  
  func changeAssetToFractionary(assetInfo: AssetInfo) {
    if let fracInfo = assetInfo.getFractionaryAssetInfo() {
      qtyTextFieldEntryOrder.backgroundColor = Colors.clFractionaryQtd
      if let lote = fracInfo.nLote {
        qtyEntryOrder.stepValue = Double(lote)
      }
      isUsingFractionary = true
    }

  }

  func unsubscribeAll()
  {
    if let assetID = m_selectedAsset {
      if let stock = Application.m_application.m_dicStocks[assetID.getKey()] {
        // chama removeFromUpdateList apenas se existe esse objeto stock
        // chamar o m_selectedStock.getter aqui faz chamar o Application.m_application.getStock que cria e insere um Stock no dicionário, em alguns casos isso dá problema (caso o nosso objetivo seja justamente remover esse Stock do dicionário, como no finish replay)
        stock.removeFromUpdateList(self)
      }
      if let assetInfo = m_selectedAssetInfo {
        assetInfo.removeFromUpdateList(self)
      }
      if let position = account?.GetPosition(a_aidAssetId: assetID) {
        position.removeFromUpdateList(self)
      }
      if let orderList = account?.GetOrderList(a_aidAssetId: assetID) {
        for order in orderList {
          order.removeFromUpdateList(self)
        }
      }
    }
  }
  
  override func changeViewAsset(_ asset: AssetIdentifier) {
    if m_selectedAsset != asset {
      unsubscribeAll()
      
      m_selectedAsset = asset
      m_aidPreviousAssetId = asset
      if newStockDetailViewController == nil {
        if !self.showNetrix {
          app.m_aidSuperDOM = asset
        } else {
          Application.m_application.m_aidPriceBook = asset
          Application.m_application.m_aidOfferBook = asset
        }
      }
      
      if let stock = m_selectedStock {
        testAlerts()
                        
//        if self.isViewLoaded, self.view.window != nil {
          // se estamos visível resetamos a view e fazemos o subscribe
          m_arNetrix = []
          m_sMaxPrice = nil
          m_sMinPrice = nil
          qtyTextFieldEntryOrder?.text = ""
          hideBoleta()
          netrixTableView.reloadData()
          
          subscribeAll()
//        }
        
        if !ExchangeManager.shared.isItReplayMarket(nExchange: stock.m_aidAssetID.m_nMarket.kotlin) {
          Application.m_application.saveLastPriceBookAsset()
        }
      }
      self.setNewChartTradingView()
    }
  }
  
  @objc override func tapNotificationView(){
    if let asset = m_selectedAsset {
      Application.m_application.m_assetAlertManager.removeAlertFromClosedAuction(asset)
      testAlerts()
    }
  }
  
  func testAlerts() {
    if newStockDetailViewController == nil {
      Application.m_application.m_assetAlertManager.showAlertsFor(assetAlertDisplay: bookViewController ?? self)
    }
  }
  
  // MARK: - Helpers
  func setEditionAppearance()
  {
    if m_otEditOrderType == .botstoplimit
      {
        priceLabelEdition.attributedText = NSMutableAttributedString(string: Localization.localizedString(key: LocalizationKey.Boleta_StopPrice).uppercased(), attributes: [NSAttributedString.Key.font: Common.font(ofSize: 10, weight: UIFont.Weight.semibold)])
    }
    else
    {
      priceLabelEdition.attributedText = NSMutableAttributedString(string: Localization.localizedString(key: LocalizationKey.Boleta_Price).uppercased(), attributes: [NSAttributedString.Key.font: Common.font(ofSize: 10, weight: UIFont.Weight.semibold)])
    }
    priceLabelEdition.textColor = Colors.clBoletaSuperDOMLabel
    qtyLabelEdition.textColor = Colors.clBoletaSuperDOMLabel

    if m_sdEditSide == .bosbuy
      {
      editButton.setTitle(Localization.localizedString(key: LocalizationKey.Livro_EditBuy), for: .normal)
      editButton.topGradientColor = Colors.clChartTradingBuyButton.first
      editButton.bottomGradientColor = Colors.clChartTradingBuyButton.last
      editButton.setTitleColor(Colors.lbFontColor, for: .normal)
    }
    else
    {
      editButton.setTitle(Localization.localizedString(key: LocalizationKey.Livro_EditSell), for: .normal)
      editButton.topGradientColor = Colors.clChartTradingSellButton.first
      editButton.bottomGradientColor = Colors.clChartTradingSellButton.last
      editButton.setTitleColor(Colors.primaryFontColor, for: .normal)
    }
  }

  override func updateTickerButton(a_strTicker: String, setButtonsInBaseVC: Bool = true, showArrow: Bool = true) -> [UIBarButtonItem] {
    let itens = super.updateTickerButton(a_strTicker: a_strTicker, setButtonsInBaseVC: setButtonsInBaseVC, showArrow: showArrow)

    #if !targetEnvironment(macCatalyst)
    self.bookViewController?.navigationItem.setRightBarButtonItems(itens, animated: false)
    #endif

    return itens
  }

  override func updateTickerButton(a_strTicker: String, isReplay: Bool, a_nExchange: Int32, setButtonsInBaseVC: Bool = true, showArrow: Bool = true) -> [UIBarButtonItem] {
    let itens = super.updateTickerButton(a_strTicker: a_strTicker, isReplay: isReplay, a_nExchange: a_nExchange, setButtonsInBaseVC: setButtonsInBaseVC, showArrow: showArrow)

    #if !targetEnvironment(macCatalyst)
    self.bookViewController?.navigationItem.setRightBarButtonItems(itens, animated: false)
    #endif

    return itens
  }
  
  @objc override func updateViewRightBarButtons(){
    if let priceBookAssetID = m_selectedAsset {
      _ = self.updateTickerButton(a_strTicker: priceBookAssetID.getKey(), setButtonsInBaseVC: false)
      setupDayTradeSwitch()
      testAlerts()
    }
  }
  
  func configBoleta() {
    boletaBackgroundView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panBoletaBar(_:))))
    
    positionView.backgroundColor = .none
    orderEntryView.backgroundColor = .none
    editOrderView.backgroundColor = .none
    headerSwipeBoletaView.backgroundColor = .none
    swipeIndicatorView.backgroundColor = Colors.clMenuDragIndicator
    
    Common.insertBlur(on: boletaBackgroundView, withBackgroundColor: Colors.clBoletaAtSuperDOM.withAlphaComponent(0.5))
    
    orderTypeBackgroundView.layer.cornerRadius = orderTypeBackgroundView.frame.height / 4
    swipeIndicatorView.layer.cornerRadius = swipeIndicatorView.frame.height / 2
    hideBoleta()
    setPositionView()
    setButtonsText()
  }
  
  func setupDayTradeSwitch() {
    if !Common.hasDayTradeAtBoleta(for: m_selectedAsset) {
      dayTradeStackView.isHidden = true
      dayTradeStackViewHeight.constant = 0
      orderEntryViewHeight = 180
    } else {
      dayTradeStackView.isHidden = false
      dayTradeStackViewHeight.constant = 31
      orderEntryViewHeight = 210
    }
  }
  
  func setupBoletaCorners() {
    let path = UIBezierPath(roundedRect: boletaBackgroundView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8.0, height: 8.0))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    boletaBackgroundView.layer.mask = mask
    let secondPath = UIBezierPath(roundedRect: boletaBackgroundView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8.0, height: 8.0))
    let secondMask = CAShapeLayer()
    secondMask.path = secondPath.cgPath
    boletaBackgroundView.layer.mask = secondMask
  }

  func setButtonsText()
  {

    // Button Colors
    // Buy Button
    buyMarketButton.topGradientColor = Colors.clChartTradingBuyButton.first
    buyMarketButton.bottomGradientColor = Colors.clChartTradingBuyButton.last
    buyMarketButton.setTitleColor(Colors.lbFontColor, for: .normal)
    buyLimitButton.topGradientColor = Colors.clChartTradingBuyButton.first
    buyLimitButton.bottomGradientColor = Colors.clChartTradingBuyButton.last
    buyLimitButton.setTitleColor(Colors.lbFontColor, for: .normal)

    if Application.m_application.isBTGFramework() {
      buyLimitButton.setTitleColor(Colors.primaryFontColor, for: .normal)
      buyMarketButton.setTitleColor(Colors.primaryFontColor, for: .normal)
    }

    // Sell Button
    sellMarketButton.topGradientColor = Colors.clChartTradingSellButton.first
    sellMarketButton.bottomGradientColor = Colors.clChartTradingSellButton.last
    sellMarketButton.setTitleColor(Colors.primaryFontColor, for: .normal)
    sellLimitButton.topGradientColor = Colors.clChartTradingSellButton.first
    sellLimitButton.bottomGradientColor = Colors.clChartTradingSellButton.last
    sellLimitButton.setTitleColor(Colors.primaryFontColor, for: .normal)

    // Reset Button
    resetButton.topGradientColor = Colors.clChartTradingClearButton.first
    resetButton.bottomGradientColor = Colors.clChartTradingClearButton.last

    // Invert Button
    invertButton.topGradientColor = Colors.clChartTradingInvertButton.first
    invertButton.bottomGradientColor = Colors.clChartTradingInvertButton.last
    invertButton.setTitleColor(.black, for: .normal)
    
    invertButton.setTitle(Localization.localizedString(key: LocalizationKey.Livro_Invert), for: .normal)
    buyMarketButton.setTitle(Localization.localizedString(key: LocalizationKey.Livro_BuyMarketShort), for: .normal)
    sellMarketButton.setTitle(Localization.localizedString(key: LocalizationKey.Livro_SellMarketShort), for: .normal)
    lbQty.attributedText = NSMutableAttributedString(string: Localization.localizedString(key: LocalizationKey.Boleta_Quantity).uppercased(), attributes: [NSAttributedString.Key.font: Common.font(ofSize: 10, weight: UIFont.Weight.semibold)])
    lbQty.textColor = Colors.clBoletaSuperDOMLabel
    lbPrice.attributedText = NSMutableAttributedString(string: Localization.localizedString(key: LocalizationKey.Boleta_Price).uppercased(), attributes: [NSAttributedString.Key.font: Common.font(ofSize: 10, weight: UIFont.Weight.semibold)])
    lbPrice.textColor = Colors.clBoletaSuperDOMLabel
    qtyLabelEdition.attributedText = NSMutableAttributedString(string: Localization.localizedString(key: LocalizationKey.SuperDOM_Qtd).uppercased(), attributes: [NSAttributedString.Key.font: Common.font(ofSize: 10, weight: UIFont.Weight.semibold)])
    priceLabelEdition.attributedText = NSMutableAttributedString(string: Localization.localizedString(key: LocalizationKey.Boleta_Price).uppercased(), attributes: [NSAttributedString.Key.font: Common.font(ofSize: 10, weight: UIFont.Weight.semibold)])

    lbQty.adjustsFontSizeToFitWidth = true
    lbPrice.adjustsFontSizeToFitWidth = true

  }

  func updateButtonsText()
  {
    if let priceBookAssetID = m_selectedAsset {
      // Update buy button text
      if let price = m_sSelectedPrice, let bestBuyOffer = Application.m_application.m_dicStocks[priceBookAssetID.getKey()]?.priceBook.groupedBuyOffers.first?.price {
        if Common.compareNearlyEqual(a: price, b: bestBuyOffer + m_sMinIncrement) || price < bestBuyOffer + m_sMinIncrement {
          buyLimitButton.setTitle(Localization.localizedString(key: LocalizationKey.BoletaSuperDOM_BuyLimitButton), for: .normal)
        }
        else if let lastTrade = m_sLastTrade, price > bestBuyOffer + m_sMinIncrement && price > lastTrade {
          if Application.m_application.isAnyProfit() || Application.m_application.isHB() {
            buyLimitButton.setTitle(Localization.localizedString(key: .Boleta_BuyStopShort), for: .normal)
          } else {
            buyLimitButton.setTitle(Localization.localizedString(key: .Livro_BuyStopShort), for: .normal)
          }
        }
      }

      // Update sell button text
      if let price = m_sSelectedPrice, let bestSellOffer = Application.m_application.m_dicStocks[priceBookAssetID.getKey()]?.priceBook.groupedSellOffers.first?.price
        {
        if Common.compareNearlyEqual(a: price, b: bestSellOffer - m_sMinIncrement) || price > bestSellOffer - m_sMinIncrement
          {
          sellLimitButton.setTitle(Localization.localizedString(key: LocalizationKey.BoletaSuperDOM_SellLimitButton), for: .normal)
        }
        else if let lastTrade = m_sLastTrade, price < bestSellOffer - m_sMinIncrement && price < lastTrade
          {
          sellLimitButton.setTitle(Localization.localizedString(key: Application.m_application.isCryptoTarget() ? LocalizationKey.Livro_SellStopShort : LocalizationKey.Boleta_SellStopShort), for: .normal)
        }
      }
    }
  }

  func calcAvgPrice()
  {
    guard let priceBookAssetID = m_selectedAsset else
    {
      return
    }

    guard let multiplier = m_selectedAssetInfo?.sContractMultiplier else
    {
      return
    }

    if let stock = m_selectedStock, let sVolume = stock.getLastDaily()?.sVolume, let nQty = stock.getLastDaily()?.nQtd
    {
      m_sAvgPrice = (sVolume / Common.calcRealQty(value: Int(nQty), forAsset: priceBookAssetID)) / multiplier
    }
  }

  func isPrice(_ price: Double, nearestTo referencePrice: Double) -> Bool
  {
    guard let priceBookAssetID = m_selectedAsset else{
      return false
    }
    let assetInfo = Application.m_application.getAssetInfo(priceBookAssetID)
    
    guard let sMinIncrement = assetInfo.sMinPriceIncrementBook else {
      return false
    }
    
    let floatdigits = assetInfo.nFloatDigitsForRound

    let roundMultiplier = Double(truncating: pow(10, floatdigits) as NSNumber)
    let roundedPrice = round(price*roundMultiplier)
    let roundedReferencePrice = round(referencePrice*roundMultiplier)
    let minIncrement = round(sMinIncrement*roundMultiplier)
    
    let priceDiff = roundedPrice - roundedReferencePrice
    if priceDiff >= 0, priceDiff < minIncrement {
      return true
    }
    
    return false
  }

  func indexPathIsValid(indexPath: IndexPath) -> Bool
  {
    return indexPath.section < netrixTableView.numberOfSections && indexPath.row < netrixTableView.numberOfRows(inSection: indexPath.section) && indexPath.row > 0
  }

  func confirmNewOrderMessage(a_assetID: AssetIdentifier, a_otOrderType: OrderType, a_sdSide: Side, a_stStrategy: StrategyType, a_vtValidity: ValidityType, a_dtValidityDate: Date, a_sPrice: Double, a_sStopPrice: Double, a_nQty: Int) -> NSMutableAttributedString
  {
    let floatDigits = Application.m_application.m_dicAssetInfo[a_assetID.getKey()]!.nDigitsPrice ?? Application.m_application.m_dicAssetInfo[a_assetID.getKey()]!.nFloatDigits
    let assetColor = !ExchangeManager.shared.isItReplayMarket(nExchange: a_assetID.m_nMarket.kotlin) ? Colors.clProfitAlertOrderFontColor : Colors.clReplayTickerColor

    let propertyNameAttributes = [NSAttributedString.Key.font: Common.font(ofSize: 15, weight: UIFont.Weight.regular), NSAttributedString.Key.foregroundColor: Colors.clProfitAlertOrderTitleFontColor]
    let propertyValueAttributes = [NSAttributedString.Key.font: Common.font(ofSize: 15, weight: UIFont.Weight.regular), NSAttributedString.Key.foregroundColor: Colors.clProfitAlertOrderFontColor]
    let assetAttributes = [NSAttributedString.Key.font: Common.font(ofSize: 15, weight: UIFont.Weight.regular), NSAttributedString.Key.foregroundColor: assetColor]

    let strMessage = NSMutableAttributedString()
    strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_Type)): ", attributes: propertyNameAttributes))

    if (a_otOrderType) == .botlimit && (a_sdSide) == .bosbuy
      {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_BuyLimited))\n", attributes: propertyValueAttributes))
    }
    else if (a_otOrderType) == .botlimit && (a_sdSide) == .bossell
      {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_SellLimited))\n", attributes: propertyValueAttributes))
    }
    else if (a_otOrderType) == .botmarket && (a_sdSide) == .bosbuy
      {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_BuyMarket))\n", attributes: propertyValueAttributes))
    }
    else if (a_otOrderType) == .botmarket && (a_sdSide) == .bossell
      {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_SellMarket))\n", attributes: propertyValueAttributes))
    }
    else if (a_otOrderType) == .botstoplimit && (a_sdSide) == .bosbuy
      {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: Application.m_application.isCryptoTarget() ? LocalizationKey.Boleta_BuyStop : LocalizationKey.Boleta_BuyStopShort))\n", attributes: propertyValueAttributes))
    }
    else if (a_otOrderType) == .botstoplimit && (a_sdSide) == .bossell
      {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: Application.m_application.isCryptoTarget() ? LocalizationKey.Boleta_SellStop : LocalizationKey.Boleta_SellStopShort))\n", attributes: propertyValueAttributes))
    }

    strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.General_Symbol)): ", attributes: propertyNameAttributes))
    var ticker: String = a_assetID.getTicker(withReplayIndicator: false).string
    if Application.m_application.handlesFractionary(), let assetInfo = app.m_dicAssetInfo[a_assetID.getKey()], assetInfo.hasFractionary(), !assetInfo.isValidQtd(a_nQtd: a_nQty), let fracInfo = app.m_dicAssetInfo[assetInfo.getFractionaryAssetId().getKey()],
       fracInfo.isValidQtd(a_nQtd: a_nQty){
      ticker = fracInfo.m_aidAssetId.getTicker(withReplayIndicator: false).string
    }
    strMessage.append(NSAttributedString(string: "\(ticker)\n", attributes: assetAttributes))

    if (a_otOrderType) == .botstoplimit
      {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_StopPrice)): ", attributes: propertyNameAttributes))

      strMessage.append(NSAttributedString(string: "\(Common.formatStringfrom(value: a_sStopPrice, minDigits: floatDigits, maxDigits: floatDigits))\n", attributes: propertyValueAttributes))
    }

    if (a_otOrderType) == .botmarket
      {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_Price)): ", attributes: propertyNameAttributes))

      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_Market))\n", attributes: propertyValueAttributes))
    }
    else
    {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_Price)): ", attributes: propertyNameAttributes))

      strMessage.append(NSAttributedString(string: "\(Common.formatStringfrom(value: a_sPrice, minDigits: floatDigits, maxDigits: floatDigits))\n", attributes: propertyValueAttributes))
    }

    strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_Quantity)): ", attributes: propertyNameAttributes))

    strMessage.append(NSAttributedString(string: "\(Common.formatQtyToString(value: a_nQty, forAsset: a_assetID, makeShort: false))\n", attributes: propertyValueAttributes))

    if a_vtValidity == .btfGoodTillDate
      {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_Validity)): ", attributes: propertyNameAttributes))

        strMessage.append(NSAttributedString(string: "\(Common.dateToStringFormat(date: a_dtValidityDate, watchlistFormat: false, asset: a_assetID))\n", attributes: propertyValueAttributes))
    }
    else
    {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_Validity)): ", attributes: propertyNameAttributes))

      strMessage.append(NSAttributedString(string: "\(a_vtValidity.description())\n", attributes: propertyValueAttributes))
    }

    if (a_otOrderType) == .botmarket
      {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_Total)): ", attributes: propertyNameAttributes))
      strMessage.append(NSAttributedString(string: "-\n", attributes: propertyValueAttributes))
    }
    else
    {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_Total)): ", attributes: propertyNameAttributes))

      let qty = Common.calcRealQty(value: a_nQty, forAsset: a_assetID)
      strMessage.append(NSAttributedString(string: "\(Common.formatStringfrom(value: (Application.m_application.m_dicAssetInfo[a_assetID.getKey()]!.sContractMultiplier)! * a_sPrice * qty, minDigits: 2, maxDigits: 2))\n", attributes: propertyValueAttributes))
    }

    if (ExchangeManager.shared.isBMF(a_nExchange: a_assetID.m_nMarket.kotlin) && broker!.arStrategyTypeBMF.contains(StrategyType.stDayTrade)) || (ExchangeManager.shared.isBovespa(a_nExchange: a_assetID.m_nMarket.kotlin) && broker!.arStrategyTypeBovespa.contains(StrategyType.stDayTrade))
      {

      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.Boleta_Strategy)): ", attributes: propertyNameAttributes))
      
      var stStrategy: StrategyType = a_stStrategy
      if app.m_userProduct.HasDayTradeModeSwitch() {
        stStrategy = app.getStrategyType()
      }
      strMessage.append(NSAttributedString(string: "\(stStrategy.description())\n", attributes: propertyValueAttributes))
    }
    
    var stStrategyType: StrategyType = a_stStrategy
    if app.m_userProduct.HasDayTradeModeSwitch() {
      stStrategyType = app.getStrategyType()
    }
    if Application.m_application.m_userProduct.HasCoveredTradeMode(assetInfo: Application.m_application.getAssetInfo(a_assetID)) {
      strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.StrategyType_CoveredTradeType)): ", attributes: propertyNameAttributes))
      strMessage.append(NSAttributedString(string: "\(stStrategyType.isCoveredStrategyString())\n", attributes: propertyValueAttributes))
    }

    strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.SendOrderStatus_Broker)): ", attributes: propertyNameAttributes))

    strMessage.append(NSAttributedString(string: "\(broker!.strName!)\n", attributes: propertyValueAttributes))

    strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.General_Account)): ", attributes: propertyNameAttributes))

    strMessage.append(NSAttributedString(string: "\(account!.strAccountID)", attributes: propertyValueAttributes))

    return strMessage
  }


  func confirmEditionMsg(a_assetID: AssetIdentifier, a_otOrderType: OrderType, a_sdSide: Side, a_vtValidity: ValidityType, a_dtValidityDate: Date, a_sOldPrice: Double, a_nOldQty: Int, a_sPrice: Double, a_nQty: Int) -> NSMutableAttributedString
  {
    let floatDigits = Application.m_application.m_dicAssetInfo[a_assetID.getKey()]!.nDigitsPrice ?? Application.m_application.m_dicAssetInfo[a_assetID.getKey()]!.nFloatDigits
    let assetColor = !ExchangeManager.shared.isItReplayMarket(nExchange: a_assetID.m_nMarket.kotlin) ? /*UIColor(rgb: 0x2d2d2d)*/ Colors.clProfitAlertTextFieldFontColor : Colors.clReplayTickerColor

    let propertyNameAttributes = [NSAttributedString.Key.font: Common.font(ofSize: 15, weight: UIFont.Weight.regular), NSAttributedString.Key.foregroundColor: Colors.clProfitAlertOrderTitleFontColor
      /*UIColor(rgb: 0x8d8d8d)*/]
    let propertyValueAttributes = [NSAttributedString.Key.font: Common.font(ofSize: 15, weight: UIFont.Weight.regular), NSAttributedString.Key.foregroundColor: Colors.clProfitAlertTextFieldFontColor /*UIColor(rgb: 0x2d2d2d)*/]
    let assetAttributes = [NSAttributedString.Key.font: Common.font(ofSize: 15, weight: UIFont.Weight.regular), NSAttributedString.Key.foregroundColor: assetColor]

    let strMessage = NSMutableAttributedString()
    strMessage.append(NSAttributedString(string: String(Localization.localizedString(key: LocalizationKey.General_Symbol) + ": "), attributes: propertyNameAttributes))

    strMessage.append(NSAttributedString(string: String(a_assetID.getTicker(withReplayIndicator: false).string + "\n"), attributes: assetAttributes))

    if a_sOldPrice != a_sPrice
      {
      if a_otOrderType == .botstoplimit {
        strMessage.append(NSAttributedString(string: String(Localization.localizedString(key: LocalizationKey.Boleta_StopPrice) + ": "), attributes: propertyNameAttributes))
      } else {
        strMessage.append(NSAttributedString(string: String(Localization.localizedString(key: LocalizationKey.Boleta_Price) + ": "), attributes: propertyNameAttributes))
      }
      strMessage.append(NSAttributedString(string: String("de " + Common.formatStringfrom(value: a_sOldPrice, minDigits: floatDigits, maxDigits: floatDigits) + " para " + Common.formatStringfrom(value: a_sPrice, minDigits: floatDigits, maxDigits: floatDigits) + "\n"), attributes: propertyValueAttributes))
    }
    else
    {
      strMessage.append(NSAttributedString(string: String(Localization.localizedString(key: LocalizationKey.Boleta_Price) + ": "), attributes: propertyNameAttributes))

      strMessage.append(NSAttributedString(string: String(Common.formatStringfrom(value: a_sOldPrice, minDigits: floatDigits, maxDigits: floatDigits) + "\n"), attributes: propertyValueAttributes))
    }

    if a_nOldQty != a_nQty
      {
      strMessage.append(NSAttributedString(string: String(Localization.localizedString(key: LocalizationKey.Boleta_Quantity) + ": "), attributes: propertyNameAttributes))

        strMessage.append(NSAttributedString(string: String("de " + Common.formatQtyToString(value: a_nOldQty, forAsset: a_assetID, makeShort: false) + " para " + Common.formatQtyToString(value: a_nQty, forAsset: a_assetID, makeShort: false) + "\n"), attributes: propertyValueAttributes))
    }
    else
    {
      strMessage.append(NSAttributedString(string: String(Localization.localizedString(key: LocalizationKey.Boleta_Quantity) + ": "), attributes: propertyNameAttributes))

      strMessage.append(NSAttributedString(string: String(Common.formatQtyToString(value: a_nOldQty, forAsset: a_assetID, makeShort: false) + "\n"), attributes: propertyValueAttributes))
    }

    if (a_vtValidity) == .btfGoodTillDate
      {
      strMessage.append(NSAttributedString(string: String(Localization.localizedString(key: LocalizationKey.Boleta_Validity) + ": "), attributes: propertyNameAttributes))

        strMessage.append(NSAttributedString(string: String(Common.dateToStringFormat(date: a_dtValidityDate, watchlistFormat: false, asset: a_assetID) + "\n"), attributes: propertyValueAttributes))
    }
    else
    {
      strMessage.append(NSAttributedString(string: String(Localization.localizedString(key: LocalizationKey.Boleta_Validity) + ": "), attributes: propertyNameAttributes))

      strMessage.append(NSAttributedString(string: String(a_vtValidity.description() + "\n"), attributes: propertyValueAttributes))
    }
    
    let oldQty = Common.calcRealQty(value: a_nOldQty, forAsset: a_assetID)
    
    let oldTotal = Common.formatStringfrom(
      value: (Application.m_application.m_dicAssetInfo[a_assetID.getKey()]!.sContractMultiplier)! * a_sOldPrice * oldQty, minDigits: 2, maxDigits: 2)

    let newQty = Common.calcRealQty(value: a_nQty, forAsset: a_assetID)
    
    let newTotal = Common.formatStringfrom(
      value: (Application.m_application.m_dicAssetInfo[a_assetID.getKey()]!.sContractMultiplier)! * (a_sPrice) * newQty, minDigits: 2, maxDigits: 2)

    if oldTotal != newTotal
      {
      strMessage.append(NSAttributedString(string: String(Localization.localizedString(key: LocalizationKey.Boleta_Total) + ": "), attributes: propertyNameAttributes))

      strMessage.append(NSAttributedString(string: String("de " + oldTotal + " para " + newTotal + "\n"), attributes: propertyValueAttributes))
    }
    else
    {
      strMessage.append(NSAttributedString(string: String(Localization.localizedString(key: LocalizationKey.Boleta_Total) + ": "), attributes: propertyNameAttributes))

      strMessage.append(NSAttributedString(string: String(oldTotal + "\n"), attributes: propertyValueAttributes))
    }

    strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.SendOrderStatus_Broker)): ", attributes: propertyNameAttributes))

    strMessage.append(NSAttributedString(string: "\(broker!.strName!)\n", attributes: propertyValueAttributes))

    strMessage.append(NSAttributedString(string: "\(Localization.localizedString(key: LocalizationKey.General_Account)): ", attributes: propertyNameAttributes))

    strMessage.append(NSAttributedString(string: "\(account!.strAccountID)", attributes: propertyValueAttributes))

    return strMessage
  }

  // Exibe Alert de estrategia rejeitada
  @objc func StrategyRejected(note : NSNotification)
  {
    if let message = note.object as? String
    {
      showAlert(a_strTitle: ToastType.StrategyRejected.description, a_strMessage: message)
    }
  }
  
  // Exibe Alert de Strategy Result srAlert
  @objc func StrategyAlert(note : NSNotification)
  {
    if let message = note.object as? String
    {
      showAlert(a_strTitle: ToastType.StrategyAlert.description, a_strMessage: message)
    }
  }
  
  // MARK: - Scrolling Control

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
  {
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
  {
    m_bIsScrolling = true
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
  {
  }

  func finishedScrolling()
  {
  }

  // MARK: - Status Bar

  func setStatusBarText()
  {
    if let status = m_osStatus {
      var statusLabelCheck = m_statusLabel
      if let bookStatusLabel = bookViewController?.m_statusLabel
      {
        statusLabelCheck = bookStatusLabel
      }
      
      if let statusLabel = statusLabelCheck {
        statusLabel.text = status.descriptionStr()
        statusLabel.textColor = status.fontColorIOS()
        statusLabel.backgroundColor = UIColor.colorWithGradientStyle(gradientStyle: .UIGradientStyleTopToBottom, frame: statusLabel.frame, colors: status.clearBackgroundGradient())
        if let strDescription = m_strStatusDescription, strDescription != "", let statusLabelText = statusLabel.text
          {
          statusLabel.text = statusLabelText + " - " + strDescription
        }
      }
    }
  }

  @objc func UpdateLastOrderStatus(note: NSNotification)
  {
    if let order = note.object as? Order
    {
      m_osStatus = order.osStatus
      m_strStatusDescription = order.strText
      setStatusBarText()
      
      if newStockDetailViewController == nil {
        bookViewController?.fadeInFadeOutMsgView()
      } else {
        fadeInFadeOutMsgView()
      }
    }
    
  }

  func editPrice(a_sdSide: Side, a_sOldPrice: Double?, a_sNewPrice: Double?)
  {
    guard let priceBookAssetID = m_selectedAsset ,let result = Application.m_application.m_dicStocks[priceBookAssetID.getKey()]?.priceBook.editOrdersAtPrice(a_sdSide: a_sdSide, a_sOldPrice: a_sOldPrice, a_sNewPrice: a_sNewPrice, a_sLastTrade: m_sLastTrade, account: account) else
    {
      return
    }

    if result == SendOrderStatus.NoPassword
      {
      delegateVC?.showPasswordView(callback: { self.editPrice(a_sdSide: a_sdSide, a_sOldPrice: a_sOldPrice!, a_sNewPrice: a_sNewPrice) })
      m_sLongPressCurrentPrice = nil
      return
    }

    m_sEditFromPrice = nil
    m_sdEditSide = nil

    if result != SendOrderStatus.Success
      {
      netrixTableView.reloadData()
      showAlert(a_strTitle: "", a_strMessage: result.description())
    }
  }

  func editQty(a_sdSide: Side, a_newQty: Int, a_sPrice: Double?, a_otOrderType: OrderType, a_sNewPrice: Double?, a_octOrderClosingType: OrderClosingType = .octNone, isEdit: Bool = false) -> SendOrderStatus
  {
    guard let _ = Application.m_application.m_strSignature else
    {
      return SendOrderStatus.NoPassword
    }

    guard let account = account else
    {
      return SendOrderStatus.NoAccountSelected
    }

    guard let broker = broker else
    {
      return SendOrderStatus.NoBrokerSelected
    }

    guard var sSelectedPrice = a_sPrice else
    {
      return SendOrderStatus.InvalidPrice
    }

    guard var priceBookAssetID = m_selectedAsset, let assetInfo = Application.m_application.m_dicAssetInfo[priceBookAssetID.getKey()] else
    {
      return SendOrderStatus.InvalidAsset
    }
    
    if Application.m_application.handlesFractionary(), assetInfo.hasFractionary(),
       let fracInfo = Application.m_application.m_dicAssetInfo[assetInfo.getFractionaryAssetId().getKey()] {
      let qty = isEdit ? a_newQty - m_nEditQty : a_newQty
      let isNewQtdValidFractionary = fracInfo.isValidQtd(a_nQtd: qty)
      let isOldOrNewQtdInvalidNonFractionary = !assetInfo.isValidQtd(a_nQtd: m_nEditQty) || !assetInfo.isValidQtd(a_nQtd: a_newQty)
      if isNewQtdValidFractionary && isOldOrNewQtdInvalidNonFractionary {
        priceBookAssetID = fracInfo.m_aidAssetId
      }
    }

    var sQuotation = 0.0
    if let quote = m_sLastTrade
      {
      sQuotation = quote
    }

    var currentQty: Int = 0
    if a_sdSide == .bosbuy
      {
      if let qty = m_dicOrderBuyQtyByPrice[Common.formatStringfrom(value: sSelectedPrice, minDigits: 3, maxDigits: 3)]?.nQty
        {
        currentQty = qty
      }
    }
    else
    {
      if let qty = m_dicOrderSellQtyByPrice[Common.formatStringfrom(value: sSelectedPrice, minDigits: 3, maxDigits: 3)]?.nQty
        {
        currentQty = qty
      }
    }

    var sStopPrice: Double = -1
    if a_otOrderType == .botstoplimit
      {
      sStopPrice = sSelectedPrice
      if a_sdSide == .bosbuy
        {
        sSelectedPrice = sSelectedPrice + m_sMinIncrement * 30
      }
      else if a_sdSide == .bossell
        {
        sSelectedPrice = sSelectedPrice - m_sMinIncrement * 30
      }
    }

    if currentQty < a_newQty || m_sdEditSide == nil
      {
      // cria nova ordem com new - current
      let order = Order(a_strProfitId: nil, a_aidAssetId: priceBookAssetID, a_sdSide: a_sdSide, a_otOrderType: a_otOrderType)

      var price = sSelectedPrice

      if let newPrice = a_sNewPrice
        {
        if a_otOrderType == .botstoplimit
          {
          sStopPrice = newPrice
          if a_sdSide == .bosbuy
            {
            price = sStopPrice + m_sMinIncrement
          }
          else if a_sdSide == .bossell
            {
            price = sStopPrice - m_sMinIncrement
          }
        }
        else
        {
          price = newPrice
        }
      }

      var qty = a_newQty
      if m_sdEditSide != nil
        {
        qty = a_newQty - currentQty
      }

      var strategy = StrategyType.stNormal
      if (broker.bHasDayTrade(market: priceBookAssetID.m_nMarket) && Application.m_application.getStrategyType() == .stDayTrade) || (Application.m_application.m_userProduct.HasCoveredTradeMode(assetInfo: assetInfo) && [.stCoveredDayTrade, .stCoveredSwingTrade].contains(Application.m_application.getStrategyType()))
        {
        strategy = Application.m_application.getStrategyType()
      }

      order.setOrderData(a_strBroker: account.strBrokerID,
                         a_strAccount: account.strAccountID,
                         a_strOrderId: nil,
                         a_strClOrdId: nil,
                         a_osStatus: nil,
                         a_sPrice: price,
                         a_nQty: qty,
                         a_vtValidity: ValidityType.defaultType(),
                         a_dtValidityDate: Date(),
                         a_sStopPrice: sStopPrice,
                         a_sAvgPrice: nil,
                         a_sUserDefinedTotal: nil,
                         a_nCumQty: nil,
                         a_dtCreationDate: nil,
                         a_dtCloseDate: nil,
                         a_dtLastUpdate: nil,
                         a_nMsgId: nil,
                         a_strText: nil,
                         a_stStrategyType: strategy,
                         a_osPreviousStatus: nil,
                         a_etExecType: nil,
                         a_otOrderType: a_otOrderType,
                         a_octOrderClosingType: a_octOrderClosingType,
                         a_bIsFinancial: RoutingManager.shared.isFinancialOrder(orderType: a_otOrderType),
                         subAccountID: account.subAccountID)
      
      if !a_octOrderClosingType.isClose()
      {
        if broker.bHasOCO == true
        {
          order.setOCOStrategy(a_ostStrategy: StrategyManager.shared.ocoStrategySelected)
        }
      }
        
      let result = order.sendOrder(a_sQuotation: sQuotation, a_osOrderSource: OrderSourceType.superdom)

      return result.status
    }
    else if currentQty > a_newQty
      {
      var nQtyToCancel = currentQty - a_newQty

      // Monta array ordenado por lastUpdate
      var arOrder: [Order] = []
      for order in account.GetOrderList(a_aidAssetId: priceBookAssetID)
      {
        if let price = order.sPrice, Common.compareNearlyEqual(a: price, b: sSelectedPrice) && order.dtCreationDate != nil && order.dtCloseDate == nil
          {
          arOrder.append(order)
        }
      }
      arOrder.sort(by: { return $0.dtLastUpdate! > $1.dtLastUpdate! })

      // Cancela / edita ordens
      for order in arOrder
      {
        if var qty = order.nQty
          {
          if let cumQty = order.nCumQty
            {
            qty -= cumQty
          }
          if qty <= nQtyToCancel
            {
            if order.cancelOrder(a_osOrderSource: OrderSourceType.superdom) == SendOrderStatus.Success
              {
              nQtyToCancel -= qty
            }
          }
          else
          {
            if a_sNewPrice == nil
              {
              return order.editOrder(
                a_sPrice: order.sPrice!,
                a_nQty: qty - nQtyToCancel,
                a_userDefinedTotal: order.userDefinedTotal,
                a_sStopPrice: order.sStopPrice!,
                a_sQuotation: sQuotation,
                a_osOrderSource: OrderSourceType.superdom
              ).status
            }
            else
            {
              order.nQty = qty - nQtyToCancel
              return SendOrderStatus.Success
            }
          }
        }
        if nQtyToCancel <= 0
          {
          break
        }
      }
    }
    return SendOrderStatus.Success
  }


  func cancel(a_sdSide: Side, a_sPrice: Double?)
  {
    Nelogger.shared.log("SuperDOMViewController.cancel - User Pressed: Cancel")
    self.showNavigationBar()
    self.hideBoleta(centerTableView: false)
    let sideForLog = a_sdSide.descriptionStr()
    dismissKeyboard()
    var validateCancelAll = SendOrderStatus.NoAccountSelected
    if let account = account {
      validateCancelAll = account.ValidateCancelAll()
    }
    
    if validateCancelAll == SendOrderStatus.NoPassword {
      delegateVC?.showPasswordView(callback: { self.cancel(a_sdSide: a_sdSide, a_sPrice: a_sPrice) })
    } else if validateCancelAll == SendOrderStatus.Success {
      if Application.m_application.m_dicDefaultConfirm["ConfirmCancel"]! {
        delegateVC?.showConfirmationAlert(strTitle: Localization.localizedString(key: LocalizationKey.Boleta_OperationConfirmation), strMessage: NSMutableAttributedString(string: Localization.localizedString(key: LocalizationKey.OrderList_CancelOrder) + "?"), confirmationKey: "ConfirmCancel", action: {
          
          Nelogger.shared.log("Cancelar \(sideForLog): \(self.contextForLog)")
          var validateCancelAll = SendOrderStatus.NoAccountSelected
          if let account = self.account {
            validateCancelAll = account.ValidateCancelAll()
          }
          if validateCancelAll == SendOrderStatus.Success {
            self.editOrderHeight.constant = 0
            self.m_sSelectedPrice = nil
            self.editOrderView.isHidden = true
            
            let sendResult = Application.m_application.m_dicStocks[self.m_selectedAsset!.getKey()]?.priceBook.cancelOrdersAtPrice(a_sPrice: a_sPrice, a_sdSide: a_sdSide, account: self.account)
            
            if sendResult != SendOrderStatus.Success {
              self.delegateVC?.showAlert(a_strTitle: "", a_strMessage: sendResult!.description())
            }
          } else {
            Nelogger.shared.log("SuperDOMViewController.cancel - Cancelamento não é possível - Resultado da validação: \(validateCancelAll.description()) - Side: \(sideForLog) - Contexto: \(self.contextForLog)")
            self.delegateVC?.showAlert(a_strTitle: "", a_strMessage: validateCancelAll.description())
          }
        }, cancelAction: {
          Nelogger.shared.log("Cancelou Cancelar \(sideForLog): \(self.contextForLog)")
        })
      } else {
        Nelogger.shared.log("Cancelar \(sideForLog): \(contextForLog)")
        editOrderHeight.constant = 0
        m_sSelectedPrice = nil
        editOrderView.isHidden = true
        
        let sendResult = Application.m_application.m_dicStocks[m_selectedAsset!.getKey()]?.priceBook.cancelOrdersAtPrice(a_sPrice: a_sPrice, a_sdSide: a_sdSide, account: self.account)
        if sendResult != SendOrderStatus.Success {
          showAlert(a_strTitle: "", a_strMessage: sendResult!.description())
        }
      }
    } else {
      showAlert(a_strTitle: "", a_strMessage: validateCancelAll.description())
    }
  }

  // MARK: - Market Orders
  //****************************************************************************
  //
  //       Nome: buyMarketClick
  //  Descrição:
  //
  //    Criação: 02/05/2019  v1.3.64 Eduardo Varela Ribeiro
  //              - AlertView Customizado
  //
  //****************************************************************************
  @IBAction func buyMarketClick(_ sender: UIButton)
  {
    Statistics.shared.log(type: .stOrderInteraction, message: "Compra Mercado", value: "SuperDOM")
    dismissKeyboard()
    buyMarket()
  }

  func buyMarket()
  {
    Nelogger.shared.log("SuperDOMViewController.buyMarket - User Pressed: Buy Market")
    if app.m_strSignature == nil || app.m_strSignature == "" {
      delegateVC?.showPasswordView(callback: { self.buyMarket() })
      return
    }
    
    guard account != nil else
    {
      showAlert(a_strTitle: "", a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_NoAccountSelected))
      return
    }

    guard let priceBookAssetID = m_selectedAsset else
    {
      return
    }

    if let assetInfo = m_selectedAssetInfo, assetInfo.sMinPriceIncrement == nil
    {
      assetInfo.addToUpdateList(self)
    }

    let price = m_selectedStock?.getPriceForMarketOrder(sdSide: .bosbuy)

    guard let text = qtyTextFieldEntryOrder.text, let qty = Optional(Common.formatQtdInput(value: text, forAsset: priceBookAssetID)), qty > 0 else
    {
      showAlert(a_strTitle: "", a_strMessage: SendOrderStatus.InvalidQtd.description())
      return
    }
    if app.m_dicDefaultConfirm["ConfirmNew"]! {
      let isDayTrade = Application.m_application.m_bSwitchDayTradeMode
      let message = confirmNewOrderMessage(a_assetID: priceBookAssetID, a_otOrderType: .botmarket, a_sdSide: .bosbuy, a_stStrategy: Common.getStrategyType(isDayTrade: isDayTrade, isCovered: Application.m_application.m_bSwitchCoveredTradeMode, assetInfo: m_selectedAssetInfo), a_vtValidity: ValidityType.defaultType(), a_dtValidityDate: Date(), a_sPrice: price!, a_sStopPrice: 0, a_nQty: qty)

      
      delegateVC?.showConfirmationAlert(
        strTitle: Localization.localizedString(key: LocalizationKey.Boleta_NewOrder),
        strMessage: message,
        confirmationKey: "ConfirmNew",
        action: {
          Nelogger.shared.log("\(self.buyMarketButton.titleLabel?.text ?? "Compra Mercado"): \(self.contextForLog)")
          _ = self.sendOrder(a_sdSide: .bosbuy, a_otOrderType: .botmarket, a_sPrice: price, a_nQty: qty)
        }, cancelAction: {
          Nelogger.shared.log("Cancelou \(self.buyMarketButton.titleLabel?.text ?? "Compra Mercado"): \(self.contextForLog)")
        }
      )
      
    } else {
      Nelogger.shared.log("\(buyMarketButton.titleLabel?.text ?? "Compra Mercado"): \(contextForLog)")
      let _ = sendOrder(a_sdSide: .bosbuy, a_otOrderType: .botmarket, a_sPrice: price, a_nQty: qty)
    }
  }

  @IBAction func sellMarketClick(_ sender: UIButton)
  {
    Statistics.shared.log(type: .stOrderInteraction, message: "Venda Mercado", value: "SuperDOM")
    dismissKeyboard()
    sellMarket()
  }

  func sellMarket()
  {
    Nelogger.shared.log("SuperDOMViewController.sellMarket - User Pressed: Sell Market")
    if Application.m_application.m_strSignature == nil || Application.m_application.m_strSignature == "" {
      delegateVC?.showPasswordView(callback: { self.sellMarket() })
      return
    }

    guard let priceBookAssetID = m_selectedAsset else
    {
      return
    }
    
    guard account != nil else
    {
      showAlert(a_strTitle: "", a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_NoAccountSelected))
      return
    }

    if let assetInfo = m_selectedAssetInfo, assetInfo.sMinPriceIncrement == nil
    {
      assetInfo.addToUpdateList(self)
    }

    let price = m_selectedStock?.getPriceForMarketOrder(sdSide: .bossell)

    guard let text = qtyTextFieldEntryOrder.text, let qty = Optional(Common.formatQtdInput(value: text, forAsset: priceBookAssetID)), qty > 0 else
    {
      showAlert(a_strTitle: "", a_strMessage: SendOrderStatus.InvalidQtd.description())
      return
    }

    if Application.m_application.m_dicDefaultConfirm["ConfirmNew"]! {
      let isDayTrade = Application.m_application.m_bSwitchDayTradeMode
      let message = confirmNewOrderMessage(a_assetID: priceBookAssetID, a_otOrderType: .botmarket, a_sdSide: .bossell, a_stStrategy: Common.getStrategyType(isDayTrade: isDayTrade, isCovered: Application.m_application.m_bSwitchCoveredTradeMode, assetInfo: m_selectedAssetInfo), a_vtValidity: ValidityType.defaultType(), a_dtValidityDate: Date(), a_sPrice: price!, a_sStopPrice: 0, a_nQty: qty)

      delegateVC?.showConfirmationAlert(
        strTitle: Localization.localizedString(key: LocalizationKey.Boleta_NewOrder),
        strMessage: message,
        confirmationKey: "ConfirmNew",
        action: {
          Nelogger.shared.log("\(self.sellMarketButton.titleLabel?.text ?? "Venda Mercado"): \(self.contextForLog)")
          _ = self.sendOrder(a_sdSide: .bossell, a_otOrderType: .botmarket, a_sPrice: price, a_nQty: qty)
        }, cancelAction: {
          Nelogger.shared.log("Cancelou \(self.sellMarketButton.titleLabel?.text ?? "Venda Mercado"): \(self.contextForLog)")
        }
      )
    } else {
      Nelogger.shared.log("\(sellMarketButton.titleLabel?.text ?? "Venda Mercado"): \(contextForLog)")
      let _ = sendOrder(a_sdSide: .bossell, a_otOrderType: .botmarket, a_sPrice: price, a_nQty: qty)
    }
  }

  @IBAction func resetClick(_ sender: UIButton)
  {
    Statistics.shared.log(type: .stOrderInteraction, message: "Zerar", value: "SuperDOM")
    dismissKeyboard()
    resetPosition()
  }

  func resetPosition()
  {
    if Application.m_application.m_strSignature == nil || Application.m_application.m_strSignature == "" {
      delegateVC?.showPasswordView(callback: { self.resetPosition() })
      return
    }

    guard let priceBookAssetID = m_selectedAsset else
    {
      return
    }
    
    guard let account = account else
    {
      showAlert(a_strTitle: "", a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_NoAccountSelected))
      return
    }
    account.confirmCancelAndReset(assetID: priceBookAssetID, orderSource: OrderSourceType.superdom, sender: self, contextForLog: contextForLog, overrideClearOrders: nil)
  }

  @IBAction func invertClick(_ sender: UIButton)
  {
    Statistics.shared.log(type: .stOrderInteraction, message: "Inverter", value: "SuperDOM")
    dismissKeyboard()
    invertPosition()
  }
  
  func invertPosition()
  {
    if Application.m_application.m_strSignature == nil || Application.m_application.m_strSignature == "" {
      delegateVC?.showPasswordView(callback: { self.invertPosition() })
      return
    }

    guard let priceBookAssetID = m_selectedAsset else
    {
      return
    }
    
    guard let account = account else
    {
      showAlert(a_strTitle: "", a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_NoAccountSelected))
      return
    }
    account.confirmInvert(assetID: priceBookAssetID, orderSource: .superdom, sender: self, contextForLog: contextForLog)
  }

  // MARK: - Limit Orders

  @IBAction func buyLimitClick(_ sender: UIButton)
  {
    Statistics.shared.log(type: .stOrderInteraction, message: "Compra Limite", value: "SuperDOM")
    dismissKeyboard()
    buyLimit()
  }

  func buyLimit()
  {
    Nelogger.shared.log("SuperDOMViewController.buyLimit - User Pressed: Buy Limit")
    if Application.m_application.m_strSignature == nil || Application.m_application.m_strSignature == "" {
      delegateVC?.showPasswordView(callback: { self.buyLimit() })
      return
    }
    
    guard account != nil else
    {
      showAlert(a_strTitle: "", a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_NoAccountSelected))
      return
    }

    guard let priceBookAssetID = m_selectedAsset else
    {
      return
    }

    var orderType: OrderType = .botlimit
    var stopPrice: Double = 0.0

    if let price = m_sSelectedPrice, let bestBuyOffer = Application.m_application.m_dicStocks[priceBookAssetID.getKey()]?.priceBook.groupedBuyOffers.first?.price
      {
      if Common.compareNearlyEqual(a: price, b: bestBuyOffer + m_sMinIncrement)
        {
        orderType = .botlimit
      }
      else if let lastTrade = m_sLastTrade, price > bestBuyOffer + m_sMinIncrement && price > lastTrade
        {
        orderType = .botstoplimit
        stopPrice = price
      }

      guard let text = qtyTextFieldEntryOrder.text, let qty = Optional(Common.formatQtdInput(value: text, forAsset: priceBookAssetID)), qty > 0 else
      {
        showAlert(a_strTitle: "", a_strMessage: SendOrderStatus.InvalidQtd.description())
        return
      }

      if Application.m_application.m_dicDefaultConfirm["ConfirmNew"]! {
        let isDayTrade = Application.m_application.m_bSwitchDayTradeMode
        let message = confirmNewOrderMessage(a_assetID: priceBookAssetID, a_otOrderType: orderType, a_sdSide: .bosbuy, a_stStrategy: Common.getStrategyType(isDayTrade: isDayTrade, isCovered: Application.m_application.m_bSwitchCoveredTradeMode, assetInfo: m_selectedAssetInfo), a_vtValidity: ValidityType.defaultType(), a_dtValidityDate: Date(), a_sPrice: stopPrice > 0 ? price + m_sMinIncrement * 30 : price, a_sStopPrice: stopPrice, a_nQty: qty)

        delegateVC?.showConfirmationAlert(
          strTitle: Localization.localizedString(key: LocalizationKey.Boleta_NewOrder),
          strMessage: message,
          confirmationKey: "ConfirmNew",
          action: {
            Nelogger.shared.log("\(self.buyLimitButton.titleLabel?.text ?? "Compra Limite"): \(self.contextForLog)")
            _ = self.sendOrder(a_sdSide: .bosbuy, a_otOrderType: orderType, a_sPrice: price, a_nQty: qty)
          },
          cancelAction: {
            Nelogger.shared.log("Cancelou \(self.buyLimitButton.titleLabel?.text ?? "Compra Limite"): \(self.contextForLog)")
          }
        )
      } else {
        Nelogger.shared.log("\(buyLimitButton.titleLabel?.text ?? "Compra Limite"): \(contextForLog)")
        let _ = sendOrder(a_sdSide: .bosbuy, a_otOrderType: orderType, a_sPrice: price, a_nQty: qty)
      }
    } else {
      Nelogger.shared.log("ERROR : NoRefPrice \(buyLimitButton.titleLabel?.text ?? "Compra Limite"): \(contextForLog)")
      showAlert(a_strTitle: "", a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_NoRefPrice))
    }
  }

  @IBAction func sellLimitClick(_ sender: UIButton)
  {
    Statistics.shared.log(type: .stOrderInteraction, message: "Venda Limite", value: "SuperDOM")
    dismissKeyboard()
    sellLimit()
  }

  func sellLimit()
  {
    Nelogger.shared.log("SuperDOMViewController.sellLimit - User Pressed: Sell Limit")
    if Application.m_application.m_strSignature == nil || Application.m_application.m_strSignature == "" {
      delegateVC?.showPasswordView(callback: { self.sellLimit() })
      return
    }

    guard let priceBookAssetID = m_selectedAsset else
    {
      return
    }
    
    guard account != nil else
    {
      showAlert(a_strTitle: "", a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_NoAccountSelected))
      return
    }

    var orderType = OrderType.botlimit
    var stopPrice: Double = 0.0

    if let price = m_sSelectedPrice, let bestSellOffer = Application.m_application.m_dicStocks[priceBookAssetID.getKey()]?.priceBook.groupedSellOffers.first?.price
      {
      if Common.compareNearlyEqual(a: price, b: bestSellOffer - m_sMinIncrement)
        {
        orderType = OrderType.botlimit
      }
      else if let lastTrade = m_sLastTrade, price < bestSellOffer - m_sMinIncrement && price < lastTrade
        {
        orderType = OrderType.botstoplimit
        stopPrice = price
      }

        guard let text = qtyTextFieldEntryOrder.text, let qty = Optional(Common.formatQtdInput(value: text, forAsset: priceBookAssetID)), qty > 0 else
      {
        showAlert(a_strTitle: "", a_strMessage: SendOrderStatus.InvalidQtd.description())
        return
      }

      if Application.m_application.m_dicDefaultConfirm["ConfirmNew"]! {
        let isDayTrade = Application.m_application.m_bSwitchDayTradeMode
        let message = confirmNewOrderMessage(a_assetID: priceBookAssetID, a_otOrderType: orderType, a_sdSide: .bossell, a_stStrategy: Common.getStrategyType(isDayTrade: isDayTrade, isCovered: Application.m_application.m_bSwitchCoveredTradeMode, assetInfo: m_selectedAssetInfo), a_vtValidity: ValidityType.defaultType(), a_dtValidityDate: Date(), a_sPrice: stopPrice > 0 ? price - m_sMinIncrement * 30 : price, a_sStopPrice: stopPrice, a_nQty: qty)

        delegateVC?.showConfirmationAlert(
          strTitle: Localization.localizedString(key: LocalizationKey.Boleta_NewOrder),
          strMessage: message,
          confirmationKey: "ConfirmNew",
          action: {
            Nelogger.shared.log("\(self.sellLimitButton.titleLabel?.text ?? "Venda Limite"): \(self.contextForLog)")
            _ = self.sendOrder(a_sdSide: .bossell, a_otOrderType: orderType, a_sPrice: price, a_nQty: qty)
          },
          cancelAction: {
            Nelogger.shared.log("Cancelou \(self.sellLimitButton.titleLabel?.text ?? "Venda Limite"): \(self.contextForLog)")
          }
        )
      } else {
        Nelogger.shared.log("\(sellLimitButton.titleLabel?.text ?? "Venda Limite"): \(contextForLog)")
        let _ = sendOrder(a_sdSide: .bossell, a_otOrderType: orderType, a_sPrice: price, a_nQty: qty)
      }
    } else {
      Nelogger.shared.log("ERROR : NoRefPrice \(buyLimitButton.titleLabel?.text ?? "Compra Limite"): \(contextForLog)")
      showAlert(a_strTitle: "", a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_NoRefPrice))
    }
  }

  @IBAction func editButtonClick(_ sender: UIButton)
  {
    Statistics.shared.log(type: .stOrderInteraction, message: "Editar Ordem", value: "SuperDOM")
    dismissKeyboard()
    editOrder()
  }

  @IBAction func goToStrategies(_ sender: Any) {
    if let sdViewController = newStockDetailViewController {
      sdViewController.performSegue(withIdentifier: "showStrategySegue", sender: sdViewController)
    } else {
      performSegue(withIdentifier: "showStrategySegue", sender: self)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showStrategySegue" {
      if #available(iOS 13.0, *) {
        segue.destination.modalPresentationStyle = .automatic
      } else {
        // Fallback on earlier versions
        segue.destination.modalPresentationStyle = .fullScreen
      }
      segue.destination.providesPresentationContextTransitionStyle = true
      segue.destination.definesPresentationContext = true
    }
  }

  func editOrder()
  {
    Nelogger.shared.log("SuperDOMViewController.editOrder - User Pressed: Edit Order")

    if Application.m_application.m_strSignature == nil || Application.m_application.m_strSignature == "" {
      delegateVC?.showPasswordView(callback: { self.editOrder() })
      return
    }

    guard var priceBookAssetID = m_selectedAsset else
    {
      return
    }
    
    guard let account = account else
    {
      showAlert(a_strTitle: "", a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_NoAccountSelected))
      return
    }

    guard let side = m_sdEditSide else
    {
      showAlert(a_strTitle: "", a_strMessage: SendOrderStatus.InvalidPrice.description())
      return
    }

    guard let text = qtyTextFieldEditOrder.text, let qty = Optional(Common.formatQtdInput(value: text, forAsset: priceBookAssetID)), qty > 0 else
    {
      showAlert(a_strTitle: "", a_strMessage: SendOrderStatus.InvalidQtd.description())
      return
    }
    
    guard let price = Double(Common.formatNumericalInput(a_strInput: priceTextFieldEditOrder.text!)) else
    {
      showAlert(a_strTitle: "", a_strMessage: SendOrderStatus.InvalidPrice.description())
      return
    }
    let oldPrice = m_sSelectedPrice!
    self.showNavigationBar()
    
    if let info = Application.m_application.m_dicAssetInfo[priceBookAssetID.getKey()],  account.hasFractionaryOrderOnPrice(assetInfo: info, price: oldPrice) {
        priceBookAssetID = info.getFractionaryAssetId()
    }
    
    if m_nEditQty == qty, Common.compareNearlyEqual(a: price, b: oldPrice) {
      showAlert(a_strTitle: "", a_strMessage: SendOrderStatus.InvalidQtdAndPriceStatus.description())
      return
    }

    
    if Application.m_application.m_dicDefaultConfirm["ConfirmEdit"]!
      {
      let message = confirmEditionMsg(a_assetID: priceBookAssetID, a_otOrderType: m_otEditOrderType, a_sdSide: side, a_vtValidity: ValidityType.defaultType(), a_dtValidityDate: Date(), a_sOldPrice: oldPrice, a_nOldQty: m_nEditQty, a_sPrice: price, a_nQty: qty)

      delegateVC?.showConfirmationAlert(
        strTitle: Localization.localizedString(key: LocalizationKey.Boleta_EditOrder),
        strMessage: message,
        confirmationKey: "ConfirmEdit",
        action: {
          var result = SendOrderStatus.Success
          Nelogger.shared.log("\(self.editButton.titleLabel?.text ?? "Editar Order"): \(self.contextForLog)")
          if let selectedPrice = self.m_sSelectedPrice, Common.compareNearlyEqual(a: price, b: selectedPrice)
            {
            result = self.editQty(a_sdSide: side, a_newQty: qty, a_sPrice: price, a_otOrderType: self.m_otEditOrderType, a_sNewPrice: nil, isEdit: true)
          }
          else if qty == self.m_nEditQty
            {
            self.editPrice(a_sdSide: side, a_sOldPrice: self.m_sSelectedPrice, a_sNewPrice: price)
          }
          else
          {
            result = self.editQty(a_sdSide: side, a_newQty: qty, a_sPrice: self.m_sSelectedPrice, a_otOrderType: self.m_otEditOrderType, a_sNewPrice: price)
            if result == SendOrderStatus.Success
              {
              self.editPrice(a_sdSide: side, a_sOldPrice: self.m_sSelectedPrice, a_sNewPrice: price)
            }
          }

          if result == SendOrderStatus.Success
          {
            self.m_sSelectedPrice = nil
            self.hideBoleta(centerTableView: false)
          }
          else
          {
            self.showAlert(a_strTitle: "", a_strMessage: result.description())
          }
        },
        cancelAction: {
          Nelogger.shared.log("Cancelou \(self.editButton.titleLabel?.text ?? "Editar Order"): \(self.contextForLog)")
        }
      )
    } else {
      var result = SendOrderStatus.Success
      Nelogger.shared.log("\(editButton.titleLabel?.text ?? "Editar Order"): \(contextForLog)")

      if let selectedPrice = m_sSelectedPrice, Common.compareNearlyEqual(a: price, b: selectedPrice)
        {
        result = editQty(a_sdSide: side, a_newQty: qty, a_sPrice: price, a_otOrderType: m_otEditOrderType, a_sNewPrice: nil)
      }
      else if qty == m_nEditQty
        {
        editPrice(a_sdSide: side, a_sOldPrice: m_sSelectedPrice, a_sNewPrice: price)
      }
      else
      {
        result = editQty(a_sdSide: side, a_newQty: qty, a_sPrice: m_sSelectedPrice, a_otOrderType: m_otEditOrderType, a_sNewPrice: price)
        if result == SendOrderStatus.Success
          {
          editPrice(a_sdSide: side, a_sOldPrice: m_sSelectedPrice, a_sNewPrice: price)
        }
      }

      if result == SendOrderStatus.Success
        {
        hideBoleta(centerTableView: false)
        m_sSelectedPrice = nil
        editOrderHeight.constant = 0
        editOrderView.isHidden = true
      }
      else
      {
        showAlert(a_strTitle: "", a_strMessage: result.description())
      }
    }
  }

  func sendOrder(a_sdSide: Side, a_otOrderType: OrderType, a_sPrice: Double?, a_nQty: Int?, a_octOrderClosingType: OrderClosingType = .octNone) -> SendOrderStatus
  {
    guard let qty = a_nQty, qty > 0 else
    {
      showAlert(a_strTitle: "", a_strMessage: SendOrderStatus.InvalidQtd.description())
      return SendOrderStatus.InvalidQtd
    }

    let result = editQty(a_sdSide: a_sdSide, a_newQty: qty, a_sPrice: a_sPrice, a_otOrderType: a_otOrderType, a_sNewPrice: nil, a_octOrderClosingType: a_octOrderClosingType)

    if result == SendOrderStatus.NoPassword
      {
      delegateVC?.showPasswordView(callback: { let _ = self.sendOrder(a_sdSide: a_sdSide, a_otOrderType: a_otOrderType, a_sPrice: a_sPrice, a_nQty: a_nQty) })
    }
    else if result != SendOrderStatus.Success
      {
      showAlert(a_strTitle: "", a_strMessage: result.description())
    }

    return result
  }

  // MARK: - Steppers and TextFields
  
  @IBAction func priceTextFieldEditingChanged(_ sender: ProfitTextField)
  {
    m_cgpLastTouchLocation = nil
    if let amountString = sender.text?.currencyInputFormatting(m_nFloatDigits)
      {
      sender.text = amountString
      setSelectedPrice(a_sPrice: Double(Common.formatNumericalInput(a_strInput: amountString)) ?? 0)
    }
    else
    {
      m_sSelectedPrice = nil
    }
    netrixTableView.reloadData()
  }

  @IBAction func priceTextFieldEditionEditingChanged(_ sender: ProfitTextField) {
    if let amountString = sender.text?.currencyInputFormatting(m_nFloatDigits) {
      sender.text = amountString
      priceEditOrder.value = Double(Common.formatNumericalInput(a_strInput: amountString)) ?? 0
    }
  }
  
  /// Verifica se é necessário mudar o ativo para fracionário ou não conforme quantidade
  /// - Authors:
  /// Tháygoro Minuzzi Leopoldino
  @IBAction func qtyTextFieldEditingChanged(_ sender: ProfitTextField) {
    
    guard var asset = m_selectedAsset, var stock = app.m_dicStocks[asset.getKey()] else {
      Nelogger.shared.error("PriceBookAsset for SuperDOMViewController is nil")
      return
    }
    
    guard var info = app.m_dicAssetInfo[asset.getKey()] else {
      Nelogger.shared.error("AssetInfo for PriceBookAsset is nil")
      return
    }
    
    if isUsingFractionary, let fracInfo = info.getFractionaryAssetInfo(), let fracStock = app.m_dicStocks[info.getFractionaryAssetId().getKey()] {
      info = fracInfo
      stock = fracStock
      asset = info.getFractionaryAssetId()
    }
    
    let oldValue = sender == qtyTextFieldEntryOrder ? qtyEntryOrder.value : qtyEditOrder.value
    
    var value : Double = Double(Common.formatQtdInput(value: sender.text ?? "0", forAsset: asset))
  
    
    if Common.updateQtyTextField(sender, stock: stock, changeAssetToNonFractionaryClosure: changeAssetToNonFractionary, changeAssetToFractionaryClosure: changeAssetToFractionary, canChangeAsset: isChosenAssetFractionary == false) {
      if let sValue = Double(Common.formatNumericalInput(a_strInput: sender.text ?? "0"))
      {
        if stock.m_aidAssetID.isCrypto() {
          value = Common.canConvertDoubleToInt(sValue * Common.c_criptoConversion) ? Common.roundNumber(a_sValue: sValue * Common.c_criptoConversion, a_nDecimalPlaces: 8) : oldValue
        } else {
          value = sValue
        }
      }
    } else {
      value = oldValue
      sender.text = String(value)
      
      Common.updateQtyTextField(sender, stock: stock, changeAssetToNonFractionaryClosure: changeAssetToNonFractionary, changeAssetToFractionaryClosure: changeAssetToFractionary, canChangeAsset: !stock.isFractionary())
    }
    
    qtyEntryOrder.value = value

  }
  
  @IBAction func qtyTextFieldEditingDidEnd(_ sender: ProfitTextField) {
    guard var asset = m_selectedAsset, var stock = app.m_dicStocks[asset.getKey()] else {
      Nelogger.shared.error("PriceBookAsset for SuperDOMViewController is nil")
      return
    }
    
    guard var info = app.m_dicAssetInfo[asset.getKey()] else {
      Nelogger.shared.error("AssetInfo for PriceBookAsset is nil")
      return
    }
    
    if isUsingFractionary, let fracInfo = info.getFractionaryAssetInfo(), let fracStock = app.m_dicStocks[info.getFractionaryAssetId().getKey()] {
      info = fracInfo
      stock = fracStock
      asset = info.getFractionaryAssetId()
    }
    
    let oldValue = sender == qtyTextFieldEntryOrder ? qtyEntryOrder.value : qtyEditOrder.value
    
    var value : Double = Double(Common.formatQtdInput(value: sender.text ?? "0", forAsset: asset))
    
    if Common.updateQtyTextField(sender, stock: stock, changeAssetToNonFractionaryClosure: changeAssetToNonFractionary, changeAssetToFractionaryClosure: changeAssetToFractionary, canChangeAsset: isChosenAssetFractionary == false) {
      if var sValue = Double(Common.formatNumericalInput(a_strInput: sender.text ?? "0"))
      {
        if stock.m_aidAssetID.isCrypto() {
          sValue = sValue * Common.c_criptoConversion
        }
        let newQty = info.goToClosestValidQtd(a_nQtd: Common.roundNumber(a_sValue: sValue, a_nDecimalPlaces: 8))
        if stock.m_aidAssetID.isCrypto() {
          value = Common.canConvertDoubleToInt(newQty) ? Common.roundNumber(a_sValue: newQty, a_nDecimalPlaces: 8) : oldValue
        } else {
          value = newQty
        }
      }
    } else {
        value = oldValue
        sender.text = String(value)
        
        Common.updateQtyTextField(sender, stock: stock, changeAssetToNonFractionaryClosure: changeAssetToNonFractionary, changeAssetToFractionaryClosure: changeAssetToFractionary, canChangeAsset: !stock.isFractionary())
    }
    
    qtyEntryOrder.value = value
    qtyTextFieldEntryOrder.text = Common.formatQtyToString(value: Int(qtyEntryOrder.value), forAsset: asset, makeShort: false)
    
    if Common.updateQtyTextFieldAfterEditingEnd(sender, stock: stock) {
      qtyEntryOrder.value = Double(Common.formatQtdInput(value: sender.text ?? "", forAsset: asset))
      qtyTextFieldEntryOrder.text = Common.formatQtyToString(value: Int(qtyEntryOrder.value), forAsset: asset, makeShort: false)
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool
  {
    priceTextFieldEntryOrder.resignFirstResponder()
    priceTextFieldEditOrder.resignFirstResponder()
    qtyTextFieldEntryOrder.resignFirstResponder()
    qtyTextFieldEditOrder.resignFirstResponder()
    qtyTextFieldEntryOrder.resignFirstResponder()
    return true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == strategyTextField {
      textField.resignFirstResponder()
      if let sdViewController = newStockDetailViewController {
        sdViewController.performSegue(withIdentifier: "showStrategySegue", sender: sdViewController)
      } else {
        performSegue(withIdentifier: "showStrategySegue", sender: self)
      }
    }
  }
  
  // MARK: - Hide Navigation Bar with swipe implementation
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if m_bIsScrolling {
      self.hideOrShowNavigationBar(scrollView, hideSelector: hideSelector, showSelector: showSelector)
    }
  }
  
  func showSelector() {
    headerView.isHidden = false
    headerViewHeightConstraint.constant = Sizes.getTitleDefaultBoxHeight(titleType: .columnTitle)
  }
  
  func hideSelector() {
    headerView.isHidden = true
    headerViewHeightConstraint.constant = 0
  }
}

// MARK: - UITableViewDelegate
extension SuperDOMViewController: UITableViewDelegate
{
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return netrixCellHeight
  }

  func setSelectedPrice(a_sPrice: Double)
  {
    if !Application.m_application.m_userProduct.hasSuperDom()
    {
      m_sSelectedPrice = nil
      return
    }
    
    showOrderEntry()
    m_sdEditSide = nil

    m_sSelectedPrice = a_sPrice

    var nQty: Int = app.m_dicAssetInfo[m_selectedAsset?.getKey() ?? ""]?.qtdDefault ?? Int(qtyEntryOrder.minimumValue)
    if let text = qtyTextFieldEntryOrder.text, let priceBookAssetID = m_selectedAsset, let qty = Optional(Common.formatQtdInput(value: text, forAsset: priceBookAssetID)), qty > 0 {
      nQty = qty
    }

    sellLimitButton.setTitle(Localization.localizedString(key: LocalizationKey.BoletaSuperDOM_SellLimitButton), for: .normal)
    buyLimitButton.setTitle(Localization.localizedString(key: LocalizationKey.BoletaSuperDOM_BuyLimitButton), for: .normal)

    updateButtonsText()

    if let sellQtyAtPrice = m_dicOrderSellQtyByPrice[Common.formatStringfrom(value: a_sPrice, minDigits: 3, maxDigits: 3)],
      let buyQtyAtPrice = m_dicOrderBuyQtyByPrice[Common.formatStringfrom(value: a_sPrice, minDigits: 3, maxDigits: 3)],
      buyQtyAtPrice.nQty > 0 && sellQtyAtPrice.nQty > 0
      {
      if let point = m_cgpLastTouchLocation
        {
        if point.x > self.view.frame.width / 2
          {
          m_sdEditSide = .bossell
          m_otEditOrderType = sellQtyAtPrice.otOrderType
          nQty = sellQtyAtPrice.nQty
        }
        else
        {
          m_sdEditSide = .bosbuy
          m_otEditOrderType = buyQtyAtPrice.otOrderType
          nQty = buyQtyAtPrice.nQty
        }
        showEditOrder()
        view.bringSubviewToFront(editOrderView)
      }
    }
    else
    {
      if let qtyAtPrice = m_dicOrderBuyQtyByPrice[Common.formatStringfrom(value: a_sPrice, minDigits: 3, maxDigits: 3)], qtyAtPrice.nQty > 0
        {
        if let point = m_cgpLastTouchLocation, point.x < self.view.frame.width * 2 / 3
          {
          m_sdEditSide = .bosbuy
          m_otEditOrderType = qtyAtPrice.otOrderType
          nQty = qtyAtPrice.nQty
          showEditOrder()
          view.bringSubviewToFront(editOrderView)
        }
      }

      if let qtyAtPrice = m_dicOrderSellQtyByPrice[Common.formatStringfrom(value: a_sPrice, minDigits: 3, maxDigits: 3)], qtyAtPrice.nQty > 0
        {
        if let point = m_cgpLastTouchLocation, point.x > self.view.frame.width / 3
          {
          m_sdEditSide = .bossell
          m_otEditOrderType = qtyAtPrice.otOrderType
          nQty = qtyAtPrice.nQty
          showEditOrder()
          view.bringSubviewToFront(editOrderView)
        }
      }
      
      if let qtyAtPrice = m_dicStrategySellQtyByPrice[Common.formatStringfrom(value: a_sPrice, minDigits: 3, maxDigits: 3)]?.nQty, m_sdEditSide == nil {
        if let point = m_cgpLastTouchLocation, point.x > self.view.frame.width / 3 {
          Common.print("Strategy Sell QTD: \(qtyAtPrice)")
          hideBoleta()
          m_sdEditSide = .bossell
          nQty = qtyAtPrice
        }
      }
      
      if let qtyAtPrice = m_dicStrategyBuyQtyByPrice[Common.formatStringfrom(value: a_sPrice, minDigits: 3, maxDigits: 3)]?.nQty, m_sdEditSide == nil {
        if let point = m_cgpLastTouchLocation, point.x < self.view.frame.width * 2 / 3 {
          Common.print("Strategy Buy QTD: \(qtyAtPrice)")
          hideBoleta()
          m_sdEditSide = .bosbuy
          nQty = qtyAtPrice
        }
      }
    }

    setEditionAppearance()

    if let priceBookAssetID = m_selectedAsset {
      qtyTextFieldEntryOrder.text = Common.formatQtyToString(value: nQty, forAsset: priceBookAssetID, makeShort: false)
      qtyTextFieldEditOrder.text = Common.formatQtyToString(value: nQty, forAsset: priceBookAssetID, makeShort: false)
    }
   

    m_nEditQty = nQty

    priceEditOrder.value = Double(a_sPrice)

    priceEntryOrder.value = Double(a_sPrice)

    qtyEntryOrder.value = Double(nQty)
    qtyEditOrder.value = Double(nQty)


    priceTextFieldEditOrder.text = Common.formatStringfrom(value: a_sPrice, minDigits: m_nFloatDigits, maxDigits: m_nFloatDigits)
    
    Scheduler.shared.doTask(in: 0.1, withKey: "AlignCenterSuperDOM", andPriority: .main) {
      if let index = self.m_arNetrix.firstIndex(where: { Common.compareNearlyEqual(a: $0.sPrice, b: a_sPrice) }) {
        let indexPath = IndexPath(row: index, section: 0)
        self.netrixTableView.scrollToRow(at: indexPath, at: .none, animated: true)
      }
    }
    self.updateNetrixTableInsets()
  }

  private func GetMax() -> Double? {
    if let priceBookAssetID = m_selectedAsset, let stock = Application.m_application.m_dicStocks[priceBookAssetID.getKey()] {
      if let maxPrice = self.m_sMaxPrice {
        return maxPrice
      } else {
        let sellOffers = stock.priceBook.groupedSellOffers
        if sellOffers.isEmpty {
          if app.isCryptoTarget() {
            if let close: Double = stock.getLastDaily()?.sClose {
              return close * 0.75
            }
            return nil
          } else if priceBookAssetID.isProfitCrypto() {
            return nil
          } else if ExchangeManager.shared.isSaxo(a_nExchange: priceBookAssetID.m_nMarket.kotlin) {
            return stock.getValidTheoricPrice() + self.m_sMinIncrement * 20
          } else {
            return stock.getValidTheoricPrice() + 10 * 20
          }
        } else if sellOffers.count > 20 {
          return sellOffers[19].price
        } else {
          return sellOffers.last?.price
        }
      }
    } else {
      return nil
    }
  }
  
  private func GetMin() -> Double? {
    if let priceBookAssetID = m_selectedAsset, let stock = Application.m_application.m_dicStocks[priceBookAssetID.getKey()] {
      if let minPrice = self.m_sMinPrice {
        return minPrice
      } else {
        let buyOffers = stock.priceBook.groupedBuyOffers
        if buyOffers.isEmpty {
          if app.isCryptoTarget() {
            if let close: Double = stock.getLastDaily()?.sClose {
              return close * 1.25
            }
            return nil
          } else if ExchangeManager.shared.isSaxo(a_nExchange: priceBookAssetID.m_nMarket.kotlin) {
            return stock.getValidTheoricPrice() - self.m_sMinIncrement * 20
          } else {
            return max(stock.getValidTheoricPrice() - 10 * 20, 0)
          }
        } else if buyOffers.count > 20 {
          return buyOffers[19].price
        } else {
          return buyOffers.last?.price
        }
      }
    } else {
      return nil
    }
  }
  
}

// MARK: - UITableViewDataSource
extension SuperDOMViewController: UITableViewDataSource
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return m_arNetrix.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NeTrixTableViewCell.identifier, for: indexPath) as? NeTrixTableViewCell else {
      return UITableViewCell()
    }

    if indexPath.row < 0 || indexPath.row >= m_arNetrix.count {
      return cell
    }
    if let selectedAssetID = currentAssetID {
      cell.m_vcSuperDomViewController = self
      cell.m_superDOMItem = m_arNetrix[indexPath.row]
      cell.updateSuperDomCellData(selectedAssetID: selectedAssetID, qtyValue: Int(qtyEntryOrder.value))
    }

    return cell
  }
}

extension SuperDOMViewController {
  @objc func receivedStrategyNotification() {
    let strategySelected = StrategyManager.shared.ocoStrategySelected

    if let name = strategySelected?.name {
      strategyTextField.text = name
      strategyTextField.textColor = .white
    } else {
      strategyTextField.text = Localization.localizedString(key: .General_NoOCOStrategy)
      strategyTextField.textColor = UIColor.white.withAlphaComponent(0.4)
    }
    
    

    strategyTextField.endEditing(true)

  }
}

extension SuperDOMViewController {
  func updateViewOnPositionPropertyChanged(property: PositionProperties, value: AnyObject?, reference: AnyObject) {
    if property == .swingresult {
      setPositionView()
    }
  }
  
  @objc func receivedNewPositionNotification() {
    if let assetID = m_selectedAsset, let account = account, let position = account.GetPosition(a_aidAssetId: assetID)
    {
      position.addToUpdateList(self)
    }
    setPositionView()
  }
  
  func setPositionView()
  {
    if !app.m_userProduct.hasSuperDom() { return }
    
    resultLabel.textColor = Colors.StrResultFontColor
    priceLabel.text = Common.formatStringfrom(value: 0, minDigits: 2, maxDigits: 2)
    orderTypeAndCountLabel.text = "0"
    let exchange: Int32 = Application.m_application.m_acSelectedAccount?.exchangesArray.first ?? -1
    let ticker: String = Application.m_application.currencyTypeForPosition.getCode()
    let priceCode: String = Application.m_application.currencyTypeForPosition.priceCode
    
    if let assetID = m_selectedAsset, let account = account, let position = account.GetPosition(a_aidAssetId: assetID), let positionQty = position.getPositionQtyInt(), positionQty > 0, let positionSide = position.getPositionSide() {
      
      if positionViewHeight.constant != positionViewOpenHeight {
        UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseOut, animations: {
          self.positionViewHeight.constant = self.positionViewOpenHeight
        }) { _ in
          self.positionView.isHidden = false
        }
      }
      let positionAvgPrice = position.getPositionAvgPriceWithCurrency()
      if Application.m_application.isCryptoTarget() {
        if Application.m_application.shouldConvertAccountCurrency() {
          let text = Common.getFullString(value: positionAvgPrice.0, exchange: exchange, ticker: ticker, currency: priceCode)

          if let coloredText = Common.adjustCurrencyColor(text: text, currency: positionAvgPrice.1 ?? "", value: nil) {
            priceLabel.attributedText = coloredText
          } else {
            priceLabel.text = text
          }
        } else {
          priceLabel.text = "\(Common.formatPriceDigits(value: positionAvgPrice.0 ?? 0.0, exchange: exchange, ticker: ticker))"
        }
      } else {
        priceLabel.text = Application.m_application.shouldConvertAccountCurrency() ? ((positionAvgPrice.1 != nil ? positionAvgPrice.1 ?? "" + " " : "") + "\(Common.formatStringfrom(value: positionAvgPrice.0 ?? 0.0, minDigits: 2, maxDigits: 2))") : "\(Common.formatStringfrom(value: positionAvgPrice.0 ?? 0.0, minDigits: 2, maxDigits: 2))"      }
      
      let attributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: orderTypeAndCountLabel.font
      ]
      if positionSide == .bosbuy {
        orderTypeBackgroundView.backgroundColor = Colors.clChartTradingBuyButton.first
        orderTypeAndCountLabel.textColor = Colors.clSuperDOMPositionBuyBackgroundColor
        let text = "\(Localization.localizedString(key: .SuperDOM_BuyOrderResult)) \(Common.formatQtyToString(value: positionQty, forAsset: assetID, makeShort: false))"
        if (text as NSString).size(withAttributes: attributes).width + 4 + orderTypeBackgroundView.frame.minX < priceLabel.frame.minX + 5 {
          orderTypeAndCountLabel.text = text
        } else {
          orderTypeAndCountLabel.text = "\(Localization.localizedString(key: .SwingPosition_ShortBuy)) \(Common.formatQtyToString(value: positionQty, forAsset: assetID, makeShort: false))"
        }
      } else {
        orderTypeBackgroundView.backgroundColor = Colors.clChartTradingSellButton.first
        orderTypeAndCountLabel.textColor = .white
        let text = "\(Localization.localizedString(key: .SuperDOM_SellOrderResult)) \(Common.formatQtyToString(value: positionQty, forAsset: assetID, makeShort: false))"
        if (text as NSString).size(withAttributes: attributes).width + 4 + orderTypeBackgroundView.frame.minX < priceLabel.frame.minX + 5 {
          orderTypeAndCountLabel.text = text
        } else {
          orderTypeAndCountLabel.text = "\(Localization.localizedString(key: .SwingPosition_ShortSell)) \(Common.formatQtyToString(value: positionQty, forAsset: assetID, makeShort: false))"
        }
      
      }
      if orderTypeBackgroundView.frame.maxX >= priceLabel.frame.minX - 7 { // 5 é o espaçamento mínimo e 1 de respiro
        orderTypeAndCountLabel.text = "\(positionSide == .bosbuy ? Localization.localizedString(key: .SwingPosition_ShortBuy) : Localization.localizedString(key: .SwingPosition_ShortSell))  \(Common.formatQtyToString(value: positionQty, forAsset: assetID, makeShort: false))"
      }
 
      var resultText: String = ""


      if isPositionSimpleOpenResult {
        let simpleOpen = position.getSimpleOpenResultConverted()

        
        resultText = Common.getFullString(value: simpleOpen.value, exchange: exchange, ticker: ticker, currency: priceCode)

        
      } else {
        if ExchangeManager.shared.isBMF(a_nExchange: assetID.m_nMarket.kotlin) {
          if position.extraOpenResult != nil {
             resultText += "\(Common.formatStringfrom(value: position.extraOpenResult, minDigits: 2, maxDigits: 2))" + (position.extraOpenResult != nil ? " pts": "")
          } else {
            resultText = ""
          }
        } else {
          if position.extraOpenResult != nil {
             resultText += "\(Common.formatStringfrom(value: position.extraOpenResult, minDigits: 2, maxDigits: 2))" + (position.extraOpenResult != nil ? " %": "")
          } else {
            resultText = ""
          }
        }
      }
      resultLabel.text = resultText
      
      if let simpleOpenResultUnwrap = position.simpleOpenResult {
        if simpleOpenResultUnwrap > 0 {
          resultLabel.textColor = Colors.PosPositiveFontColor
        } else if simpleOpenResultUnwrap < 0 {
          resultLabel.textColor = Colors.PosNegativeFontColor
        }
      }
      
        if let coloredText = Common.adjustCurrencyColor(text: resultLabel.text, currency: priceCode, value: position.simpleOpenResult) {
          resultLabel.attributedText = coloredText
        }
              
    } else {
      resultLabel.text = "-"
      
      if positionViewHeight.constant != 0 {
        UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseOut, animations: {
          self.positionViewHeight.constant = 0
        }) { _ in
          self.positionView.isHidden = true
        }
      }
    }
    
    if Application.m_application.m_userProduct.shouldHidePositionResults() {
      resultLabel.text = ""
    }
    
    self.updateNetrixTableInsets()
  }
  
  func subscribeFractionaryStock(_ assetID: AssetIdentifier) {
    if app.m_dicAssetInfo[assetID.getKey()] == nil {
      app.m_hbMsgManager.sendSubscribeInfo(a_strTicker: assetID.m_strTicker, a_nMarket: assetID.m_nMarket)
    }
    app.m_hbMsgManager.sendSubscribeDaily(a_strTicker: assetID.m_strTicker, a_nMarket: assetID.m_nMarket)
  }
  
  func unsubscribeFractionaryStock(_ assetID: AssetIdentifier) {
    app.m_dicStocks[assetID.getKey()]?.removeFromUpdateList(self)
  }
}

extension SuperDOMViewController: StockUpdateDelegate {
  
  func update(sender: Stock, dataSerie: SeriesData, seriesKey: PriceSeriesKey) {
    calcAvgPrice()
  }
  
  func updateTrade(sender: Stock, trade: Trade, added: TData.AddedType) {
    m_ttTradeType   = trade.ttTradeType
    m_nLastTradeQty = Int(trade.nQtd)
    m_sLastTrade    = trade.sPrice
    calcAvgPrice()
  }
  
  func updateDaily(sender: Stock, daily: Daily) {
    guard sender.m_aidAssetID == m_selectedAsset else {
      return
    }
    let isFirstSet = m_sMinPrice == nil && m_sMaxPrice == nil
    m_sLastTrade = daily.sClose
    m_sMinPrice  = daily.sMin
    m_sMaxPrice  = daily.sMax
    m_ttTradeType = daily.ttTradeType
    m_nLastTradeQty = nil
    
    if isFirstSet {
      loadNetrixData()
      centerView()
    }
    calcAvgPrice()
  }
  
  func updatePriceBook(sender: Stock, property: PriceBookProperty) {
    guard sender.m_aidAssetID == m_selectedAsset else {
      return
    }
    optimizedLoadNetrixData()
  }
  
  func updateTinyBook(sender: Stock, qty: Int?, side: TinyBookSide, price: Double?) {
    guard sender.m_aidAssetID == m_selectedAsset else {
      return
    }
    calcAvgPrice()
    optimizedLoadNetrixData()
  }
  
  func updateTheoric(sender: Stock, qty: Int, price: Double) {
    guard sender.m_aidAssetID == m_selectedAsset else {
      return
    }
    calcAvgPrice()
  }
  
  func updateAssetState(sender: Stock) {
    guard sender.m_aidAssetID == m_selectedAsset else {
      return
    }
    if newStockDetailViewController == nil {
      Application.m_application.m_assetAlertManager.showAlertsFor(assetAlertDisplay: bookViewController ?? self)
    }
    testAlerts()
  }
}

extension SuperDOMViewController: AssetInfoUpdateDelegate {
  func updateAssetInfo(sender: AssetInfo) {
    m_nFloatDigits = sender.nDigitsPrice ?? sender.nFloatDigits
    if let minIncrement = sender.sMinPriceIncrementBook {
      m_sMinIncrement = minIncrement
      priceEditOrder.stepValue = sender.sMinOrderPriceIncrement ?? Double(minIncrement)
      priceEntryOrder.stepValue = sender.sMinOrderPriceIncrement ?? Double(minIncrement)
    }
    if let lote = sender.nLote {
      qtyEditOrder.stepValue = Double(lote)
      qtyEntryOrder.stepValue = Double(lote)
    }
    if let minQtd = sender.nMinOrderQtd {
      qtyEditOrder.minimumValue = Double(minQtd)
      qtyEntryOrder.minimumValue = Double(minQtd)
    }
    qtyEntryOrder.value = Double(sender.getQtdDefault())
    netrixTableView.reloadData()
    reloadNetrix()
    testAlerts()
  }
}

extension SuperDOMViewController: OrderUpdateDelegate {
  func updateOrder(sender: OrderDelegate) {
    
    loadOrderData()
    netrixTableView.reloadData()
    if let price = m_sSelectedPrice {
      setSelectedPrice(a_sPrice: price)
      priceTextFieldEntryOrder.text = Common.formatStringfrom(value: price, minDigits: m_nFloatDigits, maxDigits: m_nFloatDigits)
    }
  }
}

extension SuperDOMViewController: PositionUpdateDelegate {
  func getLifecycleScope() -> CoroutineScope {
    return CommonIOS.companion.getCoroutineScopeDefault()
  }
  
  func updatePosition(sender: PositionDelegate, property: PositionProperties) {
    if property == .swingresult || property.isSwingData {
      setPositionView()
    }
  }
}
extension SuperDOMViewController: AccountSelectionDelegate {
  func accountListController(_ viewController: AccountsListViewController, didSelectAccount account: Account) {
    self.switchAccounts(newAccount: account)
  }
  var currentAccount: Account? { account }
}
struct QtyAtPriceItem
{
  var nQty: Int
  var otOrderType: OrderType
}

struct SuperDOMItem
{
  var sPrice: Double
  var nQtdBuy: Int?
  var nQtdSell: Int?
}

extension SuperDOMViewController: NewOrderEntryUpdateDelegate {
  func setEditedPrice(price: Double) {
    setSelectedPrice(a_sPrice: price)
  }
  
  func getOrderType(orderType: OrderInputType) {
    if orderType == .botmarket {
      if m_sdEditSide == nil {
        self.m_sSelectedPrice = nil
        self.loadNetrixData()
        self.centerView(offset: 2)
      }
      self.netrixTableView.reloadData()
    }
  }
  
  func onOrderSent () {
    showNavigationBar()
  }
}
