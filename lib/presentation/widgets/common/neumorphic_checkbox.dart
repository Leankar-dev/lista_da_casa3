import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class NeumorphicCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final double size;

  const NeumorphicCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Neumorphic(
            style: NeumorphicStyle(
              depth: value ? -4 : 4,
              intensity: AppConstants.neumorphicIntensity,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(6)),
            ),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: value ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      color: AppColors.textLight,
                      size: 16,
                    )
                  : null,
            ),
          ),
          if (label != null) ...[
            const SizedBox(width: AppConstants.smallPadding),
            Text(
              label!,
              style: TextStyle(
                color: value ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 14,
                decoration: value ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class NeumorphicRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final double size;

  const NeumorphicRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.size = 24,
  });

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Neumorphic(
            style: NeumorphicStyle(
              depth: _isSelected ? -4 : 4,
              intensity: AppConstants.neumorphicIntensity,
              boxShape: const NeumorphicBoxShape.circle(),
            ),
            child: Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: _isSelected
                  ? Center(
                      child: Container(
                        width: size / 2,
                        height: size / 2,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          if (label != null) ...[
            const SizedBox(width: AppConstants.smallPadding),
            Text(
              label!,
              style: TextStyle(
                color: _isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class NeumorphicSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  const NeumorphicSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
          const SizedBox(width: AppConstants.smallPadding),
        ],
        NeumorphicSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}
