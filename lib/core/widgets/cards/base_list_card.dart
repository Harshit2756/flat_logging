import 'package:flat_logging/core/theme/theme_extensions.dart';
import 'package:flat_logging/core/utils/constants/sizes.dart';
import 'package:flat_logging/core/utils/media/icons_strings.dart';
import 'package:flat_logging/core/utils/media/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseListCard extends StatelessWidget {
  final String name;
  final String roleText;
  final VoidCallback? onEdit;
  final VoidCallback? onCardTap;
  final VoidCallback? onDelete;
  final List<DetailTileData>? detailTiles;
  final Widget? extraWidget;
  final Color? statusBgColor;
  final Color? statusTextColor;
  final RxBool isExpanded = false.obs;
  final bool? isSelectable;
  final bool? isSelected;
  final Widget? leading;

  BaseListCard({
    super.key,
    required this.name,
    required this.roleText,
    this.onEdit,
    this.onDelete,
    this.detailTiles,
    this.extraWidget,
    this.statusBgColor,
    this.statusTextColor,
    this.onCardTap,
    this.isSelectable,
    this.isSelected,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        elevation: HSizes.elevationLevel4,
        shadowColor: context.colorScheme.primary.withValues(alpha: 0.3),
        margin: const EdgeInsets.symmetric(vertical: HSizes.spacingSM, horizontal: HSizes.spacingMD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HSizes.radiusMD),
          side: BorderSide(color: isSelected == true ? context.colorScheme.primary : Colors.grey.shade200, width: isSelected == true ? 2 : 1),
        ),
        // color: isSelected == true ? context.colorScheme.primary.withValues(alpha:0.5) : null,
        child: InkWell(
          onTap: onCardTap ?? toggleExpanded,
          borderRadius: BorderRadius.circular(HSizes.radiusMD),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(HSizes.spacingSM),
                child: Row(
                  children: [
                    if (leading != null) ...[leading!, const SizedBox(width: HSizes.spacingSM)],
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: context.colorScheme.primary.withValues(alpha: 0.2), blurRadius: HSizes.spacingSM, offset: const Offset(0, 2))],
                      ),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: ClipOval(child: Icon(Icons.local_laundry_service_sharp, size: 30, color: context.colorScheme.primary)),
                      ),
                    ),
                    const SizedBox(width: HSizes.spacingSM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: context.colorScheme.primary),
                          ),
                          const SizedBox(height: HSizes.spacingXS),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: HSizes.spacingSM, vertical: HSizes.spacingXS / 2),
                            decoration: BoxDecoration(
                              color: statusBgColor ?? context.colorScheme.primary.withValues(alpha: 0.1),
                              border: Border.all(color: statusBgColor ?? context.colorScheme.primary.withValues(alpha: 0.5), width: 2),
                              borderRadius: BorderRadius.circular(HSizes.radiusMD),
                            ),
                            child: Text(
                              roleText,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: statusTextColor ?? context.colorScheme.primary, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onEdit != null || onDelete != null)
                      PopupMenuButton(
                        icon: Icon(HIcons.menu, color: Colors.grey[600], size: HSizes.spacingMD),
                        elevation: HSizes.elevationLevel4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HSizes.spacingSM)),
                        itemBuilder: (context) => [
                          if (onEdit != null)
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(HIcons.edit, size: HSizes.spacingMD, color: context.colorScheme.primary),
                                  const SizedBox(width: HSizes.spacingSM),
                                  Text(HTexts.edit, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          if (onDelete != null)
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(HIcons.delete, size: HSizes.spacingMD, color: context.colorScheme.error),
                                  const SizedBox(width: HSizes.spacingSM),
                                  Text(HTexts.delete, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit' && onEdit != null) {
                            onEdit!();
                          } else if (value == 'delete' && onDelete != null) {
                            onDelete!();
                          }
                        },
                      ),
                    if (detailTiles != null)
                      IconButton(
                        icon: Icon(isExpanded.value ? HIcons.collapse : HIcons.expande, color: Colors.grey[600]),
                        onPressed: toggleExpanded,
                      ),
                  ],
                ),
              ),
              if (extraWidget != null) extraWidget!,
              if (isExpanded.value && detailTiles != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(HSizes.radiusMD, 0, HSizes.radiusMD, HSizes.radiusMD),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(HSizes.radiusMD),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: List.generate(
                      detailTiles!.length,
                      (index) =>
                          _buildDetailTile(context, icon: detailTiles![index].icon, label: detailTiles![index].label, value: detailTiles![index].value, isLast: index == detailTiles!.length - 1),
                    ),
                  ),
                ),

              const SizedBox(height: HSizes.spacingSM),
            ],
          ),
        ),
      ),
    );
  }

  void toggleExpanded() => isExpanded.value = !isExpanded.value;

  Widget _buildDetailTile(BuildContext context, {required IconData icon, required String label, required String value, bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(HSizes.spacingSM),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(HSizes.spacingXS),
                decoration: BoxDecoration(color: context.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(HSizes.spacingXS)),
                child: Icon(icon, size: HSizes.spacingMD, color: context.colorScheme.primary),
              ),
              const SizedBox(width: HSizes.spacingSM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[800], fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: HSizes.elevationLevel1, thickness: HSizes.elevationLevel1, color: Colors.grey.shade200),
      ],
    );
  }
}

class DetailTileData {
  final IconData icon;
  final String label;
  final String value;

  DetailTileData({required this.icon, required this.label, required this.value});
}
