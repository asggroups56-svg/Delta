import 'package:flutter/material.dart';

import 'package:my_template/core/theme/app_colors.dart';

/// A top-level business section the user can start from after signing in.
class WorkspaceModule {
  final String id;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final IconData icon;
  final Color color;

  const WorkspaceModule({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.icon,
    required this.color,
  });

  String title(bool isArabic) => isArabic ? titleAr : titleEn;

  String description(bool isArabic) => isArabic ? descriptionAr : descriptionEn;
}

const List<WorkspaceModule> workspaceModules = [
  WorkspaceModule(
    id: 'accounting',
    titleAr: 'المحاسبة',
    titleEn: 'Accounting',
    descriptionAr: 'القيود والحسابات والتقارير المالية',
    descriptionEn: 'Journals, ledgers and financial reports',
    icon: Icons.account_balance_rounded,
    color: AppColor.emeraldTeal,
  ),
  WorkspaceModule(
    id: 'assets',
    titleAr: 'الأصول',
    titleEn: 'Assets',
    descriptionAr: 'الأصول الثابتة والإهلاك والعهد',
    descriptionEn: 'Fixed assets, depreciation and custody',
    icon: Icons.domain_rounded,
    color: AppColor.oceanBlue,
  ),
  WorkspaceModule(
    id: 'sales',
    titleAr: 'المبيعات',
    titleEn: 'Sales',
    descriptionAr: 'الفواتير والعملاء والتحصيل',
    descriptionEn: 'Invoices, customers and collections',
    icon: Icons.point_of_sale_rounded,
    color: AppColor.indigoLight,
  ),
  WorkspaceModule(
    id: 'purchases',
    titleAr: 'المشتريات',
    titleEn: 'Purchases',
    descriptionAr: 'أوامر الشراء والموردون والمصروفات',
    descriptionEn: 'Purchase orders, vendors and expenses',
    icon: Icons.shopping_cart_rounded,
    color: AppColor.warningOrange,
  ),
  WorkspaceModule(
    id: 'inventory',
    titleAr: 'المخزون',
    titleEn: 'Inventory',
    descriptionAr: 'الأصناف والمستودعات وحركة المخزون',
    descriptionEn: 'Items, warehouses and stock movements',
    icon: Icons.inventory_2_rounded,
    color: Color(0xFF7C3AED),
  ),
];

WorkspaceModule? workspaceModuleById(String? id) {
  if (id == null || id.isEmpty) return null;
  for (final module in workspaceModules) {
    if (module.id == id) return module;
  }
  return null;
}
