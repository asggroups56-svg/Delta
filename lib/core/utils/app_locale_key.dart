/// All translation keys used in the app.
/// Each key corresponds to an entry in [i18n/ar.json] and [i18n/en.json].
/// Usage:  AppLocaleKey.skip.tr()
class AppLocaleKey {
  AppLocaleKey._();

  // ── General / App ─────────────────────────────────────────────────────────
  static const String pleaseCheckYourConnectionAndTryAgain = 'PleaseCheckYourConnectionAndTryAgain';
  static const String appName                   = 'appName';
  static const String appSubtitle               = 'appSubtitle';
  static const String versionPoweredBy          = 'versionPoweredBy';

  // ── Onboarding ────────────────────────────────────────────────────────────
  static const String skip                      = 'skip';
  static const String next                      = 'next';
  static const String startNow                  = 'startNow';
  static const String onboardingTitle1          = 'onboardingTitle1';
  static const String onboardingSubtitle1       = 'onboardingSubtitle1';
  static const String onboardingTitle2          = 'onboardingTitle2';
  static const String onboardingSubtitle2       = 'onboardingSubtitle2';
  static const String onboardingTitle3          = 'onboardingTitle3';
  static const String onboardingSubtitle3       = 'onboardingSubtitle3';

  // ── Modules ───────────────────────────────────────────────────────────────
  static const String sales                     = 'sales';
  static const String inventory                 = 'inventory';
  static const String accounting                = 'accounting';
  static const String crm                       = 'crm';
  static const String invoicing                 = 'invoicing';
  static const String employees                 = 'employees';
  static const String pos                       = 'pos';
  static const String settingsModule            = 'settings';
  static const String reports                   = 'reports';
  static const String purchases                 = 'purchases';

  // ── Dashboard KPIs ────────────────────────────────────────────────────────
  static const String weeklySales               = 'weeklySales';
  static const String updatedNow                = 'updatedNow';
  static const String totalProfit               = 'totalProfit';
  static const String newPurchaseOrder          = 'newPurchaseOrder';
  static const String receivedAutomatically     = 'receivedAutomatically';
  static const String issueInvoiceUpdateStock   = 'issueInvoiceUpdateStock';
  static const String realtimeProcessing        = 'realtimeProcessing';
  static const String sendReportToCustomer      = 'sendReportToCustomer';
  static const String sentSuccessfully          = 'sentSuccessfully';

  // ── Language ──────────────────────────────────────────────────────────────
  static const String changeLanguage            = 'changeLanguage';
  static const String arabic                    = 'arabic';
  static const String english                   = 'english';
  static const String langSwitchLabel           = 'langSwitchLabel';
  static const String langSwitchShort           = 'langSwitchShort';

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String loginTitle                = 'loginTitle';
  static const String loginSubtitle             = 'loginSubtitle';
  static const String mobileOrEmail             = 'mobileOrEmail';
  static const String password                  = 'password';
  static const String confirmPassword           = 'confirmPassword';
  static const String fullName                  = 'fullName';
  static const String companyName               = 'companyName';
  static const String accountType               = 'accountType';
  static const String rememberMe                = 'rememberMe';
  static const String forgotPassword            = 'forgotPassword';
  static const String forgotPasswordHeader      = 'forgotPasswordHeader';
  static const String forgotPasswordHeaderSubtitle = 'forgotPasswordHeaderSubtitle';
  static const String sendVerificationCode      = 'sendVerificationCode';
  static const String verificationCode          = 'verificationCode';
  static const String enterVerificationCode     = 'enterVerificationCode';
  static const String newPassword               = 'newPassword';
  static const String confirmNewPassword        = 'confirmNewPassword';
  static const String resetPasswordBtn          = 'resetPasswordBtn';
  static const String passwordResetSuccess      = 'passwordResetSuccess';
  static const String backToLogin               = 'backToLogin';
  static const String resendCode                = 'resendCode';
  static const String loginBtn                  = 'loginBtn';
  static const String dontHaveAccount           = 'dontHaveAccount';
  static const String createNewAccount          = 'createNewAccount';
  static const String signupTitle               = 'signupTitle';
  static const String signupSubtitle            = 'signupSubtitle';
  static const String agreeTerms                = 'agreeTerms';
  static const String signupBtn                 = 'signupBtn';
  static const String alreadyHaveAccount        = 'alreadyHaveAccount';

