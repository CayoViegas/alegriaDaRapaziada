// rejeita os mizeráveis

import Foundation
import UIKit
import sharedProfitPackage

protocol BoletaViewController: AnyObject {
  func setSelectedAsset(a_stoStock: Stock)
  func tapBuyViewWithoutAnimation(sender: UIView)
  func tapSellViewWithoutAnimation(sender:  UIView)
  func tapDayTradeViewWithoutAnimation(sender: UIView)
  func updateViewOnOrderPropertyChanged(property: OrderProperty, value: AnyObject?, reference: AnyObject)
  func updateViewOnInfoPropertyChanged(property: AssetInfoProperty, value: AnyObject?, reference: AnyObject)
  func sendOrderDayTrade(buttonType: BookOrderType, button: UIButton)
  func updateViewOnPropertyChanged(property: PriceBookProperty, value: AnyObject, reference: AnyObject)
  func cancelAndResetDidTap(_ sender: UIButton)
  func qtyStepperValueChangedDayTrade(_ sender: ProfitStepper)
  func updateViewOnPositionPropertyChanged(property: PositionProperties, value: AnyObject?, reference: AnyObject)
  func qtyTextFieldValueChangedDayTrade(_ sender: UITextField)
  func qtyTextFieldValueEditingDidEnd(_ sender: UITextField)
  
  func tapSellView(sender: UIView)
  func tapBuyView(sender: UIView)
  func dayTradeXibValueChanged(_ sender: UISwitch)
  func coveredTradeXibValueChanged(_ sender: UISwitch)
  
  var m_quantity:Double { get set }
  var contentView: UIView! { get set }
  var isChartsSegue: Bool { get set }
  var boletaTab: OrderEntryView { get set }
  var dayTradeView: UIView! { get set }
  var selectedOrder: Order? { get set }
  var isChosenAssetFractionary: Bool { get set }
}

enum OrderEntryView
{
  case Buy, Sell, DayTrade
}

class OldBoletaViewController: BaseViewController, BoletaViewController, InnerScrollControllerExtension
{
  // MARK: Labels
  @IBOutlet var buyLabel: UILabel!
  @IBOutlet var sellLabel: UILabel!
  @IBOutlet var dayTradeLabel: UILabel!
  @IBOutlet var dayTradeTitle: UILabel!
  @IBOutlet var coveredTradeTitle: UILabel!
  @IBOutlet var totalLabel: UILabel!
  @IBOutlet var dateTitleLabel: UILabel!
  @IBOutlet var validityTitleLabel: UILabel!
  @IBOutlet var typeTitleLabel: UILabel!
  @IBOutlet var qtyTitleLabel: UILabel!
  @IBOutlet var priceTitleLabel: UILabel!
  @IBOutlet var totalTitleLabel: UILabel!
  @IBOutlet var qtyResultTitleLabel: UILabel!
  @IBOutlet var qtyResultLabel: UILabel!
  @IBOutlet var averageResultTitleLabel: UILabel!
  @IBOutlet var averageResultLabel: UILabel!
  @IBOutlet var openResultTitleLabel: UILabel!
  @IBOutlet var openResultLabel: UILabel!
  @IBOutlet var totalResultTitleLabel: UILabel!
  @IBOutlet var totalResultLabel: UILabel!
  @IBOutlet var totalPositionTitleLabel: UILabel!
  @IBOutlet var totalPositionLabel: UILabel!
  var label: UILabel!
  @IBOutlet var strategyTitleLabel: UILabel!
  @IBOutlet var priceBookBuyQty: UILabel!
  @IBOutlet var priceBookBuy: UILabel!
  @IBOutlet var priceBookSell: UILabel!
  @IBOutlet var priceBookSellQty: UILabel!
  @IBOutlet var stopOffsetLabel: UILabel!
  @IBOutlet var icebergLabel: UILabel!
  
  // MARK: - VIEWS
  @IBOutlet var stopOffsetView: UIView!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var dateView: UIView!
  @IBOutlet var posContentView: UIView!
  @IBOutlet var backgorundView: UIView!
  @IBOutlet var contentView: UIView!
  @IBOutlet var buttonView: UIView!
  @IBOutlet var buyView: UIView!
  @IBOutlet var sellView: UIView!
  @IBOutlet var dayTradeView: UIView!
  @IBOutlet var positionView: UIView!
  @IBOutlet var headerPositionView: SectionTitle!
  @IBOutlet var symbolDataCollectionView: UICollectionView!
  @IBOutlet var orderListTableView: UITableView!
  @IBOutlet var priceBookView: UIView!
  @IBOutlet var headerPriceBookView: SectionTitle!
  @IBOutlet var headerView: UIView!
  @IBOutlet weak var offersTableView: UITableView!
  @IBOutlet var headerOrderListView: SectionTitle!
  @IBOutlet var orderListView: UIView!
  @IBOutlet var buyBottomLine: UIView!
  @IBOutlet var sellBottomLine: UIView!
  @IBOutlet var dayTradeBottomLine: UIView!
  @IBOutlet var dayTradeSwitchView: UIView!
  @IBOutlet var coveredTradeSwitchView: UIView!
  @IBOutlet var contentScroll: UIView!
  @IBOutlet weak var xibAccountView: XibView!
  @IBOutlet var icebergView: UIView!
  
  // MARK: - TEXTFIELDS AND STEPPERS
  @IBOutlet var priceTextField: UITextField!
  @IBOutlet var typeTextField: UITextField!
  @IBOutlet var priceStepper: ProfitStepper!
  @IBOutlet var qtyStepper: ProfitStepper!
  @IBOutlet var qtyTextField: UITextField!
  @IBOutlet var validityTextField: UITextField!
  @IBOutlet var dateTextField: UITextField!
  @IBOutlet var dayTradeSwitch: UISwitch!
  @IBOutlet var coveredTradeSwitch: UISwitch!
  @IBOutlet var strategyTextField: UITextField!
  @IBOutlet var strategySelectionArrow: UIImageView!
  @IBOutlet var stopOffsetTextField: UITextField!
  @IBOutlet var stopOffsetStepper: ProfitStepper!
  @IBOutlet var icebergTextField: UITextField!
  @IBOutlet var icebergStepper: ProfitStepper!
  @IBOutlet var scheduleView: UIView!
  @IBOutlet var scheduleTextField: UITextField!
  @IBOutlet var scheduleLabel: UILabel!
  
  // MARK: - BUTTONS
  @IBOutlet var sendButton: CustomButton!

  // MARK: - CONSTRAINTS
  @IBOutlet var posHeightCons: NSLayoutConstraint!
  @IBOutlet var orderHeightCons: NSLayoutConstraint!
  @IBOutlet var priceHeightCons: NSLayoutConstraint!
  @IBOutlet var contentHeightCons: NSLayoutConstraint!
  @IBOutlet var dateHeight: NSLayoutConstraint!
  @IBOutlet var stopOffsetHeight: NSLayoutConstraint!
  @IBOutlet var dayTradeHeight: NSLayoutConstraint!
  @IBOutlet var coveredTradeHeight: NSLayoutConstraint!
  @IBOutlet var icebergViewHeight: NSLayoutConstraint!
  @IBOutlet var scheduleViewHeight: NSLayoutConstraint!
  
  @IBOutlet weak var tabsBarTrailingDayTrade: NSLayoutConstraint!
  @IBOutlet weak var dayTradeLeadingSellViewTrailing: NSLayoutConstraint!
  @IBOutlet weak var sellViewTrailingTabsBar: NSLayoutConstraint!
  @IBOutlet weak var dayTradeViewWidth: NSLayoutConstraint!
    
  @IBOutlet var dataCollectionTopConstraint: NSLayoutConstraint!
  @IBOutlet var viewForReplay: UIView!
  @IBOutlet var viewForReplayHeight: NSLayoutConstraint!
  
  @IBOutlet var AccountViewHeightConstraint: NSLayoutConstraint!
  
  // MARK: - OBSERVERS
  
  let app = Application.m_application
  
  var isChartsSegue: Bool = false
  var isWatchListSegue: Bool = false
  var boletaTab: OrderEntryView = .Buy

  // MARK: - PROPERTIES
  var lastContentOffset: CGFloat = 0.0
  var lastContentHeight: CGFloat = 0.0
  var setStatusBar: Bool = true
  private var m_stockLabel: UILabel?
  var m_quantity : Double = 0
  var m_iceberg : Double = 0
  private var m_dayTrade: StrategyType = .stNormal
  private var m_statusMessageLabel: UILabel? = nil
  var orderDetailSegue = "showOrderDetail"
  var m_cgpEditViewLocation: CGPoint? = nil
  let sDayTradeHeight: CGFloat = 373.5 + 35
  // fileprivate var accountView: AccountView?
  var dayTradeXibView: DayTradeView?
  var optionsButton: UIBarButtonItem?
  //var m_stock: Stock?
  var m_sendType: Side = Side.bosbuy
  var m_validityPickerData: [ValidityType] = []
  var m_updatePriceField = true
  var m_Variation = 0.0
  var m_osStatus: OrderStatus? = nil
  var m_strStatusDescription: String? = nil
  var m_orderType: OrderType = OrderType.botlimit
  var m_selectedValidity: ValidityType?
  var m_date = Date()
  var m_scheduleDate: Date? = nil
  var m_clBackgroundColor: UIColor = .clear
  var m_acPreviousAccount: Account? = nil
  var m_nFloatDigits: Int
  {
    get
    {
      if let floatDigits = Application.m_application.m_dicAssetInfo[m_selectedAsset!.getKey()]?.nDigitsPrice ?? Application.m_application.m_dicAssetInfo[m_selectedAsset!.getKey()]?.nFloatDigits
      {
        return floatDigits
      }
      return 2
    }
  }
  
  var changedToFractionary: Bool = false
  var changedToNonFractionary: Bool = false
  var changedByTyping: Bool = false
  var fakeFullAsset: Bool = false
  var m_sMinIncrement = 0.01
  var m_bShowQtyBars: Bool = true
  var m_bvcBookPageViewController: BookViewController? = nil
  var selectedOrder: Order?
  var currentView: OrderEntryView = .Buy

  let cellId = "PriceBookCell"

  // MARK: - ESTRUTURAS
  enum OrderTypePickerData: Int {
    case botmarket    = 1
    case botlimit     = 2
    case botstoplimit = 4
    case botScheduled = 999
    
    func description() -> String {
      switch self {
      case .botmarket: return OrderType.botmarket.descriptionStr()
      case .botlimit: return OrderType.botlimit.descriptionStr()
      case .botstoplimit: return OrderType.botstoplimit.descriptionStr()
      case .botScheduled: return Localization.localizedString(key: LocalizationKey.OrderType_otSchedule)
      }
    }
    
    func getRealOrderType() -> OrderType {
      if self == .botScheduled {
        return .botlimit
      }
      else {
        return OrderType.companion.fromInt(type: Int32(self.rawValue)) ?? .botlimit
      }
    }
    
    static func getDefaultTypes() -> [OrderTypePickerData] {
      var defaultOrderTypes: [OrderTypePickerData] = [
        OrderTypePickerData.botlimit,
        OrderTypePickerData.botstoplimit,
        OrderTypePickerData.botmarket
      ]
      if Application.m_application.m_userProduct.canScheduleOrders() {
        defaultOrderTypes.append(OrderTypePickerData.botScheduled)
      }
      return defaultOrderTypes
    }
  }
  
  var strategies: [StrategyType] = []
  var m_arSellOffers: [PriceBookOffer] = []
  var m_arBuyOffers: [PriceBookOffer] = []
  var orderList: [Order] = []
  var m_orderTypePickerData: [OrderTypePickerData] = OrderTypePickerData.getDefaultTypes()

  var m_arStockCollectionData: [StockCollectionData] = [StockCollectionData(key: .StockProperty_Last, value: "-"),
    StockCollectionData(key: .Boleta_BuyBid, value: "-"),
    StockCollectionData(key: .Boleta_SellAsk, value: "-"),
    StockCollectionData(key: .StockProperty_Hour, value: "-"),
    StockCollectionData(key: .StockProperty_Variation, value: "-")]

  struct StockCollectionData
  {
    var key: LocalizationKey
    var value: String
  }
  
  var inAnimation = false

  // MARK: - GESTURES
  var m_grTap: UITapGestureRecognizer? = nil
  var m_grDoubleTap: UITapGestureRecognizer? = nil
  var m_grLongPress: UIGestureRecognizer? = nil

  // Variáveis temporárias para tratamento dos PickerViews
  var m_otOrderTypeTemp: OrderTypePickerData = .botlimit
  var m_vtValidityPickerDataTemp: ValidityType? = nil
  var m_dDataTemp: Date? = nil
  var m_dScheduleDateTemp: Date? = nil

  // MARK: - Position
  var m_simpleOpenResult: Double? = nil
  {
    didSet
    {
      guard !Application.m_application.m_userProduct.shouldHidePositionResults() else {
        openResultLabel.text = "-"
        openResultLabel.textColor = .white
        return
      }
      
      openResultLabel.textColor = .white
      
      if let selectedAsset: AssetIdentifier = m_selectedAsset {
        let isBovespa: Bool = ExchangeManager.shared.isBovespa(a_nExchange: selectedAsset.m_nMarket.kotlin)
        let isBMF: Bool = ExchangeManager.shared.isBMF(a_nExchange: selectedAsset.m_nMarket.kotlin)
        
        if isBovespa || isBMF {
          openResultLabel.text = "-"
          if let simpleOpenResult: Double = m_simpleOpenResult,
             let extraOpenResult: Double = m_extraOpenResult {
            let simpleText: String = Common.formatStringfrom(value: simpleOpenResult, minDigits: 2, maxDigits: 2)
            var extraText: String = ""
            
            if isBovespa {
              extraText = " (" + Common.formatStringfrom(value: extraOpenResult, minDigits: 2, maxDigits: 2, usePts: false) + ")"
            }
            else if isBMF {
              extraText = " (" + Common.formatStringfrom(value: (extraOpenResult * 1000) / 1000, minDigits: 2, maxDigits: 2, usePts: true) + ")"
            }
            
            openResultLabel.text = simpleText + extraText
          }
        }
      }
      
      if let simpleOpenResultUnwrap = m_simpleOpenResult {
        if simpleOpenResultUnwrap > 0
          {
          openResultLabel.textColor = Colors.PosPositiveFontColor
        }
        else if simpleOpenResultUnwrap < 0
          {
          openResultLabel.textColor = Colors.PosNegativeFontColor
        }
      }
    }
  }

  var m_extraOpenResult:Double? = nil
  {
    didSet
    {
      guard !Application.m_application.m_userProduct.shouldHidePositionResults() else {
        openResultLabel.text = "-"
        openResultLabel.textColor = .white
        return
      }
      
      if let selectedAsset: AssetIdentifier = m_selectedAsset {
        let isBovespa: Bool = ExchangeManager.shared.isBovespa(a_nExchange: selectedAsset.m_nMarket.kotlin)
        let isBMF: Bool = ExchangeManager.shared.isBMF(a_nExchange: selectedAsset.m_nMarket.kotlin)
        
        if isBovespa || isBMF {
          openResultLabel.text = "-"
          if let simpleOpenResult: Double = m_simpleOpenResult,
             let extraOpenResult: Double = m_extraOpenResult {
            let simpleText: String = Common.formatStringfrom(value: simpleOpenResult, minDigits: 2, maxDigits: 2)
            var extraText: String = ""
            
            if isBovespa {
              extraText = " (" + Common.formatStringfrom(value: (extraOpenResult * 1000) / 1000, minDigits: 2, maxDigits: 2, usePts: false) + ")"
            }
            else if isBMF {
              extraText = " (" + Common.formatStringfrom(value: (extraOpenResult * 1000) / 1000, minDigits: 2, maxDigits: 2, usePts: true) + ")"
            }
            
            openResultLabel.text = simpleText + extraText
          }
        }
      }
      
      openResultLabel.textColor = .white
      if let simpleOpenResultUnwrap = m_simpleOpenResult {
        if simpleOpenResultUnwrap > 0
          {
          openResultLabel.textColor = Colors.PosPositiveFontColor
        }
        else if simpleOpenResultUnwrap < 0
          {
          openResultLabel.textColor = Colors.PosNegativeFontColor
        }
      }
    }
  }

  var m_simpleTotalResult: Double? = 0.0
  {
    didSet
    {
      guard !Application.m_application.m_userProduct.shouldHidePositionResults() else {
        totalResultLabel.text = "-"
        totalResultLabel.textColor = .white
        return
      }
      
      var textTotalResult = Common.formatStringfrom(value: m_simpleTotalResult, minDigits: 2, maxDigits: 2)
      
      var valueCalculated: Double? = nil
      if let m_extraTotalResultUnwrap = m_extraTotalResult {
        valueCalculated = (m_extraTotalResultUnwrap * 1000) / 1000
      }
      
      if valueCalculated != nil, let selectedAsset: AssetIdentifier = m_selectedAsset {
        if ExchangeManager.shared.isBovespa(a_nExchange: selectedAsset.m_nMarket.kotlin) {
          textTotalResult += " (" + Common.formatStringfrom(value: valueCalculated, minDigits: 2, maxDigits: 2, usePts: false) + " )"
        }
        else if ExchangeManager.shared.isBMF(a_nExchange: selectedAsset.m_nMarket.kotlin) {
          textTotalResult += " (" + Common.formatStringfrom(value: valueCalculated, minDigits: 2, maxDigits: 2, usePts: true) + ")"
        }
      }

      totalResultLabel.text = textTotalResult
      totalResultLabel.textColor = .white
      
      if let simpleTotalResultUnwrap = m_simpleTotalResult {
        if simpleTotalResultUnwrap > 0
        {
          totalResultLabel.textColor = Colors.PosPositiveFontColor
        }
        else if simpleTotalResultUnwrap < 0
          {
          totalResultLabel.textColor = Colors.PosNegativeFontColor
        }
      }
    }
  }

  var m_extraTotalResult: Double? = nil
  {
    didSet
    {
      guard !Application.m_application.m_userProduct.shouldHidePositionResults() else {
        totalResultLabel.text = "-"
        totalResultLabel.textColor = .white
        return
      }
      
      var temp = Common.formatStringfrom(value: m_simpleTotalResult, minDigits: 2, maxDigits: 2)
      if let selectedAsset: AssetIdentifier = m_selectedAsset, let extraTotalResult: Double = m_extraTotalResult {
        if ExchangeManager.shared.isBovespa(a_nExchange: selectedAsset.m_nMarket.kotlin) {
          temp += " (" + Common.formatStringfrom(value: extraTotalResult, minDigits: 2, maxDigits: 2, usePts: false) + " )"
        }
        else if ExchangeManager.shared.isBMF(a_nExchange: selectedAsset.m_nMarket.kotlin) {
          temp += " (" + Common.formatStringfrom(value: extraTotalResult, minDigits: 2, maxDigits: 2, usePts: true) + ")"
        }
      }
      totalResultLabel.text = temp
      
      totalResultLabel.textColor = .white
      if let simpleTotalResultUnwrap = m_simpleTotalResult {
        if simpleTotalResultUnwrap > 0
        {
          totalResultLabel.textColor = Colors.PosPositiveFontColor
        }
        else if simpleTotalResultUnwrap < 0
        {
          totalResultLabel.textColor = Colors.PosNegativeFontColor
        }
      }
    }
  }

  var m_totalValueTrade: Double? = nil
  {
    didSet
    {
      if totalPositionLabel != nil {
          totalPositionLabel.text = Common.formatStringfrom(value: m_totalValueTrade, minDigits: 2, maxDigits: 2)
      }
    }
  }
  
  var contextForLog : String {
    get {
      return "Conta: \(String(describing: app.m_acSelectedAccount?.strAccountID)), Asset: \(m_selectedAsset!.getKey()), Price: \(priceStepper.value), Qtd: \(qtyStepper.value), stopOffset: \(stopOffsetStepper.value), SwingQty: \(String(describing: app.m_acSelectedAccount?.GetPosition(a_aidAssetId: m_selectedAsset!)?.getPositionQtyInt()))"
    }
  }
  
  var contextForOrderLog : (Order)->String = {
    return "Conta: \(String(describing: Application.m_application.m_acSelectedAccount?.strAccountID)), Asset: \($0.m_aidAssetId.getKey()), Price: \(String(describing: $0.sPrice)), Qtd: \(String(describing: $0.nQty)), StopPrice: \(String(describing: $0.sStopPrice)), SwingQty: \(String(describing: Application.m_application.m_acSelectedAccount?.GetPosition(a_aidAssetId: $0.m_aidAssetId)?.getPositionQtyInt()))"
  }
  
  var isChosenAssetFractionary : Bool = false
  
  @IBOutlet var strategyTextFieldTopSpace: NSLayoutConstraint!
  @IBOutlet var strategyLabelTopSpace: NSLayoutConstraint!
  @IBOutlet var strategyLabelBottomSpace: NSLayoutConstraint!
  @IBOutlet var strategyTextFieldBottomSpace: NSLayoutConstraint!
  
  @objc private func showStrategySelectionIfNeeded() {
    let hasOCO: Bool = Application.m_application.m_userProduct.HasOCOStrategy()
    
    strategyTextFieldTopSpace.isActive = hasOCO
    strategyTextFieldBottomSpace.isActive = hasOCO
    strategyLabelTopSpace.isActive = hasOCO
    strategyLabelBottomSpace.isActive = hasOCO
    
    dayTradeXibView?.strategyTextFieldTopSpace?.isActive = hasOCO
    dayTradeXibView?.strategyTextFieldBottomSpace?.isActive = hasOCO
    dayTradeXibView?.strategyLabelTopSpace?.isActive = hasOCO
    dayTradeXibView?.strategyLabelBottomSpace?.isActive = hasOCO
    
    strategyTitleLabel.isHidden = !hasOCO
    strategyTextField.isHidden = !hasOCO
    strategySelectionArrow.isHidden = !hasOCO
    
    dayTradeXibView?.strategyTitleLabel?.isHidden = !hasOCO
    dayTradeXibView?.strategyTextField?.isHidden = !hasOCO
    dayTradeXibView?.strategyArrow?.isHidden = !hasOCO
    
    lockStrategySelectionIfNeeded()
  }
  
  private func lockStrategySelectionIfNeeded() {
    let enableOco: Bool = isStrategySelectionEnabled()
    
    strategyTextField.isUserInteractionEnabled = enableOco
    strategyTextField.alpha = enableOco ? 1 : 0.5
    dayTradeXibView?.strategyTextField.isUserInteractionEnabled = enableOco
    dayTradeXibView?.strategyTextField.alpha = enableOco ? 1 : 0.5
    
    let strategySelected = StrategyManager.shared.ocoStrategySelected
    
    if enableOco, let name = strategySelected?.name {
      strategyTextField.text = name
      dayTradeXibView?.strategyTextField.text = name
    } else {
      strategyTextField.text = Localization.localizedString(key: .General_NoOCOStrategy)
      dayTradeXibView?.strategyTextField.text = Localization.localizedString(key: .General_NoOCOStrategy)
    }
  }
  
  private func isStrategySelectionEnabled() -> Bool {
    return Application.m_application.m_userProduct.HasOCOStrategy() && m_otOrderTypeTemp != .botScheduled
  }
  
  //****************************************************************************
  //
  //       Nome: longPressGestureRecognized
  //  Descrição:
  //
  //    Criação: 09/11/2016 v1.0 Guilherme Prates
  // Modificado: 23/04/2019 v1.3.62 Eduardo Varela Ribeiro
  //             - Reenvio da ordem na Boleta
  //
  //****************************************************************************
  @objc func longPressGestureRecognized(gestureRecognizer: UILongPressGestureRecognizer) {
    m_cgpEditViewLocation = gestureRecognizer.location(in: self.view)
    
    guard let indexPath = orderListTableView.indexPathForRow(at: gestureRecognizer.location(in: orderListTableView)) else {
      return
    }
    
    if gestureRecognizer.state == .began {
      selectedOrder = orderList[indexPath.row]
      orderOptionsMenu()
    }
  }

  //             06/02/2019   v1.3.42   Guilherme Cardoso Soares
  //             - Barra de Replay
  @IBOutlet var scrollViewBottomSpace: NSLayoutConstraint!
    
