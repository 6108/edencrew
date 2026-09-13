import 'package:edencrew_assignment_starter/widgets/watchlist_empty.dart';
import 'package:edencrew_assignment_starter/widgets/watchlist_header.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        child: Column(
          children: [
            const WatchlistHeader(),
            const Expanded(child: WatchlistEmpty()),
          ],
        ),
      ),
    );
  }
}
