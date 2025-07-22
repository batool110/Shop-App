import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AnimatedFavoriteButton extends StatefulWidget {
  final int favoriteCount;
  final VoidCallback onPressed;

  const AnimatedFavoriteButton({
    super.key,
    required this.favoriteCount,
    required this.onPressed,
  });

  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(AnimatedFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.favoriteCount != oldWidget.favoriteCount) {
      _pulseController.forward().then((_) {
        _pulseController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _pulseAnimation.value,
          child: FloatingActionButton.extended(
            onPressed: () {
              _scaleController.forward().then((_) {
                _scaleController.reverse();
              });
              widget.onPressed();
            },
            backgroundColor: AppColors.favorite,
            foregroundColor: AppColors.surface,
            elevation: 8,
            icon: const Icon(Icons.favorite),
            label: Text(
              'Favorites ${widget.favoriteCount > 0 ? '(${widget.favoriteCount})' : ''}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        );
      },
    );
  }
}
