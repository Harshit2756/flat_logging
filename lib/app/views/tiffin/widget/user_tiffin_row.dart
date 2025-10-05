import 'package:flat_logging/app/models/user_model.dart';
import 'package:flat_logging/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class UserTiffinRow extends StatelessWidget {
  final UserModel user;
  final String date;
  final int quantity; // This represents "shares" now
  final double? calculatedQuantity; // Actual tiffin quantity
  final bool isSelected;
  final VoidCallback? onDateTap;
  final VoidCallback? onSelectionChanged;
  final VoidCallback? onQuantityDecrease;
  final VoidCallback? onQuantityIncrease;

  const UserTiffinRow({
    super.key,
    required this.user,
    required this.date,
    required this.quantity,
    this.calculatedQuantity,
    required this.isSelected,
    this.onDateTap,
    this.onSelectionChanged,
    this.onQuantityDecrease,
    this.onQuantityIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: HSizes.spacingXS),
      child: Padding(
        padding: const EdgeInsets.all(HSizes.spacingMD),
        child: Column(
          children: [
            Row(
              children: [
                // Selection Checkbox
                GestureDetector(
                  onTap: onSelectionChanged,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                      border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade400, width: 2),
                    ),
                    child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                  ),
                ),
                const SizedBox(width: HSizes.spacingMD),

                // User Avatar/Initial
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.3), width: 1),
                  ),
                  child: Center(
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: HSizes.spacingMD),

                // User Name and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: HSizes.spacingXS),
                      GestureDetector(
                        onTap: onDateTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: HSizes.spacingSM, vertical: HSizes.spacingXS),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: HSizes.spacingXS),
                              Text(date, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Shares Counter (renamed from Quantity)
                Column(
                  children: [
                    Text('Shares', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600, fontSize: 10)),
                    const SizedBox(height: HSizes.spacingXS),
                    Row(
                      children: [
                        // Decrease Button
                        GestureDetector(
                          onTap: quantity > 0 ? onQuantityDecrease : null,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: quantity > 0 ? Colors.grey.shade200 : Colors.grey.shade100,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Icon(Icons.remove, size: 16, color: quantity > 0 ? Colors.grey.shade700 : Colors.grey.shade400),
                          ),
                        ),
                        const SizedBox(width: HSizes.spacingSM),

                        // Shares Display
                        Container(
                          constraints: const BoxConstraints(minWidth: 40),
                          child: Text(
                            quantity.toString(),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: HSizes.spacingSM),

                        // Increase Button
                        GestureDetector(
                          onTap: onQuantityIncrease,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Icon(Icons.add, size: 16, color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Show calculated quantity if selected
            if (isSelected && calculatedQuantity != null && calculatedQuantity! > 0)
              Padding(
                padding: const EdgeInsets.only(top: HSizes.spacingSM),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: HSizes.spacingSM, vertical: HSizes.spacingXS),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    'Will receive: ${calculatedQuantity!.toStringAsFixed(2)} tiffins',
                    style: TextStyle(color: Colors.green.shade900, fontSize: 12, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
