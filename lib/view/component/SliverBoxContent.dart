import 'package:flutter/material.dart';

class SliverBoxContent extends StatelessWidget {
  final Widget child;

  SliverBoxContent({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverToBoxAdapter(
        child: child,
      ),
    );
  }
}