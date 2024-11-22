import 'package:flutter/material.dart';

class NumPad extends StatelessWidget {
  final Function(String) onNumberSelected;

  const NumPad({super.key, required this.onNumberSelected});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        if (index == 9) {
          return const SizedBox.shrink();
        }
        if (index == 10) {
          return NumButton(
            text: '0',
            onTap: () => onNumberSelected('0'),
          );
        }
        if (index == 11) {
          return NumButton(
            text: '.',
            onTap: () => onNumberSelected('.'),
          );
        }
        return NumButton(
          text: '${index + 1}',
          onTap: () => onNumberSelected('${index + 1}'),
        );
      },
    );
  }
}

class NumButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const NumButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
