/// One account as returned by `ChartOfAccount/AccountsTree`.
///
/// The endpoint returns a flat list (like `ChartOfAccount/GetLight`) where every
/// account points at its parent through [accountParent]. [buildAccountsForest]
/// turns that flat list into the expandable tree shown on the organization page.
class AccountsTreeModel {
  final int accountNo;
  final int? accountType;
  final int? finalAccount;
  final int? acctNature;
  final int accountLevel;
  final String accountName;
  final String? eaccountName;
  final int? accountParent;
  final int? cauDistributed;
  final int? currencyCode;
  final String? currencyName;
  final double? currencyExchangeRate;

  const AccountsTreeModel({
    required this.accountNo,
    required this.accountLevel,
    required this.accountName,
    this.accountType,
    this.finalAccount,
    this.acctNature,
    this.eaccountName,
    this.accountParent,
    this.cauDistributed,
    this.currencyCode,
    this.currencyName,
    this.currencyExchangeRate,
  });

  factory AccountsTreeModel.fromJson(Map<String, dynamic> json) {
    return AccountsTreeModel(
      accountNo: _asInt(json['accountNo']) ?? 0,
      accountType: _asInt(json['accountType']),
      finalAccount: _asInt(json['finalAccount']),
      acctNature: _asInt(json['acctNature']),
      accountLevel: _asInt(json['accountLevel']) ?? 0,
      accountName: (json['accountName'] as String?)?.trim() ?? '',
      eaccountName: (json['eaccountName'] as String?)?.trim(),
      accountParent: _asInt(json['accountParent']),
      cauDistributed: _asInt(json['cauDistributed']),
      currencyCode: _asInt(json['currencyCode']),
      currencyName: (json['currencyName'] as String?)?.trim(),
      currencyExchangeRate: _asDouble(json['currencyExchangeRate']),
    );
  }

  /// Arabic name in Arabic locales, English name when available otherwise.
  String nameFor({required bool isArabic}) {
    final english = eaccountName;
    if (!isArabic && english != null && english.isNotEmpty) {
      return english;
    }
    return accountName;
  }
}

/// A node in the account hierarchy.
class AccountsTreeNode {
  final AccountsTreeModel account;
  final List<AccountsTreeNode> children;

  const AccountsTreeNode({
    required this.account,
    this.children = const <AccountsTreeNode>[],
  });
}

/// Builds the account hierarchy from the flat list returned by the endpoint.
///
/// Accounts whose parent is not part of the current page/result are treated as
/// roots so paged or filtered responses never lose rows.
List<AccountsTreeNode> buildAccountsForest(List<AccountsTreeModel> accounts) {
  final byNumber = <int, AccountsTreeModel>{};
  for (final account in accounts) {
    byNumber[account.accountNo] = account;
  }

  final unique = byNumber.values.toList();
  final childrenByParent = <int, List<AccountsTreeModel>>{};
  final roots = <AccountsTreeModel>[];

  for (final account in unique) {
    final parent = account.accountParent;
    if (parent != null &&
        parent != account.accountNo &&
        byNumber.containsKey(parent)) {
      childrenByParent
          .putIfAbsent(parent, () => <AccountsTreeModel>[])
          .add(account);
    } else {
      roots.add(account);
    }
  }

  int byAccountNo(AccountsTreeModel a, AccountsTreeModel b) =>
      a.accountNo.compareTo(b.accountNo);

  roots.sort(byAccountNo);
  for (final children in childrenByParent.values) {
    children.sort(byAccountNo);
  }

  final visited = <int>{};
  AccountsTreeNode buildNode(AccountsTreeModel account) {
    visited.add(account.accountNo);
    final children = <AccountsTreeNode>[];
    for (final child
        in childrenByParent[account.accountNo] ?? const <AccountsTreeModel>[]) {
      if (visited.contains(child.accountNo)) continue;
      children.add(buildNode(child));
    }
    return AccountsTreeNode(account: account, children: children);
  }

  final forest = <AccountsTreeNode>[for (final root in roots) buildNode(root)];

  // Defensive: a malformed parent cycle would otherwise hide accounts.
  for (final account in unique..sort(byAccountNo)) {
    if (!visited.contains(account.accountNo)) {
      forest.add(buildNode(account));
    }
  }

  return forest;
}

class AccountsTreeResponse {
  /// Flat accounts as received (useful when merging pages).
  final List<AccountsTreeModel> accounts;

  /// Accounts arranged as an expandable tree.
  final List<AccountsTreeNode> forest;

  final bool hasMore;
  final bool success;
  final String message;
  final int totalRecords;

  const AccountsTreeResponse({
    required this.accounts,
    required this.forest,
    required this.hasMore,
    required this.success,
    required this.message,
    required this.totalRecords,
  });

  factory AccountsTreeResponse.fromJson(Map<String, dynamic> json) {
    final raw = _pickAccountsList(json);
    final accounts = raw
        .whereType<Map<String, dynamic>>()
        .map(AccountsTreeModel.fromJson)
        .toList();

    return AccountsTreeResponse(
      accounts: accounts,
      forest: buildAccountsForest(accounts),
      hasMore: json['hasMore'] as bool? ?? false,
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      totalRecords: _asInt(json['totalRecords']) ?? accounts.length,
    );
  }
}

List<dynamic> _pickAccountsList(Map<String, dynamic> json) {
  for (final key in const ['chartOfAccounts', 'accountsTree', 'accounts']) {
    final value = json[key];
    if (value is List) return value;
  }
  return const <dynamic>[];
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
