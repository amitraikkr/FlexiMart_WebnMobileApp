
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/empty.svg',
          width: 150,
          height: 120,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
        const SizedBox(height: 8.0),
        Text(
          title,
          style: textTheme.bodySmall,
        )
      ],
    );
  }
}