  // MARK: - VIEW LIFECYCLE
  //****************************************************************************
  //
  //       Nome: viewDidLoad
  //  Descrição: View foi carregada, não está visível ainda
  //
  //    Criação:
  // Modificado: 02/05/2018 v1.0 Ludgero Mascarenhas
  //             Add dismiss no status bar
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             22/04/2019  v1.3.62  Guilherme Cardoso Soares
  //             - Definir plataforma conforme tamanho de tela: Ajustes para iPad
  //****************************************************************************
  override func viewDidLoad()
  {
    super.viewDidLoad()
    Common.print("boleta did load")
    
    if let asset = Application.m_application.getDayTradeAssetID() {
      m_selectedAsset = asset
    } else {
      Nelogger.shared.log("BoletaViewController.viewDidLoad - dayTradeAsset nil")
    }
    
    if (Application.m_application.m_userProduct.IsHBPro()) {
      setTitle(a_strTitle: Localization.localizedString(key: .HB_BuySell))
    } else {
      setTitle(a_strTitle: Localization.localizedString(key: LocalizationKey.Boleta_OrderEntry))
    }
    scrollView.delegate = self
    
    offersTableView.register(PriceBookTableViewCell.self, forCellReuseIdentifier: cellId)

    SetupStatusBarView()

    // Observers
    //m_baoBookAssetObserver.target = self
    
    if isChartsSegue{
      if let stock = Application.m_application.getChartStock().m_stoStock {
        isChosenAssetFractionary = stock.isFractionary()
        setSelectedAsset(a_stoStock: stock)
      } else {
        Nelogger.shared.log("BoletaViewController.viewDidLoad - m_stoStock nil")
      }
    } else if isWatchListSegue {
      if let stock = m_selectedAsset {
        setSelectedAsset(a_stoStock: Stock(a_aidAssetId: stock))
      } else {
        Nelogger.shared.log("BoletaViewController.viewDidLoad - selectedAsset nil")
      }
    }

    // Gesture Recognizers
    if let accountView = xibAccountView.contentView as? AccountView
    {
      let tapAccount = UITapGestureRecognizer(target: self, action: #selector(tapAccountView(sender:)))
      accountView.addGestureRecognizer(tapAccount)
    }
    
    let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
    for direction in directions {
      let gesture = UISwipeGestureRecognizer(target: self, action: #selector(OldBoletaViewController.handleSwipe(gesture:)))
      gesture.direction = direction
      contentView?.addGestureRecognizer(gesture)
    }

    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)

    let tapBuy = UITapGestureRecognizer(target: self, action: #selector(tapBuyView(sender:)))
    buyView?.addGestureRecognizer(tapBuy)

    let tapSell = UITapGestureRecognizer(target: self, action: #selector(tapSellView(sender:)))
    sellView?.addGestureRecognizer(tapSell)

    if !app.m_userProduct.IsHBOne() {
      let tapDayTrade = UITapGestureRecognizer(target: self, action: #selector(tapDayTradeView(sender:)))
      dayTradeView?.addGestureRecognizer(tapDayTrade)
    }

    m_grDoubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapGestureRecognized(gestureRecognizer:)))
    m_grDoubleTap!.numberOfTapsRequired = 2
    m_grTap = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureRecognized(gestureRecognizer:)))
    m_grTap!.require(toFail: m_grDoubleTap!)
    m_grLongPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized(gestureRecognizer:)))

    orderListTableView.addGestureRecognizer(m_grLongPress!)
    orderListTableView.addGestureRecognizer(m_grDoubleTap!)
    orderListTableView.addGestureRecognizer(m_grTap!)
    
    headerPositionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerPositionButton)))
    headerOrderListView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerOrderListButton)))
    headerPriceBookView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerPriceBookButton)))

    // Xib
    if !app.m_userProduct.IsHBOne() {
      dayTradeXibView = DayTradeView.loadViewFromNib()
      scrollView.addSubview(dayTradeXibView!)
    }

    dayTradeXibView?.cardView.backgroundColor = Colors.PosViewBackgroundColor
    dayTradeXibView?.orderEntryViewModel = self

    let identifier = OrderListTableViewCell.identifier
    let nib = UINib(nibName: identifier, bundle: Bundle(for: AppDelegate.self))
    orderListTableView.register(nib, forCellReuseIdentifier: identifier)

    //Delegates
    symbolDataCollectionView.delegate = self
    symbolDataCollectionView.dataSource = self
    orderListTableView.delegate = self
    orderListTableView.dataSource = self
    priceTextField.delegate = self
    stopOffsetTextField.delegate = self
    strategyTextField.delegate = self
    typeTextField.delegate = self
    validityTextField.delegate = self
    dateTextField.delegate = self
    scheduleTextField.delegate = self
    dayTradeXibView?.strategyTextField?.delegate = self
    
    strategyTextField.inputView = UIView()
    dayTradeXibView?.strategyTextField?.inputView = UIView()

    // Setup
    setupAppearance()

    dayTradeLabel.text = Localization.localizedString(key: .OrderEntry_QuickTabTitle)
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      self.headerPriceBookButton(self)
      self.headerOrderListButton(self)
    }
  }

  //****************************************************************************
  //
  //       Nome: viewDidAppear
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             12/02/2019   v1.3.42   Guilherme Cardoso Soares
  //             - Barra de Replay
  //             13/02/2019 v1.3.44 Eduardo Varela Ribeiro
  //             - Funcionamento do Replay
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //****************************************************************************
  override func viewDidAppear(_ animated: Bool)
  {
    super.viewDidAppear(animated)

    self.navigationController?.setStatusBar(backgroundColor: Colors.primaryColor)
    if let assetID = m_selectedAsset, let stock = app.m_dicStocks[assetID.getKey()] {
      stock.addToUpdateList(self, extra: .PriceBook)
    }
    
    fetchOrderList()

    calculaHeigthConstraint()
    
    if let assetID = m_selectedAsset, let m_stock = app.m_dicStocks[assetID.getKey()]{
      self.updateTickerButton(a_strTicker: m_stock.m_aidAssetID.getKey())
    }

    Common.print("BoletaViewController.viewDidAppear")
    
    testForAlerts()
  }

  //****************************************************************************
  //
  //       Nome: viewWillAppear
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             13/02/2019   v1.3.42   Guilherme Cardoso Soares
  //             - Barra de Replay
  //             18/02/2019   v1.3.46   Guilherme Cardoso Soares
  //             - Barra de Replay: visível apenas se o ativo selecionado for o ativo de Replay
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             28/02/2019  v1.3.48  Guilherme Cardoso Soares
  //             - Notificação: NewPositionNotification
  //             18/03/2019  v1.3.54  Guilherme Cardoso Soares
  //             - Barra de Replay: definido delegate para abertura de modal
  //             01/04/2019  v1.3.56  Guilherme Cardoso Soares
  //             - Barra de Replay: remove a barra ao encerrar o replay via modal
  //             21/06/2019  v1.3.86  Guilherme Cardoso Soares
  //             - Subscribe PriceBook: não atualizada o pricebook da boleta ao usar o longPress
  //****************************************************************************
  override func viewWillAppear(_ animated: Bool)
  {
    Common.print("viewWillAppear BOLETA")
    m_dayTrade = Application.m_application.getStrategyType()
    dayTradeSwitch.isOn = Application.m_application.m_bSwitchDayTradeMode
    self.dayTradeXibView?.dayTradeSwitch.isOn = Application.m_application.m_bSwitchDayTradeMode
    coveredTradeSwitch.isOn = Application.m_application.m_bSwitchCoveredTradeMode
    self.dayTradeXibView?.coveredTradeSwitch.isOn = Application.m_application.m_bSwitchCoveredTradeMode
    showStrategySelectionIfNeeded()
    super.viewWillAppear(animated)

    self.addPasswordButton()
    self.updatePasswordButtonImage()
    
    Application.m_application.m_moCurrentView = .boleta

    Application.m_application.m_oMsgManager.m_strProfitIdLastOrder = nil
    Application.m_application.m_oMsgManager.m_nMsgIdLastOrder = nil

    setupDatePicker()
    setupScheduleDatePicker()
    setupValidityPicker()
    setupTypePicker()
    enableBoleta()
    loadStockData()
    calculaHeigthConstraint()
    if let accountView = xibAccountView.contentView as? AccountView
    {
      accountView.setAccountInformation()
    }

    self.navigationController?.navigationBar.shadowImage = UIImage()
    
    NotificationCenter.default.addObserver(self, selector: #selector(UpdateViewAccount), name: AccountReceivedNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(UpdateInfoSubscrition), name: LoginResultSuccess, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(UpdateLastOrderStatus), name: UpdateLastOrderNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(NewOrder), name: NewOrderNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(receivedNewPositionNotification), name: NewPositionNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(receivedStrategyNotification), name: OCOStrategySelectedNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(showStrategySelectionIfNeeded), name: BrokerInfoUpdatedNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateViewRightBarButtons), name: AssetStateChange, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(accountChanged), name: AccountChangedNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(StrategyRejected), name: StrategyRejectedNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(StrategyAlert), name: StrategyAlertNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didReceiveAssetInfo(notification:)), name: AssetInfoReceivedNotification, object: nil)
    if Application.m_application.isGenial() {
      NotificationCenter.default.addObserver(self, selector: #selector(genialSsoErrorAlert), name: GenialSsoError, object: nil)
    }
    
    checkIfAccountChanged()
    if priceHeightCons.constant != 32
    {
      if let assetID = m_selectedAsset, let stock = app.m_dicStocks[assetID.getKey()]
      {
        stock.addToUpdateList(self, extra: .PriceBook)
        m_arBuyOffers.removeAll()
        m_arSellOffers.removeAll()
        offersTableView.reloadData()
      }
    }
    navigationItem.rightBarButtonItems?.forEach({ (leftBarButton) in
      leftBarButton.tintColor = Colors.clNavigationBarTitleColor
    })
    if newStockDetailViewController == nil {
      self.addObserverForNavigationBar()
    if let assetID = m_selectedAsset, app.m_replay.replayAssetID.getKey() == assetID.getKey() && newStockDetailViewController == nil {
      if let replay = putReplayBar(using: viewForReplay.frame, with: self) {
        viewForReplayHeight.constant = 60
        viewForReplay.addSubview(replay)
        replayBarView = replay
        replayBarView?.setupSuperViewConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(replayFinished), name: ReplayFinished, object: nil)
        } else {
          replayBarView?.removeFromSuperview()
          replayBarView = nil
          viewForReplayHeight.constant = 0
        }
      } else {
        replayBarView?.removeFromSuperview()
        replayBarView = nil
        viewForReplayHeight.constant = 0
      }
    }

    if !Common.showAccountView() {
      AccountViewHeightConstraint.constant = 0
      xibAccountView.isHidden = true
    }
    else {
      AccountViewHeightConstraint.constant = 35
      xibAccountView.isHidden = false
    }

    receivedStrategyNotification()
    
    scrollView.setNeedsLayout()
    
    if isChosenAssetFractionary == false {
      changeAssetToNonFractionary(assetInfo: nil)
    }
    
    dayTradeXibView?.clearButton.setTitle(Localization.localizedString(key: LocalizationKey.Livro_Reset), for: .normal)
    dayTradeXibView?.clearAllButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_CancelAndReset), for: .normal)
    
    if isChartsSegue || isWatchListSegue {
        if boletaTab == .Buy {
            self.tapBuyViewWithoutAnimation(sender: self.contentView)
          } else if boletaTab == .Sell {
            self.tapSellViewWithoutAnimation(sender: self.contentView)
          } else {
            self.tapDayTradeViewWithoutAnimation(sender: self.contentView)
          }
      }
    
    if app.m_userProduct.HasDayTradeModeSwitch() {
      totalResultTitleLabel.isHidden = !app.m_bSwitchDayTradeMode
      totalResultLabel.isHidden = !app.m_bSwitchDayTradeMode
    }
  }
  
  @objc func didReceiveAssetInfo(notification: Foundation.Notification)  {
    if let assetID = self.m_selectedAsset, assetID == (notification.object as? AssetIdentifier) {
      enableBoleta()
    }
  }
  
  @objc func backToCharts() {
    self.navigationController?.navigationBar.isHidden = true
    self.navigationController?.popViewController(animated: true)
  }

  @objc func backToWatchList(){
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func accountChanged()
  {
    if let dayTradeAsset = m_selectedAsset {
      if let stock = Application.m_application.m_dicStocks[dayTradeAsset.getKey()] {
        loadPosition(m_stock: stock)
      }
    }
    if let accountView = xibAccountView.contentView as? AccountView
    {
      accountView.setAccountInformation()
    }
    fetchOrderList()
    setupValidityPicker()
    checkIfAccountChanged()
  }
  
  //******************************************************************************
  //
  // Nome:      replayFinished
  // Descrição: remove a view do replay ao encerrar o mesmo via modal
  //
  // Criação:     29/03/2019  v1.3.56 Guilherme Cardoso Soares
  // Modificado:
  //******************************************************************************
  @objc func replayFinished() {
    
    replayBarView?.removeFromSuperview()
    viewForReplayHeight.isActive = true
    
    if let assetID = m_selectedAsset, let stock = Application.m_application.m_dicStocks[assetID.getKey()] {
      setSelectedAsset(a_stoStock: stock)
    }
    
    self.view.setNeedsLayout()
    NotificationCenter.default.removeObserver(self, name: ReplayFinished, object: nil)
  }
  
  //******************************************************************************
  //
  // Nome:      viewWillDisappear
  // Descrição: View tornará invisível
  //
  // Criação:
  // Modificado: 13/02/2019   v1.3.42   Guilherme Cardoso Soares
  //             - Barra de Replay
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             28/02/2019  v1.3.48  Guilherme Cardoso Soares
  //             - Notificação: NewPositionNotification
  //             01/04/2019  v1.3.56  Guilherme Cardoso Soares
  //             - Barra de Replay: remove a barra ao encerrar o replay via modal
  //             21/06/2019  v1.3.86  Guilherme Cardoso Soares
  //             - Subscribe PriceBook: não atualizada o pricebook da boleta ao usar o longPress
  //******************************************************************************
  override func viewWillDisappear(_ animated: Bool)
  {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: NewOrderNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UpdateLastOrderNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: LoginResultSuccess, object: nil)
    NotificationCenter.default.removeObserver(self, name: NewPositionNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: OCOStrategySelectedNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: BrokerInfoUpdatedNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: AccountChangedNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: AccountReceivedNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: AssetStateChange, object: nil)
    NotificationCenter.default.removeObserver(self, name: StrategyRejectedNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: StrategyAlertNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: AssetInfoReceivedNotification, object: nil)
    if Application.m_application.isGenial() {
      NotificationCenter.default.removeObserver(self, name: GenialSsoError, object: nil)
    }
    
    if newStockDetailViewController == nil {
      self.removeObserverForNavigationBar()
      unsubscribeData()
      unsubscribePriceBook()
    }
    
    if isChosenAssetFractionary == false {
      changeAssetToNonFractionary(assetInfo: nil)
    }
    
    replayBarView?.removeFromSuperview()
    NotificationCenter.default.removeObserver(self, name: ReplayFinished, object: nil)
    NotificationCenter.default.removeObserver(self, name: AssetStateChange, object: nil)
    
    if isChartsSegue{
      Application.m_application.m_mvcMenu?.slideMenuController()?.addLeftGestures()
    }
  }

  //******************************************************************************
  //
  //       Nome: prepare
  //  Descrição: Notifica a view qual segue será executada e faz a troca de informações entre view controllers.
  //
  //    Criação: 15/01/2018  v1.0    Luís Felipe Polo
  // Modificado: 06/07/2018  v1.3.4  Luís Felipe Polo
  //             - Passar estrutura de dados de ordem de dicionário para array
  //             23/04/2019 v1.3.60 Eduardo Varela Ribeiro
  //             - Edição de ordem na lista de ordens
  //
  //******************************************************************************
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == "goToSetSymbolFromBoleta"
      {
      if let vc = segue.destination as? SetAssetViewController
        {
        vc.unwindTo = "unwindToOrderEntry"
      }
    }else if segue.identifier == orderDetailSegue
      {
      if let orderDetailViewController = segue.destination as? OrderDetailViewController
        {
        orderDetailViewController.m_orOrder = selectedOrder
        //selectedOrder = nil
      }
    }else if segue.identifier == "showOrderChangeFromList"{
      if let orderChangeViewController = segue.destination as? OrderChangeViewController
      {
        orderChangeViewController.m_orOrder = selectedOrder
      }
    } else if segue.identifier == "showStrategySegue" {
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

  //****************************************************************************
  //
  //       Nome: didRotate
  //  Descrição: Método chamado após rotação do aparelho
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
    offersTableView.reloadData()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
  {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { context in
      context.viewController(forKey: UITransitionContextViewControllerKey.from)
      // Stuff you used to do in willRotateToInterfaceOrientation would go here.
      // If you don't need anything special, you can set this block to nil.
      self.m_messageView?.removeFromSuperview()
      Common.print("viewWillTransition alongsideTransition")
    }, completion: { context in
        self.hideDayTradeTabIfNeeded()
        self.offersTableView.reloadData()
        self.orderListTableView.reloadData()
        Common.print("viewWillTransition completion")
      })
    self.navigationController?.updateStatusBar()
  }

  //****************************************************************************
  //
  //       Nome: unwindToOrderEntry
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6   Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             03/10/2018  v1.3.12  Luís Felipe Polo
  //             - Manter a última quantidade informada pelo usuário na boleta
  //             21/06/2019  v1.3.86  Guilherme Cardoso Soares
  //             - Subscribe PriceBook: não atualizada o pricebook da boleta ao usar o longPress
  //****************************************************************************
  @IBAction func unwindToOrderEntry(segue: UIStoryboardSegue)
  {
    if let vc = segue.source as? SetAssetViewController, let stock = vc.m_stkSelected
      {
      m_quantity = 0
      isChosenAssetFractionary = stock.isFractionary()
      setSelectedAsset(a_stoStock: stock)

      Application.m_application.m_aidDayTradeAsset = stock.m_aidAssetID
      if let assetID = m_selectedAsset, let stock = app.m_dicStocks[assetID.getKey()] {
        stock.addToUpdateList(self, extra: .PriceBook)
      }
      
        
      testForAlerts()

      m_arBuyOffers = []
      m_arSellOffers = []
      offersTableView.reloadData()
    }
    fetchOrderList()
  }

  func testForAlerts() {
    if let _ = m_selectedAsset, newStockDetailViewController == nil {
      Application.m_application.m_assetAlertManager.showAlertsFor(assetAlertDisplay: self)
    }
  }
  
  func unsubscribeData()
  {
    if let m_aidDayTradeAsset = m_selectedAsset {
      let referenceAssetId = Common.getReferenceAssetId(a_aidAssetId: m_aidDayTradeAsset)
      if m_aidDayTradeAsset != referenceAssetId, let referenceStock = app.m_dicStocks[referenceAssetId.getKey()]
      {
        referenceStock.removeFromUpdateList(self)
      }
      
      if let stock = app.m_dicStocks[m_aidDayTradeAsset.getKey()] {
        stock.removeFromUpdateList(self)
      }
      
      let info = Application.m_application.getAssetInfo(m_aidDayTradeAsset)
      info.removeFromUpdateList(self)
      if app.handlesFractionary(), info.hasFractionary() {
        if !info.isFractionary() {
          let fracInfo = app.getAssetInfo(info.getFractionaryAssetId())
          fracInfo.removeFromUpdateList(self)
        } else {
          let nonFracInfo = app.getAssetInfo(info.getNonFractionaryAssetId())
          nonFracInfo.removeFromUpdateList(self)
        }
      }
    }
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
  
  //****************************************************************************
  //
  //       Nome: setSelectedAsset
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //****************************************************************************
  func setSelectedAsset(a_stoStock: Stock)
  {
    unsubscribeData()
    m_selectedAsset = a_stoStock.m_aidAssetID
    app.m_aidDayTradeAsset = a_stoStock.m_aidAssetID
    testForAlerts()
    loadStockData()
    fetchOrderList()
  }

  func changeAssetToNonFractionary(assetInfo: AssetInfo?) {
    var assetInfoToTest = assetInfo
    if assetInfo == nil {
      guard let asset = m_selectedAsset else {
        Nelogger.shared.error("DayTradeAsset for BoletaViewController is nil")
        return
      }

      guard let info = app.m_dicAssetInfo[asset.getKey()] else {
        Nelogger.shared.error("AssetInfo for DayTradeAsset is nil")
        return
      }
      assetInfoToTest = info
    }

    guard let _assetInfo = assetInfoToTest, _assetInfo.hasFractionary(), _assetInfo.isFractionary() else {
      return
    }
    
    fakeFullAsset = false
    let nonFractionaryAssetId = _assetInfo.getNonFractionaryAssetId()
    unsubscribePriceBook()

    let stock: Stock = app.getStock(assetID: nonFractionaryAssetId)
    setSelectedAsset(a_stoStock: stock)

    qtyTextField.backgroundColor = Colors.UserEntryBackgroundColor
    dayTradeXibView?.qtyTextField.backgroundColor = Colors.UserEntryBackgroundColor
  }
    
  func changeAssetToFractionary(assetInfo: AssetInfo?) {
    var assetInfoToTest = assetInfo
    if assetInfo == nil {
      guard let asset = m_selectedAsset else {
        Nelogger.shared.error("DayTradeAsset for BoletaViewController is nil")
        return
      }

      guard let info = app.m_dicAssetInfo[asset.getKey()] else {
        Nelogger.shared.error("AssetInfo for DayTradeAsset is nil")
        return
      }
      assetInfoToTest = info
    }

    guard let _assetInfo = assetInfoToTest, _assetInfo.hasFractionary(), !_assetInfo.isFractionary() else {
      return
    }

    fakeFullAsset = true
    let fractionaryAssetId = _assetInfo.getFractionaryAssetId()
    unsubscribePriceBook()

    let stock: Stock = app.getStock(assetID: fractionaryAssetId)
    setSelectedAsset(a_stoStock: stock)

    qtyTextField.backgroundColor = Colors.clFractionaryQtd
    dayTradeXibView?.qtyTextField.backgroundColor = Colors.clFractionaryQtd
  }
  
  override func changeViewAsset(_ asset: AssetIdentifier) {
    m_selectedAsset = asset
    if let stock = Application.m_application.m_dicStocks[asset.getKey()]{
      if newStockDetailViewController == nil {
        setSelectedAsset(a_stoStock: stock)
      } else {
        if self.view.window != nil {
          testForAlerts()
          loadStockData()
          fetchOrderList()
        }
      }
    }
  }
  // MARK: - Interface
  //******************************************************************************
  //
  // Nome:      setStatusBarText
  // Descrição:
  //
  // Criação:
  // Modificado:
  //
  //******************************************************************************
  func setStatusBarText()
  {
    //SetupStatusBarView()
    if let status = m_osStatus
      {
      m_statusLabel?.text = status.descriptionStr()
      m_statusLabel?.textColor = status.fontColorIOS()
      m_statusLabel?.backgroundColor = UIColor.colorWithGradientStyle(gradientStyle: .UIGradientStyleTopToBottom, frame: m_statusLabel!.frame, colors: status.clearBackgroundGradient())
      if let strDescription = m_strStatusDescription, strDescription != ""
        {
        m_statusLabel?.text = m_statusLabel!.text! + " - " + strDescription
      }
    }
  }

  //******************************************************************************
  //
  //       Nome: viewDidLayoutSubviews
  //  Descrição: Posiciona elementos de layout inseridos via código, chamada quando
  //              as xib são carregadas
  //
  //    Criação:
  // Modificado: 12/02/2019   v1.3.42   Guilherme Cardoso Soares
  //             - Barra de Replay
  //
  //******************************************************************************
  override func viewDidLayoutSubviews()
  {
    Common.print("boleta did layout subviews")
    super.viewDidLayoutSubviews()
    // let accountViewHeight = 35
    
    var y = 0
    if let height = navigationController?.navigationBar.frame.height
      {
      y = Int(height)
      if let hidden = navigationController?.prefersStatusBarHidden
        {
        y += (hidden ? 0 : 20)
      }
    }


    var dayTHeight = sDayTradeHeight
    if !strategies.contains(.stDayTrade) || !Application.m_application.m_userProduct.HasDayTradeSwitchAtBoleta() {
      dayTHeight -= 35
    }
    
    if !Application.m_application.m_userProduct.HasCoveredTradeMode(assetInfo: m_selectedAssetInfo) {
      dayTHeight -= 35
    }
    
    if !Application.m_application.m_userProduct.HasOCOStrategy() {
      dayTHeight -= 45
    }
    
    dayTradeXibView?.cardViewHeightCons.constant = dayTHeight

    if currentView == .Buy || currentView == .Sell
      {
      dayTradeXibView?.isHidden = true
      contentView.isHidden = false
    }
    else if currentView == .DayTrade
      {
      dayTradeXibView?.isHidden = false
      contentView.isHidden = true
    }

    if let dtXibView = dayTradeXibView {
      dtXibView.frame = CGRect(x: 0, y: Int(contentView.frame.minY), width: Int(view.frame.width), height: Int(dtXibView.cardViewHeightCons.constant))
    }

    /*if let replayBar = replayBarView {
      scrollViewBottomSpace.constant = -1 * replayBar.heightBar
    } else {
      scrollViewBottomSpace.constant = 0
    }*/

    view.layoutIfNeeded()

  }

  //******************************************************************************
  //
  // Nome:      setupAppearance
  // Descrição:
  //
  // Criação:
  // Modificado: 20/03/2019 v1.3.54 Eduardo Varela Ribeiro
  //             - Correção crash BTG
  //
  //******************************************************************************
  private func setupAppearance()
  {
    backgorundView.backgroundColor = Colors.PosViewBackgroundColor
    contentScroll.backgroundColor = Colors.PosViewBackgroundColor
    contentView.backgroundColor = Colors.PosViewBackgroundColor
    buttonView.backgroundColor = Colors.menuBackgroundColor
    symbolDataCollectionView.backgroundColor = Colors.menuBackgroundColor
    orderListTableView.backgroundColor = Colors.PosViewBackgroundColor
    dayTradeView.backgroundColor = Colors.menuBackgroundColor
    buyView.backgroundColor = Colors.menuBackgroundColor
    sellView.backgroundColor = Colors.menuBackgroundColor
    headerPriceBookView.backgroundColor = Colors.PosComponentBackgroundColor
    priceBookView.backgroundColor = Colors.PosViewBackgroundColor
    headerView.backgroundColor = Colors.PosComponentBackgroundColor
    offersTableView.backgroundColor = Colors.BookBackgroundColor
    positionView.backgroundColor = Colors.PosViewBackgroundColor
    orderListView.backgroundColor = Colors.PosViewBackgroundColor
    headerOrderListView.backgroundColor = Colors.PosComponentBackgroundColor
    posContentView.backgroundColor = Colors.PosViewBackgroundColor

    buyLabel.textColor = UIColor(rgb: 0xFFFFFF)
    buyLabel.adjustsFontSizeToFitWidth = true
    buyLabel.text = Localization.localizedString(key: LocalizationKey.Boleta_Buy)
    sellLabel.textColor = UIColor(rgb: 0xFFFFFF)
    sellLabel.adjustsFontSizeToFitWidth = true
    sellLabel.text = Localization.localizedString(key: LocalizationKey.Boleta_Sell)
    dayTradeLabel.textColor = UIColor(rgb: 0xFFFFFF)
    dayTradeLabel.adjustsFontSizeToFitWidth = true
    totalLabel.textColor = UIColor(rgb: 0xFFFFFF)
    dateTitleLabel.textColor = UIColor(rgb: 0xFFFFFF)
    dateTitleLabel.adjustsFontSizeToFitWidth = true
    dateTitleLabel.text = Localization.localizedString(key: LocalizationKey.OrderList_Date)
    validityTitleLabel.textColor = UIColor(rgb: 0xFFFFFF)
    validityTitleLabel.adjustsFontSizeToFitWidth = true
    validityTitleLabel.text = Localization.localizedString(key: LocalizationKey.Boleta_Validity)
    scheduleLabel.textColor = UIColor(rgb: 0xFFFFFF)
    scheduleLabel.adjustsFontSizeToFitWidth = true
    scheduleLabel.text = Localization.localizedString(key: LocalizationKey.Boleta_ToSchedule)
    typeTitleLabel.textColor = UIColor(rgb: 0xFFFFFF)
    typeTitleLabel.adjustsFontSizeToFitWidth = true
    typeTitleLabel.text = Localization.localizedString(key: LocalizationKey.Boleta_Type)
    qtyTitleLabel.textColor = UIColor(rgb: 0xFFFFFF)
    qtyTitleLabel.text = Localization.localizedString(key: LocalizationKey.Boleta_Qty)
    qtyTitleLabel.adjustsFontSizeToFitWidth = true
    icebergLabel.textColor = UIColor(rgb: 0xFFFFFF)
    icebergLabel.adjustsFontSizeToFitWidth = true
    icebergLabel.text = Localization.localizedString(key: LocalizationKey.Boleta_Iceberg)
    stopOffsetLabel.textColor = UIColor(rgb: 0xFFFFFF)
    stopOffsetLabel.adjustsFontSizeToFitWidth = true
    stopOffsetLabel.text = Localization.localizedString(key: LocalizationKey.Boleta_StopOffset)
    priceTitleLabel.textColor = UIColor(rgb: 0xFFFFFF)
    priceTitleLabel.adjustsFontSizeToFitWidth = true
    priceTitleLabel.text = Localization.localizedString(key: LocalizationKey.Boleta_Price)
    totalTitleLabel.textColor = UIColor(rgb: 0xFFFFFF)
    totalLabel.adjustsFontSizeToFitWidth = true
    dayTradeTitle.textColor = UIColor(rgb: 0xFFFFFF)
    dayTradeTitle.adjustsFontSizeToFitWidth = true
    coveredTradeTitle.textColor = UIColor(rgb: 0xFFFFFF)
    coveredTradeTitle.adjustsFontSizeToFitWidth = true
    //priceBookLabel.adjustsFontSizeToFitWidth = true
    qtyResultTitleLabel.textColor = UIColor(rgb: 0xFFFFFF)
    qtyResultTitleLabel.adjustsFontSizeToFitWidth = true
    qtyResultTitleLabel.text = Localization.localizedString(key: LocalizationKey.Boleta_Qty)
    qtyResultLabel.textColor = UIColor(rgb: 0xFFFFFF)
    qtyResultLabel.adjustsFontSizeToFitWidth = true
    averageResultTitleLabel.textColor = UIColor(rgb: 0xFFFFFF)
    averageResultTitleLabel.text = Localization.localizedString(key: LocalizationKey.Boleta_Average)
    averageResultLabel.adjustsFontSizeToFitWidth = true
    averageResultLabel.textColor = UIColor(rgb: 0xFFFFFF)
    openResultTitleLabel.textColor = UIColor(rgb: 0xFFFFFF)
    openResultTitleLabel.text = Localization.localizedString(key: LocalizationKey.Position_OpenResult)
    openResultLabel.textColor = UIColor(rgb: 0xFFFFFF)
    openResultLabel.adjustsFontSizeToFitWidth = true
    totalResultTitleLabel.textColor = UIColor(rgb: 0xFFFFFF)
    totalResultTitleLabel.text = Localization.localizedString(key: LocalizationKey.Position_TotalResult)
    totalResultLabel.textColor = UIColor(rgb: 0xFFFFFF)
    totalResultLabel.adjustsFontSizeToFitWidth = true
    totalPositionTitleLabel.textColor = UIColor(rgb: 0xFFFFFF)
    totalPositionTitleLabel.adjustsFontSizeToFitWidth = true
    totalPositionLabel.textColor = UIColor(rgb: 0xFFFFFF)
    totalPositionLabel.adjustsFontSizeToFitWidth = true
    headerPositionView.titleLabel.text = Localization.localizedString(key: LocalizationKey.Position_Position).uppercased()
    headerOrderListView.titleLabel.text = Localization.localizedString(key: LocalizationKey.Boleta_OrderList).uppercased()
    headerPriceBookView.titleLabel.text = Localization.localizedString(key: LocalizationKey.General_PriceBook).uppercased()
    headerPositionView.section.frame.size.width = self.view.frame.width
    headerPositionView.section.setNeedsDisplay()
    headerOrderListView.changeImage()
    headerPriceBookView.changeImage()
    
    priceTextField.backgroundColor = Colors.UserEntryBackgroundColor
    priceTextField.textColor = Colors.clProfitAlertTextFieldFontColor
    typeTextField.backgroundColor = Colors.UserEntryBackgroundColor
    typeTextField.textColor = Colors.clProfitAlertTextFieldFontColor
    priceStepper.backgroundColor = Colors.UserEntryBackgroundColor
    priceStepper.setDecrementImage(priceStepper.decrementImage(for: .normal), for: .normal)
    priceStepper.setIncrementImage(priceStepper.incrementImage(for: .normal), for: .normal)
    priceStepper.tintColor = Colors.clProfitAlertTextFieldFontColor
    qtyStepper.backgroundColor = Colors.UserEntryBackgroundColor
    qtyStepper.setDecrementImage(qtyStepper.decrementImage(for: .normal), for: .normal)
    qtyStepper.setIncrementImage(qtyStepper.incrementImage(for: .normal), for: .normal)
    qtyStepper.tintColor = Colors.clProfitAlertTextFieldFontColor
    icebergStepper.backgroundColor = Colors.UserEntryBackgroundColor
    icebergStepper.setDecrementImage(icebergStepper.decrementImage(for: .normal), for: .normal)
    icebergStepper.setIncrementImage(icebergStepper.incrementImage(for: .normal), for: .normal)
    icebergStepper.tintColor = Colors.clProfitAlertTextFieldFontColor
    stopOffsetStepper.backgroundColor = Colors.UserEntryBackgroundColor
    stopOffsetStepper.setDecrementImage(priceStepper.decrementImage(for: .normal), for: .normal)
    stopOffsetStepper.setIncrementImage(priceStepper.incrementImage(for: .normal), for: .normal)
    stopOffsetStepper.tintColor = Colors.clProfitAlertTextFieldFontColor
    qtyTextField.backgroundColor = Colors.UserEntryBackgroundColor
    qtyTextField.textColor = Colors.clProfitAlertTextFieldFontColor
    icebergTextField.backgroundColor = Colors.UserEntryBackgroundColor
    icebergTextField.textColor = Colors.clProfitAlertTextFieldFontColor
    validityTextField.backgroundColor = Colors.UserEntryBackgroundColor
    validityTextField.textColor = Colors.clProfitAlertTextFieldFontColor
    dateTextField.backgroundColor = Colors.UserEntryBackgroundColor
    dateTextField.textColor = Colors.clProfitAlertTextFieldFontColor
    stopOffsetTextField.backgroundColor = Colors.UserEntryBackgroundColor
    stopOffsetTextField.textColor = Colors.clProfitAlertTextFieldFontColor
    scheduleTextField.backgroundColor = Colors.UserEntryBackgroundColor
    scheduleTextField.textColor = Colors.clProfitAlertTextFieldFontColor
    //dayTradeSwitch.backgroundColor = Colors.UserEntryBackgroundColor

    strategyTextField.backgroundColor = Colors.UserEntryBackgroundColor
    strategyTextField.textColor = Colors.clProfitAlertTextFieldFontColor
    strategyTitleLabel.textColor = .white
    strategyTitleLabel.text = Localization.localizedString(key: .BoletaBar_StrategyTitle)
    strategyTitleLabel.adjustsFontSizeToFitWidth = true
    
    dayTradeXibView?.strategyTextField?.backgroundColor = Colors.UserEntryBackgroundColor
    dayTradeXibView?.strategyTextField?.textColor = Colors.clProfitAlertTextFieldFontColor
    dayTradeXibView?.strategyTitleLabel?.textColor = .white
    dayTradeXibView?.strategyTitleLabel?.text = Localization.localizedString(key: .BoletaBar_StrategyTitle)
    dayTradeXibView?.strategyTitleLabel?.adjustsFontSizeToFitWidth = true
    
    //BTG
    if Application.m_application.isBTGFramework() {
      buyBottomLine.backgroundColor = Colors.clBuyBackgroundColor
    } else {
      buyBottomLine.backgroundColor = Colors.menuSelectedTextColor
    }

    sellBottomLine.backgroundColor = sellView.backgroundColor
    dayTradeBottomLine.backgroundColor = dayTradeView.backgroundColor

    qtyStepper.layer.cornerRadius = 5
    icebergStepper.layer.cornerRadius = 5
    priceStepper.layer.cornerRadius = 5
    stopOffsetStepper.layer.cornerRadius = 5

    dayTradeSwitch.tintColor = Colors.secondaryColor
    coveredTradeSwitch.tintColor = Colors.secondaryColor
    //dayTradeSwitch.onTintColor = Colors.clProfitAlertSuccess

    sendButton.gradientColor = true
    sendButton.topGradientColor = Colors.clChartTradingBuyButton.first
    sendButton.bottomGradientColor = Colors.clChartTradingBuyButton.last
    
    sendButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_BuyButton), for: .normal)
    sendButton.titleLabel?.font = Common.font(ofSize: 17, weight: .semibold)
    sendButton.titleLabel?.adjustsFontSizeToFitWidth = true
    sendButton.setTitleColor(Colors.lbFontColor, for: .normal)
    //BTG
    if Application.m_application.isBTGFramework() {
      sendButton.setTitleColor(.white, for: .normal)
    }

    dayTradeXibView?.qtyStepper.layer.cornerRadius = 5
    dayTradeXibView?.qtyStepper.backgroundColor = Colors.UserEntryBackgroundColor
    dayTradeXibView?.qtyStepper.setDecrementImage(qtyStepper.decrementImage(for: .normal), for: .normal)
    dayTradeXibView?.qtyStepper.setIncrementImage(qtyStepper.incrementImage(for: .normal), for: .normal)
    dayTradeXibView?.qtyStepper.tintColor = Colors.clProfitAlertTextFieldFontColor
    dayTradeXibView?.qtyTextField.backgroundColor = Colors.UserEntryBackgroundColor
    dayTradeXibView?.qtyTextField.textColor = Colors.clProfitAlertTextFieldFontColor
    dayTradeXibView?.qtyTextField.tintColor = Colors.clProfitAlertTextFieldFontColor
    dayTradeXibView?.QtyTopTitleLabel.textColor = Colors.primaryFontColor
    dayTradeXibView?.QtyTopTitleLabel.text = Localization.localizedString(key: LocalizationKey.Boleta_Qty)
    dayTradeXibView?.DayTradeTitleLabel.textColor = Colors.primaryFontColor
    dayTradeXibView?.DayTradeTitleLabel.adjustsFontSizeToFitWidth = true
    dayTradeXibView?.CoveredTradeTitleLabel.textColor = Colors.primaryFontColor
    dayTradeXibView?.CoveredTradeTitleLabel.adjustsFontSizeToFitWidth = true
    dayTradeXibView?.clearButton.gradientColor = true
    dayTradeXibView?.clearButton.topGradientColor = Colors.clChartTradingClearButton.first
    dayTradeXibView?.clearButton.bottomGradientColor = Colors.clChartTradingClearButton.last
    dayTradeXibView?.clearButton.setTitle(app.m_bCancelAndClear ? Localization.localizedString(key: LocalizationKey.ChartTrading_CancelAndReset) : Localization.localizedString(key: LocalizationKey.Livro_Reset), for: .normal)
    dayTradeXibView?.clearButton.titleLabel?.adjustsFontSizeToFitWidth = true
    dayTradeXibView?.clearButton.titleLabel?.textAlignment = .center
    dayTradeXibView?.clearButton.titleLabel?.numberOfLines = 2
    dayTradeXibView?.clearAllButton.gradientColor = true
    dayTradeXibView?.clearAllButton.topGradientColor = Colors.clChartTradingClearButton.first
    dayTradeXibView?.clearAllButton.bottomGradientColor = Colors.clChartTradingClearButton.last
    dayTradeXibView?.clearAllButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_CancelAndReset), for: .normal)
    dayTradeXibView?.clearAllButton.titleLabel?.adjustsFontSizeToFitWidth = true
    dayTradeXibView?.clearAllButton.titleLabel?.textAlignment = .center
    dayTradeXibView?.clearAllButton.titleLabel?.numberOfLines = 2
    dayTradeXibView?.reverseButton.gradientColor = true
    dayTradeXibView?.reverseButton.topGradientColor = Colors.clChartTradingInvertButton.first
    dayTradeXibView?.reverseButton.bottomGradientColor = Colors.clChartTradingInvertButton.last
    dayTradeXibView?.reverseButton.setTitle(Localization.localizedString(key: LocalizationKey.Livro_Invert), for: .normal)
    dayTradeXibView?.reverseButton.titleLabel?.adjustsFontSizeToFitWidth = true
    dayTradeXibView?.dayTradeSwitch.tintColor = Colors.secondaryColor
    dayTradeXibView?.coveredTradeSwitch.tintColor = Colors.secondaryColor
    dayTradeXibView?.buyMarketButton.gradientColor = true
    dayTradeXibView?.buyMarketButton.topGradientColor = Colors.clChartTradingBuyButton.first
   dayTradeXibView?.buyMarketButton.bottomGradientColor = Colors.clChartTradingBuyButton.last
    dayTradeXibView?.buyMarketButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_BuyMarket), for: .normal)
    dayTradeXibView?.buyMarketButton.titleLabel?.adjustsFontSizeToFitWidth = true
    dayTradeXibView?.buyBidButton.gradientColor = true
     dayTradeXibView?.buyBidButton.topGradientColor = Colors.clChartTradingBuyButton.first
    dayTradeXibView?.buyBidButton.bottomGradientColor = Colors.clChartTradingBuyButton.last
    dayTradeXibView?.buyBidButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_BuyInBid), for: .normal)
    dayTradeXibView?.buyBidButton.titleLabel?.adjustsFontSizeToFitWidth = true
    dayTradeXibView?.buyAskButton.gradientColor = true
     dayTradeXibView?.buyAskButton.topGradientColor = Colors.clChartTradingBuyButton.first
    dayTradeXibView?.buyAskButton.bottomGradientColor = Colors.clChartTradingBuyButton.last
    dayTradeXibView?.buyAskButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_BuyInAsk), for: .normal)
    dayTradeXibView?.buyAskButton.titleLabel?.adjustsFontSizeToFitWidth = true
    dayTradeXibView?.sellMarketButton.gradientColor = true
    dayTradeXibView?.sellMarketButton.topGradientColor = Colors.clChartTradingSellButton.first
    dayTradeXibView?.sellMarketButton.bottomGradientColor = Colors.clChartTradingSellButton.last
  dayTradeXibView?.sellMarketButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_SellMarket), for: .normal)
    dayTradeXibView?.sellMarketButton.titleLabel?.adjustsFontSizeToFitWidth = true
    dayTradeXibView?.sellBidButton.gradientColor = true
    dayTradeXibView?.sellBidButton.topGradientColor = Colors.clChartTradingSellButton.first
    dayTradeXibView?.sellBidButton.bottomGradientColor = Colors.clChartTradingSellButton.last
    dayTradeXibView?.sellBidButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_SellInBid), for: .normal)
    dayTradeXibView?.sellBidButton.titleLabel?.adjustsFontSizeToFitWidth = true
    dayTradeXibView?.sellAskButton.gradientColor = true
    dayTradeXibView?.sellAskButton.topGradientColor = Colors.clChartTradingSellButton.first
    dayTradeXibView?.sellAskButton.bottomGradientColor = Colors.clChartTradingSellButton.last
    dayTradeXibView?.sellAskButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_SellInAsk), for: .normal)
    dayTradeXibView?.sellAskButton.titleLabel?.adjustsFontSizeToFitWidth = true

    
    dayTradeXibView?.buyMarketButton.setTitleColor(Colors.lbFontColor, for: .normal)
    dayTradeXibView?.buyAskButton.setTitleColor(Colors.lbFontColor, for: .normal)
    dayTradeXibView?.buyBidButton.setTitleColor(Colors.lbFontColor, for: .normal)
    dayTradeXibView?.reverseButton.setTitleColor(Colors.clChartTradingInvertButtonLabel, for: .normal)
    
    if Application.m_application.isBTGFramework() {
      dayTradeXibView?.buyMarketButton.setTitleColor(.white, for: .normal)
      dayTradeXibView?.buyAskButton.setTitleColor(.white, for: .normal)
      dayTradeXibView?.buyBidButton.setTitleColor(.white, for: .normal)
    }
    
    orderListTableView.separatorStyle = .none
    orderListTableView.layoutMargins = UIEdgeInsets.zero
    orderListTableView.separatorInset = UIEdgeInsets.zero

    posHeightCons.constant = 215 //45
    posContentView.isHidden = false

    orderHeightCons.constant = 32
    orderListTableView.isHidden = true

    priceHeightCons.constant = 32
    headerView.isHidden = true
    offersTableView.isHidden = true

    dateHeight.constant = 0.0
    dateView.isHidden = true

    stopOffsetHeight.constant = 0.0
    stopOffsetView.isHidden = true
    
    scheduleViewHeight.constant = 0.0
    scheduleView.isHidden = true

    buyLabel.textColor = .white
    sellLabel.textColor = Colors.PosViewMenuDeselectFontColor
    dayTradeLabel.textColor = Colors.PosViewMenuDeselectFontColor
    
    priceBookBuyQty.text = Localization.localizedString(key: LocalizationKey.Boleta_Qty).uppercased()
    priceBookBuy.text = Localization.localizedString(key: LocalizationKey.Boleta_Buy).uppercased()
    priceBookSell.text = Localization.localizedString(key: LocalizationKey.Boleta_Sell).uppercased()
    priceBookSellQty.text = Localization.localizedString(key: LocalizationKey.Boleta_Qty).uppercased()
    priceBookBuyQty.textColor = Colors.clBookHeaderLabel
    priceBookBuy.textColor = Colors.clBookHeaderLabel
    priceBookSell.textColor = Colors.clBookHeaderLabel
    priceBookSellQty.textColor = Colors.clBookHeaderLabel
    
    headerOrderListView.isHidden = !Application.m_application.m_userProduct.HasBoletaOrderList()
    
    headerPriceBookView.isHidden = !Application.m_application.m_userProduct.HasBoletaPriceBook()
    
    // setting custom roundStyle
    strategyTextField.setRoundStyle()
    stopOffsetTextField.setRoundStyle()
    priceTextField.setRoundStyle()
    typeTextField.setRoundStyle()
    qtyTextField.setRoundStyle()
    validityTextField.setRoundStyle()
    dateTextField.setRoundStyle()
    dayTradeXibView?.strategyTextField?.setRoundStyle()
    dayTradeXibView?.qtyTextField?.setRoundStyle()
    
    hideDayTradeTabIfNeeded()
  }
  
  private func setupAverageResultLabelText(_ setTextFunction: @escaping () -> Void) {
    if Application.m_application.m_userProduct.shouldHidePositionResults() {
      averageResultLabel.text? = "-"
    } else {
      setTextFunction()
    }
  }

  //****************************************************************************
  //
  //       Nome: enableInterface
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //****************************************************************************
  func enableInterface()
  {
    var bEnabled = false

    if let m_aidDayTradeAsset = m_selectedAsset {
      let dicAssetInfo = app.m_dicAssetInfo[m_aidDayTradeAsset.getKey()]

      if let nMaxOrderQtd = dicAssetInfo!.nMaxOrderQtd, nMaxOrderQtd > 0, let sQuotation = app.m_dicStocks[m_aidDayTradeAsset.getKey()]?.getLastDaily()?.sClose, sQuotation > 0
        {
        bEnabled = true
      }
      
      let isStepperEnabled: Bool = bEnabled && (app.m_dicAssetInfo[m_aidDayTradeAsset.getKey()]?.sMinPriceIncrement != nil)
      
      stopOffsetStepper.isEnabled = isStepperEnabled
      priceStepper.isEnabled = isStepperEnabled
    }
    qtyStepper.isEnabled = true
    qtyTextField.isEnabled = true
    dayTradeSwitch.isEnabled = bEnabled
    coveredTradeSwitch.isEnabled = bEnabled
    priceTextField.isEnabled = bEnabled
    stopOffsetTextField.isEnabled = bEnabled
    sendButton.isEnabled = bEnabled
    dateTextField.isEnabled = bEnabled && m_selectedValidity == .btfGoodTillDate
    validityTextField.isEnabled = bEnabled
  }

  // MARK: - TAPS

  //******************************************************************************
  //
  // Nome:      dismissKeyboard
  // Descrição: Esconde keyboard
  //
  // Criação:
  // Modificado:
  //
  //******************************************************************************
  @objc func dismissKeyboard()
  {
    view.endEditing(true)
  }

  //****************************************************************************
  //
  //       Nome: optionsButtonDidTap
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  func optionsButtonDidTap(_ sender: UIBarButtonItem)
  {
    let storyboard = UIStoryboard(name: "OptionsMenu", bundle: Bundle(for: AppDelegate.self))
    let optionsMenuViewController = storyboard.instantiateViewController(withIdentifier: "OptionsMenuViewController") as! OptionsMenuViewController
    optionsMenuViewController.delegate = self
    optionsMenuViewController.modalPresentationStyle = .popover
    optionsMenuViewController.preferredContentSize = CGSize(width: 200, height: 88)
    optionsMenuViewController.m_strOptionType = "Trading"

    let screenSize = UIScreen.main.bounds
    let screenWidth = screenSize.width

    let popoverController = optionsMenuViewController.popoverPresentationController
    popoverController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
    popoverController?.delegate = self
    popoverController?.sourceView = view
    let rect = CGRect(x: screenWidth - 40, y: 0, width: 0, height: 0)
    popoverController?.sourceRect = rect

    present(optionsMenuViewController, animated: true, completion: {
      optionsMenuViewController.view.superview?.layer.cornerRadius = 5
    })
  }

  //****************************************************************************
  //
  //       Nome: tapAccountView
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  @objc private func tapAccountView(sender: UIView)
  {
    if Application.m_application.allowSelectAccount()
    {
      Statistics.shared.log(type: .stUserInteraction, message: "Selecionar Conta", value: "Boleta")
      Nelogger.shared.log("AccountView @ BoletaViewController did Tap")
      if let sdViewController = newStockDetailViewController {
        sdViewController.performSegue(withIdentifier: "goToAccounts", sender: sdViewController)
      } else {
        performSegue(withIdentifier: "goToAccountsFromBoleta", sender: self)
      }
    }
  }

  //****************************************************************************
  //
  //       Nome: tapSymbolView
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  @objc override func tapSymbolView(sender: UIView)
  {
    Statistics.shared.log(type: .stUserInteraction, message: "Mudar Ativo", value: "Boleta")
    performSegue(withIdentifier: "goToSetSymbolFromBoleta", sender: self)
  }

  //******************************************************************************
  //
  // Nome:      tapGestureRecognized(gestureRecognizer
  // Descrição:
  //
  // Criação:
  // Modificado:
  //
  //******************************************************************************
  @objc func tapGestureRecognized(gestureRecognizer: UIGestureRecognizer)
  {
    if let tap = gestureRecognizer as? UITapGestureRecognizer
      {
      let state = tap.state
      let locationInView = tap.location(in: orderListTableView)

      if let indexPath = orderListTableView.indexPathForRow(at: locationInView)
        {
        switch state
        {
        case .ended:
          selectedOrder = orderList[indexPath.row]
          performSegue(withIdentifier: orderDetailSegue, sender: self)
          break
        default:
          break
        }
      }
    }
  }

  //******************************************************************************
  //
  // Nome:     doubleTapGestureRecognized(gestureRecognizer
  // Descrição:
  //
  // Criação:
  // Modificado:
  //
  //******************************************************************************
  @objc func doubleTapGestureRecognized(gestureRecognizer: UIGestureRecognizer)
  {
    if let tap = gestureRecognizer as? UITapGestureRecognizer
      {
      m_cgpEditViewLocation = tap.location(in: self.view)
    }
  }

  //******************************************************************************
  //
  // Nome:      tapBuyView
  // Descrição:
  //
  // Criação:
  // Modificado:
  //
  //******************************************************************************
  @objc func tapBuyView(sender: UIView)
  {
    Statistics.shared.log(type: .stUserInteraction, message: "Compra", value: "Boleta")
    
    scrollView.bringSubviewToFront(buttonView)
    scrollView.bringSubviewToFront(symbolDataCollectionView)
    
    if(!self.inAnimation) {
      self.inAnimation = true
      if(self.currentView == .DayTrade) {

        self.currentView = .Buy

        let viewCenter = self.view.frame.width / 2

        self.contentView.layer.position.x = 0 - viewCenter
        self.dayTradeXibView?.layer.position.x = viewCenter
        sendButton.topGradientColor = Colors.clChartTradingBuyButton.first
        sendButton.bottomGradientColor = Colors.clChartTradingBuyButton.last

        self.sendButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_BuyButton), for: .normal)
        //BTG
        if !Application.m_application.isBTGFramework() {
          self.sendButton.setTitleColor(Colors.lbFontColor, for: .normal)
        }

        self.view.layoutIfNeeded()

        self.contentView.isHidden = false
        self.dayTradeXibView?.isHidden = false



        UIView.animate(withDuration: 0.3, animations: {
          self.dayTradeXibView?.layer.position.x = viewCenter * 3
          self.contentView.layer.position.x = viewCenter
        }) { (finished: Bool) in
          self.inAnimation = false
          self.calculaHeigthConstraint()

        }
        self.dayTradeLabel.textColor = Colors.PosViewMenuDeselectFontColor
        self.dayTradeBottomLine.backgroundColor = self.buyView.backgroundColor

        //BTG
        if Application.m_application.isBTGFramework() {
          self.buyBottomLine.backgroundColor = Colors.clBuyBackgroundColor
        } else {
          self.buyBottomLine.backgroundColor = Colors.menuSelectedTextColor
        }


      }
      else if(self.currentView == .Sell) {
        self.currentView = .Buy

        let cloneView = self.contentView.snapshotView(afterScreenUpdates: true)
        let viewCenter = self.view.frame.width / 2

        cloneView?.layer.position.y = self.contentView.layer.position.y
        self.contentView.layer.position.x = 0 - self.contentView.layer.position.x
        sendButton.topGradientColor = Colors.clChartTradingBuyButton.first
        sendButton.bottomGradientColor = Colors.clChartTradingBuyButton.last
        self.sendButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_BuyButton), for: .normal)
        if !Application.m_application.isBTGFramework() {
          self.sendButton.setTitleColor(Colors.lbFontColor, for: .normal)
        }
        self.view.layoutIfNeeded()

        self.scrollView.addSubview(cloneView!)

        UIView.animate(withDuration: 0.3, animations: {
          cloneView?.layer.position.x = viewCenter * 3
          self.contentView.layer.position.x = viewCenter
        }) { (finished: Bool) in
          self.inAnimation = false
          cloneView?.removeFromSuperview()
        }
        self.sellLabel.textColor = Colors.PosViewMenuDeselectFontColor
        self.sellBottomLine.backgroundColor = self.buyView.backgroundColor
        //BTG
        if Application.m_application.isBTGFramework() {
          self.buyBottomLine.backgroundColor = Colors.clBuyBackgroundColor
        } else {
          self.buyBottomLine.backgroundColor = Colors.menuSelectedTextColor
        }
      }
      m_sendType = .bosbuy
      self.buyLabel.textColor = .white
      self.inAnimation = false
    }
  }

  //******************************************************************************
  //
  // Nome:      tapSellView
  // Descrição:
  //
  // Criação:
  // Modificado:
  //
  //******************************************************************************
  @objc func tapSellView(sender: UIView)
  {
    Statistics.shared.log(type: .stUserInteraction, message: "Venda", value: "Boleta")

    scrollView.bringSubviewToFront(buttonView)
    scrollView.bringSubviewToFront(symbolDataCollectionView)
    
    if(!self.inAnimation) {
      self.inAnimation = true
      if(self.currentView == .DayTrade) {

        self.currentView = .Sell

        let viewCenter = self.view.frame.width / 2

        self.contentView.layer.position.x = 0 - viewCenter
        self.dayTradeXibView?.layer.position.x = viewCenter
        self.sendButton.topGradientColor = Colors.clChartTradingSellButton.first
        self.sendButton.bottomGradientColor = Colors.clChartTradingSellButton.last
        self.sendButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_SellButton), for: .normal)
        self.sendButton.setTitleColor(.white, for: .normal)
        self.view.layoutIfNeeded()

        self.contentView.isHidden = false
        self.dayTradeXibView?.isHidden = false

        UIView.animate(withDuration: 0.3, animations: {
          self.dayTradeXibView?.layer.position.x = viewCenter * 3
          self.contentView.layer.position.x = viewCenter
        }) { (finished: Bool) in
          self.inAnimation = false
          self.calculaHeigthConstraint()
        }
        self.dayTradeLabel.textColor = Colors.PosViewMenuDeselectFontColor
        self.dayTradeBottomLine.backgroundColor = self.buyView.backgroundColor
        //BTG
        if Application.m_application.isBTGFramework() {
          self.sellBottomLine.backgroundColor = Colors.clSellBackgroundColor
        } else {
          self.sellBottomLine.backgroundColor = Colors.menuSelectedTextColor
        }

      }
      else if(self.currentView == .Buy) {
        self.currentView = .Sell

        let cloneView = self.contentView.snapshotView(afterScreenUpdates: true)
        let viewCenter = self.view.frame.width / 2

        cloneView?.layer.position.y = self.contentView.layer.position.y
        self.contentView.layer.position.x = self.contentView.layer.position.x * 3
        self.sendButton.topGradientColor = Colors.clChartTradingSellButton.first
        self.sendButton.bottomGradientColor = Colors.clChartTradingSellButton.last
        self.sendButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_SellButton), for: .normal)
        self.sendButton.setTitleColor(.white, for: .normal)
        self.view.layoutIfNeeded()

        self.scrollView.addSubview(cloneView!)

        UIView.animate(withDuration: 0.3, animations: {
          cloneView?.layer.position.x = 0 - viewCenter
          self.contentView.layer.position.x = viewCenter
        }) { (finished: Bool) in
          self.inAnimation = false
          cloneView?.removeFromSuperview()
        }
        self.buyLabel.textColor = Colors.PosViewMenuDeselectFontColor
        self.buyBottomLine.backgroundColor = self.buyView.backgroundColor
        //BTG
        if Application.m_application.isBTGFramework() {
          self.sellBottomLine.backgroundColor = Colors.clSellBackgroundColor
        } else {
          self.sellBottomLine.backgroundColor = Colors.menuSelectedTextColor
        }

      }
      m_sendType = .bossell
      self.sellLabel.textColor = .white
      self.inAnimation = false
    }
  }

  //******************************************************************************
  //
  // Nome:      tapDayTradeView
  // Descrição:
  //
  // Criação:
  // Modificado:
  //
  //******************************************************************************
  @objc func tapDayTradeView(sender: UIView)
  {
    Statistics.shared.log(type: .stUserInteraction, message: "Day Trade", value: "Boleta")
    
    scrollView.bringSubviewToFront(buttonView)
    scrollView.bringSubviewToFront(symbolDataCollectionView)

    if(!self.inAnimation && self.currentView != .DayTrade) {
      self.inAnimation = true

      let originView = self.currentView
      self.currentView = .DayTrade

      let viewCenter = self.view.frame.width / 2

      self.contentView.layer.position.x = viewCenter
      self.dayTradeXibView?.layer.position.x = viewCenter * 3
      self.calculaHeigthConstraint()
      self.view.layoutIfNeeded()

      self.contentView.isHidden = false
      self.dayTradeXibView?.isHidden = false


      UIView.animate(withDuration: 0.3, animations: {

        self.dayTradeXibView?.strategyTextField.delegate = self

        self.dayTradeXibView?.layer.position.x = viewCenter
        self.contentView.layer.position.x = 0 - viewCenter
      }) { (finished: Bool) in
        self.inAnimation = false
      }
      self.dayTradeLabel.textColor = Colors.primaryFontColor

      if(originView == .Sell) {
        self.sellLabel.textColor = Colors.PosViewMenuDeselectFontColor
        self.sellBottomLine.backgroundColor = self.sellView.backgroundColor
      }
      else {
        self.buyLabel.textColor = Colors.PosViewMenuDeselectFontColor
        self.buyBottomLine.backgroundColor = self.buyView.backgroundColor
      }
      //BTG
      if Application.m_application.isBTGFramework() {
        self.dayTradeBottomLine.backgroundColor = UIColor(rgb: 0xCF9000)
      } else {
        self.dayTradeBottomLine.backgroundColor = Colors.menuSelectedTextColor
      }
    }
    self.inAnimation = false
  }

  //******************************************************************************
  //
  // Nome:      tapBuyViewWithoutAnimation
  // Descrição:
  //
  // Criação:
  // Modificado:
  //
  //******************************************************************************
  @objc func tapBuyViewWithoutAnimation(sender: UIView)
  {
    if(self.currentView == .DayTrade) {
      currentView = .Buy
      let viewCenter = self.view.frame.width / 2
      contentView.layer.position.x = viewCenter

      sendButton.topGradientColor = Colors.clChartTradingBuyButton.first
      sendButton.bottomGradientColor = Colors.clChartTradingBuyButton.last
      sendButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_BuyButton), for: .normal)
      if !Application.m_application.isBTGFramework() {
        self.sendButton.setTitleColor(Colors.lbFontColor, for: .normal)
      }
      self.view.layoutIfNeeded()

      contentView.isHidden = false
      dayTradeXibView?.isHidden = true
      calculaHeigthConstraint()
      dayTradeLabel.textColor = Colors.PosViewMenuDeselectFontColor
      dayTradeBottomLine.backgroundColor = self.buyView.backgroundColor
      if Application.m_application.isBTGFramework() {
        self.buyBottomLine.backgroundColor = Colors.clBuyBackgroundColor
      } else {
        self.buyBottomLine.backgroundColor = Colors.menuSelectedTextColor
      }
    }
    else if(self.currentView == .Sell) {
      currentView = .Buy

      let viewCenter = self.view.frame.width / 2
      contentView.layer.position.x = viewCenter
      sendButton.topGradientColor = Colors.clChartTradingBuyButton.first
      sendButton.bottomGradientColor = Colors.clChartTradingBuyButton.last
      sendButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_BuyButton), for: .normal)
      if !Application.m_application.isBTGFramework() {
        self.sendButton.setTitleColor(Colors.lbFontColor, for: .normal)
      }
      self.view.layoutIfNeeded()

      sellLabel.textColor = Colors.PosViewMenuDeselectFontColor
      sellBottomLine.backgroundColor = self.buyView.backgroundColor
      if Application.m_application.isBTGFramework() {
        self.buyBottomLine.backgroundColor = Colors.clBuyBackgroundColor
      } else {
        self.buyBottomLine.backgroundColor = Colors.menuSelectedTextColor
      }

    }
    m_sendType = .bosbuy
    buyLabel.textColor = .white
  }

  //******************************************************************************
  //
  // Nome:      tapSellViewWithoutAnimation
  // Descrição:
  //
  // Criação:
  // Modificado:
  //
  //******************************************************************************
  @objc func tapSellViewWithoutAnimation(sender: UIView)
  {
    if(self.currentView == .DayTrade) {
      currentView = .Sell
      let viewCenter = self.view.frame.width / 2

      contentView.layer.position.x = viewCenter
      self.sendButton.topGradientColor = Colors.clChartTradingSellButton.first
      self.sendButton.bottomGradientColor = Colors.clChartTradingSellButton.last
      sendButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_SellButton), for: .normal)
      sendButton.setTitleColor(.white, for: .normal)
      self.view.layoutIfNeeded()

      contentView.isHidden = false
      dayTradeXibView?.isHidden = true
      calculaHeigthConstraint()

      dayTradeLabel.textColor = Colors.PosViewMenuDeselectFontColor
      dayTradeBottomLine.backgroundColor = self.buyView.backgroundColor
      //BTG
      if Application.m_application.isBTGFramework() {
        self.sellBottomLine.backgroundColor = Colors.clSellBackgroundColor
      } else {
        self.sellBottomLine.backgroundColor = Colors.menuSelectedTextColor
      }
    }
    else if(self.currentView == .Buy) {
      currentView = .Sell

      let viewCenter = self.view.frame.width / 2
      contentView.layer.position.x = viewCenter
      self.sendButton.topGradientColor = Colors.clChartTradingSellButton.first
      self.sendButton.bottomGradientColor = Colors.clChartTradingSellButton.last
      sendButton.setTitle(Localization.localizedString(key: LocalizationKey.Boleta_SellButton), for: .normal)
      sendButton.setTitleColor(.white, for: .normal)
      self.view.layoutIfNeeded()

      buyLabel.textColor = Colors.PosViewMenuDeselectFontColor
      buyBottomLine.backgroundColor = self.buyView.backgroundColor
      //BTG
      if Application.m_application.isBTGFramework() {
        self.sellBottomLine.backgroundColor = Colors.clSellBackgroundColor
      } else {
        self.sellBottomLine.backgroundColor = Colors.menuSelectedTextColor
      }
    }
    m_sendType = .bossell
    self.sellLabel.textColor = .white
  }
  //******************************************************************************
  //
  // Nome:      tapDayTradeViewWithoutAnimation
  // Descrição:
  //
  // Criação:
  // Modificado:
  //
  //******************************************************************************
  @objc func tapDayTradeViewWithoutAnimation(sender: UIView)
  {
    self.currentView = .DayTrade

    let viewCenter = self.view.frame.width / 2

    dayTradeXibView?.layer.position.x = viewCenter
    calculaHeigthConstraint()
    self.view.layoutIfNeeded()

    contentView.isHidden = true
    dayTradeXibView?.isHidden = false

    self.dayTradeLabel.textColor = Colors.primaryFontColor

    sellLabel.textColor = Colors.PosViewMenuDeselectFontColor
    sellBottomLine.backgroundColor = self.sellView.backgroundColor

    buyLabel.textColor = Colors.PosViewMenuDeselectFontColor
    buyBottomLine.backgroundColor = self.buyView.backgroundColor
    //BTG
    if Application.m_application.isBTGFramework() {
      dayTradeBottomLine.backgroundColor = UIColor(rgb: 0xCF9000)
    } else {
      dayTradeBottomLine.backgroundColor = Colors.menuSelectedTextColor
    }
  }

  //****************************************************************************
  //
  //       Nome: resetAllDidTap
  //  Descrição:
  //
  //    Criação:
  // Modificado: 06/03/2019  v1.3.52  Guilherme Cardoso Soares
  //             - Nova classe de Logs
  //             22/04/2019  v1.3.58 Eduardo Varela Ribeiro
  //             - AlertView Customizado
  //****************************************************************************
  func cancelAndResetDidTap(_ sender: UIButton)
  {
    Nelogger.shared.log("OldBoletaViewController.cancelAndResetDidTap - User Pressed: Cancel and Reset")
    dismissKeyboard()
    guard let account = Application.m_application.m_acSelectedAccount else
    {
      showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: SendOrderStatus.NoAccountSelected.description())
      return
    }
    
    guard let assetID = m_selectedAsset else {
      showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: SendOrderStatus.NoAssetInfo.description())
      return
    }
    
    self.showConfirmationAlert(
      strTitle: Localization.localizedString(key: LocalizationKey.ChartTrading_CancelAndReset),
      strMessage: NSMutableAttributedString(string: Localization.localizedString(key: LocalizationKey.OrderMessage_CancelAndReset) + "?"),
      confirmationKey: "ConfirmCancelReset",
      action: {
        var result : SendOrderStatus = SendOrderStatus.Success
        result = account.cancelAndReset(a_aidAssetId: assetID, a_osOrderSource: .daytrade, a_stStrategyType: self.m_dayTrade)
        if result == .NoPassword {
          self.showPasswordView(callback: { account.confirmCancelAndReset(assetID: assetID, orderSource: .daytrade, sender: self, strategy: self.m_dayTrade, contextForLog: self.contextForLog, overrideClearOrders: nil) })
        }
        else if result != .Success {
          if !self.contextForLog.isEmpty {
            Nelogger.shared.log("\(Localization.localizedString(key: LocalizationKey.OrderMessage_CancelAndReset)): \(self.contextForLog)")
          }
          self.showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: result.description())
        }
      },
      cancelAction: {
        if !self.contextForLog.isEmpty {
          Nelogger.shared.log("Cancelou \(Localization.localizedString(key: LocalizationKey.OrderMessage_CancelAndReset)): \(self.contextForLog)")
        }
      }
    )
  }

  // MARK: - SEND

  //****************************************************************************
  //
  //       Nome: sendButtonDidTap
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             08/08/2018  v1.3.8  Luís Felipe Polo
  //             - Tipo da ordem não estava sendo alterado após receber mensagem do hades
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             19/03/2019  v1.3.54  Luís Felipe Polo
  //             - Zeragem de posição via servidor
  //             22/04/2019  v1.3.58 Eduardo Varela Ribeiro
  //             - AlertView Customizado
  //
  //****************************************************************************
  @IBAction func sendButtonDidTap(_ sender: UIButton)
  {
    Nelogger.shared.log("OldBoletaViewController.sendButtonDidTap - User Pressed: Send")
    dismissKeyboard()
    
    var info: [String: Any] = [:]

    guard let m_stock = app.m_dicStocks[m_selectedAsset?.getKey() ?? ""] else {
      Nelogger.shared.log("Não foi possível obter o ativo no dicionário \(String(describing: m_selectedAsset?.description()))")
      return
    }
    
    var hasIceberg: Bool = false
    if let broker: Broker = Application.m_application.m_brkSelectedBroker {
      hasIceberg = broker.hasIceberg(m_nMarket: m_stock.m_aidAssetID.m_nMarket)
    }
    guard let priceText = priceTextField.text else {
      Nelogger.shared.log("Não foi possível obter o conteúdo do campo priceTextField")
      return
    }
    
    let strPrice: String = Common.formatNumericalInput(a_strInput: priceText)
    
    guard let stopOffsetText = stopOffsetTextField.text else {
      Nelogger.shared.log("Não foi possível obter o conteúdo do campo stopOffsetTextField")
      return
    }
    
    let strStopOffset: String = Common.formatNumericalInput(a_strInput: stopOffsetText)
    
    guard let stopOffsetValue : Double = Double(strStopOffset.isEmpty ? "0" : strStopOffset) else {
      Nelogger.shared.log("Não foi possível converter o valor do campo stopOffsetValue para Double")
      return
    }
    
    if let strQty = qtyTextField.text
    {
      info["quantity"] = Common.formatQtdInput(value: strQty, forAsset: m_stock.m_aidAssetID)
    }
    else
    {
      showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_InvalidQtd))
      Nelogger.shared.log("Quantidade inválida: qtyTextField.text = nil")
      return
    }
    
    info["iceberg"] = Common.formatQtdInput(value: "0", forAsset: m_stock.m_aidAssetID)
    if hasIceberg {
      if let assetInfo = m_selectedAssetInfo, let strIceberg = icebergTextField.text {
        if Common.isIcebergValid(iceberg: m_iceberg, qty: m_quantity, forAsset: assetInfo) {
          info["iceberg"] = Common.formatQtdInput(value: strIceberg, forAsset: m_stock.m_aidAssetID)
        } else {
          showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_InvalidQtd))
          return
        }
      }
    }
    
    if m_orderType != .botmarket && Double(strPrice) == nil
      {
      showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: Localization.localizedString(key: LocalizationKey.Boleta_NoPrice))
      return
    }
    else if m_orderType == .botmarket && m_stock.getLastDaily()?.sClose == nil
      {
      showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: Localization.localizedString(key: LocalizationKey.Boleta_NoPrice))
      return
    }

    if m_orderType == .botstoplimit && Double(strStopOffset) == nil
    {
      showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: Localization.localizedString(key: LocalizationKey.Boleta_NoStopPrice))
      return
    }

    if m_selectedValidity == nil
      {
      showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: Localization.localizedString(key: LocalizationKey.Boleta_NoValidity))
      return
    }

    info["strategy"] = m_dayTrade
    info["stopPrice"] = Double(0)
    info["orderType"] = m_orderType
    info["side"] = m_sendType

    if m_orderType == .botstoplimit
    {
//      info["price"] = Double(strPrice)
      guard let priceValue : Double = Double(strPrice.isEmpty ? "0" : strPrice) else {
        Nelogger.shared.log("Não foi possível converter o valor do campo stopOffsetValue para Double")
        return
      }
      if m_sendType == .bosbuy {
        info["price"] = priceValue + stopOffsetValue
      } else if m_sendType == .bossell {
        info["price"] = priceValue - stopOffsetValue
      }
      
      info["stopPrice"] = Double(strPrice)
    }
    else if m_orderType == .botmarket
      {
      info["price"] = m_stock.getLastDaily()?.sClose
    }
    else if m_orderType == .botlimit
    {
      info["price"] = Double(strPrice)
    }

    info["assetId"] = m_stock.m_aidAssetID

    info["validateType"] = m_selectedValidity
    if m_selectedValidity == ValidityType.btfGoodTillDate
      {
      info["date"] = m_date
    }
    else
    {
      info["date"] = Date()
    }
    
    if let scheduleDate = m_scheduleDate {
      info["scheduleDate"] = scheduleDate
    }

    info["quotation"] = 0.0

    if let quote = m_stock.getLastDaily()?.sClose {
      info["quotation"] = quote
    }
    
    let order = Order(
      a_strProfitId: nil,
      a_aidAssetId: info["assetId"] as! AssetIdentifier,
      a_sdSide: info ["side"] as! Side,
      a_otOrderType: info["orderType"] as! OrderType
    )

    order.setOrderData(
      a_strBroker: Application.m_application.m_brkSelectedBroker?.strBrokerId,
      a_strAccount: Application.m_application.m_acSelectedAccount?.strAccountID,
      a_strOrderId: nil,
      a_strClOrdId: nil,
      a_osStatus: nil,
      a_sPrice: info["price"] as? Double,
      a_nQty: info["quantity"] as? Int,
      a_vtValidity: info["validateType"] as? ValidityType,
      a_dtValidityDate: info["date"] as? Date,
      a_sStopPrice: info["stopPrice"] as? Double,
      a_sAvgPrice: nil,
      a_sUserDefinedTotal: info["userDefinedTotal"] as? Double,
      a_nCumQty: nil,
      a_dtCreationDate: nil,
      a_dtCloseDate: nil,
      a_dtLastUpdate: nil,
      a_nMsgId: nil,
      a_strText: nil,
      a_stStrategyType: info["strategy"] as? StrategyType,
      a_osPreviousStatus: nil,
      a_etExecType: nil,
      a_otOrderType: info["orderType"] as! OrderType,
      a_octOrderClosingType: .octNone,
      a_bIsFinancial: RoutingManager.shared.isFinancialOrder(orderType: info["orderType"] as! OrderType),
      a_nMaxFloor: info["iceberg"] as! Int,
      subAccountID: Application.m_application.m_acSelectedAccount?.subAccountID,
      a_dtScheduleDate: info["scheduleDate"] as? Date
    )

    if isStrategySelectionEnabled() {
      order.setOCOStrategy(a_ostStrategy: StrategyManager.shared.ocoStrategySelected)
    }
    
    let result = order.ValidateOrder(
      a_sQuotation: info["quotation"] as? Double,
      a_sPrice: info["price"] as? Double,
      a_nQty: info["quantity"] as? Int,
      a_userDefinedTotal: info["userDefinedTotal"] as? Double,
      a_sStopPrice: info["stopPrice"] as? Double,
      a_nMaxFloor: hasIceberg ? (info["iceberg"] as? Int) : nil
    )

    if result.status != SendOrderStatus.Success
      {
      if result.status == SendOrderStatus.NoPassword
        {
        Nelogger.shared.log("ValidateOrder returned NoPassword")
          showPasswordView(callback: { self.sendButtonDidTap(sender) })
      }
      else
      {
        showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.Boleta_OrderNotSent), a_strMessage: result.description())
      }
    }
    else
    {
      if Application.m_application.m_dicDefaultConfirm["ConfirmNew"]!
        {
          self.showConfirmationAlert(
            strTitle: Localization.localizedString(key: LocalizationKey.Boleta_NewOrder),
            strMessage:  order.confirmNewOrderMessage(),
            confirmationKey: "ConfirmNew", action: {
              self.sendOrder(info, buttonType: nil, button: sender)  // Send order já loga o envio
            }, cancelAction: {
              Nelogger.shared.log("Cancelou \(sender.titleLabel?.text ?? order.otOrderType.descriptionStr()): \(self.contextForOrderLog(order))")
            })
      }
      else
      {
        sendOrder(info, buttonType: nil, button: sender)  // Send order já loga o envio
      }
    }
    
    Statistics.shared.log(type: .stUserInteraction, message: sender.titleLabel?.text ?? "", value: "Boleta")
  }

  //****************************************************************************
  //
  //       Nome: updateTickerButton
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  func updateTickerButton(a_strTicker: String) {
    var ticker = a_strTicker
    var exchange = m_selectedAsset?.m_nMarket ?? -1
    if app.handlesFractionary(), let info = app.m_dicAssetInfo[a_strTicker], info.isFractionary(), isChosenAssetFractionary == false {
      ticker = info.getNonFractionaryTicker()
      exchange = info.getNonFractionaryAssetId().m_nMarket
    }
    let isReplay = ExchangeManager.shared.isItReplayMarket(nExchange: m_selectedAsset?.m_nMarket.kotlin ?? -1)

    _ = self.updateTickerButton(a_strTicker: ticker, isReplay: isReplay, a_nExchange: exchange, showArrow: !self.isChartsSegue)
  }

  //****************************************************************************
  //
  //       Nome: sendOrder
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6   Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             08/08/2018  v1.3.8   Luís Felipe Polo
  //             - Tipo da ordem não estava sendo alterado após receber mensagem do hades
  //             08/08/2018  v1.3.8   Luís Felipe Polo
  //             - Crash ao calcular preço de ordem à mercado quando não tem incremento mínimo
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             06/03/2019  v1.3.52  Guilherme Cardoso Soares
  //             - Nova classe de Logs
  //             19/03/2019  v1.3.54  Luís Felipe Polo
  //             - Zeragem de posição via servidor
  //             27/03/2019  v1.3.56  Guilherme Cardoso Soares
  //             - Nova Classe de Logs: Novas informações sendo registradas
  //             22/04/2019  v1.3.58 Eduardo Varela Ribeiro
  //             - AlertView Customizado
  //
  //****************************************************************************
  private func sendOrder(_ info: [String: Any], buttonType: BookOrderType? = nil, button: UIButton)
  {
    m_statusLabel?.backgroundColor = Colors.clear
    m_statusLabel?.text = ""
    m_osStatus = nil
    m_strStatusDescription = nil

    guard let side = info["side"] as? Side else {
      Nelogger.shared.log("BoletaViewController sendOrder side nil")
      return
    }
    
    guard let orderType = info["orderType"] as? OrderType else{
      Nelogger.shared.log("BoletaViewController sendOrder orderType nil")
      return
    }
    
    guard var price = info["price"] as? Double else {
      Nelogger.shared.log("BoletaViewController sendOrder price nil")
      return
    }
    
    guard let assetId = info["assetId"] as? AssetIdentifier else {
      Nelogger.shared.log("BoletaViewController sendOrder assetId nil")
      return
    }
    
    guard let quotation = info["quotation"] as? Double else {
      Nelogger.shared.log("BoletaViewController sendOrder quotation nil")
      return
    }
    
    guard let dayTradeAsset = m_selectedAsset else {
      Nelogger.shared.log("BoletaViewController sendOrder dayTradeAsset nil")
      return
    }
    
    guard let stock = app.m_dicStocks[dayTradeAsset.getKey()] else {
      Nelogger.shared.log("BoletaViewController sendOrder stock nil")
      return
    }
    
    var maxFloor: Int = 0
    if let strongMaxFloor = info["iceberg"] as? Int {
      maxFloor = strongMaxFloor
    }
    
    if orderType == .botmarket
    {
      let info = Application.m_application.getAssetInfo(assetId)
      info.addToUpdateList(self)
      
      price = stock.getPriceForMarketOrder(sdSide: side)
    }

    var octOrderClosingType : OrderClosingType = .octNone
    if buttonType == BookOrderType.otResetPosition
    {
      octOrderClosingType = Common.getOrderClosingType(a_bIsInvert: false)
    }
    else if buttonType == BookOrderType.otInvertPosition
    {
      octOrderClosingType = Common.getOrderClosingType(a_bIsInvert: true)
    }
    
    let order = Order(a_strProfitId: nil, a_aidAssetId: assetId, a_sdSide: side, a_otOrderType: orderType)

    order.setOrderData(
      a_strBroker: Application.m_application.m_brkSelectedBroker?.strBrokerId,
      a_strAccount: Application.m_application.m_acSelectedAccount?.strAccountID,
      a_strOrderId: nil,
      a_strClOrdId: nil,
      a_osStatus: nil,
      a_sPrice: price,
      a_nQty: info["quantity"] as? Int,
      a_vtValidity: info["validateType"] as? ValidityType,
      a_dtValidityDate: info["date"] as? Date,
      a_sStopPrice: info["stopPrice"] as? Double,
      a_sAvgPrice: nil,
      a_sUserDefinedTotal: info["userDefinedTotal"] as? Double,
      a_nCumQty: nil,
      a_dtCreationDate: nil,
      a_dtCloseDate: nil,
      a_dtLastUpdate: nil,
      a_nMsgId: nil,
      a_strText: nil,
      a_stStrategyType: info["strategy"] as? StrategyType,
      a_osPreviousStatus: nil,
      a_etExecType: nil,
      a_otOrderType: orderType,
      a_octOrderClosingType: octOrderClosingType,
      a_bIsFinancial: RoutingManager.shared.isFinancialOrder(orderType: orderType),
      a_nMaxFloor: maxFloor,
      subAccountID: Application.m_application.m_acSelectedAccount?.subAccountID,
      a_dtScheduleDate: info["scheduleDate"] as? Date
    )

    if !octOrderClosingType.isClose() {
      if isStrategySelectionEnabled() {
        order.setOCOStrategy(a_ostStrategy: StrategyManager.shared.ocoStrategySelected)
      }
    }
    
    var osOrderSource: OrderSourceType = .daytrade
    if buttonType == nil {
      osOrderSource = .boleta
    }

    Nelogger.shared.log("\(String(describing: button.titleLabel?.text)): \(contextForLog)")
        
    let result = order.sendOrder(a_sQuotation: quotation, a_osOrderSource: osOrderSource)

    if result.status == .Success {
      if buttonType == .otInvertPosition || buttonType == .otResetPosition {
        if let selectedAccount = Application.m_application.m_acSelectedAccount, let position = selectedAccount.GetPosition(a_aidAssetId: order.m_aidAssetId){
          position.m_strProfitIdResetInvert = order.strProfitId
        }
      }
    }
    else
    {
      self.showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.Boleta_OrderNotSent), a_strMessage: result.description())
    }
  }

  //****************************************************************************
  //
  //       Nome: sendOrder da Day Trade
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             08/08/2018  v1.3.8  Luís Felipe Polo
  //             - Tipo da ordem não estava sendo alterado após receber mensagem do hades
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             19/03/2019  v1.3.54  Luís Felipe Polo
  //             - Zeragem de posição via servidor
  //             28/03/2019  v1.3.56  Luís Felipe Polo
  //             - Roteamento para o replay
  //             22/04/2019  v1.3.58 Eduardo Varela Ribeiro
  //             - AlertView Customizado
  //
  //****************************************************************************
  func sendOrderDayTrade(buttonType: BookOrderType, button: UIButton)
  {
    Nelogger.shared.log("OldBoletaViewController.sendOrderDayTrade - User Pressed: Send")
    dismissKeyboard()
    var info: [String: Any] = [:]

    guard let assetID = m_selectedAsset else {
      return
    }
    
    guard let stock = app.m_dicStocks[assetID.getKey()] else {
      return
    }
    
    info["assetId"] = stock.m_aidAssetID
    info["strategy"] = m_dayTrade

    if [.otBuyAsk, .otSellAsk].contains(buttonType)
      {
      info["price"] = stock.sellOffer //Application.m_application.m_baDayTradeAsset?.tinyBookSellPrice
      info["orderType"] = OrderType.botlimit
    }
    else if [.otBuyBid, .otSellBid].contains(buttonType)
      {
      info["price"] = stock.buyOffer //Application.m_application.m_baDayTradeAsset?.tinyBookBuyPrice
      info["orderType"] = OrderType.botlimit
    }
    else if [.otBuyMarket, .otSellMarket, .otInvertPosition, .otResetPosition, .otCancelOrdersAndResetPosition].contains(buttonType)
      {
      info["price"] = stock.getLastDaily()?.sClose //Application.m_application.m_baDayTradeAsset?.quotation
      info["orderType"] = OrderType.botmarket
    }

    if info["price"] == nil
      {
      showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_InvalidPrice))
      return
    }

    if [.otBuyAsk, .otBuyBid, .otBuyMarket].contains(buttonType)
      {
      info["side"] = Side.bosbuy
    }
    else if [.otSellAsk, .otSellBid, .otSellMarket].contains(buttonType)
      {
      info["side"] = Side.bossell
    }

    var nQtd         : Int? = nil
    var intradaySide        : Side? = nil
    var octOrderClosingType : OrderClosingType = .octNone
    
    if let account = Application.m_application.m_acSelectedAccount
    {
      if buttonType == .otResetPosition {
        account.confirmCancelAndReset(assetID: stock.m_aidAssetID, orderSource: .daytrade, sender: self, strategy: m_dayTrade, contextForLog: self.contextForLog, overrideClearOrders: false)
        return
      } else if buttonType == .otCancelOrdersAndResetPosition {
        account.confirmCancelAndReset(assetID: stock.m_aidAssetID, orderSource: .daytrade, sender: self, strategy: m_dayTrade, contextForLog: self.contextForLog, overrideClearOrders: true)
        return
      } else if buttonType == .otInvertPosition {
        account.confirmInvert(assetID: stock.m_aidAssetID, orderSource: .daytrade, sender: self, strategy: m_dayTrade, contextForLog: self.contextForLog)
        return
      }
      if let position = account.GetPosition(a_aidAssetId: stock.m_aidAssetID)
        {
        nQtd = position.getPositionQtyInt()
        intradaySide = position.inverseSide()
      }
    }

    if buttonType == .otInvertPosition && nQtd == nil
    {
      showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: Localization.localizedString(key: LocalizationKey.Boleta_NoPosition))
      return
    }
    else if buttonType == .otResetPosition && nQtd != nil
    {
      octOrderClosingType = Common.getOrderClosingType(a_bIsInvert: false)
      info["quantity"] = nQtd!
      info["side"] = intradaySide
    }
    else if buttonType == .otInvertPosition && nQtd != nil
    {
      octOrderClosingType = Common.getOrderClosingType(a_bIsInvert: true)
      info["quantity"] = nQtd! * 2
      info["side"] = intradaySide
    } else if [.otResetPosition, .otInvertPosition].contains(buttonType) && nQtd == nil {
      showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_InvalidQtd))
      Nelogger.shared.log("Quantidade inválida: qtd = \(qtyTextField.text ?? "nil")")
      return
    }
    else if let qtdTxt = (dayTradeXibView?.qtyTextField.text), let asset =  m_selectedAsset {
      let qtd = Common.formatQtdInput(value: qtdTxt, forAsset: asset)
      info["quantity"] = qtd
    }
    else
    {
      showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: Localization.localizedString(key: LocalizationKey.SendOrderStatus_InvalidQtd))
      Nelogger.shared.log("Quantidade inválida: qtd = \(qtyTextField.text ?? "nil")")
      return
    }

    info["validateType"] = ValidityType.defaultType()
    info["date"] = Date()
    info["stopPrice"] = 0.0

    // Se não tem cotação, então envia 0. Se chegou até aqui e não tem cotação é ordem limitada e não precisa da cotação
    info["quotation"] = 0.0
    if let quote = stock.getLastDaily()?.sClose
      {
      info["quotation"] = quote
    }

    let order = Order(
      a_strProfitId: nil,
      a_aidAssetId: info["assetId"] as! AssetIdentifier,
      a_sdSide: info["side"] as! Side,
      a_otOrderType: info["orderType"] as! OrderType
    )

    order.setOrderData(
      a_strBroker: Application.m_application.m_brkSelectedBroker?.strBrokerId,
      a_strAccount: Application.m_application.m_acSelectedAccount?.strAccountID,
      a_strOrderId: nil,
      a_strClOrdId: nil,
      a_osStatus: nil,
      a_sPrice: info["price"] as? Double,
      a_nQty: info["quantity"] as? Int,
      a_vtValidity: info["validateType"] as? ValidityType,
      a_dtValidityDate: info["date"] as? Date,
      a_sStopPrice: info["stopPrice"] as? Double,
      a_sAvgPrice: nil,
      a_sUserDefinedTotal: info["userDefinedTotal"] as? Double,
      a_nCumQty: nil,
      a_dtCreationDate: nil,
      a_dtCloseDate: nil,
      a_dtLastUpdate: nil,
      a_nMsgId: nil,
      a_strText: nil,
      a_stStrategyType: info["strategy"] as? StrategyType,
      a_osPreviousStatus: nil,
      a_etExecType: nil,
      a_otOrderType: info["orderType"] as! OrderType,
      a_octOrderClosingType: octOrderClosingType,
      a_bIsFinancial: RoutingManager.shared.isFinancialOrder(orderType: info["orderType"] as! OrderType),
      subAccountID: Application.m_application.m_acSelectedAccount?.subAccountID
    )
    
    if !octOrderClosingType.isClose() {
      if isStrategySelectionEnabled() {
        order.setOCOStrategy(a_ostStrategy: StrategyManager.shared.ocoStrategySelected)
      }
    }

    let result = order.ValidateOrder(
      a_sQuotation: info["quotation"] as? Double,
      a_sPrice: info["price"] as? Double,
      a_nQty: info["quantity"] as? Int,
      a_userDefinedTotal: info["userDefinedTotal"] as? Double,
      a_sStopPrice: info["stopPrice"] as? Double
    )

    if result.status != SendOrderStatus.Success
      {
      if result.status == SendOrderStatus.NoPassword
        {
          showPasswordView(callback: {self.sendOrderDayTrade(buttonType: buttonType, button: button)})
      }
      else
      {
        showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.Boleta_OrderNotSent), a_strMessage: result.description())
      }
    }
    else
    {
      if Application.m_application.m_dicDefaultConfirm[ConfirmationKey(a_otType: buttonType)]!
        {
          self.showConfirmationAlert(
            strTitle: Localization.localizedString(key: LocalizationKey.Boleta_NewOrder),
            strMessage:  order.confirmNewOrderMessage(),
            confirmationKey: ConfirmationKey(a_otType: buttonType), action: {
              self.sendOrder(info, buttonType: buttonType, button: button) // Send order já loga o envio
            }, cancelAction: {
              Nelogger.shared.log("\(button.titleLabel?.text ?? order.otOrderType.descriptionStr()): \(self.contextForOrderLog(order))")
            })
      }
      else
      {
        self.sendOrder(info, buttonType: buttonType, button: button) // Send order já loga o envio
      }
    }
    Statistics.shared.log(type: .stOrderInteraction, message: button.titleLabel?.text ?? "", value: "Boleta")
  }

  //****************************************************************************
  //
  //       Nome: needConfirmation
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  func ConfirmationKey(a_otType: BookOrderType) -> String
  {
    switch a_otType {
    case .otInvertPosition:
      return "ConfirmInvert"
    case .otResetPosition:
      return "ConfirmReset"
    default:
      return "ConfirmNew"
    }
  }
  
  func confirmationType(a_otType: BookOrderType) -> String
  {
    switch a_otType {
    case .otInvertPosition:
      return "ConfirmInvert"
    case .otResetPosition:
      return "ConfirmReset"
    default:
      return "ConfirmNew"
    }
  }
  
  //******************************************************************************
  //
  //       Nome: orderOptionsMenu
  //  Descrição: monta opções do menu após seleção de ordem
  //
  //    Criação:
  // Modificado: 23/07/18  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //              26/03/2019  v1.3.56
  //              - Adicionar ativos da lista de ordens no dicionário global de ativos
  //              23/04/2019 v1.3.62 Eduardo Varela Ribeiro
  //              - Reenvio da ordem na Boleta
  //             02/05/2019  v1.3.64  Guilherme Cardoso Soares
  //             - Ajustes para iPad
  //******************************************************************************
  func orderOptionsMenu()
  {
    let optionsController = UIAlertController(title: Localization.localizedString(key: LocalizationKey.OrderList_OrderOptions), message: "", preferredStyle: .actionSheet)
    
    let editOrder = UIAlertAction(
      title:  Localization.localizedString(key: LocalizationKey.OrderList_EditOrder),
      style: .default,
      handler: { (action) -> Void in
        self.editOrder(a_orOrder: self.selectedOrder!)
        self.selectedOrder = nil
    })
    
    let cancelOrder = UIAlertAction(
      title: Localization.localizedString(key: LocalizationKey.OrderList_CancelOrder),
      style: .default,
      handler: { (action) -> Void in
        self.cancelOrder(a_orOrder: self.selectedOrder!)
        self.selectedOrder = nil
    })
    
    let resendOrder = UIAlertAction(
      title: Localization.localizedString(key: LocalizationKey.OrderList_ResendOrder),
      style: .default,
      handler: { (action) -> Void in
        self.resendOrder(a_orOrder: self.selectedOrder!)
        self.selectedOrder = nil
    })
    
    let cancelAction = UIAlertAction(
      title: Localization.localizedString(key: LocalizationKey.General_Back),
      style: .cancel,
      handler: nil)
    
    if selectedOrder?.dtCloseDate == nil
    {
      optionsController.addAction(editOrder)
      optionsController.addAction(cancelOrder)
    }
    
    optionsController.addAction(resendOrder)
    optionsController.addAction(cancelAction)
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      optionsController.popoverPresentationController?.sourceView = self.view
      optionsController.popoverPresentationController?.permittedArrowDirections = []
      optionsController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: self.view.frame.height - 300, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    present(optionsController, animated: true, completion: nil)
  }

  // MARK: - UPDATES
  //******************************************************************************
  //
  // Nome:      updateViewOnPositionPropertyChanged
  // Descrição:
  //
  // Criação:
  // Modificado:
  //
  //******************************************************************************
  func updateViewOnPositionPropertyChanged(property: PositionProperties,
    value: AnyObject?,
    reference: AnyObject)
  {
    if property.isSwingData {
      if let assetID = m_selectedAsset, let account = Application.m_application.m_acSelectedAccount, let pos = account.GetPosition(a_aidAssetId: assetID)
      {
        let positionAvgPrice = pos.getPositionAvgPriceWithCurrency()
        setupAverageResultLabelText {
          self.averageResultLabel.text = Common.formatStringfrom(value: positionAvgPrice.0, minDigits: 2, maxDigits: 2)
          self.averageResultLabel.text? = (positionAvgPrice.1 ?? "") + " " + (self.averageResultLabel.text ?? "")
        }
        
        if let side = pos.getPositionSide(), let qty = pos.getPositionQtyInt()
        {
          let qty = NSMutableAttributedString(string: Common.formatQtyToString(value: qty, forAsset: assetID, makeShort: false) + "  ")
          let strSide = NSMutableAttributedString(string: side.descriptionStr(), attributes: [NSAttributedString.Key.foregroundColor: side.fontColorIOS()])
          let strQty = NSMutableAttributedString()
          strQty.append(qty)
          strQty.append(strSide)
          qtyResultLabel.attributedText = strQty
        }
        else
        {
          qtyResultLabel.text = "-"
        }
      }
      return
    }
    
    switch property
    {
    case .ssimpleopenresult:
      m_simpleOpenResult = value as? Double
    case .ssimpletotalresult:
      m_simpleTotalResult = value as? Double
    case .sextraopenresult:
      m_extraOpenResult = value as? Double
    case .sextratotalresult:
      m_extraTotalResult = value as? Double
    case .stotalvaluetrade:
      m_totalValueTrade = value as? Double
    default:
      break
    }
  }

  //****************************************************************************
  //
  //       Nome: UpdateViewAccount
  //  Descrição:
  //
  //    Criação:
  // Modificado: 19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //****************************************************************************
  @objc func UpdateViewAccount(note: NSNotification)
  {
    if let accountView = xibAccountView.contentView as? AccountView
    {
      accountView.setAccountInformation()
    }
    setupValidityPicker()
    unsubscribeData()
    
    loadStockData()
  }

  /// Garante inscrição do info do ativo quando a conexão com o marketData é realizada
  /// - Parameter note: NSNotification
  /// - Authors:
  /// Tháygoro Minuzzi Leopoldino
  @objc func UpdateInfoSubscrition(note: NSNotification)
  {
    guard let dayTradeAsset: AssetIdentifier = m_selectedAsset else {
      return
    }
    let m_stock: Stock = app.getStock(assetID: dayTradeAsset)

    let info = app.getAssetInfo(m_stock.m_aidAssetID)
    info.addToUpdateList(self)
  }
  
  //****************************************************************************
  //
  //       Nome: UpdateLastOrderStatus
  //  Descrição: Notificação de mudança de status da última ordem enviada
  //
  //    Criação: 05/01/2018  v1.0    Luís Felipe Polo
  // Modificado: 05/07/2018  v1.3.4  Luís Felipe Polo
  //             - Passar estrutura de dados de ordem de dicionário para array
  //
  //****************************************************************************
  @objc func UpdateLastOrderStatus(note: NSNotification)
  {
    if let order = note.object as? Order
    {
      m_osStatus = order.osStatus
      m_strStatusDescription = order.strText
      setStatusBarText()
      fadeInFadeOutMsgView()
    }
  }

  //****************************************************************************
  //
  //       Nome: receivedNewPositionNotification
  //  Descrição: trata a notificação de nova posição
  //
  //    Criação: 28/02/2019  v1.3.48  Guilherme Cardoso Soares
  // Modificado: 28/02/2019  v1.3.48  Guilherme Cardoso Soares
  //             - Notificação: NewPositionNotification
  //             28/03/2019  v1.3.56  Luís Felipe Polo
  //             - Roteamento para o replay
  //
  //****************************************************************************
  @objc func receivedNewPositionNotification() {
    if let account = app.m_acSelectedAccount {
      if let assetID = m_selectedAsset, let position = account.GetPosition(a_aidAssetId: assetID) {
        position.addToUpdateList(self)
        
        m_totalValueTrade = position.currentTotal
        m_extraTotalResult = position.extraTotalResult
        m_extraOpenResult = position.extraOpenResult
        m_simpleTotalResult = position.simpleTotalResult
        m_simpleOpenResult = position.simpleOpenResult
        

        let positionAvgPrice = position.getPositionAvgPriceWithCurrency()
        setupAverageResultLabelText {
          self.averageResultLabel.text = Common.formatStringfrom(value: positionAvgPrice.0, minDigits: 2, maxDigits: 2)
          self.averageResultLabel.text? = (positionAvgPrice.1 ?? "") + " " + (self.averageResultLabel.text ?? "")
        }

        if let side = position.getPositionSide()
        {
          if let qty = position.getPositionQtyInt()
          {
            let qty = NSMutableAttributedString(string: Common.formatQtyToString(value: qty, forAsset: assetID, makeShort: false) + "  ")
            let strSide = NSMutableAttributedString(string: side.descriptionStr(), attributes: [NSAttributedString.Key.foregroundColor: side.fontColorIOS()])
            
            let strQty = NSMutableAttributedString()
            strQty.append(qty)
            strQty.append(strSide)
            qtyResultLabel.attributedText = strQty
          }
        }
      }
    }
  }
  
  
  // MARK: - DATA
  //****************************************************************************
  //
  //       Nome: loadStockData
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             07/08/2018  v1.3.8  Luís Felipe Polo
  //             - Crash ao abrir boleta a partir do forcetouch
  //             03/10/2018  v1.3.12  Luís Felipe Polo
  //             - Manter a última quantidade informada pelo usuário na boleta
  //             13/02/2019 v1.3.44 Eduardo Varela Ribeiro
  //             - Funcionamento do Replay
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             26/02/2019  v1.3.48 Eduardo Varela Ribeiro
  //             - Funcionamento do Replay
  //             28/02/2019  v1.3.48  Guilherme Cardoso Soares
  //             - Crashes na BoletaViewController
  //             28/03/2019  v1.3.56  Luís Felipe Polo
  //             - Roteamento para o replay
  //             05/04/2019  v1.3.56  Luís Felipe Polo
  //             - Teste se bolsa é Bovespa ou BMF incluindo bolsas de replay
  //
  //****************************************************************************
  private func loadStockData()
  {

    setDefaultValues()

    m_updatePriceField = true
    
    guard let dayTradeAsset: AssetIdentifier = m_selectedAsset else {
      return
    }
    let m_stock: Stock = app.getStock(assetID: dayTradeAsset)
    
    m_stock.addToUpdateList(self, extras: [.TinyBook, .PriceBook, .Daily])
    
    loadValidyPickerData()
    
    setDefaultValuesForVitreo(dayTradeAsset)

    // Subscribe para a posição do ativo da referencia
    let referenceAssetId = Common.getReferenceAssetId(a_aidAssetId: m_stock.m_aidAssetID)
    if referenceAssetId != m_stock.m_aidAssetID {
      let referenceInfo = Application.m_application.getAssetInfo(referenceAssetId)
      referenceInfo.addToUpdateList(self)
      
      let referenceStock: Stock = app.getStock(assetID: referenceAssetId)
      referenceStock.addToUpdateList(self, extra: .Quotation)
    }

    let info = app.getAssetInfo(m_stock.m_aidAssetID)
    info.addToUpdateList(self)
    if app.handlesFractionary(), info.hasFractionary() {
      if info.isFractionary() {
        self.updateTickerButton(a_strTicker: info.getNonFractionaryAssetId().getKey())
      } else {
        self.updateTickerButton(a_strTicker: m_stock.m_aidAssetID.getKey())
      }
    } else {
      self.updateTickerButton(a_strTicker: m_stock.m_aidAssetID.getKey())
    }


    if let lastDaily = m_stock.getLastDaily() {
      let defaultStopOffset: Double = 30 * m_sMinIncrement
      let stopOffsetString: String = formatText(defaultStopOffset)
      
      let sQuotation = lastDaily.sClose
      let strQuotation = formatText(sQuotation)
      m_arStockCollectionData[0].value = strQuotation
      priceTextField.text = strQuotation
      stopOffsetTextField.text = stopOffsetString
      m_updatePriceField = false
      priceStepper.value = Double(sQuotation)
      stopOffsetStepper.value = defaultStopOffset
    }

    if let dtDate = m_stock.lastTradeDate //Application.m_application.m_baDayTradeAsset!.date
    {
      m_arStockCollectionData[3].value = ExchangeManager.shared.isItReplayMarket(nExchange: m_selectedAsset?.m_nMarket.kotlin ?? -1) ? Common.dateToStringFormatReplay(date: dtDate, asset: m_selectedAsset) : Common.dateToStringFormat(date: dtDate, watchlistFormat: true, asset: m_selectedAsset)
    }

    if let sChange = m_stock.sDailyChange
    {
      m_arStockCollectionData[4].value = Common.formatStringfrom(value: sChange, minDigits: 2, maxDigits: 2) + "%"
      m_Variation = sChange
    }

    if let sBuyPrice = m_stock.buyOffer //Application.m_application.m_baDayTradeAsset!.tinyBookBuyPrice
    {
      m_arStockCollectionData[1].value = formatText(sBuyPrice)
    }

    if let sSellPrice = m_stock.sellOffer //Application.m_application.m_baDayTradeAsset!.tinyBookSellPrice
    {
      m_arStockCollectionData[2].value = formatText(sSellPrice)
    }

    guard let assetInfo = app.m_dicAssetInfo[m_stock.m_aidAssetID.getKey()] else {
      return
    }
    
    if app.handlesFractionary() && assetInfo.hasFractionary() {
      if assetInfo.isFractionary() {
        if let nonFracInfo = assetInfo.getNonFractionaryAssetInfo(), let minOrderQtd = assetInfo.nMinOrderQtd, let maxOrderQtd = nonFracInfo.nMaxOrderQtd {
          qtyStepper.minimumValue = Double(minOrderQtd)
          dayTradeXibView?.qtyStepper.minimumValue = Double(minOrderQtd)
          qtyStepper.maximumValue = Double(maxOrderQtd)
          dayTradeXibView?.qtyStepper.maximumValue = Double(maxOrderQtd)
        }
      } else {
        if let fracInfo = assetInfo.getFractionaryAssetInfo(), let minOrderQtd = fracInfo.nMinOrderQtd, let maxOrderQtd = assetInfo.nMaxOrderQtd {
          qtyStepper.minimumValue = Double(minOrderQtd)
          dayTradeXibView?.qtyStepper.minimumValue = Double(minOrderQtd)
          qtyStepper.maximumValue = Double(maxOrderQtd)
          dayTradeXibView?.qtyStepper.maximumValue = Double(maxOrderQtd)
        }
      }
    } else {
      if let maxOrderQtd = assetInfo.nMaxOrderQtd {
        qtyStepper.maximumValue = Double(maxOrderQtd)
        dayTradeXibView?.qtyStepper.maximumValue = Double(maxOrderQtd)
      }
      if let minOrderQtd = assetInfo.nMinOrderQtd {
        qtyStepper.minimumValue = Double(minOrderQtd)
        dayTradeXibView?.qtyStepper.minimumValue = Double(minOrderQtd)
      }
    }
    
    m_quantity = Double(assetInfo.getQtdDefault())
    m_iceberg = 0
    qtyStepper.value = m_quantity
    icebergStepper.value = m_iceberg
    dayTradeXibView?.qtyStepper.value = Double(m_quantity)
    qtyTextField.text = Common.formatQtyToString(value: Common.convertDoubleToInt(m_quantity), forAsset: m_stock.m_aidAssetID, makeShort: false)
    icebergTextField.text = Common.formatQtyToString(value: Common.convertDoubleToInt(m_iceberg), forAsset: m_stock.m_aidAssetID, makeShort: false)
    dayTradeXibView?.qtyTextField.text = Common.formatQtyToString(value: Common.convertDoubleToInt(m_quantity), forAsset: m_stock.m_aidAssetID, makeShort: false)
    

    
    if let lote = assetInfo.nLote {
      qtyStepper.stepValue = Double(lote)
      icebergStepper.stepValue = Double(lote)
      dayTradeXibView?.qtyStepper.stepValue = Double(lote)
    }
    
    if ExchangeManager.shared.isSaxo(a_nExchange: m_stock.m_aidAssetID.m_nMarket.kotlin), let minIncrement = Application.m_application.m_dicAssetInfo[m_stock.m_aidAssetID.getKey()]?.sMinOrderPriceIncrement
    {
      priceStepper.stepValue = minIncrement
      stopOffsetStepper.stepValue = minIncrement
    }
    else {
      if let increment = assetInfo.sMinOrderPriceIncrement ?? assetInfo.sMinPriceIncrement {
        priceStepper.stepValue = Double(increment)
        stopOffsetStepper.stepValue = Double(increment)
      }
    }
    
    loadPosition(m_stock: m_stock)

    totalLabel.text = calcTotal()
    symbolDataCollectionView.reloadData()
    orderListTableView.reloadData()
    enableBoleta()

    var hasIceberg: Bool = false
    if let broker: Broker = Application.m_application.m_brkSelectedBroker {
      hasIceberg = broker.hasIceberg(m_nMarket: m_stock.m_aidAssetID.m_nMarket)
    }
    icebergView.isHidden = !hasIceberg
    icebergViewHeight.constant = hasIceberg ? 41.0 : 0.0
    
    stopOffsetHeight.constant = 0.0
    stopOffsetView.isHidden = true
    if m_orderType == .botstoplimit
      {
      stopOffsetHeight.constant = 41.0
      stopOffsetView.isHidden = false
    }
    
    if m_otOrderTypeTemp == .botScheduled {
      m_scheduleDate = Date()
      m_dScheduleDateTemp = m_scheduleDate
      scheduleViewHeight.constant = 41.0
      scheduleView.isHidden = false
      scheduleTextField.text = Common.dateToStringFormat(date: m_scheduleDate, watchlistFormat: false, asset: m_stock.m_aidAssetID)
    } else {
      m_scheduleDate = nil
      m_dScheduleDateTemp = nil
      scheduleViewHeight.constant = 0.0
      scheduleView.isHidden = true
      scheduleTextField.text = ""
    }

    if m_selectedValidity == ValidityType.btfGoodTillDate
    {
      m_date = Date()
      dateHeight.constant = 41.0
      dateView.isHidden = false
      dateTextField.text = Common.dateToStringFormat(date: m_date, watchlistFormat: false, asset: m_stock.m_aidAssetID)
    }
    else
    {
      dateHeight.constant = 0.0
      dateView.isHidden = true
      dateTextField.text = ""
    }

    m_dayTrade = Application.m_application.getStrategyType()
    
    if !strategies.contains(.stDayTrade) || !Application.m_application.m_userProduct.HasDayTradeSwitchAtBoleta()
      {
      dayTradeXibView?.dayTradeView.isHidden = true
      dayTradeXibView?.dayTradeViewHeightCons.constant = 0
      dayTradeSwitchView.isHidden = true
      dayTradeHeight.constant = 0
    }
    else
    {
      dayTradeXibView?.dayTradeView.isHidden = false
      dayTradeXibView?.dayTradeViewHeightCons.constant = 35
      dayTradeSwitchView.isHidden = false
      dayTradeHeight.constant = 41
    }
    
    if Application.m_application.m_userProduct.HasCoveredTradeMode(assetInfo: m_selectedAssetInfo) {
      dayTradeXibView?.coveredTradeView.isHidden = false
      dayTradeXibView?.coveredTradeViewHeightCons.constant = 35
      coveredTradeSwitchView.isHidden = false
      coveredTradeHeight.constant = 41
    } else {
      dayTradeXibView?.coveredTradeView.isHidden = true
      dayTradeXibView?.coveredTradeViewHeightCons.constant = 0
      coveredTradeSwitchView.isHidden = true
      coveredTradeHeight.constant = 0
    }
  }
  
  func loadPosition(m_stock: Stock?) {
    if let account = Application.m_application.m_acSelectedAccount {
      var assetID = m_stock!.m_aidAssetID
      if Application.m_application.handlesFractionary() {
        if let assetInfo = Application.m_application.m_dicAssetInfo[m_stock!.m_aidAssetID.getKey()], assetInfo.hasFractionary() && assetInfo.isFractionary() {
          assetID = assetInfo.getNonFractionaryAssetId()
        }
      }
      if let position = account.GetPosition(a_aidAssetId: assetID) {
        position.addToUpdateList(self)

        m_totalValueTrade = position.currentTotal
        m_extraTotalResult = position.extraTotalResult
        m_extraOpenResult = position.extraOpenResult
        m_simpleTotalResult = position.simpleTotalResult
        m_simpleOpenResult = position.simpleOpenResult

        let positionAvgPrice = position.getPositionAvgPriceWithCurrency()
        if let avg = positionAvgPrice.0
        {
          setupAverageResultLabelText {
            self.averageResultLabel.text = Common.formatStringfrom(value: avg, minDigits: 2, maxDigits: 2)
            self.averageResultLabel.text? = (positionAvgPrice.1 ?? "") + " " + (self.averageResultLabel.text ?? "")
          }
        }
        else
        {
          averageResultLabel.text = "-"
        }

        if let side = position.getPositionSide()
        {
          if let qty = position.getPositionQtyInt()
          {
            let qty = NSMutableAttributedString(string:Common.formatQtyToString(value: qty, forAsset: assetID, makeShort: false) + "  ")
            let strSide = NSMutableAttributedString(string: side.descriptionStr(), attributes: [NSAttributedString.Key.foregroundColor: side.fontColorIOS()])

            let strQty = NSMutableAttributedString()
            strQty.append(qty)
            strQty.append(strSide)
            qtyResultLabel.attributedText = strQty
          }
          else
          {
            qtyResultLabel.text = "-"
          }
        }
        else
        {
          qtyResultLabel.text = "-"
        }
      }
      else
      {
        averageResultLabel.text = "-"
        qtyResultLabel.text = "-"
        m_totalValueTrade = nil
        m_extraTotalResult = nil
        m_extraOpenResult = nil
        m_simpleTotalResult = nil
        m_simpleOpenResult = nil
      }
    }
  }

  //****************************************************************************
  //
  //       Nome: formatText
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             07/08/2018  v1.3.8  Luís Felipe Polo
  //             - Crash ao abrir boleta a partir do forcetouch
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //****************************************************************************
  private func formatText(_ value: Double) -> String
  {
    if let floatDigits = Application.m_application.m_dicAssetInfo[m_selectedAsset!.getKey()]?.nDigitsPrice ?? Application.m_application.m_dicAssetInfo[m_selectedAsset!.getKey()]?.nFloatDigits
    {
      return Common.formatStringfrom(value: value, minDigits: floatDigits, maxDigits: floatDigits)
    }
    return Common.formatStringfrom(value: value, minDigits: 2, maxDigits: 2)
  }

  //****************************************************************************
  //
  //       Nome: calcTotal
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //****************************************************************************
  func calcTotal() -> String
  {
    if m_orderType != .botmarket
    {
      guard let text = qtyTextField.text, let asset = m_selectedAsset else {
        return "-"
      }
      let qty = Common.calcRealQty(value: Common.formatQtdInput(value: text, forAsset: asset), forAsset: asset)
      if let price = Double(Common.formatNumericalInput(a_strInput: priceTextField.text!)),
      let multiplier = Application.m_application.m_dicAssetInfo[m_selectedAsset!.getKey()]?.sContractMultiplier
      {
        var digits = 2
        if let info = Application.m_application.m_dicAssetInfo[m_selectedAsset?.getKey() ?? ""] , let priceDigits = info.nDigitsPrice {
          digits = priceDigits
        }
        return Common.formatStringfrom(value: price * qty * multiplier, minDigits: digits, maxDigits: digits)
      }
    }
    return "-"
  }


  //****************************************************************************
  //
  //       Nome: setupTypePicker
  //  Descrição: Inicializa componente typeTextField com PickerView
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  private func setupTypePicker()
  {
    let typePickerView = UIPickerView()
    typePickerView.delegate = self
    typePickerView.dataSource = self
    typePickerView.tag = 2
    typeTextField.inputView = typePickerView


    // ToolBar
    let toolBar = UIToolbar()
    toolBar.barTintColor = Colors.clPickerToolbar
    //toolBar.isTranslucent = true
    toolBar.sizeToFit()
    let doneButton = UIBarButtonItem(title: Localization.localizedString(key: LocalizationKey.General_Done), style: .plain, target: self, action: #selector(self.typeToolbarDoneClick))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: Localization.localizedString(key: LocalizationKey.General_Cancel), style: .plain, target: self, action: #selector(self.typeCancelClick))
    cancelButton.tintColor = UIColor.flatBlack
    doneButton.tintColor = UIColor.flatBlack
    cancelButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.flatBlack], for: .normal)
    doneButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.flatBlack], for: .normal)
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    typeTextField.inputAccessoryView = toolBar
  }

  //****************************************************************************
  //
  //       Nome: typeToolbarDoneClick
  //  Descrição: Botão para capturar seleção do typeTextField
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  @objc func typeToolbarDoneClick()
  {
    m_orderType = m_otOrderTypeTemp.getRealOrderType()
    typeTextField.text = m_otOrderTypeTemp.description()
    totalLabel.text = calcTotal()
    typeTextField.resignFirstResponder()
    stopOffsetHeight.constant = 0.0
    stopOffsetView.isHidden = true
    if m_otOrderTypeTemp == .botstoplimit
      {
      stopOffsetHeight.constant = 41.0
      stopOffsetView.isHidden = false
    }
    
    if m_otOrderTypeTemp == .botScheduled {
      let date = Date()
      m_dScheduleDateTemp = date
      m_scheduleDate = date
      scheduleViewHeight.constant = 41.0
      scheduleView.isHidden = false
      scheduleTextField.text = Common.dateToStringFormat(date: date, watchlistFormat: false, asset: m_selectedAsset)
    } else {
      m_dScheduleDateTemp = nil
      m_scheduleDate = nil
      scheduleViewHeight.constant = 0.0
      scheduleView.isHidden = true
    }

    if m_otOrderTypeTemp == .botmarket {
      priceStepper.isEnabled = false
      priceTextField.isEnabled = false
      priceTextField.text = "Mercado"
      priceStepper.tintColor = .gray
    } else {
      priceStepper.isEnabled = true
      priceTextField.isEnabled = true
      priceTextField.text = formatText(priceStepper.value)
      priceStepper.tintColor = Colors.clProfitAlertTextFieldFontColor
    }

    lockStrategySelectionIfNeeded()
    calculaHeigthConstraint()
  }

  //****************************************************************************
  //
  //       Nome: typeCancelClick
  //  Descrição: Botão para cancelar a seleção do typeTextField
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  @objc func typeCancelClick()
  {
    typeTextField.resignFirstResponder()
  }

  //****************************************************************************
  //
  //       Nome: setDefaultValues
  //  Descrição:
  //
  //    Criação:
  // Modificado:  03/05/2019  v1.3.64  Eduardo Varela Ribeiro
  //              - Correção do cursor nos campos de texto
  //              30/05/2019  v1.3.76  Luís Felipe Polo
  //              - Não estava limpando valores da posição na boleta após seleção de ativo sem posição
  //              17/07/2019  v1.3.96 Guilherme Cardoso Soares
  //              - Crash na BoletaViewController: DayTradeXibView com objetos weak e crash de nil
  //              02/08/2019  v1.3.102  Guilherme Cardoso Soares
  //              - Crash na BoletaViewController
  //****************************************************************************
  private func setDefaultValues()
  {
    if qtyTextField != nil{
      qtyTextField.text = "0"
    }
    
    if qtyStepper != nil {
      qtyStepper.value = 0
    }
    
    if icebergTextField != nil {
      icebergTextField.text = "0"
    }
    
    if icebergStepper != nil {
      icebergStepper.value = 0
    }
    
    if dayTradeXibView != nil {
      if dayTradeXibView?.qtyStepper != nil {
        dayTradeXibView?.qtyStepper.value = 0
      }
      if dayTradeXibView?.qtyTextField != nil {
        dayTradeXibView?.qtyTextField.text = "0"
      }
    }

    if totalLabel != nil {
      totalLabel.text = Common.formatStringfrom(value: 0, minDigits: 2, maxDigits: 2)
    }
    
    if priceTextField != nil {
      priceTextField.text = ""
    }
    
    if stopOffsetTextField != nil {
      stopOffsetTextField.text = ""
    }
    
    if averageResultLabel != nil {
      averageResultLabel.text = "-"
    }

    if qtyResultLabel != nil {
      qtyResultLabel.text = "-"
    }
    
    m_totalValueTrade = nil
    m_extraTotalResult = nil
    m_extraOpenResult = nil
    m_simpleTotalResult = nil
    m_simpleOpenResult = nil

    m_arStockCollectionData[0].value = "-"
    m_arStockCollectionData[1].value = "-"
    m_arStockCollectionData[2].value = "-"
    m_arStockCollectionData[3].value = "-"
    m_arStockCollectionData[4].value = "-"

    if m_validityPickerData.count > 0 {
      if let sv = m_selectedValidity, m_validityPickerData.contains(sv) {
        if validityTextField != nil {
          validityTextField.text = sv.description()
        }
      } else {
        if m_validityPickerData.contains(ValidityType.defaultType()) {
          m_selectedValidity = ValidityType.defaultType()
          if validityTextField != nil {
            validityTextField.text = m_selectedValidity!.description()
          }
        } else {
          m_selectedValidity = m_validityPickerData[0]
          if validityTextField != nil {
            validityTextField.text = m_selectedValidity!.description()
          }
        }
      }
    } else {
      //  nenhum tipo de validade
      m_selectedValidity = nil
      if validityTextField != nil {
        validityTextField.text = ""
      }
    }

    if typeTextField != nil {
      typeTextField.text = m_otOrderTypeTemp.description()
    }

  }
  
  private func setDefaultValuesForVitreo(_ a_assetID: AssetIdentifier) {
    guard Application.m_application.isVitreoFramework() else {
      return
    }
    
    var isStockOrMiniContract: Bool = false
    let validSecurityTypes: [SecurityType] = [.stcommonstock, .stpreferredstock, .strights]
    if let assetInfo: AssetInfo = Application.m_application.m_dicAssetInfo[a_assetID.getKey()], assetInfo.sstSubSecurityType == .ssMiniContract || validSecurityTypes.contains(assetInfo.stSecurityType ?? .stunknown) {
      isStockOrMiniContract = true
    }
    
    if ExchangeManager.shared.isBovespa(a_nExchange: a_assetID.m_nMarket.kotlin) {
      if m_validityPickerData.contains(ValidityType.btfGoodTillCancel) {
        m_selectedValidity = ValidityType.btfGoodTillCancel
        validityTextField.text = ValidityType.btfGoodTillCancel.description()
      }
      if isStockOrMiniContract {
        m_otOrderTypeTemp = OrderTypePickerData.botmarket
        m_orderType = m_otOrderTypeTemp.getRealOrderType()
        typeTextField.text = m_otOrderTypeTemp.description()
      }
    } else if ExchangeManager.shared.isBMF(a_nExchange: a_assetID.m_nMarket.kotlin) && isStockOrMiniContract {
      m_otOrderTypeTemp = OrderTypePickerData.botmarket
      m_orderType = m_otOrderTypeTemp.getRealOrderType()
      typeTextField.text = m_otOrderTypeTemp.description()
    }
    
  }
  
  //****************************************************************************
  //
  //       Nome: setupValidityPicker
  //  Descrição: Inicializa componente validityTextField com PickerView
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  private func setupValidityPicker()
  {
    loadValidyPickerData()
    let validityPickerView = UIPickerView()
    validityPickerView.delegate = self
    validityPickerView.dataSource = self
    validityPickerView.tag = 1
    validityTextField.inputView = validityPickerView

    // ToolBar
    let toolBar = UIToolbar()
    toolBar.barTintColor = Colors.clPickerToolbar
    toolBar.sizeToFit()
    let doneButton = UIBarButtonItem(title: Localization.localizedString(key: LocalizationKey.General_Done), style: .plain, target: self, action: #selector(self.validityToolbarDoneClick))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: Localization.localizedString(key: LocalizationKey.General_Cancel), style: .plain, target: self, action: #selector(self.validityCancelClick))
    cancelButton.tintColor = UIColor.flatBlack
    doneButton.tintColor = UIColor.flatBlack
    cancelButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.flatBlack], for: .normal)
    doneButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.flatBlack], for: .normal)
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    validityTextField.inputAccessoryView = toolBar

  }

  //****************************************************************************
  //
  //       Nome: validityToolbarDoneClick
  //  Descrição: Botão para capturar seleção do validityTextField
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  @objc func validityToolbarDoneClick()
  {
    if let validityPickerData = m_vtValidityPickerDataTemp {
      m_selectedValidity = validityPickerData
      validityTextField.text = validityPickerData.description()
      if m_selectedValidity == ValidityType.btfGoodTillDate
        {
        m_date = Date()
        dateHeight.constant = 41.0
        dateView.isHidden = false
          dateTextField.text = Common.dateToStringFormat(date: m_date, watchlistFormat: false, asset: m_selectedAsset)
      }
      else
      {
        dateHeight.constant = 0.0
        dateView.isHidden = true
        dateTextField.text = ""
      }
    }
    else
    {
      m_selectedValidity = nil
    }
    calculaHeigthConstraint()
    validityTextField.endEditing(true)
  }

  //****************************************************************************
  //
  //       Nome: calculaHeigthConstraint()
  //  Descrição: Botão para cancelar a seleção do validityTextField
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  func calculaHeigthConstraint()
  {
    var cont = 0

    if strategies.contains(.stDayTrade) || !Application.m_application.m_userProduct.HasDayTradeSwitchAtBoleta(){
      cont = cont + 1
    }
    
    if Application.m_application.m_userProduct.HasCoveredTradeMode(assetInfo: m_selectedAssetInfo) {
      cont = cont + 1
    }

    if m_selectedValidity == ValidityType.btfGoodTillDate {
      cont = cont + 1
    }

    if m_orderType == .botstoplimit {
      cont = cont + 1
    }
    if currentView == .DayTrade {
      contentHeightCons.isActive = true
      var dayTHeight = sDayTradeHeight
      if !strategies.contains(.stDayTrade) || !Application.m_application.m_userProduct.HasDayTradeSwitchAtBoleta() {
        dayTHeight -= 35
      }
      
      if !Application.m_application.m_userProduct.HasCoveredTradeMode(assetInfo: m_selectedAssetInfo) {
        dayTHeight -= 35
      }
      
      if !Application.m_application.m_userProduct.HasOCOStrategy() {
        dayTHeight -= 45
      }
      
      self.contentHeightCons.constant = dayTHeight
    } else {
      contentHeightCons.isActive = false
    }
  }

  //****************************************************************************
  //
  //       Nome: validityCancelClick
  //  Descrição: Botão para cancelar a seleção do validityTextField
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  @objc func validityCancelClick()
  {
    validityTextField.resignFirstResponder()
  }

  //****************************************************************************
  //
  //       Nome: setupDatePicker
  //  Descrição: Inicializa componente dateTextField com PickerView
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  private func setupDatePicker()
  {
    let datePickerView = UIDatePicker()
    datePickerView.datePickerMode = .date
    if #available(iOS 14, *) {
      datePickerView.preferredDatePickerStyle = .wheels
    }
    datePickerView.addTarget(self,
      action: #selector(datePickerValueChanged(sender:)),
      for: .valueChanged)
    dateTextField.inputView = datePickerView

    // ToolBar
    let toolBar = UIToolbar()
    toolBar.barTintColor = Colors.clPickerToolbar
    toolBar.sizeToFit()
    let doneButton = UIBarButtonItem(title: Localization.localizedString(key: LocalizationKey.General_Done), style: .plain, target: self, action: #selector(self.dataToolbarDoneClick))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: Localization.localizedString(key: LocalizationKey.General_Cancel), style: .plain, target: self, action: #selector(self.dataCancelClick))
    cancelButton.tintColor = UIColor.flatBlack
    doneButton.tintColor = UIColor.flatBlack
    cancelButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.flatBlack], for: .normal)
    doneButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.flatBlack], for: .normal)
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    dateTextField.inputAccessoryView = toolBar

  }

  //****************************************************************************
  //
  //       Nome: dataToolbarDoneClick
  //  Descrição: Botão para capturar seleção do dateTextField
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  @objc func dataToolbarDoneClick()
  {
    if let date = m_dDataTemp
      {
      m_date = date
        dateTextField.text = Common.dateToStringFormat(date: date, watchlistFormat: false, asset: m_selectedAsset)
    }
    dateTextField.endEditing(true)
  }

  //****************************************************************************
  //
  //       Nome: dataCancelClick
  //  Descrição: Botão para cancelar a seleção do dateTextField
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  @objc func dataCancelClick()
  {
    dateTextField.resignFirstResponder()
  }

  //****************************************************************************
  //
  //       Nome: datePickerValueChanged
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  @objc private func datePickerValueChanged(sender: UIDatePicker)
  {
    m_dDataTemp = sender.date
  }

  //******************************************************************************
  //
  // Nome:      loadValidyPickerData
  // Descrição:
  //
  // Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             05/04/2019  v1.3.56  Luís Felipe Polo
  //             - Teste se bolsa é Bovespa ou BMF incluindo bolsas de replay
  //
  //******************************************************************************
  private func loadValidyPickerData()
  {
    if let broker = Application.m_application.m_brkSelectedBroker, let aidAssetID = m_selectedAsset {
      if ExchangeManager.shared.isBovespa(a_nExchange: aidAssetID.m_nMarket.kotlin) {
        m_validityPickerData = broker.arTimeInForceBovespa
      } else if ExchangeManager.shared.isBMF(a_nExchange: aidAssetID.m_nMarket.kotlin) {
        m_validityPickerData = broker.arTimeInForceBMF
      } else {
        m_validityPickerData = broker.arTimeInForceOthers
      }
    }
  }
  
  private func setupScheduleDatePicker()
  {
    let datePickerView = UIDatePicker()
    datePickerView.datePickerMode = .date
    if #available(iOS 14, *) {
      datePickerView.preferredDatePickerStyle = .wheels
    }
    datePickerView.addTarget(self,
      action: #selector(scheduleDatePickerValueChanged(sender:)),
      for: .valueChanged)
    scheduleTextField.inputView = datePickerView

