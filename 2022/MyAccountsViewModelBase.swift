//
//  MyAccountsViewModelBase.swift
//  ProfitChart
//
//  Created by nelogica on 22/08/22.
//  Copyright © 2022 Nelogica. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

@available(iOS 14.0, *)
class MyAccountsViewModelBase: AccountListViewModelBase, EditAccountDataDelegate {
  
  private var cancellables: Set<AnyCancellable> = []
  var listRequested: Bool = false
  private var apiAccounts: [SimpleGenericListData] = []
  @Published var openEditItem: EditType? = nil
  private(set) var accountToEdit: SimpleGenericListData? = nil
  @Published private(set) var isLoading: Bool = false
  var brokerTypeName: String {
    return Localization.localizedString(key: LocalizationKey.General_Brokerage).lowercased()
  }
  private(set) var brokerList: [ApiBroker] = []
  
  enum EditType: Hashable, Identifiable {
    var id: Int {
      return hashValue
    }
    
    case RealAccount
    case VirtualAccount
  }
  
  override var isEditing: Bool {
    didSet {
      isEditingWillChange(to: isEditing)
    }
  }
  
  override var defaultCellBackground: Color {
    Colors.clSettingsCellBackgroundColor.toColor()
  }
  
  override init() {
    super.init()
    
    NotificationCenter.default.publisher(for: AccountsListAPINotification) // TODO: precisa trocar pra notificar só quando receber tudo
      .receive(on: DispatchQueue.main)
      .sink { [weak self] notification in
        guard let strongSelf: MyAccountsViewModelBase = self,
              let accountsAPI = notification.userInfo?["status"] as? [ApiAccount] else {
          return
        }
        strongSelf.receivedAccounts(accounts: accountsAPI)
      }
      .store(in: &cancellables)
    NotificationCenter.default.publisher(for: DeleteAccountAPINotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] notification in
        guard let strongSelf: MyAccountsViewModelBase = self else {
          return
        }
        strongSelf.receivedDeleteResult(note: notification)
      }
      .store(in: &cancellables)
    
