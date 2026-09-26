import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';

import '../model/PharmacyNotification.dart';




class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationCategory _selectedCategory = NotificationCategory.all;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;
  String _searchQuery = '';

  late List<PharmacyNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = _getInitialNotifications();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PharmacyNotification> _getInitialNotifications() {
    final now = DateTime.now();
    return [
      PharmacyNotification(
        id: '1',
        title: 'Critical Low Stock: Amoxicillin 500mg',
        message:
            'Only 3 strips remaining in inventory. Minimum reorder threshold is 25.',
        category: NotificationCategory.inventory,
        priority: NotificationPriority.critical,
        timestamp: now.subtract(const Duration(minutes: 12)),
        isRead: false,
        actionLabel: 'Reorder Stock',
        details: {
          'Medicine': 'Amoxicillin 500mg (Cap)',
          'Batch': 'AMX-2024-B1',
          'Current Stock': '3 units',
          'Threshold': '25 units',
          'Preferred Supplier': 'Sun Pharma Logistics',
        },
      ),
      PharmacyNotification(
        id: '2',
        title: 'Batch Expiring Soon: Paracetamol 650mg',
        message:
            'Batch #PCM-8849 (45 strips) expires in 14 days on Oct 10, 2026.',
        category: NotificationCategory.expiry,
        priority: NotificationPriority.warning,
        timestamp: now.subtract(const Duration(hours: 1, minutes: 40)),
        isRead: false,
        actionLabel: 'Review Batch',
        details: {
          'Medicine': 'Paracetamol 650mg Dolo',
          'Batch': 'PCM-8849',
          'Expiry Date': '10 Oct 2026',
          'Remaining Units': '45 strips',
          'Action Needed': 'Apply near-expiry discount or return to vendor',
        },
      ),
      PharmacyNotification(
        id: '3',
        title: 'High-Value Bill Generated',
        message:
            'Invoice #INV-9281 generated for ₹4,850 via UPI payment by Rahul Sharma.',
        category: NotificationCategory.sales,
        priority: NotificationPriority.success,
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: false,
        actionLabel: 'View Invoice',
        details: {
          'Invoice ID': '#INV-9281',
          'Customer': 'Rahul Sharma',
          'Amount': '₹4,850.00',
          'Payment Mode': 'UPI / QR',
          'Cashier': 'Soumen M. (Counter 1)',
        },
      ),
      PharmacyNotification(
        id: '4',
        title: 'Staff Shift Check-in: Priya Sen',
        message:
            'Pharmacist Priya Sen clocked in at 09:02 AM at Main Counter.',
        category: NotificationCategory.staff,
        priority: NotificationPriority.info,
        timestamp: now.subtract(const Duration(hours: 5, minutes: 15)),
        isRead: true,
        actionLabel: 'Staff Profile',
        details: {
          'Staff Name': 'Priya Sen',
          'Role': 'Registered Pharmacist',
          'Clock-in Time': '09:02 AM',
          'Status': 'On Duty',
        },
      ),
      PharmacyNotification(
        id: '5',
        title: 'Daily Auto-Backup Completed',
        message:
            'Cloud sync successful. 1,420 medicine records and sales backed up securely.',
        category: NotificationCategory.system,
        priority: NotificationPriority.info,
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
        isRead: true,
        actionLabel: 'View Sync Log',
        details: {
          'Service': 'Encrypted Cloud Storage',
          'Items Synced': '1,420 Medicines, 342 Bills',
          'Status': 'Healthy',
          'Timestamp': 'Yesterday at 04:00 AM',
        },
      ),
      PharmacyNotification(
        id: '6',
        title: 'Low Stock Alert: Cetirizine 10mg',
        message:
            'Stock reached reorder point (8 strips left). Average weekly consumption: 20 strips.',
        category: NotificationCategory.inventory,
        priority: NotificationPriority.warning,
        timestamp: now.subtract(const Duration(days: 1, hours: 6)),
        isRead: true,
        actionLabel: 'Reorder Stock',
        details: {
          'Medicine': 'Cetirizine 10mg Tab',
          'Batch': 'CTZ-2023-A9',
          'Current Stock': '8 strips',
          'Weekly Sales': '22 strips',
        },
      ),
      PharmacyNotification(
        id: '7',
        title: 'Drug License Renewal Reminder',
        message:
            'Retail Drug License #DL-2021-9988 expires in 30 days. Renewal window is open.',
        category: NotificationCategory.system,
        priority: NotificationPriority.warning,
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
        actionLabel: 'License Details',
        details: {
          'License No': 'DL-2021-9988 / Form 20',
          'Issued To': 'Pharmace Care Meds',
          'Valid Till': '26 Oct 2026',
          'Authority': 'State Drugs Control Dept',
        },
      ),
    ];
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  List<PharmacyNotification> get _filteredNotifications {
    return _notifications.where((item) {
      if (_selectedCategory == NotificationCategory.unread && item.isRead) {
        return false;
      }
      if (_selectedCategory == NotificationCategory.inventory &&
          item.category != NotificationCategory.inventory) {
        return false;
      }
      if (_selectedCategory == NotificationCategory.expiry &&
          item.category != NotificationCategory.expiry) {
        return false;
      }
      if (_selectedCategory == NotificationCategory.sales &&
          item.category != NotificationCategory.sales) {
        return false;
      }
      if (_selectedCategory == NotificationCategory.staff &&
          item.category != NotificationCategory.staff) {
        return false;
      }
      if (_selectedCategory == NotificationCategory.system &&
          item.category != NotificationCategory.system) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(query);
        final matchMessage = item.message.toLowerCase().contains(query);
        return matchTitle || matchMessage;
      }

      return true;
    }).toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.done_all_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('All notifications marked as read'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear All Notifications?'),
        content: const Text(
          'This will remove all notifications from your list. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              final backup = List<PharmacyNotification>.from(_notifications);
              setState(() {
                _notifications.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('All notifications cleared'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: Colors.amberAccent,
                    onPressed: () {
                      setState(() {
                        _notifications = backup;
                      });
                    },
                  ),
                ),
              );
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _toggleNotificationRead(PharmacyNotification item) {
    setState(() {
      item.isRead = !item.isRead;
    });
  }

  void _deleteNotification(PharmacyNotification item) {
    final index = _notifications.indexOf(item);
    setState(() {
      _notifications.remove(item);
    });
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
              _notifications.insert(index, item);
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

  void _showNotificationSettingsSheet() {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeExtension>()!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
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
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notification Preferences',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  _buildSettingSwitch(
                    title: 'Low Stock Alerts',
                    subtitle: 'Notify when medicine quantity drops below threshold',
                    icon: Icons.inventory_2_outlined,
                    value: true,
                    onChanged: (val) {},
                    appColors: appColors,
                    theme: theme,
                  ),
                  _buildSettingSwitch(
                    title: 'Expiry Warnings',
                    subtitle: 'Alert 30 and 15 days before batch expiration date',
                    icon: Icons.warning_amber_rounded,
                    value: true,
                    onChanged: (val) {},
                    appColors: appColors,
                    theme: theme,
                  ),
                  _buildSettingSwitch(
                    title: 'Daily Sales & Cash Summaries',
                    subtitle: 'Receive shift closing sales and settlement alerts',
                    icon: Icons.receipt_long_outlined,
                    value: true,
                    onChanged: (val) {},
                    appColors: appColors,
                    theme: theme,
                  ),
                  _buildSettingSwitch(
                    title: 'Staff Check-ins & Attendance',
                    subtitle: 'Get notified when an employee clocks in or out',
                    icon: Icons.badge_outlined,
                    value: false,
                    onChanged: (val) {},
                    appColors: appColors,
                    theme: theme,
                  ),
                  _buildSettingSwitch(
                    title: 'Sound & Vibration',
                    subtitle: 'Play alert sound on critical pharmacy warnings',
                    icon: Icons.volume_up_outlined,
                    value: true,
                    onChanged: (val) {},
                    appColors: appColors,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Preferences saved successfully!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text('Save Preferences'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingSwitch({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    required AppThemeExtension appColors,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: appColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: theme.colorScheme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeExtension>()!;
    final filtered = _filteredNotifications;

    return Scaffold(
      appBar: AppBar(
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Material(
        //     color: theme.cardTheme.color ?? theme.colorScheme.surface,
        //     borderRadius: BorderRadius.circular(12),
        //     child: InkWell(
        //       borderRadius: BorderRadius.circular(12),
        //       onTap: () => Navigator.maybePop(context),
        //       child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        //     ),
        //   ),
        // ),
        title: Row(
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_unreadCount new',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Search alerts',
            icon: Icon(
              _isSearchExpanded ? Icons.search_off : Icons.search_rounded,
              color: _isSearchExpanded
                  ? theme.colorScheme.primary
                  : appColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                if (!_isSearchExpanded) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onSelected: (val) {
              if (val == 'read_all') {
                _markAllAsRead();
              } else if (val == 'clear_all') {
                _clearAllNotifications();
              } else if (val == 'settings') {
                _showNotificationSettingsSheet();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'read_all',
                child: Row(
                  children: [
                    Icon(Icons.done_all_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.tune_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Alert preferences'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_outlined,
                        size: 18, color: AppColors.error),
                    SizedBox(width: 10),
                    Text(
                      'Clear all',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Expandable Search Bar
            if (_isSearchExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search alerts, medicine name, batch...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: theme.cardTheme.color ?? theme.colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: appColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: appColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                ),
              ),

            // Horizontal Filter Chips
            Container(
              height: 48,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterChip(
                    category: NotificationCategory.all,
                    label: 'All',
                    count: _notifications.length,
                    theme: theme,
                  ),
                  _buildFilterChip(
                    category: NotificationCategory.unread,
                    label: 'Unread',
                    count: _unreadCount,
                    theme: theme,
                  ),
                  _buildFilterChip(
                    category: NotificationCategory.inventory,
                    label: 'Low Stock',
                    icon: Icons.inventory_2_outlined,
                    theme: theme,
                  ),
                  _buildFilterChip(
                    category: NotificationCategory.expiry,
                    label: 'Expiry Alerts',
                    icon: Icons.warning_amber_rounded,
                    theme: theme,
                  ),
                  _buildFilterChip(
                    category: NotificationCategory.sales,
                    label: 'Sales & Bills',
                    icon: Icons.receipt_long_outlined,
                    theme: theme,
                  ),
                  _buildFilterChip(
                    category: NotificationCategory.staff,
                    label: 'Staff',
                    icon: Icons.people_outline_rounded,
                    theme: theme,
                  ),
                  _buildFilterChip(
                    category: NotificationCategory.system,
                    label: 'System',
                    icon: Icons.shield_outlined,
                    theme: theme,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // List of Notifications or Empty State
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState(theme, appColors)
                  : RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(const Duration(milliseconds: 600));
                        setState(() {
                          _notifications = _getInitialNotifications();
                        });
                      },
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return _buildNotificationCard(
                            item: item,
                            theme: theme,
                            appColors: appColors,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required NotificationCategory category,
    required String label,
    int? count,
    IconData? icon,
    required ThemeData theme,
  }) {
    final isSelected = _selectedCategory == category;
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          setState(() {
            _selectedCategory = category;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? primary
                : theme.cardTheme.color ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? primary : Colors.grey.withValues(alpha: 0.2),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                ),
              ),
              if (count != null && count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.25)
                        : primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required PharmacyNotification item,
    required ThemeData theme,
    required AppThemeExtension appColors,
  }) {
    return Dismissible(
      key: Key(item.id),
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
      onDismissed: (_) => _deleteNotification(item),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showNotificationDetailSheet(item),
          child: Container(
            decoration: BoxDecoration(
              color: item.isRead
                  ? theme.cardTheme.color ?? theme.colorScheme.surface
                  : theme.colorScheme.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: item.isRead
                    ? appColors.border
                    : theme.colorScheme.primary.withValues(alpha: 0.35),
                width: item.isRead ? 1.0 : 1.5,
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
                    _buildNotificationIcon(item),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: item.isRead
                                        ? FontWeight.w600
                                        : FontWeight.bold,
                                    color: appColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (!item.isRead) ...[
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: appColors.textSecondary,
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
                          color: appColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTimeAgo(item.timestamp),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: appColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (item.actionLabel != null)
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              visualDensity: VisualDensity.compact,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => _handleActionTap(item),
                            child: Text(
                              item.actionLabel!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        IconButton(
                          tooltip: item.isRead ? 'Mark as unread' : 'Mark as read',
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            item.isRead
                                ? Icons.mark_email_unread_outlined
                                : Icons.mark_email_read_outlined,
                            size: 18,
                            color: appColors.textTertiary,
                          ),
                          onPressed: () => _toggleNotificationRead(item),
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

  Widget _buildNotificationIcon(PharmacyNotification item,
      {bool isLarge = false}) {
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
      PharmacyNotification item, AppThemeExtension appColors) {
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

  Widget _buildEmptyState(ThemeData theme, AppThemeExtension appColors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 40,
                  color: theme.colorScheme.primary.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No matching alerts'
                  : 'You\'re all caught up!',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No notifications match "$_searchQuery". Try searching with different terms.'
                  : 'There are no active notifications in this category. We\'ll notify you when stock or orders need attention.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: appColors.textTertiary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            if (_selectedCategory != NotificationCategory.all ||
                _searchQuery.isNotEmpty)
              OutlinedButton.icon(
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Show all notifications'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selectedCategory = NotificationCategory.all;
                    _searchController.clear();
                    _searchQuery = '';
                    _isSearchExpanded = false;
                  });
                },
              ),
          ],
        ),
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
}