//    let dateRange: ClosedRange<Date> = Common.getValidScheduleDates(asset: currentAssetID)
//
//    datePickerView.minimumDate = dateRange.lowerBound
//    datePickerView.maximumDate = dateRange.upperBound
    
    // ToolBar
    let toolBar = UIToolbar()
    toolBar.barTintColor = Colors.clPickerToolbar
    toolBar.sizeToFit()
    let doneButton = UIBarButtonItem(title: Localization.localizedString(key: LocalizationKey.General_Done), style: .plain, target: self, action: #selector(self.scheduleToolbarDoneClick))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: Localization.localizedString(key: LocalizationKey.General_Cancel), style: .plain, target: self, action: #selector(self.scheduleCancelClick))
    cancelButton.tintColor = UIColor.flatBlack
    doneButton.tintColor = UIColor.flatBlack
    cancelButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.flatBlack], for: .normal)
    doneButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.flatBlack], for: .normal)
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    scheduleTextField.inputAccessoryView = toolBar

  }

  @objc func scheduleToolbarDoneClick()
  {
    if let date = m_dScheduleDateTemp
      {
      m_scheduleDate = date
      scheduleTextField.text = Common.dateToStringFormat(date: date, watchlistFormat: false, asset: m_selectedAsset)
    }
    scheduleTextField.endEditing(true)
  }

  @objc func scheduleCancelClick()
  {
    scheduleTextField.resignFirstResponder()
  }

  @objc private func scheduleDatePickerValueChanged(sender: UIDatePicker)
  {
    m_dScheduleDateTemp = sender.date
  }

  //******************************************************************************
  //
  // Nome:      Buttons para expandir as view
  // Descrição:
  //
  // Criação:
  // Modificado: 19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             20/03/2019 v1.3.54 Eduardo Varela Ribeiro
  //             - Correção crash BTG
  //******************************************************************************
  @IBAction func headerPositionButton(_ sender: Any)
  {
    if posHeightCons.constant == 32
      {
      posHeightCons.constant = 215
      posContentView.isHidden = false
    }
    else
    {
      posHeightCons.constant = 32
      posContentView.isHidden = true
      
      self.navigationController?.setNavigationBarHidden(false, animated: true)
      if Common.showAccountView() {
        showSelector()
      }
    }
    
    headerPositionView.changeImage()
  }

  @IBAction func headerOrderListButton(_ sender: Any)
  {
    label = UILabel(frame: CGRect(x: orderListView.frame.width / 2 - 180,
      y: orderListView.frame.height / 2,
      width: 350,
      height: 32))
    label.text = Localization.localizedString(key: LocalizationKey.OrderList_NoOrderFound)
    label.textAlignment = .center
    label.textColor = Colors.primaryFontColor
    label.font = UIFont.preferredFont(forTextStyle: .headline)

    if let views = orderListTableView.tableFooterView?.subviews
      {
      for view in views
      {
        view.removeFromSuperview()
      }
    }
    if orderHeightCons.constant == 32
      {
      if orderList.count != 0
        {
        orderHeightCons.constant = CGFloat(orderList.count) * OrderListTableViewCell.height() + 35
          orderListTableView.isHidden = !Application.m_application.m_userProduct.HasBoletaOrderList()
      }
      else
      {
        orderListTableView.isHidden = !Application.m_application.m_userProduct.HasBoletaOrderList()
        orderHeightCons.constant = 90
        let view = UIView(frame: orderListTableView.frame)
        view.addSubview(label)
        orderListTableView.tableFooterView = view

      }
    }
    else
    {
      orderHeightCons.constant = 32
      orderListTableView.isHidden = true
      self.orderListTableView.tableFooterView = UIView()
      
      self.navigationController?.setNavigationBarHidden(false, animated: true)
      if Common.showAccountView() {
        showSelector()
      }
    }
    
    headerOrderListView.changeImage()
    orderListTableView.reloadData()
  }

  //****************************************************************************
  //
  //       Nome: headerPriceBookButton
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             13/02/2018  v1.3.42  Luís Felipe Polo
  //             - Máscara para o campo de preço da boleta
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             22/04/2019  v1.3.62  Guilherme Cardoso Soares
  //             - Definir plataforma conforme tamanho de tela: Ajustes para iPad
  //****************************************************************************
  func subscribePriceBook(_ assetID: AssetIdentifier) {
    if let stock = Application.m_application.m_dicStocks[assetID.getKey()]
      {
      m_arBuyOffers = stock.priceBook.groupedBuyOffers
      m_arSellOffers = stock.priceBook.groupedSellOffers

      let assetInfo = app.getAssetInfo(assetID)
      
      //m_nFloatDigits = assetInfo.nFloatDigits
      if let minIncrement = assetInfo.sMinPriceIncrement
      {
        m_sMinIncrement = minIncrement
      }

      stock.addExtraSubscription(self, extra: .PriceBook)
    }
  }
  
  func unsubscribePriceBook() {
    if let assetID = m_selectedAsset, let stock = app.m_dicStocks[assetID.getKey()] {
      stock.removeExtraSubscription(self, extra: .PriceBook)
    }    
  }
  
  @IBAction func headerPriceBookButton(_ sender: Any)
  {
    if priceHeightCons.constant == 32 {
      if let assetID = m_selectedAsset {
        subscribePriceBook(assetID)
      }

      // Seta constraints e exibe views
      priceHeightCons.constant = 285 * (UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1)
      headerView.isHidden = false
      offersTableView.isHidden = !Application.m_application.m_userProduct.HasBoletaPriceBook()
    }
    else
    {
      unsubscribePriceBook()

      // Seta constraints e esconde views
      priceHeightCons.constant = 32
      headerView.isHidden = true
      offersTableView.isHidden = true
      
      self.navigationController?.setNavigationBarHidden(false, animated: true)
      if Common.showAccountView() {
        showSelector()
      }
    }
    
    headerPriceBookView.changeImage()
  }

  //****************************************************************************
  //
  //       Nome: qtyStepperValueChanged
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             10/10/2018  v1.3.14  Luís Felipe Polo
  //             - Mantém mesma quantidade nas boletas day trade e de compra e venda
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             28/02/2019  v1.3.48  Guilherme Cardoso Soares
  //             - Crashes na BoletaViewController
  //             11/03/2019  v1.3.52  Guilherme Cardoso Soares
  //             - Incremento e decremento do stepper devem ir para o próximo valor válido (e não variar conforme o lote/incremento)
  //****************************************************************************
  @IBAction func qtyStepperValueChanged(_ sender: ProfitStepper)
  {
    self.qtyStepperValueChangedDayTrade(sender)
    
  }

  //****************************************************************************
  //
  //       Nome: qtyStepperValueChangedDayTrade
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6   Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             10/10/2018  v1.3.14  Luís Felipe Polo
  //             - Mantém mesma quantidade nas boletas day trade e de compra e venda
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             28/02/2019  v1.3.48  Guilherme Cardoso Soares
  //             - Crashes na BoletaViewController
  //             11/03/2019  v1.3.52  Guilherme Cardoso Soares
  //             - Incremento e decremento do stepper devem ir para o próximo valor válido (e não variar conforme o lote/incremento)
  //****************************************************************************
  func qtyStepperValueChangedDayTrade(_ sender: ProfitStepper)
  {
    if let assetID = m_selectedAsset, let info = app.m_dicAssetInfo[assetID.getKey()] {
      guard let qtyValue = Double(qtyTextField.text ?? ""), Common.canConvertDoubleToInt(qtyValue) else {
        return
      }
      let lote = Double(info.nLote ?? 1)
      let isReplay = ExchangeManager.shared.isItReplayMarket(nExchange: info.m_aidAssetId.m_nMarket.kotlin)
      if sender.value > m_quantity {
        if app.handlesFractionary(), Common.convertDoubleToInt(qtyValue) == info.nMaxOrderQtd, info.hasFractionary(), info.isFractionary(), isReplay == false, isChosenAssetFractionary == false  {
          changeAssetToNonFractionary(assetInfo: info)
        } else {
          let newQuantity = m_quantity + lote
          if info.isValidQtd(a_nQtd: Common.convertDoubleToInt(newQuantity)) {
            m_quantity = newQuantity
          } else {
            m_quantity = info.goToNextValidQtd(a_nQtd: Int(newQuantity))
          }
        }
      } else if sender.value < m_quantity {
        if app.handlesFractionary(), Common.convertDoubleToInt(qtyValue) == info.nMinOrderQtd, info.hasFractionary(), !info.isFractionary(), isReplay == false, isChosenAssetFractionary == false {
            if let fracInfo = info.getFractionaryAssetInfo() {
              let newQtd = fracInfo.nMaxOrderQtd ?? AssetInfo.bDefaultFractionaryMaxOrderQtd
              changeAssetToFractionary(assetInfo: info)
              m_quantity = Double(newQtd)
            } else {
              app.m_hbMsgManager.sendSubscribeInfo(a_strTicker: info.getFractionaryTicker(), a_nMarket: assetID.m_nMarket)
            }
          } else {
            let newQuantity = m_quantity - lote
            let newQtdAsInt = max(newQuantity , Double(info.nMinOrderQtd ?? 1))
            if info.isValidQtd(a_nQtd: Common.convertDoubleToInt(newQuantity)) {
              m_quantity = Double(newQtdAsInt)
            } else {
              m_quantity = info.goToPreviousValidQtd(a_nQtd: Int(newQuantity))
            }
          }
      } else {
        sender.value = sender.oldValue
      }
      let newQtd = Common.convertDoubleToInt(m_quantity)
      qtyStepper.value = m_quantity
      dayTradeXibView?.qtyStepper.value = m_quantity
      qtyTextField.text = String(newQtd)
      dayTradeXibView?.qtyTextField.text = String(newQtd)
    }
    totalLabel.text = calcTotal()
  }
  
  @IBAction func stopOffsetTextFieldValueChanged(_ sender: UITextField) {
    if let strPrice = Double(Common.formatNumericalInput(a_strInput: sender.text!)) {
      stopOffsetStepper.value = strPrice
    }
  }

  //****************************************************************************
  //
  //       Nome: qtyTextFieldValueChangedDayTrade
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             28/02/2019  v1.3.48  Guilherme Cardoso Soares
  //             - Crashes na BoletaViewController
  //****************************************************************************
  func qtyTextFieldValueChangedDayTrade(_ sender: UITextField)
  {
    guard let asset = m_selectedAsset, let stock = app.m_dicStocks[asset.getKey()] else {
      return
    }
    guard let _ = sender.text, let oldValue = qtyTextField.text  else
    {
      return
    }
    
    if Common.updateQtyTextField(sender, stock: stock, changeAssetToNonFractionaryClosure: changeAssetToNonFractionary, changeAssetToFractionaryClosure: changeAssetToFractionary, canChangeAsset: isChosenAssetFractionary == false) {
    } else {
      let value = Double(Common.formatQtdInput(value: oldValue, forAsset: asset))
      sender.text = String(value)
      
      Common.updateQtyTextField(sender, stock: stock, changeAssetToNonFractionaryClosure: changeAssetToNonFractionary, changeAssetToFractionaryClosure: changeAssetToFractionary, canChangeAsset: isChosenAssetFractionary == false)
    }
    m_quantity = Double(Common.formatQtdInput(value: sender.text ?? "", forAsset: asset))
    
    let newQtd = Common.convertDoubleToInt(m_quantity)
    qtyStepper.value = m_quantity
    dayTradeXibView?.qtyStepper.value = m_quantity
    qtyTextField.text = String(newQtd)
    dayTradeXibView?.qtyTextField.text = String(newQtd)

    totalLabel.text = calcTotal()
  }
  
  @IBAction func qtyTextFieldValueEditingDidEndAction(_ sender: UITextField) {
    qtyTextFieldValueEditingDidEnd(sender)
  }
  
  func qtyTextFieldValueEditingDidEnd(_ sender: UITextField) {
    guard let asset = m_selectedAsset, let stock = app.m_dicStocks[asset.getKey()] else {
      return
    }
    
    if Common.updateQtyTextFieldAfterEditingEnd(sender, stock: stock) {
      m_quantity = Double(Common.formatQtdInput(value: sender.text ?? "", forAsset: asset))
      qtyStepper.value = m_quantity
      dayTradeXibView?.qtyStepper.value = m_quantity
      
      let newQty = Common.convertDoubleToInt(m_quantity)
      qtyTextField.text = String(newQty)
      dayTradeXibView?.qtyTextField.text = String(newQty)

      totalLabel.text = calcTotal()
    }
  }

  func calculateSelectedText(sender: UITextField, selectedRange: UITextRange, amountString: String) {
    let textSize = sender.text?.count ?? 0
    sender.text = amountString
    if let newPosition = sender.position(from: selectedRange.start, offset: ((sender.text?.count ?? 0) - textSize)) {
      sender.selectedTextRange = sender.textRange(from: newPosition, to: newPosition)
    }
  }
  
  //****************************************************************************
  //
  //       Nome: qtyTextFieldValueChanged
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             28/02/2019  v1.3.48  Guilherme Cardoso Soares
  //             - Crashes na BoletaViewController
  //             06/03/2019  v1.3.52  Guilherme Cardoso Soares
  //             - Nova classe de Logs
  //****************************************************************************
  @IBAction func qtyTextFieldValueChanged(_ sender: UITextField)
  {
    self.qtyTextFieldValueChangedDayTrade(sender)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool
  {
    priceTextField.resignFirstResponder()
    stopOffsetTextField.resignFirstResponder()
    return true
  }
  
  @IBAction func icebergStepperValueChanged(_ sender: ProfitStepper) {
    guard let assetInfo = m_selectedAssetInfo else {
      sender.value = m_iceberg
      return
    }
    let icebergMin = Double(assetInfo.getIcebergMinQty())
    
    if m_quantity <= icebergMin {
      m_iceberg = 0
      sender.value = m_iceberg
      icebergTextField.text = "\(Common.convertDoubleToInt(m_iceberg))"
      return
    }
    
    if sender.value >= m_quantity {
      sender.value = m_iceberg
      icebergTextField.text = "\(Common.convertDoubleToInt(m_iceberg))"
      return
    }
    
    if sender.value > m_iceberg {
      if sender.value < icebergMin {
        m_iceberg = icebergMin
        sender.value = m_iceberg
      } else {
        m_iceberg = sender.value
      }
    } else {
      if sender.value < icebergMin {
        m_iceberg = 0
        sender.value = m_iceberg
      } else {
        m_iceberg = sender.value
      }
    }
    icebergTextField.text = "\(Common.convertDoubleToInt(m_iceberg))"
  }
  
  @IBAction func icebergTextFieldValueChanged(_ sender: UITextField) {
    guard let icebergTextFieldStr = sender.text else {
      return
    }
    guard let assetInfo = m_selectedAssetInfo else {
      return
    }
    
    let icebergTextFieldValue = Common.formatQtdInput(value: icebergTextFieldStr, forAsset: assetInfo.m_aidAssetId)
    let icebergMin = assetInfo.getIcebergMinQty()
    if icebergTextFieldValue >= icebergMin && icebergTextFieldValue < Int(m_quantity) {
      m_iceberg = Double(icebergTextFieldValue)
    } else {
      m_iceberg = 0
      sender.text = Common.formatQtyToString(value: Int(m_iceberg), forAsset: assetInfo.m_aidAssetId, makeShort: false)
    }
    icebergStepper.value = m_iceberg
  }

  //****************************************************************************
  //
  //       Nome: priceTextFieldValueChanged
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  @IBAction func priceTextFieldValueChanged(_ sender: UITextField)
  {
    if let asset = m_selectedAsset, let selectedRange = sender.selectedTextRange, let amountString = sender.text?.currencyInputFormatting(app.m_dicAssetInfo[asset.getKey()]?.nDigitsPrice ?? app.m_dicAssetInfo[asset.getKey()]?.nFloatDigits ?? 2) {
      calculateSelectedText(sender: sender, selectedRange: selectedRange, amountString: amountString)
      if let strPrice = Double(Common.formatNumericalInput(a_strInput: sender.text!)){
        priceStepper.value = strPrice
      }
    }
    totalLabel.text = calcTotal()
  }
  
  @IBAction func stopOffsetTextFieldChanged(_ sender: UITextField) {
    if let amountString = sender.text?.currencyInputFormatting(m_nFloatDigits) {
        sender.text = amountString
        stopOffsetStepper.value = Double(Common.formatNumericalInput(a_strInput: amountString)) ?? 0
    }
  }
  
  
  @IBAction func stopOffsetStepperValueChanged(_ sender: ProfitStepper) {
    if let assetID = m_selectedAsset, let info = app.m_dicAssetInfo[assetID.getKey()] {
      
      if sender.isUp {
        sender.value = info.goToNextValidPrice(a_sPrice: sender.value)
      } else if sender.isDown {
        sender.value = info.goToPreviousValidPrice(a_sPrice: sender.value)
      }
      
    } else {
      sender.value = sender.oldValue
    }
    
    stopOffsetTextField.text = formatText(sender.value)
  }
  

  //****************************************************************************
  //
  //       Nome: priceStepperValueChanged
  //  Descrição:
  //
  //    Criação:
  // Modificado: 11/03/2019  v1.3.52  Guilherme Cardoso Soares
  //             - Incremento e decremento do stepper devem ir para o próximo valor válido (e não variar conforme o lote/incremento)
  //****************************************************************************
  @IBAction func priceStepperValueChanged(_ sender: ProfitStepper)
  {
    if let assetID = m_selectedAsset, let info = app.m_dicAssetInfo[assetID.getKey()] {
      
      if sender.isUp {
        sender.value = info.goToNextValidPrice(a_sPrice: sender.value)
      } else if sender.isDown {
        sender.value = info.goToPreviousValidPrice(a_sPrice: sender.value)
      }
      
    } else {
      sender.value = sender.oldValue
    }
    
    priceTextField.text = formatText(sender.value)
    totalLabel.text = calcTotal()
  }

  //****************************************************************************
  //
  //       Nome: dayTradeValueChanged
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  @IBAction func dayTradeValueChanged(_ sender: UISwitch)
  {
    // Alterado o switch da boleta de compra e venda, entao atualiza a variável m_dayTrade e o switch da boleta day trade
    let isCovered: Bool = self.coveredTradeSwitch.isOn
    Application.m_application.m_bSwitchDayTradeMode = sender.isOn
    m_dayTrade = Common.getStrategyType(isDayTrade: sender.isOn, isCovered: isCovered, assetInfo: self.m_selectedAssetInfo)
    dayTradeXibView?.dayTradeSwitch.isOn = sender.isOn
  }
  
  //****************************************************************************
  //
  //       Nome: coveredTradeValueChanged
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  @IBAction func coveredTradeValueChanged(_ sender: UISwitch)
  {
    // Alterado o switch da boleta de compra e venda, entao atualiza a variável m_dayTrade e o switch da boleta coveredTrade
    let isDayTrade: Bool = self.dayTradeSwitch.isOn
    Application.m_application.m_bSwitchCoveredTradeMode = sender.isOn
    m_dayTrade = Common.getStrategyType(isDayTrade: isDayTrade, isCovered: sender.isOn, assetInfo: self.m_selectedAssetInfo)
    dayTradeXibView?.coveredTradeSwitch.isOn = sender.isOn
  }

  //****************************************************************************
  //
  //       Nome: enableDayTrade
  //  Descrição:
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             27/03/2019  v1.3.56  Guilherme Cardoso Soares
  //             - Nova Classe de Logs: Novas informações sendo registradas
  //             05/04/2019  v1.3.56  Luís Felipe Polo
  //             - Teste se bolsa é Bovespa ou BMF incluindo bolsas de replay
  //
  //****************************************************************************
  private func enableBoleta()
  {
    if let broker = Application.m_application.m_brkSelectedBroker
    {
      if ExchangeManager.shared.isBovespa(a_nExchange: m_selectedAsset!.m_nMarket.kotlin)
      {
        strategies = broker.arStrategyTypeBovespa
      }
      else
      {
        strategies = broker.arStrategyTypeBMF
      }
    }

    if !strategies.contains(.stDayTrade) || !Application.m_application.m_userProduct.HasDayTradeSwitchAtBoleta()
      {
      dayTradeXibView?.dayTradeView.isHidden = true
      dayTradeXibView?.dayTradeViewHeightCons.constant = 0
      dayTradeXibView?.dayTradeStepperSpace.constant = Application.m_application.m_userProduct.HasCoveredTradeMode(assetInfo: m_selectedAssetInfo) ? 12 : 0
      dayTradeSwitchView.isHidden = true
      dayTradeHeight.constant = 0
      calculaHeigthConstraint()
    }
    else
    {
      dayTradeXibView?.dayTradeView.isHidden = false
      dayTradeXibView?.dayTradeViewHeightCons.constant = 35
      dayTradeXibView?.dayTradeStepperSpace.constant = 12
      dayTradeSwitchView.isHidden = false
      dayTradeHeight.constant = 41
      calculaHeigthConstraint()
    }
    
    if Application.m_application.m_userProduct.HasCoveredTradeMode(assetInfo: m_selectedAssetInfo) {
      dayTradeXibView?.coveredTradeView.isHidden = false
      dayTradeXibView?.coveredTradeViewHeightCons.constant = 35
      coveredTradeSwitchView.isHidden = false
      coveredTradeHeight.constant = 41
      calculaHeigthConstraint()
    } else {
      dayTradeXibView?.coveredTradeView.isHidden = true
      dayTradeXibView?.coveredTradeViewHeightCons.constant = 0
      coveredTradeSwitchView.isHidden = true
      coveredTradeHeight.constant = 0
      calculaHeigthConstraint()
    }
  }

  private func hideDayTradeTabIfNeeded()
  {
    if Application.m_application.m_userProduct.IsHBOne() {
      dayTradeView.isHidden = true
      tabsBarTrailingDayTrade.isActive = false
      dayTradeLeadingSellViewTrailing.isActive = false
      sellViewTrailingTabsBar.isActive = true
      dayTradeViewWidth.isActive = false
    }
  }
  
  //******************************************************************************
  //
  // Nome:      updateViewOnInfoPropertyChanged
  // Descrição:
  //
  // Criação:
  // Modificado: 24/07/2018  v1.3.6   Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             03/10/2018  v1.3.12  Luís Felipe Polo
  //             - Manter a última quantidade informada pelo usuário na boleta
  //             25/10/2018  v1.3.18  Luís Felipe Polo
  //             - Levar em consideração a data de validade dos ativos
  //             01/11/2018  v1.3.20  Luís Felipe Polo
  //             - Correção ao notificar de validade nula
  //             13/02/2018  v1.3.42  Luís Felipe Polo
  //             - Máscara para o campo de preço da boleta
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //******************************************************************************
  func updateViewOnInfoPropertyChanged(property: AssetInfoProperty,
    value: AnyObject?,
    reference: AnyObject)
  {
    guard let assetInfo = reference as? AssetInfo, assetInfo.m_aidAssetId.getKey() == m_selectedAsset!.getKey() else
      {
      return
    }

    switch property
    {
    case .MaxOrderQtd:
      if !(Application.m_application.handlesFractionary() && assetInfo.isFractionary()) {
        qtyStepper.maximumValue = Double(value as! Int)
        dayTradeXibView?.qtyStepper.maximumValue = Double(value as! Int)
      }
    case .MinOrderQtd:
      if m_quantity == 0
        {
        m_quantity = Double(value as! Int)
        qtyStepper.minimumValue = Double(value as! Int)
        qtyStepper.value = Double(value as! Int)
          qtyTextField.text = Common.formatQtyToString(value: value as! Int, forAsset: m_selectedAsset!, makeShort: false)
        dayTradeXibView?.qtyStepper.minimumValue = Double(value as! Int)
        dayTradeXibView?.qtyStepper.value = Double(value as! Int)
          dayTradeXibView?.qtyTextField.text = Common.formatQtyToString(value: value as! Int, forAsset: m_selectedAsset!, makeShort: false)
        totalLabel.text = calcTotal()
      }
    case .Lote:
      qtyStepper.stepValue = Double(value as! Int)
      dayTradeXibView?.qtyStepper.stepValue = Double(value as! Int)
      icebergStepper.stepValue = Double(value as! Int)
    case .ContractMultiplier:
      totalLabel.text = calcTotal()
      break
    case .MinPriceIncrement:
      if let info = reference as? AssetInfo
        {
        if ExchangeManager.shared.isSaxo(a_nExchange: info.m_aidAssetId.m_nMarket.kotlin), let minIncrement = info.sMinOrderPriceIncrement
         {
           priceStepper.stepValue = info.sMinOrderPriceIncrement ?? minIncrement
           stopOffsetStepper.stepValue = info.sMinOrderPriceIncrement ?? minIncrement
         }
         else if let minIncrement = info.sMinPriceIncrement
         {
           priceStepper.stepValue = info.sMinOrderPriceIncrement ?? minIncrement
           stopOffsetStepper.stepValue = info.sMinOrderPriceIncrement ?? minIncrement
         }
      }
      break
    case .OrderIncrement:
      priceStepper.stepValue = value as! Double
      stopOffsetStepper.stepValue = value as! Double
    case .QtdDefault:
      qtyStepper.value = Double(value as! Int)
      qtyTextField.text = Common.formatQtyToString(value: value as! Int, forAsset: m_selectedAsset!, makeShort: false)
      dayTradeXibView?.qtyStepper.value = Double(value as! Int)
      dayTradeXibView?.qtyTextField.text = Common.formatQtyToString(value: value as! Int, forAsset: m_selectedAsset!, makeShort: false)
    default:
      break
    }

    if let info = reference as? AssetInfo
    {
      let referenceAssetId = Common.getReferenceAssetId(a_aidAssetId: info.m_aidAssetId)
      if referenceAssetId != info.m_aidAssetId, let referenceStock = app.m_dicStocks[referenceAssetId.getKey()]
      {
        referenceStock.addToUpdateList(self, extra: .Quotation)
      }
      
      // Price book
      //m_nFloatDigits = info.nFloatDigits
      if let minIncrement = info.sMinPriceIncrement
      {
        m_sMinIncrement = minIncrement
      }
      offersTableView.reloadData()

      // Atualiza campos de preço com os float digits
      if let price = Double(Common.formatNumericalInput(a_strInput: priceTextField.text!))
      {
        priceTextField.text = formatText(price)
      }

      if let stopOffset = Double(Common.formatNumericalInput(a_strInput: stopOffsetTextField.text!))
      {
        stopOffsetTextField.text = formatText(stopOffset)
      }
      testForAlerts()
    }
  }

  //******************************************************************************
  //
  // Nome:      updateViewOnOrderPropertyChanged
  // Descrição:
  //
  // Criação:
  // Modificado: 05/07/2018  v1.3.4  Luís Felipe Polo
  //             - Passar estrutura de dados de ordem de dicionário para array
  //
  //******************************************************************************
  func updateViewOnOrderPropertyChanged(property: OrderProperty,
    value: AnyObject?,
    reference: AnyObject)
  {
    fetchOrderList()
  }

  //******************************************************************************
  //
  // Nome:     sortOrders
  // Descrição:
  //
  // Criação:
  // Modificado:
  //
  //******************************************************************************
  func sortOrders()
  {
    let arOrdersBeforeSort: [Order] = orderList

    orderList.sort(by: {
      if $0.dtCreationDate == nil {
        return true
      } else if $1.dtCreationDate == nil {
        return false
      } else {
        return $0.dtCreationDate! > $1.dtCreationDate!
      }
    })

    if arOrdersBeforeSort != orderList
      {
      orderListTableView.reloadData()
    }
  }

  //******************************************************************************
  //
  // Nome:     sortOrders
  // Descrição:
  //
  // Criação:
  // Modificado:
  //
  //******************************************************************************
  @objc func NewOrder(note: NSNotification)
  {
    fetchOrderList()
  }

  //******************************************************************************
  //
  //      Nome: fetchOrderList
  // Descrição:
  //
  //    Criação:
  // Modificado: 05/07/2018  v1.3.4  Luís Felipe Polo
  //             - Passar estrutura de dados de ordem de dicionário para array
  //             23/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //             19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //             28/03/2019  v1.3.56  Luís Felipe Polo
  //             - Roteamento para o replay
  //
  //******************************************************************************
  func fetchOrderList()
  {
    var arOrderListAux: [Order] = []
    let backgroundQueue = DispatchQueue(label: "com.profitchart.fetchOderListQueue",
      qos: .background,
      target: nil)

    backgroundQueue.sync {
      if let account = Application.m_application.m_acSelectedAccount
      {
        if let assetInfo = Application.m_application.m_dicAssetInfo[m_selectedAsset!.getKey()] {
          if Application.m_application.handlesFractionary() && assetInfo.hasFractionary() {
            for order in account.GetOrderList(a_aidAssetId: assetInfo.m_aidAssetId) {
              if order.m_aidAssetId == assetInfo.m_aidAssetId {
                if let strategyType: StrategyType = order.stStrategyType, Common.canShowOrderByStrategyType(orderStrategyType: strategyType) {
                  order.addToUpdateList(self)
                  arOrderListAux.append(order)
                }
              }
            }
            if let assetInfoFractionary = assetInfo.getFractionaryAssetInfo() {
              for order in account.GetOrderList(a_aidAssetId: assetInfoFractionary.m_aidAssetId) {
                if order.m_aidAssetId == assetInfoFractionary.m_aidAssetId {
                  if let strategyType: StrategyType = order.stStrategyType, Common.canShowOrderByStrategyType(orderStrategyType: strategyType) {
                    order.addToUpdateList(self)
                    arOrderListAux.append(order)
                  }
                }
              }
            }
            if assetInfo.isFractionary(), fakeFullAsset {
              if let assetInfoNonFractionary = assetInfo.getNonFractionaryAssetInfo() {
                for order in account.GetOrderList(a_aidAssetId: assetInfoNonFractionary.m_aidAssetId) {
                  if order.m_aidAssetId == assetInfoNonFractionary.m_aidAssetId {
                    if let strategyType: StrategyType = order.stStrategyType, Common.canShowOrderByStrategyType(orderStrategyType: strategyType) {
                      order.addToUpdateList(self)
                      arOrderListAux.append(order)
                    }
                  }
                }
              }
            }
          } else {
            for order in account.GetOrderList(a_aidAssetId: m_selectedAsset!)
            {
              if order.m_aidAssetId.getKey() == (m_selectedAsset!.getKey())
              {
                if let strategyType: StrategyType = order.stStrategyType, Common.canShowOrderByStrategyType(orderStrategyType: strategyType) {
                  order.addToUpdateList(self)
                  arOrderListAux.append(order)
                }
              }
            }
          }
        } else {
          for order in account.GetOrderList(a_aidAssetId: m_selectedAsset!)
          {
            if order.m_aidAssetId.getKey() == (m_selectedAsset!.getKey())
            {
              if let strategyType: StrategyType = order.stStrategyType, Common.canShowOrderByStrategyType(orderStrategyType: strategyType) {
                order.addToUpdateList(self)
                arOrderListAux.append(order)
              }
            }
          }
        }
      }
      
      DispatchQueue.main.async {
        self.orderList = arOrderListAux
        self.sortOrders()
        self.orderListTableView.reloadData()
        if let views = self.orderListTableView.tableFooterView?.subviews
          {
          for view in views
          {
            view.removeFromSuperview()
          }
        }

        if self.orderHeightCons.constant > 32
          {
          if self.orderList.count > 0
            {
            self.orderHeightCons.constant = CGFloat(self.orderList.count) * OrderListTableViewCell.height() + 35
            self.orderListTableView.isHidden = !Application.m_application.m_userProduct.HasBoletaOrderList()
            self.orderListTableView.tableFooterView = UIView()
          }
          else
          {
            self.orderListTableView.isHidden = !Application.m_application.m_userProduct.HasBoletaOrderList()
            self.orderHeightCons.constant = 90
            let view = UIView(frame: self.orderListTableView.frame)
            view.addSubview(self.label)
            self.orderListTableView.tableFooterView = view
          }
        }
      }
    }
  }

  //****************************************************************************
  //
  //       Nome: updateViewOnPropertyChanged
  //  Descrição: atualiza livro de preços exibidos na interface
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  func updateViewOnPropertyChanged(property: PriceBookProperty,
    value: AnyObject,
    reference: AnyObject)
  {
    if property == .arBuyOffers {
      m_arBuyOffers = value as! [PriceBookOffer]
    }
    else if property == .arSellOffers {
      m_arSellOffers = value as! [PriceBookOffer]
    }
    offersTableView.optimizedReloadData()

    if let asset = m_selectedAsset {
      let info = app.getAssetInfo(asset)
      if app.handlesFractionary(), info.hasFractionary(), info.isFractionary() {
        self.updateTickerButton(a_strTicker: info.getFractionaryAssetId().getKey())
      } else {
        self.updateTickerButton(a_strTicker: asset.getKey())
      }
    }
  }
  
  @objc override func updateViewRightBarButtons(){
    if let asset = m_selectedAsset {
      self.updateTickerButton(a_strTicker: asset.getKey())
      testForAlerts()
    }
  }
  
  //****************************************************************************
  //
  //       Nome: checkIfAccountChanged
  //  Descrição: limpa os filtros caso a conta selecionada tenha mudado
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  func checkIfAccountChanged()
  {
    if m_acPreviousAccount == nil
      {
      if let selectedAccount = Application.m_application.m_acSelectedAccount
        {
        m_acPreviousAccount = selectedAccount
      }
    }
    else
    {
      if m_acPreviousAccount != Application.m_application.m_acSelectedAccount
        {
        m_acPreviousAccount = Application.m_application.m_acSelectedAccount
      }
    }
  }

  //****************************************************************************
  //
  //       Nome: dayTradeXibValueChanged
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
//****************************************************************************
  func dayTradeXibValueChanged(_ sender: UISwitch)
  {
    let isCovered: Bool = self.dayTradeXibView?.coveredTradeSwitch.isOn ?? false
    Application.m_application.m_bSwitchDayTradeMode = sender.isOn
    m_dayTrade = Common.getStrategyType(isDayTrade: sender.isOn, isCovered: isCovered, assetInfo: self.m_selectedAssetInfo)
    self.dayTradeSwitch.isOn = sender.isOn
  }
  
  //****************************************************************************
  //
  //       Nome: coveredTradeXibValueChanged
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
//****************************************************************************
  func coveredTradeXibValueChanged(_ sender: UISwitch)
  {
    let isDayTrade: Bool = self.dayTradeXibView?.dayTradeSwitch.isOn ?? false
    Application.m_application.m_bSwitchCoveredTradeMode = sender.isOn
    m_dayTrade = Common.getStrategyType(isDayTrade: isDayTrade, isCovered: sender.isOn, assetInfo: self.m_selectedAssetInfo)
    self.coveredTradeSwitch.isOn = sender.isOn
  }

  //****************************************************************************
  //
  //       Nome: handleSwipe
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
    switch gesture.direction {
    case UISwipeGestureRecognizer.Direction.left:
      Common.print("left swipe")
      if m_sendType == .bossell && !app.m_userProduct.IsHBOne()
      {
        tapDayTradeView(sender: dayTradeView)
      }
      else
      {
        tapSellView(sender: contentView)
      }
    case UISwipeGestureRecognizer.Direction.right:
      Common.print("right swipe")
      if m_sendType == .bossell
      {
        tapBuyView(sender: contentView)
      }
      else if !app.m_userProduct.IsHBOne()
      {
        tapDayTradeView(sender: dayTradeView)
      }
    default:
      break
    }
  }
  // MARK: - Hide Navigation Bar with swipe implementation
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.hideOrShowNavigationBar(scrollView, hideSelector: hideSelector, showSelector: showSelector)
  }
  
  func hideSelector() {
    if Common.showAccountView() {
      UIView.animate(withDuration: 0.3){
        self.xibAccountView.isHidden = true
      }
    }
  }
  
  func showSelector() {
    if Common.showAccountView() {
      UIView.animate(withDuration: 0.3){
        self.xibAccountView.isHidden = false
      }
    }
  }
  //FIM DA VIEW CONTROLLER
}


