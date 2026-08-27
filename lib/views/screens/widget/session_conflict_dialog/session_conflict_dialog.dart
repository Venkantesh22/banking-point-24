import 'dart:async';

import 'package:flutter/material.dart';

class SessionConflictDialog extends StatefulWidget {
  final VoidCallback onLogout;

  const SessionConflictDialog({
    super.key,
    required this.onLogout,
  });

  @override
  State<SessionConflictDialog> createState() =>
      _SessionConflictDialogState();
}

class _SessionConflictDialogState extends State<SessionConflictDialog> {
  int remainingSeconds = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (remainingSeconds > 1) {
          setState(() {
            remainingSeconds--;
          });
        } else {
          timer.cancel();

          // Close this dialog first.
          Navigator.of(context).pop();

          // Then logout.
          widget.onLogout();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Login Warning',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your account has been logged in on another mobile device using the same login credentials.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Text(
                '$remainingSeconds',
                key: ValueKey(remainingSeconds),
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              remainingSeconds == 1
                  ? 'Logging out...'
                  : 'Logging out automatically',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _timer?.cancel();

                Navigator.of(context).pop();

                widget.onLogout();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Logout Now',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}