  // ── Home ──────────────────────────────────────────────────────────────────
  static const String welcomeUser               = 'welcomeUser';
  static const String welcomeBack               = 'welcomeBack';
  static const String searchApps                = 'searchApps';
  static const String appsTitle                 = 'appsTitle';
  static const String quickActions              = 'quickActions';
  static const String kpiOverview               = 'kpiOverview';
  static const String totalRevenue              = 'totalRevenue';
  static const String activeOrders              = 'activeOrders';
  static const String pendingInvoices           = 'pendingInvoices';
  static const String recentActivities          = 'recentActivities';
  static const String newInvoiceIssued          = 'newInvoiceIssued';
  static const String stockUpdated              = 'stockUpdated';
  static const String newLeadAdded              = 'newLeadAdded';
  static const String createInvoice             = 'createInvoice';
  static const String addProduct                = 'addProduct';
  static const String newCustomer               = 'newCustomer';
  static const String viewReport                = 'viewReport';
  static const String mainModules               = 'mainModules';
  static const String dashboardTitle            = 'dashboardTitle';
  static const String dashboardLabel            = 'dashboardLabel';

  // ── Bottom Nav Tabs ───────────────────────────────────────────────────────
  static const String homeTab                   = 'homeTab';
  static const String appsTab                   = 'appsTab';
  static const String analyticsTab              = 'analyticsTab';
  static const String profileTab                = 'profileTab';

  // ── Grid Modules ──────────────────────────────────────────────────────────
  static const String moduleDiscuss             = 'moduleDiscuss';
  static const String moduleKnowledge           = 'moduleKnowledge';
  static const String moduleReports             = 'moduleReports';
  static const String moduleAccounting          = 'moduleAccounting';
  static const String moduleDocuments           = 'moduleDocuments';
  static const String moduleApps                = 'moduleApps';
  static const String moduleSettings            = 'moduleSettings';

  // ── Document Folders ──────────────────────────────────────────────────────
  static const String folderInsurance           = 'folderInsurance';
  static const String folderInsuranceCount      = 'folderInsuranceCount';
  static const String folderLoans               = 'folderLoans';
  static const String folderLoansCount          = 'folderLoansCount';
  static const String folderRegistrations       = 'folderRegistrations';
  static const String folderRegistrationsCount  = 'folderRegistrationsCount';
  static const String folderContracts           = 'folderContracts';
  static const String folderContractsCount      = 'folderContractsCount';
  static const String foldersTitle              = 'foldersTitle';
  static const String documentsAndFiles         = 'documentsAndFiles';

  // ── Buttons / Labels ──────────────────────────────────────────────────────
  static const String newBtn                    = 'newBtn';
  static const String uploadBtn                 = 'uploadBtn';
  static const String orLabel                   = 'orLabel';
  static const String logout                    = 'logout';
  static const String logoutLabel               = 'logoutLabel';
  static const String backToHome                = 'backToHome';

  // ── Side Drawer ───────────────────────────────────────────────────────────
  static const String appsAndServices           = 'appsAndServices';
  static const String allApps                   = 'allApps';
  static const String documentsFiles            = 'documentsFiles';
  static const String financeLabel              = 'financeLabel';
  static const String clientsLabel              = 'clientsLabel';
  static const String aiAssistant               = 'aiAssistant';
  static const String systemSettings            = 'systemSettings';