// MARK: - DELEGATES AND DATASOURCES
extension OldBoletaViewController: UIPopoverPresentationControllerDelegate
{

  func adaptivePresentationStyle(for controller: UIPresentationController,
    traitCollection: UITraitCollection) -> UIModalPresentationStyle
  {
    return UIModalPresentationStyle.none
  }

  func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController)
  {
    //selectedOrder = nil
  }

}

extension OldBoletaViewController: OptionsViewControllerProtocol
{
  func actionForSelected(option: Option)
  {
    dismiss(animated: true)
    {
      switch option
      {

      default:
        break
      }
    }
  }
}

extension OldBoletaViewController: UIPickerViewDelegate
{

  //****************************************************************************
  //
  //       Nome: pickerView (...didSelectRow...)
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  func pickerView(_ pickerView: UIPickerView,
    didSelectRow row: Int,
    inComponent component: Int)
  {

    if pickerView.tag == 1
      {
      // Validity
      if m_validityPickerData.count > 0
        {
        m_vtValidityPickerDataTemp = m_validityPickerData[row]
      }
      else {
        m_vtValidityPickerDataTemp = nil
      }
    }

    if pickerView.tag == 2
      {
      // Type
      m_otOrderTypeTemp = m_orderTypePickerData[row]
    }
  }

}

