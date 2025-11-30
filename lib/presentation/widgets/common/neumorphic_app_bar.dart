import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class CustomNeumorphicAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double height;

  const CustomNeumorphicAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(color: NeumorphicTheme.baseColor(context)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
        ),
        child: Row(
          children: [
            if (leading != null)
              leading!
            else if (Navigator.of(context).canPop())
              NeumorphicButton(
                onPressed: () => Navigator.of(context).pop(),
                style: const NeumorphicStyle(
                  depth: 4,
                  boxShape: NeumorphicBoxShape.circle(),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              )
            else
              const SizedBox(width: 40),
            Expanded(
              child: centerTitle
                  ? Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    )
                  : Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
            ),
            if (actions != null)
              Row(children: actions!)
            else
              const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class NeumorphicAppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;

  const NeumorphicAppBarAction({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: onPressed,
      style: const NeumorphicStyle(
        depth: 4,
        boxShape: NeumorphicBoxShape.circle(),
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(icon, size: 20, color: iconColor ?? AppColors.textPrimary),
    );
  }
}
