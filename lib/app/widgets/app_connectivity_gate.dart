import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/helpers/connectivity_helper.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';

class AppConnectivityGate extends StatefulWidget {
  const AppConnectivityGate({
    super.key,
    required this.child,
    this.onRetry,
  });

  final Widget child;
  final Future<void> Function()? onRetry;

  @override
  State<AppConnectivityGate> createState() => _AppConnectivityGateState();
}

class _AppConnectivityGateState extends State<AppConnectivityGate> {
  bool _isChecking = true;
  bool _isOffline = false;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _performInitialCheck();
  }

  Future<void> _performInitialCheck() async {
    final results = await ConnectivityHelper.checkConnectivity();
    if (!mounted) return;

    final online = ConnectivityHelper.isOnline(results);
    setState(() {
      _isOffline = !online;
      _isChecking = false;
    });
  }

  Future<void> _handleRetry() async {
    setState(() => _isRetrying = true);
    final results = await ConnectivityHelper.checkConnectivity();
    if (!mounted) return;

    final online = ConnectivityHelper.isOnline(results);
    if (online) {
      if (widget.onRetry != null) {
        await widget.onRetry!();
      }
      if (!mounted) return;
      setState(() {
        _isOffline = false;
        _isRetrying = false;
      });
    } else {
      setState(() => _isRetrying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Still offline. Please check your network connection.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SizedBox.expand(),
      );
    }

    if (_isOffline) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSize.size24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSize.size20),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wifi_off_rounded,
                      size: AppSize.size48,
                      color: AppColors.error,
                    ),
                  ),
                  AppGaps.gap20,
                  Text(
                    'No Internet Connection',
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  AppGaps.gap8,
                  Text(
                    'Please check your Wi-Fi or mobile data connection and try again.',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  AppGaps.gap24,
                  SizedBox(
                    height: AppSize.size48,
                    child: ElevatedButton.icon(
                      onPressed: _isRetrying ? null : _handleRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.borderRadius14,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.size24,
                        ),
                      ),
                      icon: _isRetrying
                          ? const SizedBox(
                              width: AppSize.size18,
                              height: AppSize.size18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : const Icon(Icons.refresh_rounded),
                      label: const Text('Try Again'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
