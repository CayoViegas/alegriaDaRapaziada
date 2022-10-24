//  vai si fuder pedr0 f0nt3s


import SwiftUI

@available(iOS 14.0, *)
struct MyAccountsView: View {
  @EnvironmentObject var navigationBridge: SwiftUINavigationBridge // TODO: Gambi necessária enquanto mantém NavLink e Bridge no fluxo
  @EnvironmentObject var baseController: WeakContainer<SwiftUIBaseViewController>
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @StateObject var listController: MyAccountsViewModel
  @State var toRoot: Bool = false
  @ObservedObject private var navigationControl: AccountListNavigationController
  let backgroundColor: Color = Colors.backgroundColor.toColor()
  
  init() {
    let controller: MyAccountsViewModel = MyAccountsViewModel()
    _listController = StateObject(wrappedValue: controller)
    navigationControl = controller.navigationControl
  }
  
  var body: some View {
    NavigationView {
      VStack {
        SimpleGenericListView(controller: listController)
          .background(backgroundColor)
          .navigationTitle(Localization.localizedString(key: LocalizationKey.Menu_AccountSettingsTitle))
          .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
          .navigationBarHidden(false)
          .toolbar {
            ToolbarItemGroup(placement: ToolbarItemPlacement.navigationBarLeading) {
              Button(
                action: {
                  baseController.value?.slideMenuController()?.toggleLeft()
                }, label: {
                  Image("Menu", bundle: Bundle(for: AppDelegate.self))
                    .resizable()
                    .frame(width: 24, height: 24)
                    .accentColor(Colors.secondaryColor)
                }
              )
            }
            ToolbarItemGroup(placement: ToolbarItemPlacement.navigationBarTrailing) {
              if listController.isEditing {
                Button(
                  action: {
                    listController.isEditing = false
                  }, label: {
                    Text(Localization.localizedString(key: LocalizationKey.General_Finish))
                      .font(Fonts.generalRegularButtonFont)
                      .foregroundColor(Colors.menuSelectedTextColor.toColor())
                  }
                )
              }
            }
          }
          .sheet(item: $listController.openEditItem) { type in
            switch type {
              case .RealAccount:
                BaseModalNavigationView(
                  title: LocalizationKey.MyAccounts_UpdateAccountTitle.getString(),
                  leadingNavBarItems: [getEditModalBackButton()]
                ) {
                  UpdateAccountRegisterView(
                    APIData: listController.getEditAccountData(),
                    brokerData: listController.getBrokerForEditItem()
                  )
                  .ignoresSafeArea()
                }
              case .VirtualAccount:
                BaseModalNavigationView(
                  title: LocalizationKey.MyAccounts_UpdateAccountTitle.getString(),
                  leadingNavBarItems: [getEditModalBackButton()]
                ) {
                  AddVirtualAccountView(
                    backgroundColor: UIColor.clear,
                    accountToEdit: listController.accountToEdit as? VirtualAccount,
                    editCompletion: { succeeded in
                      listController.finishAccountEdit()
                      let message: String = listController.getAccountEditResultMessage(succeeded: succeeded)
                      DispatchQueue.main.async {
                        Common.showAlertOnCurrentViewController(title: "", message: message)
                      }
                    }
                  )
                  .ignoresSafeArea()
                }
            }
          }
        NavigationLink(
          destination: AccountListNavigationController.NavigationTag.AddAccount.getDestination(backgroundColor: backgroundColor.toUIColor(), usesNavLink: false),
          tag: AccountListNavigationController.NavigationTag.AddAccount,
          selection: $navigationControl.selection
        ) {}
      }
      .overlay(listController.isLoading ? OverlayLoadingActivityView().ignoresSafeArea() : nil)
      .id(toRoot)
    }
    .accentColor(Colors.primaryFontColor)
    .navigationViewStyle(StackNavigationViewStyle())
    .setNavigation(backgroundColor: Colors.tabBarTabBackground, shouldChangeBackgroundColor: true)
    .onAppear {
      Application.m_application.m_moCurrentView = MenuOption.accountSettings
      navigationControl.presentation = presentationMode
      navigationBridge.preferNavLinkFlow = false
      baseController.value?.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    .onDisappear {
      NavigationBarModifier.clearNavbarConfiguration(setBackgroundColor: UIColor.clear)
      navigationControl.selection = nil
    }
    .environment(\.rewind, $toRoot)
  }
  
  private func getEditModalBackButton() -> ModalButton {
    ModalButton(
      text: LocalizationKey.Close.getString(),
      action: {
        listController.finishAccountEdit()
      }
    )
  }
  
}