// MARK: - UIPickerViewDataSource
extension OldBoletaViewController: UIPickerViewDataSource
{
  //****************************************************************************
  //
  //       Nome: numberOfComponents
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  func numberOfComponents(in pickerView: UIPickerView) -> Int
  {
    return 1
  }

  //****************************************************************************
  //
  //       Nome: pickerView (... numberOfRowsInComponent ...)
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  func pickerView(_ pickerView: UIPickerView,
    numberOfRowsInComponent component: Int) -> Int
  {

    if pickerView.tag == 2
      {
      return m_orderTypePickerData.count
    }

    return m_validityPickerData.count
  }

  //****************************************************************************
  //
  //       Nome: pickerView (... titleForRow ...)
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  func pickerView(_ pickerView: UIPickerView,
    titleForRow row: Int,
    forComponent component: Int) -> String?
  {

    if pickerView.tag == 2
      {
      return m_orderTypePickerData[row].description()
    }

    return m_validityPickerData[row].description()
  }
  
  //****************************************************************************
  //
  //       Nome: editOrder
  //  Descrição:
  //
  //    Criação:
  // Modificado:  28/02/2019  v1.3.48 Guilherme Cardoso Soares
  //              - Crash OrderListViewController.editOrder
  //             06/03/2019  v1.3.52  Guilherme Cardoso Soares
  //             - Nova classe de Logs
  //             23/04/2019 v1.3.60 Eduardo Varela Ribeiro
  //             - Edição de ordem na lista de ordens
  //
  //****************************************************************************
  func editOrder(a_orOrder: Order?)
  {
    if let order = a_orOrder
      {
      if order.dtCloseDate == nil
      {
        performSegue(withIdentifier: "showOrderChangeFromList", sender: self)
      }
    }
  }