  // ── Accounting Drawer ─────────────────────────────────────────────────────
  static const String accountingAndFinance      = 'accountingAndFinance';
  static const String dashboardDrawer           = 'dashboardDrawer';
  static const String salesAndInvoices          = 'salesAndInvoices';
  static const String purchasesLabel            = 'purchasesLabel';
  static const String taxAndReturns             = 'taxAndReturns';
  static const String bankAndCash               = 'bankAndCash';

  // ── Category Filters ──────────────────────────────────────────────────────
  static const String catAll                    = 'catAll';
  static const String catLegal                  = 'catLegal';
  static const String catFinancial              = 'catFinancial';
  static const String catContracts              = 'catContracts';
  static const String catAdmin                  = 'catAdmin';

  // ── AI Chat ───────────────────────────────────────────────────────────────
  static const String aiWelcomeMessage          = 'aiWelcomeMessage';
  static const String aiAssistantTitle          = 'aiAssistantTitle';
  static const String aiAssistantSubtitle       = 'aiAssistantSubtitle';
  static const String aiThinking                = 'aiThinking';
  static const String aiInputHint               = 'aiInputHint';

  // ── Accounting Dashboard Cards ────────────────────────────────────────────
  static const String salesCard                 = 'salesCard';
  static const String salesDesc                 = 'salesDesc';
  static const String purchasesCard             = 'purchasesCard';
  static const String purchasesDesc             = 'purchasesDesc';
  static const String createVendorBill          = 'createVendorBill';
  static const String bankCard                  = 'bankCard';
  static const String bankDesc                  = 'bankDesc';
  static const String connectBank               = 'connectBank';
  static const String importStatement           = 'importStatement';
  static const String cashCard                  = 'cashCard';
  static const String cashDesc                  = 'cashDesc';
  static const String taxReturnsCard            = 'taxReturnsCard';
  static const String taxReturnStep1            = 'taxReturnStep1';
  static const String taxReturnStep2            = 'taxReturnStep2';
  static const String taxReturnStep3            = 'taxReturnStep3';

  // ── Accounting Forms & Actions ──────────────────────────────────────────────
  static const String newRecord                 = 'newRecord';
  static const String customerPartner           = 'customerPartner';
  static const String customerPartnerHint       = 'customerPartnerHint';
  static const String refInvoiceNo              = 'refInvoiceNo';
  static const String refInvoiceHint            = 'refInvoiceHint';
  static const String totalAmountSar            = 'totalAmountSar';
  static const String notesAndDesc              = 'notesAndDesc';
  static const String notesHint                 = 'notesHint';
  static const String saveDraft                 = 'saveDraft';
  static const String recordAddedSuccess        = 'recordAddedSuccess';
  static const String confirmAndSave            = 'confirmAndSave';
  static const String vendorName                = 'vendorName';
  static const String selectVendorHint          = 'selectVendorHint';
  static const String billNumber                = 'billNumber';
  static const String billNumberHint            = 'billNumberHint';
  static const String taxRate                   = 'taxRate';
  static const String totalBillAmount           = 'totalBillAmount';
  static const String itemsDescription          = 'itemsDescription';
  static const String itemsDescHint             = 'itemsDescHint';
  static const String draft                     = 'draft';
  static const String vendorBillCreated         = 'vendorBillCreated';
  static const String postBill                  = 'postBill';
  static const String uploadInvoiceDoc          = 'uploadInvoiceDoc';
  static const String tapToSelectFile           = 'tapToSelectFile';
  static const String maxSize10Mb               = 'maxSize10Mb';
  static const String aiScanningDoc             = 'aiScanningDoc';
  static const String scanAndUpload             = 'scanAndUpload';
  static const String taxAdjustments            = 'taxAdjustments';
  static const String ifrs16Asset               = 'ifrs16Asset';
  static const String zakatLabel                = 'zakatLabel';
  static const String accountingDashboard       = 'accountingDashboard';
  static const String integratedBusinessManagementSystem = 'integratedBusinessManagementSystem';
}
