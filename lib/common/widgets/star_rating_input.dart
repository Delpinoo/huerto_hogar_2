import 'package:flutter/material.dart';

class StarRatingInput extends StatefulWidget {
  // Callback para avisar al widget padre cuál es la nueva puntuación
  final Function(int rating) onRatingChanged;

  const StarRatingInput({super.key, required this.onRatingChanged});

  @override
  State<StarRatingInput> createState() => _StarRatingInputState();
}

class _StarRatingInputState extends State<StarRatingInput> {
  int _currentRating = 0; // El estado local de las estrellas

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              _currentRating = index + 1;
            });
            // Llama al callback
            widget.onRatingChanged(_currentRating);
          },
          icon: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 40,
          ),
        );
      }),
    );
  }
}