  // MARK: - Side Functions
  //****************************************************************************
  //
  //       Nome: resendOrder
  //  Descrição:
  //
  //    Criação:
  // Modificado: 22/04/2019  v1.3.58 Eduardo Varela Ribeiro
  //             - AlertView Customizado
  //
  //****************************************************************************
  func resendOrder(a_orOrder: Order)
  {
    Nelogger.shared.log("OldBoletaViewController.resendOrder - User Pressed: Resend")
    let validateResult = a_orOrder.ValidateOrder(
      a_sQuotation: a_orOrder.sPrice,
      a_sPrice: a_orOrder.sPrice,
      a_nQty: a_orOrder.nQty,
      a_userDefinedTotal: a_orOrder.userDefinedTotal,
      a_sStopPrice: a_orOrder.sStopPrice
    )
    
    if validateResult.status == SendOrderStatus.NoPassword
    {
      self.showPasswordView(callback: { self.resendOrder(a_orOrder: a_orOrder) })
    }
    else if validateResult.status == SendOrderStatus.Success
    {
      if Application.m_application.m_dicDefaultConfirm["ConfirmResend"]!
      {
        self.showConfirmationAlert(
          strTitle: Localization.localizedString(key: LocalizationKey.Boleta_NewOrder),
          strMessage:  a_orOrder.confirmNewOrderMessage(),
          confirmationKey: "ConfirmResend",
          action: {
            Nelogger.shared.log("Reenviar Ordem: \(self.contextForOrderLog(a_orOrder))")
            let result = a_orOrder.resendOrder(a_osOrderSource: OrderSourceType.orderlist)

            if result.status == SendOrderStatus.NoPassword
            {
              self.showPasswordView(callback: { self.resendOrder(a_orOrder: a_orOrder) })
            }
            else if result.status != SendOrderStatus.Success
            {
              self.showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.Boleta_OrderNotSent), a_strMessage: result.description())
            }
          },
          cancelAction: {
            Nelogger.shared.log("Cancelou Reenviar Ordem: \(self.contextForOrderLog(a_orOrder))")
          }
        )
      }
      else
      {
        Nelogger.shared.log("Reenviar Ordem: \(contextForOrderLog(a_orOrder))")
        let sendResult = a_orOrder.resendOrder(a_osOrderSource: OrderSourceType.orderlist)
        if sendResult.status != SendOrderStatus.Success
        {
          showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.Boleta_OrderNotSent), a_strMessage: sendResult.description())
        }
      }
    }
    else
    {
      showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.Boleta_OrderNotSent), a_strMessage: validateResult.description())
    }
  }
  
}