    NotificationCenter.default.publisher(for: RequestRoutingAccountAPINotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] notification in
        guard let strongSelf: MyAccountsViewModelBase = self else {
          return
        }
        strongSelf.receivedAccountResult(note: notification)
      }
      .store(in: &cancellables)
    NotificationCenter.default.publisher(for: BrokerListAPINotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] notification in
        guard let strongSelf: MyAccountsViewModelBase = self,
              let result: [ApiBroker] = notification.userInfo?["status"] as? [ApiBroker] else {
          return
        }
        strongSelf.brokerList = result
      }
      .store(in: &cancellables)
    NotificationCenter.default.publisher(for: UpdateAccountResultAPINotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] notification in
        guard let strongSelf: MyAccountsViewModelBase = self else {
          return
        }
        strongSelf.receivedUpdateAccountResult(note: notification)
      }
      .store(in: &cancellables)
    
    requestBrokersList()
    reloadData()
  }
  
  func requestBrokersList() {
    Application.m_application.m_oMsgManager.sendGetBrokersListApiGateway()
  }
  
  override func getAccounts() -> [Account] {
    Application.m_application.getAllAccounts(toShow: false)
  }
  
  override func reloadData() {
    isLoading = !listRequested
    requestAPIAccounts()
    super.reloadData()
  }
  
  func resetData() {
    listRequested = false
    reloadData()
  }
  
  override func appendSections() {
    defer {
      setEditActionIfNeeded()
    }
    guard isEditing else {
      super.appendSections()
      return
    }
    appendRealAccountsSection()
    appendVirtualAccountsSections()
    appendSimulatorAccountsSections()
  }
  
  override func appendRealAccountsSection() {
    appendSectionIfCan(
      sectionItems: realAccounts + apiAccounts,
      title: LocalizationKey.AccountsList_HeaderReal.getString().uppercased()
    )
  }
  
  private func setEditActionIfNeeded() {
    itemsBySection.first?.headerAction = getListHeaderAction()
  }
  private func getListHeaderAction() -> SimpleGenericListTitleHeaderAction? {
    guard !isEditing else {
      return nil
    }
    return SimpleGenericListTitleHeaderAction(
      title: Localization.localizedString(key: LocalizationKey.General_Edit),
      action: { [weak self] in
        self?.isEditing.toggle()
      }
    )
  }
  
  func requestAPIAccounts() {
    guard !listRequested else { return }
    Application.m_application.m_oMsgManager.sendGetListAccountsFromUserApiGateway()
    listRequested = true
  }
  
  func receivedAccounts(accounts: [ApiAccount]) {
    var finalAPIAccounts: [SimpleGenericListData] = []
    accounts.forEach { APIAccount in
      let brokerID: String = APIAccount.getBrokerReferenceID()
      if let account: Account = Application.m_application.m_dicBrokers[brokerID]?.getAccount(accountId: APIAccount.accountId) {
        account.APIData = APIAccount
      } else if !APIAccount.isSimulator {
        finalAPIAccounts.append(APIAccount)
      }
    }
    apiAccounts = finalAPIAccounts
    reloadData()
  }
  
  func isEditingWillChange(to newIsEditing: Bool) {
    reloadData()
    updateAlertEditingView(isEditing: newIsEditing)
  }
  
  func updateAlertEditingView(isEditing: Bool) {
    showAlert = isEditing
  }
  
  override func canEdit(item: SimpleGenericListData) -> Bool {
    guard isEditing else { return false }
    if let wallet: UserWallet = item as? UserWallet {
      return wallet.canDelete()
    }
    if let account: Account = item as? Account, account.isSimAccount() {
      return false
    }
    return super.canEdit(item: item)
  }
  
  override func getTableFooterView() -> AnyView? {
    if isEditing {
      return AnyView(
        HStack(alignment: VerticalAlignment.center, spacing: 0) {
          Button(
            action: { [weak self] in
              guard let strongSelf: MyAccountsViewModelBase = self else { return }
              strongSelf.deleteSelecteds()
              strongSelf.isEditing = false
            },
            label: {
              HStack(alignment: VerticalAlignment.center, spacing: 4) {
                Image("icContexMenuTrash", bundle: Bundle(for: AppDelegate.self))
                Text(Localization.localizedString(key: LocalizationKey.General_TableViewRemove))
              }
              .frame(height: 60)
              .frame(maxWidth: CGFloat.infinity)
              .background(
                Color.red
              )
            }
          )
          .disabled(selectedItemsBySection.isEmpty)
          .accentColor(Colors.secondaryColor)
          
          .cornerRadius(8)
          .padding(Edge.Set.vertical, 16)
          .padding(Edge.Set.horizontal, 8)
        }
      )
    }
    
    return nil
  }
  
  override func getAccessoryIcon(forItem item: SimpleGenericListData) -> UIImage? {
    if item is AddAccount {
      return UIImage(withName: "chevron")
    }
    
    if let APIData: ApiAccount = item as? ApiAccount,
       let statusImage: UIImage = APIData.getStatus()?.image {
      return statusImage
    }
    return nil
  }
  
  override func getAccessoryActions(forItem item: SimpleGenericListData) -> [SimpleGenericListAccessoryAction] {
    var acessories: [SimpleGenericListAccessoryAction] = []
    if hasToShowEditAcessory(forItem: item) {
      acessories.append(EditItem())
    }
    if hasToShowVisibilityAcessory(forItem: item) {
      acessories.append(VisibilityItem(
        active: Binding<Bool>(
          get: { (item as? Account)?.isVisible() ?? true },
          set: { newValue in
            (item as? Account)?.setIsVisible(isVisible: newValue)
          }
        )
      ))
    }
    
    return acessories
  }
  
  override func getSubItems(forItem item: SimpleGenericListData) -> [SimpleGenericListData]? {
    if let account: Account = item as? Account {
      return account.getWallets(toShow: false) + account.getSubAccounts(toShow: false)
    }
    return nil
  }
  
  override func didSelect(item: SimpleGenericListData) {
    if let accountData: ApiAccount = getAccountData(fromItem: item),
       accountData.backOfficeStatus == 5, // não sei o que significa 5 exatamente só realoquei código funcional. Deve ser status de erro geral
       let errorDescription: String = accountData.backOfficeDescription {
      Common.showAlertOnCurrentViewController(title: "", message: errorDescription)
      return
    }
    super.didSelect(item: item)
  }
  
  override func didTap(on accessoryAction: SimpleGenericListAccessoryAction, of item: SimpleGenericListData) {
    if let visibilityAccessory: VisibilityItem = accessoryAction as? VisibilityItem {
      visibilityAccessory.active.toggle()
      if let account: Account = item as? Account {
        account.setIsVisible(isVisible: visibilityAccessory.active)
      }
      return
    }
    
    if accessoryAction is EditItem {
      if item is VirtualAccount {
        openEditItem = EditType.VirtualAccount
      } else if let account: Account = item as? Account, !account.isSimAccount() {
        openEditItem = EditType.RealAccount
      }
      accountToEdit = item
    }
  }
  
  func getBrokerFor(APIData: ApiAccount?) -> ApiBroker? {
    return brokerList.first(where: { $0.key == APIData?.brokerId })
  }
  
  func getBrokerForEditItem() -> ApiBroker? {
    guard let editItem: SimpleGenericListData = accountToEdit,
          let APIData: ApiAccount = getAccountData(fromItem: editItem) else { return nil }
    return getBrokerFor(APIData: APIData)
  }
  
  func deleteSelecteds() {
    selectedItemsBySection.values.forEach { item in
      sendDelete(item: item)
    }
    selectedItemsBySection = [:]
    reloadData()
  }
  
  func sendDelete(item: SimpleGenericListData) {
    if let wallet: UserWallet = item as? UserWallet {
      wallet.deleteIfCan(withConfirmation: false)
      return
    }
    if let account: Account = item as? Account {
      if account.isVirtualAccount() {
        deleteVirtualAccount(account: account)
      } else if let APIData: ApiAccount = account.APIData {
        sendDeleteToAPI(account: APIData)
      }
    } else if let apiAccount: ApiAccount = item as? ApiAccount {
      sendDeleteToAPI(account: apiAccount)
    }
  }
  
  func getEditAccountData() -> ApiAccount? {
    guard let editItem: SimpleGenericListData = accountToEdit else { return nil }
    return getAccountData(fromItem: editItem)
  }
  
  private func getAccountData(fromItem item: SimpleGenericListData) -> ApiAccount? {
    if let account: Account = item as? Account {
      return account.APIData
    }
    return item as? ApiAccount
  }
  
  private func deleteVirtualAccount(account: Account) {
    VirtualPositionManager.removeVirtualPosition(accountId: account.strAccountID)
    Application.m_application.updateVirtualAccountsPositions()
  }
  
  private func sendDeleteToAPI(account: ApiAccount) {
    // TODO: Fazer override no profit para usar a API Rest
    switch account.getStatus() {
      case .approving, .processing:
        sendCancelProcessingAccount(accountData: account)
      case .inactive:
        let alertMessageError: String = Localization.localizedString(key: LocalizationKey.MyAccounts_CantDeleteInactiveMessage)
          .replacingOccurrences(of: "|ACCOUNTNAME|", with: account.accountName)
          .replacingOccurrences(of: "|BROKERTYPENAME|", with: brokerTypeName)
        DispatchQueue.main.async {
          Common.showAlertOnCurrentViewController(title:  Localization.localizedString(key: .AccountRegister_RequestCanceled), message: alertMessageError)
        }
      case .rejectedRequest:
        sendCancelRejectedRequestAccount(accountData: account)
      case .canceledRequest:
        sendCancelCanceledRequestAccount(accountData: account)
      case .active, .none:
        sendCancelActiveAccount(accountData: account)
    }
  }
  
  func sendCancelProcessingAccount(accountData: ApiAccount) {
    Application.m_application.m_oMsgManager.sendCancelAccountRequestFromUserApiGateway(brokerId: accountData.brokerId, accountId: accountData.accountId, requestId: accountData.requestId ?? 0)
  }
  func sendCancelRejectedRequestAccount(accountData: ApiAccount) {
    Application.m_application.m_oMsgManager.sendDeleteAccountRequestFromUserApiGateway(requestId: accountData.requestId ?? 0)
  }
  
  func sendCancelCanceledRequestAccount(accountData: ApiAccount) {
    Application.m_application.m_oMsgManager.sendDeleteAccountRequestFromUserApiGateway(requestId: accountData.requestId ?? 0)
  }
  
  func sendCancelActiveAccount(accountData: ApiAccount) {
    Application.m_application.m_oMsgManager.sendDeleteAccountFromUserApiGateway(accountId: accountData.accountId, rotBrokerId: accountData.rotBrokerId ?? 0)
  }
  
  func updateAccountName(accountData: ApiAccount, newName: String) {
    // TODO: Verificar se rename ainda é feito na REST API
    Application.m_application.m_APIManager.getToken()
    Application.m_application.m_APIManager.updateAccountName(accountID: accountData.accountId, newName: newName) { [weak self] success in
      if success {
        self?.resetData()
      } else {
        DispatchQueue.main.async {
          Common.showAlertOnCurrentViewController(title: Localization.localizedString(key: .AccountRegister_EditNameFailedMessage), message: "")
        }
      }
    }
  }
  
  func finishAccountEdit() {
    accountToEdit = nil
    openEditItem = nil
  }
  
  func getAccountEditResultMessage(succeeded: Bool) -> String {
    if succeeded {
      return LocalizationKey.MyAccounts_UpdateAccountSuccess.getString()
    }
    return LocalizationKey.MyAccounts_UpdateAccountFail.getString()
  }
  
  func receivedAccountResult(note: NotificationCenter.Publisher.Output) {
    if let result: MessageResultApiGateway = note.userInfo?["status"] as? MessageResultApiGateway {
      if result.status {
        Application.m_application.m_oMsgManager.sendGetAccountStatusFromUserApiGateway(requestId: Int(result.requestId))
      }
    }
    resetData()
  }
  
  func receivedUpdateAccountResult(note: NotificationCenter.Publisher.Output) {
    guard let result: UpdateAccountResult = note.object as? UpdateAccountResult else { return }
    NotificationCenter.default.publisher(for: RequestAccountStatusAPINotification)
      .receive(on: DispatchQueue.main)
      .sink { note in
        guard let statusResult: StatusAccountFromUserResultApiGateway = note.userInfo?["status"] as? StatusAccountFromUserResultApiGateway,
              statusResult.requestId == result.requestID,
              let status = BackOfficeStatusBinaryAKG(rawValue: statusResult.statusBackOffice),
              status.isFailure()
        else { return }
        Common.showAlertOnCurrentViewController(title: "", message: statusResult.backOfficeDescription.string)
      }
      .store(in: &cancellables)
    
    openEditItem = nil
    accountToEdit = nil
    DispatchQueue.main.async {
      Common.showAlertOnCurrentViewController(title: "", message: result.message)
    }
  }
  
  func receivedDeleteResult(note: NotificationCenter.Publisher.Output) {
    var deleted: Bool = true
    if let result: CancelAccountRequestResultApiGateway = note.userInfo?["status"] as? CancelAccountRequestResultApiGateway {
      deleted = result.status
    } else if let result: DeleteAccountRequestResultApiGateway = note.userInfo?["status"] as? DeleteAccountRequestResultApiGateway {
      deleted = result.status
    }
    if deleted {
      SubscribeSync.updateSubscribeTimer(callSubscribersAction: Action { [weak self] in
        guard let strongSelf: MyAccountsViewModelBase = self else { return }
        strongSelf.resetData()
      }, delay: 0.5)
    } else {
      DispatchQueue.main.async {
        Common.showAlertOnCurrentViewController(title: Localization.localizedString(key: .AccountRegister_RequestCanceled), message: Localization.localizedString(key: .AccountRegister_RequestCanceledMessageReject))
      }
    }
  }
  
  func hasToShowEditAcessory(forItem item: SimpleGenericListData) -> Bool {
    guard let accountItem: Account = item as? Account else { return false }
    if accountItem.isSimAccount() {
      return false
    }
    return true
  }
  
  func hasToShowVisibilityAcessory(forItem item: SimpleGenericListData) -> Bool {
    return item is Account
  }
  
  class EditItem: SimpleGenericListAccessoryAction {
    override init() {
      super.init()
      setIcon(UIImage(withName: "Edit") ?? UIImage())
    }
  }
  
  class VisibilityItem: SimpleGenericListAccessoryAction {
    @Binding var active: Bool {
      willSet {
        updateIcon(newActive: newValue)
      }
    }
    
    init(active: Binding<Bool>) {
      self._active = active
      super.init()
      setIcon(getIcon(active: active.wrappedValue))
    }
    
    func updateIcon(newActive: Bool) {
      setIcon(getIcon(active: newActive))
    }
    
    func getIcon(active: Bool) -> UIImage {
      return UIImage(withName: active ? "icShowPassword" : "icHidePositions") ?? UIImage()
    }
  }
}

protocol EditAccountDataDelegate: AnyObject {
  func updateAccountName(accountData: ApiAccount, newName: String)
  func finishAccountEdit()
}
