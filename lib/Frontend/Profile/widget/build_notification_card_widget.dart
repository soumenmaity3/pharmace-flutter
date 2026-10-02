import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_theme_extension.dart';
import '../model/PharmacyNotification.dart';

class BuildNotificationCardWidget extends StatefulWidget {
  const BuildNotificationCardWidget({
    super.key,
    required this.item,
    required this.theme,
    required this.appColors,
    required this._notifications,
    this.onDelete,
  });

  final PharmacyNotification item;
  final ThemeData theme;
  final AppThemeExtension appColors;
  final List<PharmacyNotification> _notifications;
  final VoidCallback? onDelete;

  @override
  State<BuildNotificationCardWidget> createState() =>
      _BuildNotificationCardWidgetState();
}

class _BuildNotificationCardWidgetState
    extends State<BuildNotificationCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => _deleteNotification(widget.item),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showNotificationDetailSheet(widget.item),
          child: Container(
            decoration: BoxDecoration(
              color: widget.item.isRead
                  ? widget.theme.cardTheme.color ??
                        widget.theme.colorScheme.surface
                  : widget.theme.colorScheme.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.item.isRead
                    ? widget.appColors.border
                    : widget.theme.colorScheme.primary.withValues(alpha: 0.35),
                width: widget.item.isRead ? 1.0 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNotificationIcon(widget.item),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: widget.theme.textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: widget.item.isRead
                                            ? FontWeight.w600
                                            : FontWeight.bold,
                                        color: widget.appColors.textPrimary,
                                      ),
                                ),
                              ),
                              if (!widget.item.isRead) ...[
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: widget.theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.item.message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: widget.theme.textTheme.bodySmall?.copyWith(
                              color: widget.appColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: widget.appColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTimeAgo(widget.item.timestamp),
                          style: widget.theme.textTheme.labelSmall?.copyWith(
                            color: widget.appColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (widget.item.actionLabel != null)
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              visualDensity: VisualDensity.compact,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => _handleActionTap(widget.item),
                            child: Text(
                              widget.item.actionLabel!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: widget.theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        IconButton(
                          tooltip: widget.item.isRead
                              ? 'Mark as unread'
                              : 'Mark as read',
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            widget.item.isRead
                                ? Icons.mark_email_unread_outlined
                                : Icons.mark_email_read_outlined,
                            size: 18,
                            color: widget.appColors.textTertiary,
                          ),
                          onPressed: () => _toggleNotificationRead(widget.item),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleNotificationRead(PharmacyNotification item) {
    setState(() {
      item.isRead = !item.isRead;
    });
  }

  void _deleteNotification(PharmacyNotification item) {
    print('called delete');
    final index = widget._notifications.indexOf(item);
    widget._notifications.remove(item);
    widget.onDelete?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed "${item.title}"'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.amberAccent,
          onPressed: () {
            setState(() {
              widget._notifications.insert(index, item);
              widget.onDelete?.call();
            });
          },
        ),
      ),
    );
  }

  void _showNotificationDetailSheet(PharmacyNotification item) {
    if (!item.isRead) {
      setState(() {
        item.isRead = true;
      });
    }

    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeExtension>()!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.of(ctx).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNotificationIcon(item, isLarge: true),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategoryBadge(item, appColors),
                        const SizedBox(height: 6),
                        Text(
                          item.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDetailedTime(item.timestamp),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: appColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                item.message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: appColors.textSecondary,
                ),
              ),
              if (item.details != null && item.details!.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'Event Details',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color ?? theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: appColors.border),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: item.details!.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                entry.key,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: appColors.textTertiary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: appColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Dismiss'),
                    ),
                  ),
                  if (item.actionLabel != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _handleActionTap(item);
                        },
                        child: Text(item.actionLabel!),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleActionTap(PharmacyNotification item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action "${item.actionLabel}" triggered.'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }

  String _formatDetailedTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final day = time.day.toString().padLeft(2, '0');
    final month = time.month.toString().padLeft(2, '0');
    return '$day/$month/${time.year} at $hour:$minute';
  }

  Widget _buildNotificationIcon(
    PharmacyNotification item, {
    bool isLarge = false,
  }) {
    Color bgColor;
    Color iconColor;
    IconData icon;

    switch (item.priority) {
      case NotificationPriority.critical:
        bgColor = AppColors.errorLight;
        iconColor = AppColors.error;
        icon = Icons.error_outline_rounded;
        break;
      case NotificationPriority.warning:
        bgColor = AppColors.warningLight;
        iconColor = AppColors.warning;
        icon = Icons.warning_amber_rounded;
        break;
      case NotificationPriority.success:
        bgColor = AppColors.successLight;
        iconColor = AppColors.success;
        icon = Icons.check_circle_outline_rounded;
        break;
      case NotificationPriority.info:
        bgColor = AppColors.primaryContainer;
        iconColor = AppColors.primary;
        if (item.category == NotificationCategory.staff) {
          icon = Icons.badge_outlined;
        } else {
          icon = Icons.notifications_none_rounded;
        }
        break;
    }

    final size = isLarge ? 48.0 : 40.0;
    final iconSize = isLarge ? 24.0 : 20.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(isLarge ? 14 : 12),
      ),
      child: Center(
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }

  Widget _buildCategoryBadge(
    PharmacyNotification item,
    AppThemeExtension appColors,
  ) {
    Color color;
    String label;

    switch (item.category) {
      case NotificationCategory.inventory:
        color = AppColors.error;
        label = 'INVENTORY ALERT';
        break;
      case NotificationCategory.expiry:
        color = AppColors.warning;
        label = 'EXPIRY WARNING';
        break;
      case NotificationCategory.sales:
        color = AppColors.success;
        label = 'SALES UPDATE';
        break;
      case NotificationCategory.staff:
        color = AppColors.primary;
        label = 'STAFF & ATTENDANCE';
        break;
      case NotificationCategory.system:
        color = appColors.textSecondary;
        label = 'SYSTEM NOTICE';
        break;
      default:
        color = AppColors.primary;
        label = 'NOTIFICATION';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