// MARK: - UIUITableViewDelegate
extension OldBoletaViewController: UITableViewDelegate
{
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    if tableView == orderListTableView
      {
      return OrderListTableViewCell.height()
    }
    return 44
  }

  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
  {
    if tableView == orderListTableView
      {
      return Localization.localizedString(key: LocalizationKey.OrderList_CancelOrderSwipe)
    }
    return ""
  }

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
  {
    if tableView == orderListTableView
      {
      return .delete
    }
    return .none
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
  {
    if tableView == orderListTableView
      {
      if editingStyle == .delete
        {
        cancelOrder(a_orOrder: orderList[indexPath.row])
        selectedOrder = nil
        orderListTableView.reloadData()
      }
    }
  }
  //****************************************************************************
  //
  //       Nome: cancelOrder
  //  Descrição:
  //
  //    Criação:
  // Modificado: 22/04/2019  v1.3.58 Eduardo Varela Ribeiro
  //             - AlertView Customizado
  //
  //****************************************************************************
  func cancelOrder(a_orOrder: Order) {
    Nelogger.shared.log("OldBoletaViewController.cancelOrder - User Pressed: Cancel")
    let result = a_orOrder.ValidateCancel()
    if result == SendOrderStatus.NoPassword {
      self.showPasswordView(callback: { self.cancelOrder(a_orOrder: a_orOrder) })
    } else if result == SendOrderStatus.Success {
      if Application.m_application.m_dicDefaultConfirm["ConfirmCancel"]! {
          self.showConfirmationAlert(
            strTitle: Localization.localizedString(key: LocalizationKey.Boleta_OperationConfirmation),
            strMessage: NSMutableAttributedString(string: Localization.localizedString(key: LocalizationKey.Boleta_CancelOrder) + "?"),
            confirmationKey: "ConfirmCancel",
            action: {
              let result = a_orOrder.ValidateCancel()
              if result == SendOrderStatus.Success {
                Nelogger.shared.log("Cancelar Ordem: \(self.contextForOrderLog(a_orOrder))")
                _ = a_orOrder.cancelOrder(a_osOrderSource: OrderSourceType.boleta)
              } else {
                self.showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: result.description())
              }
            },
            cancelAction: {
              Nelogger.shared.log("Cancelou Cancelar Ordem: \(self.contextForOrderLog(a_orOrder))")
            }
          )
      } else {
        Nelogger.shared.log("Cancelar Ordem: \(self.contextForOrderLog(a_orOrder))")
        _ = a_orOrder.cancelOrder(a_osOrderSource: OrderSourceType.boleta)
      }

    } else {
      Nelogger.shared.log("OldBoletaViewController.cancelOrder - Cancelamento não é possível - Resultado da validação: \(result.description()) - Contexto: \(self.contextForOrderLog(a_orOrder))")
      showAlert(a_strTitle: Localization.localizedString(key: LocalizationKey.General_Error), a_strMessage: result.description())
    }
  }
}

