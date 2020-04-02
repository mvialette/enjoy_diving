import 'package:flutter/material.dart';

class SliverGroupHeader extends StatelessWidget {

  final String header;

  SliverGroupHeader({
    Key key,
    @required this.header,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              header,
              style: theme.textTheme.headline,
            ),
            Padding(
              padding: EdgeInsets.only(right: 64),
              child: Container(
                height: 2,
                color: theme.accentColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}