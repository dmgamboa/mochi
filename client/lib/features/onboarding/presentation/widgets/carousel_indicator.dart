import 'package:flutter/material.dart';

class CarouselIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const CarouselIndicator({
    required this.currentPage,
    required this.pageCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pageCount,
        itemBuilder: (context, index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentPage == index
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.background,
            ),
          );
        },
      ),
    );
  }
}