// MARK: - UITableViewDataSource
extension OldBoletaViewController: UITableViewDataSource
{
  //****************************************************************************
  //
  //       Nome: tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
  //  Descrição: monta tableviews com ordens do ativo e livro de preços
  //
  //    Criação:
  // Modificado: 24/07/2018  v1.3.6  Luís Felipe Polo
  //             - Usar AssetId como identificador de ativos
  //
  //****************************************************************************
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    if tableView == orderListTableView
    {
      var floatDigits = 2
      let order = orderList[indexPath.row]
      
      let info = Application.m_application.getAssetInfo(order.m_aidAssetId)
      info.addToUpdateList(self)
      floatDigits = info.nDigitsPrice ?? info.nFloatDigits  
      
      if let cell = tableView.dequeueReusableCell(withIdentifier: OrderListTableViewCell.identifier) as? OrderListTableViewCell {
        cell.m_orderListViewController = nil
        cell.m_orderEntryViewController = self
        cell.nFloatDigits = floatDigits
        cell.setData(orderList[indexPath.row])
        cell.adjustWalletLabel(walletId: nil, shouldHideLabel: true)
        
        // formata células para portrait ou landscape
        if(UIScreen.main.bounds.width < UIScreen.main.bounds.height) {
          cell.enterPortrait()
        } else {
          cell.enterLandscape()
        }
        
        return cell
      }
    }
    else if tableView == offersTableView {
      let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PriceBookTableViewCell
      guard let priceBookAssetID = m_selectedAsset else {
        return cell
      }
      
      if let buyPriceBookOffer = m_arBuyOffers[safe: indexPath.row] {
        addQtyBarLayer(cell: cell.buyView, a_nQty: buyPriceBookOffer.quantity, a_sdSide: .bosbuy)
        cell.setBuyPriceAndQuantityOffer(price: Common.formatStringfrom(value: buyPriceBookOffer.price, minDigits: m_nFloatDigits, maxDigits: m_nFloatDigits) , quantity: Common.formatQtyToString(value: buyPriceBookOffer.quantity, forAsset:priceBookAssetID , makeShort: true))
      }
      else {
        addQtyBarLayer(cell: cell.buyView, a_nQty: 0, a_sdSide: .bosbuy)
      }
      if let sellPriceBookOffer = m_arSellOffers[safe: indexPath.row] {
        addQtyBarLayer(cell: cell.sellView, a_nQty: sellPriceBookOffer.quantity, a_sdSide: .bossell)
        cell.setSellPriceAndQuantityOffer(price: Common.formatStringfrom(value: sellPriceBookOffer.price, minDigits: m_nFloatDigits, maxDigits: m_nFloatDigits) , quantity: Common.formatQtyToString(value: sellPriceBookOffer.quantity, forAsset:priceBookAssetID , makeShort: true))
      }
      else {
        addQtyBarLayer(cell: cell.sellView, a_nQty: 0, a_sdSide: .bossell)
      }
      return cell
    }
    return UITableViewCell()
  }

  //****************************************************************************
  //
  //       Nome: tableView
  //  Descrição: Retorna o número de linhas da seção passada por parâmetro
  //             pertencente a table view.
  //
  //    Criação:
  // Modificado: 22/04/2019  v1.3.62  Guilherme Cardoso Soares
  //             - Definir plataforma conforme tamanho de tela: Ajustes para iPad
  //****************************************************************************
  func tableView(_ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    if tableView == offersTableView {
      if max(m_arBuyOffers.count, m_arSellOffers.count) > (UIDevice.current.userInterfaceIdiom == .pad ? 10 : 5) {
        return (UIDevice.current.userInterfaceIdiom == .pad ? 10 : 5)
      }
      else {
        return max(m_arBuyOffers.count, m_arSellOffers.count)
      }
    }
    return orderList.count
  }

  //****************************************************************************
  //
  //       Nome: addQtyBarLayer
  //  Descrição: desenha barra referente à quantidade
  //
  //    Criação:
  // Modificado: 17/01/2019  v1.3.36  Luís Felipe Polo
  //             - Crash no desenho das barras do livro de preços da boleta
  //             04/02/2019  v1.3.42  Guilherme Cardoso Soares
  //             - Novo crash no desenho das barras do livro de preços da boleta (NaN)
  //             14/02/2019  v1.3.44  Luís Felipe Polo
  //             - Novo tratamento para o crash das barras do livro de preços
  //
  //****************************************************************************
  func addQtyBarLayer(cell: UIView, a_nQty: Int, a_sdSide: Side)
  {
    guard let priceBookAssetID = m_selectedAsset, let priceBook = Application.m_application.m_dicStocks[priceBookAssetID.getKey()]?.priceBook else{
      return
    }
    
    if priceBook.nMaxQtd <= 0 {
      return
    }
    
    let relativeQtd = CGFloat(a_nQty) / CGFloat(priceBook.nMaxQtd)
    let barWidth = relativeQtd * cell.bounds.width
    let subLayer: CALayer = CALayer()

    if a_sdSide == .bossell
      {

      if cell.bounds.minX.isNaN || cell.bounds.minY.isNaN || barWidth.isNaN || cell.bounds.height.isNaN || barWidth.isInfinite
        {
        return
      }

      //subLayer.colors = Colors.sellQtyBarColors
      subLayer.backgroundColor = Colors.clPriceBookSellQtyBar.cgColor
      subLayer.frame = CGRect(x: cell.bounds.minX, y: cell.bounds.minY, width: barWidth, height: cell.bounds.height-2)
      subLayer.addBorder(edge: .left, color: Colors.clPriceBookSellBackground , thickness: 2)
      if #available(iOS 11.0, *) {
        subLayer.cornerRadius = 5
        subLayer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
      } else {
      }
    }
    else
    {
      if cell.bounds.maxX.isNaN || cell.bounds.minY.isNaN || barWidth.isNaN || cell.bounds.height.isNaN || (cell.bounds.maxX - barWidth).isNaN || barWidth.isInfinite
        {
        return
      }

      //subLayer.colors = Colors.buyQtyBarColors
      subLayer.backgroundColor = Colors.clPriceBookBuyQtyBar.cgColor
      subLayer.frame = CGRect(x: cell.bounds.maxX - barWidth, y: cell.bounds.minY, width: barWidth, height: cell.bounds.height-2)
      if #available(iOS 11.0, *) {
        subLayer.cornerRadius = 5
        subLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
      } else {
      }
    }

    cell.clipsToBounds = true
    subLayer.zPosition = -1

    if let sublayers = cell.layer.sublayers {
      if sublayers.count <= 3 {
        DispatchQueue.main.async {
          cell.layer.addSublayer(CAGradientLayer())
          cell.layer.addSublayer(CAGradientLayer())
          cell.layer.replaceSublayer(cell.layer.sublayers!.last!, with: subLayer)
        }
      } else {
        cell.layer.replaceSublayer(cell.layer.sublayers!.last!, with: subLayer)
      }
    }
  }
}

// MARK: - UICollectionViewDataSource
extension OldBoletaViewController: UICollectionViewDataSource
{

  //****************************************************************************
  //
  //       Nome: collectionView (... numberOfItemsInSection ...)
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  func collectionView(_ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int
  {

    return m_arStockCollectionData.count
  }

  //****************************************************************************
  //
  //       Nome: collectionView (... cellForItemAt ...)
  //  Descrição:
  //
  //    Criação:
  // Modificado: 19/02/2019  v1.3.46  Guilherme Cardoso Soares
  //             - Referência única para um Stock
  //****************************************************************************
  func collectionView(_ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
  {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Collection View Cell", for: indexPath)

    let descriptionLabel = cell.viewWithTag(1) as? UILabel
    let valueLabel = cell.viewWithTag(2) as? UILabel
    descriptionLabel?.font = Fonts.oldBoletaCollectionDescriptionLabel
    descriptionLabel?.adjustsFontSizeToFitWidth = true
    valueLabel?.adjustsFontSizeToFitWidth = true
    descriptionLabel?.textColor = Colors.clOrderEntryLightTextColor
    valueLabel?.textColor = Colors.clOrderEntryLightTextColor

    let desc = m_arStockCollectionData[indexPath.row].key
    descriptionLabel?.text = Localization.localizedString(key: desc)

    valueLabel?.layer.cornerRadius = 5
    valueLabel?.text = m_arStockCollectionData[indexPath.row].value

    if desc == LocalizationKey.StockProperty_Variation || desc == LocalizationKey.StockProperty_Last
      {
        if let variation = app.m_dicStocks[m_selectedAsset!.getKey()]?.sDailyChange {
        
          let stock = app.m_dicStocks[m_selectedAsset!.getKey()]
        
        if ( variation > 0)
        {
          if stock?.backgroundColor == .positive
          {
            valueLabel?.textColor = Colors.clPositiveFontColor
          }
          else
          {
            valueLabel?.textColor = Colors.PosPositiveFontColor
          }
        }
        else if ( variation < 0)
        {
          if stock?.backgroundColor == .negative
          {
            valueLabel?.textColor = Colors.clNegativeFontColor
          }
          else
          {
            valueLabel?.textColor = Colors.PosNegativeFontColor
          }
        }
      }
      valueLabel?.backgroundColor = m_clBackgroundColor
    }
    else
    {
      valueLabel?.backgroundColor = .clear
    }

    return cell
  }


}

// MARK: - UICollectionViewDelegate
extension OldBoletaViewController: UICollectionViewDelegateFlowLayout
{
  //****************************************************************************
  //
  //       Nome: collectionView (... minimumLineSpacingForSectionAt ...)
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int) -> CGFloat
  {
    return 0
  }

  //****************************************************************************
  //
  //       Nome: collectionView (... sizeForItemAt ...)
  //  Descrição:
  //
  //    Criação:
  // Modificado:
  //
  //****************************************************************************
  func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    let itemHeight = collectionView.bounds.height
    return CGSize(width: 105, height: itemHeight)
  }
}

// MARK: - UITextFieldDelegate
extension OldBoletaViewController : UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField : UITextField) {
    Common.setInputToolbarColor(forTextField: textField)
    if textField == strategyTextField || textField == dayTradeXibView?.strategyTextField {
      textField.resignFirstResponder()
      if let sdViewController = newStockDetailViewController {
        sdViewController.performSegue(withIdentifier: "showStrategySegue", sender: sdViewController)
      } else {
        performSegue(withIdentifier: "showStrategySegue", sender: self)
      }
    }
  }
}

extension OldBoletaViewController {
  @objc func receivedStrategyNotification() {
    let strategySelected = StrategyManager.shared.ocoStrategySelected
    
    if let name = strategySelected?.name {
      strategyTextField.text = name
      dayTradeXibView?.strategyTextField.text = name
    } else {
      strategyTextField.text = Localization.localizedString(key: .General_NoOCOStrategy)
      dayTradeXibView?.strategyTextField.text = Localization.localizedString(key: .General_NoOCOStrategy)
    }
    
    strategyTextField.endEditing(true)
    dayTradeXibView?.strategyTextField.endEditing(true)
  }
}

extension OldBoletaViewController : AssetInfoUpdateDelegate {
  
  /// Atualiza os limites dos steppers de quantidade caso o ativo tenha fracionário
  /// - Parameter sender: AssetInfo
  /// - Authors:
  /// Tháygoro Minuzzi Leopoldino
  private func updateSteppersLimits(sender: AssetInfo) {
    guard let dayTradeAssetId = m_selectedAsset else {
      return
    }
    let dayTradeAssetInfo = app.getAssetInfo(dayTradeAssetId)
    
    if app.handlesFractionary(), sender.hasFractionary(), sender.m_aidAssetId.m_strTicker != dayTradeAssetId.m_strTicker {
      if sender.isFractionary(), sender.m_aidAssetId == dayTradeAssetInfo.getFractionaryAssetId() {
        let fracInfo = app.getAssetInfo(sender.m_aidAssetId)
        if let minOrderQtd = fracInfo.nMinOrderQtd {
          qtyStepper.minimumValue = Double(minOrderQtd)
          dayTradeXibView?.qtyStepper.minimumValue = Double(minOrderQtd)
        }
      }
      else if sender.m_aidAssetId == dayTradeAssetInfo.getNonFractionaryAssetId() {
        let nonFracInfo = app.getAssetInfo(sender.m_aidAssetId)
        if let maxOrderQtd = nonFracInfo.nMaxOrderQtd {
          qtyStepper.maximumValue = Double(maxOrderQtd)
          dayTradeXibView?.qtyStepper.maximumValue = Double(maxOrderQtd)
        }
      }
    }
  }
  
  func updateAssetInfo(sender: AssetInfo) {
    if app.handlesFractionary(), sender.hasFractionary() {
      /// Garante que o equivalente fracionário/não-fracionário do ativo atual também será inscrito
      let assetInfo = sender.isFractionary() ? app.getAssetInfo(sender.getNonFractionaryAssetId()) : app.getAssetInfo(sender.getFractionaryAssetId())
      assetInfo.addToUpdateList(self)
    }
    
    updateSteppersLimits(sender: sender)
    
    setDefaultValuesForVitreo(sender.m_aidAssetId)
    
    if m_quantity == 0 {
      if let minOrderQtd = sender.nMinOrderQtd {
        m_quantity = Double(minOrderQtd)
      }
      qtyStepper.minimumValue = Double(m_quantity)
      dayTradeXibView?.qtyStepper.minimumValue = Double(m_quantity)
      
      if let maxOrderQtd = sender.nMaxOrderQtd {
        qtyStepper.maximumValue = Double(maxOrderQtd)
        dayTradeXibView?.qtyStepper.maximumValue = Double(maxOrderQtd)
      }
      if app.handlesFractionary(), sender.hasFractionary(), sender.isFractionary(), let nonFracInfo = sender.getNonFractionaryAssetInfo(), let maxOrderQtd = nonFracInfo.nMaxOrderQtd {
        qtyStepper.maximumValue = Double(maxOrderQtd)
        dayTradeXibView?.qtyStepper.maximumValue = Double(maxOrderQtd)
      }
      
      qtyStepper.value = m_quantity
      dayTradeXibView?.qtyStepper.minimumValue = m_quantity
      dayTradeXibView?.qtyStepper.value = m_quantity
      if let dayTradeAssetId = m_selectedAsset {
        qtyTextField.text = Common.formatQtyToString(value: Common.convertDoubleToInt(m_quantity), forAsset: dayTradeAssetId, makeShort: false)
        dayTradeXibView?.qtyTextField.text = Common.formatQtyToString(value: Common.convertDoubleToInt(m_quantity), forAsset: dayTradeAssetId, makeShort: false)
      }
      totalLabel.text = calcTotal()
    }
    
    if let lote = sender.nLote {
      qtyStepper.stepValue = Double(lote)
      dayTradeXibView?.qtyStepper.stepValue = Double(lote)
    }
    totalLabel.text = calcTotal()
    if let minOrderPriceIncrement = sender.sMinOrderPriceIncrement {
      priceStepper.stepValue = minOrderPriceIncrement
      stopOffsetStepper.stepValue = minOrderPriceIncrement
    }
    
    if let qtdDefault = sender.qtdDefault, let dayTradeAssetId = m_selectedAsset {
      qtyStepper.value = Double(qtdDefault)
      qtyTextField.text = Common.formatQtyToString(value: qtdDefault, forAsset: dayTradeAssetId, makeShort: false)
      dayTradeXibView?.qtyStepper.value = Double(qtdDefault)
      dayTradeXibView?.qtyTextField.text = Common.formatQtyToString(value: qtdDefault, forAsset: dayTradeAssetId, makeShort: false)
    }
        
    let referenceAssetId = Common.getReferenceAssetId(a_aidAssetId: sender.m_aidAssetId)
    if referenceAssetId != sender.m_aidAssetId, let referenceStock = app.m_dicStocks[referenceAssetId.getKey()]
    {
      referenceStock.removeFromUpdateList(self)
    }
    
    // Price book
    //m_nFloatDigits = info.nFloatDigits
    if let minIncrement = sender.sMinPriceIncrement
    {
      m_sMinIncrement = minIncrement
    }
    offersTableView.reloadData()
    
    // Atualiza campos de preço com os float digits
    if let priceText = priceTextField.text, let price = Double(Common.formatNumericalInput(a_strInput: priceText))
    {
      priceTextField.text = formatText(price)
    }
    
    if let stopOffsetText = stopOffsetTextField.text, let stopOffset = Double(Common.formatNumericalInput(a_strInput: stopOffsetText))
    {
      stopOffsetTextField.text = formatText(stopOffset)
    }
    testForAlerts()    
  }
}

extension OldBoletaViewController : PositionUpdateDelegate {
  func getLifecycleScope() -> CoroutineScope {
    return CommonIOS.companion.getCoroutineScopeDefault()
  }
  
  func updatePosition(sender: PositionDelegate, property: PositionProperties) {
    
    guard property.isSwingData || property == .swingresult else {
      return
    }
    
    if let assetID = m_selectedAsset, let account = Application.m_application.m_acSelectedAccount, let pos = account.GetPosition(a_aidAssetId: assetID)
    {
      setupAverageResultLabelText {
        self.averageResultLabel.text = Common.formatStringfrom(value: pos.getPositionAvgPriceDouble(), minDigits: 2, maxDigits: 2)
      }
            
      if let _ = pos.getPositionSide(), let _ = pos.getPositionQtyInt()
      {
        let positionAvgPrice = pos.getPositionAvgPriceWithCurrency()
        
        setupAverageResultLabelText {
          self.averageResultLabel.text = Common.formatStringfrom(value: positionAvgPrice.0, minDigits: 2, maxDigits: 2)
          self.averageResultLabel.text? = (positionAvgPrice.1 ?? "") + " " + (self.averageResultLabel.text ?? "")
        }
        
        if let side = pos.getPositionSide(), let qty = pos.getPositionQtyInt()
        {
          let qty = NSMutableAttributedString(string: Common.formatQtyToString(value: qty, forAsset: assetID, makeShort: false) + "  ")
          let strSide = NSMutableAttributedString(string: side.descriptionStr(), attributes: [NSAttributedString.Key.foregroundColor: side.fontColorIOS()])
          let strQty = NSMutableAttributedString()
          strQty.append(qty)
          strQty.append(strSide)
          qtyResultLabel.attributedText = strQty
        }
        else
        {
          qtyResultLabel.text = "-"
        }
      }
      else
      {
        qtyResultLabel.text = "-"
      }
      
      m_simpleOpenResult = sender.getSimpleOpenResult()
      m_simpleTotalResult = sender.getSimpleTotalResult()
      m_extraOpenResult = Double(sender.getExtraOpenResult())
      m_extraTotalResult = Double(sender.getExtraTotalResult())
      m_totalValueTrade = Double(sender.getTotalValueTrade())
    }
  }
}


extension OldBoletaViewController : OrderUpdateDelegate {
  func updateOrder(sender: OrderDelegate) {
    fetchOrderList()
  }
}

extension OldBoletaViewController : StockUpdateDelegate {
  
  func updateAssetState(sender: Stock) {
    Application.m_application.m_assetAlertManager.showAlertsFor(assetAlertDisplay: self)
  }
  
  func updateQuotation(sender: Stock, quote: Cotacao) {
    
  }
  
  func updateTinyBook(sender: Stock, qty: Int?, side: TinyBookSide, price: Double?) {
    guard let _price = price else {
      return
    }
    switch side {
      case .buy:  m_arStockCollectionData[1].value = formatText(_price)
      case .sell: m_arStockCollectionData[2].value = formatText(_price)
    }
    
    symbolDataCollectionView.reloadData()
  }
  
  func updatePriceBook(sender: Stock, property: PriceBookProperty) {
    if property == .arBuyOffers {
      m_arBuyOffers = sender.priceBook.groupedBuyOffers
    }
    else if property == .arSellOffers {
      m_arSellOffers = sender.priceBook.groupedSellOffers
    }
  
    offersTableView.optimizedReloadData()
  }
  
  func updateDaily(sender: Stock, daily: Daily) {

    guard let assetID = m_selectedAsset else
    {
      return
    }
    
    // atualiza valores com o daily
    let string = formatText(daily.sClose)
    m_arStockCollectionData[0].value = string
    
    // atualiza stop offset com o default (30 * tick)
    let defaultStopOffset: Double = 30 * m_sMinIncrement
    let stopOffsetString: String = formatText(defaultStopOffset)
    
    if m_updatePriceField
    {
      priceStepper.value = daily.sClose
      stopOffsetStepper.value = defaultStopOffset
      priceTextField.text = string
      stopOffsetTextField.text = stopOffsetString
      m_updatePriceField = false
      totalLabel.text = calcTotal()
    }
    
    guard let stock = Application.m_application.m_dicStocks[assetID.getKey()] else {
      return
    }
    
    m_arStockCollectionData[3].value = ExchangeManager.shared.isItReplayMarket(nExchange: assetID.m_nMarket.kotlin) ? Common.dateToStringFormatReplay(date: daily.lastTradeDate, asset: m_selectedAsset) : Common.dateToStringFormat(date: daily.lastTradeDate, watchlistFormat: true, asset: m_selectedAsset)
    
    if let variation = stock.sDailyChange {
      m_arStockCollectionData[4].value = Common.formatStringfrom(value: variation, minDigits: 2, maxDigits: 2) + "%"
      m_Variation = variation
    } else {
      m_arStockCollectionData[4].value = "-"
      m_Variation = 0
    }
    
    symbolDataCollectionView.reloadData()
    
  }
  
  func update(sender: Stock, dataSerie: SeriesData, seriesKey: PriceSeriesKey) {
                
    if let asset = m_selectedAsset {
      self.updateTickerButton(a_strTicker: asset.getKey())
    }
                
    if let variation = sender.sDailyChange {
      let string = Common.formatStringfrom(value: variation, minDigits: 2, maxDigits: 2) + "%"
      m_arStockCollectionData[4].value = string
      m_Variation = variation
      symbolDataCollectionView.reloadData()
    }
  }
  
  func updateBackgroundColor(sender: Stock) {
    
    if let stock = app.m_dicStocks[m_selectedAsset!.getKey()] {
      if stock.backgroundColor == .normal {
        m_clBackgroundColor = .clear
      } else if stock.backgroundColor == .positive {
        m_clBackgroundColor = Colors.clPositiveBackgroundColor
      } else if stock.backgroundColor == .negative {
        m_clBackgroundColor = Colors.clNegativeBackgroundColor
      }
    }
    symbolDataCollectionView.reloadData()
  }
}
