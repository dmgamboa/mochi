import 'package:flutter/material.dart';

class CarouselItem extends StatelessWidget {
  final String image;
  final String heading;
  final String text;
  final Function()? onPressed;

  const CarouselItem({
    required this.image,
    required this.heading,
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            width: double.infinity,
            child: Image.asset(
              'assets/brand/logo_mascot.png',
              fit: BoxFit.contain,
              width: 0.6 * MediaQuery.of(context).size.width,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            children: [
              Text(
                'Heading',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Button',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
