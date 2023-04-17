import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mochi/features/auth/presentation/widgets/slime.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      height: screenHeight * 0.2,
      width: double.infinity,
      child: Stack(
        children: [
          Slime(
            height: screenHeight * 0.6,
            width: double.infinity,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/brand/logo.svg',
              height: screenHeight * 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
