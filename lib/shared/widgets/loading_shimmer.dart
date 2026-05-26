import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';

class LoadingShimmer extends StatelessWidget {
  final int itemCount;
  final bool isGrid;

  const LoadingShimmer({
    super.key,
    this.itemCount = 6,
    this.isGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.surfaceBlack,
      highlightColor: AppTheme.cardBlack,
      child: isGrid ? _buildGridShimmer() : _buildListShimmer(),
    );
  }

  Widget _buildGridShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBlack,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  Widget _buildListShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.cardBlack,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}