import 'package:flutter/material.dart';

class SortButton extends StatelessWidget {
  final bool sortBySeen;
  final ValueChanged<bool> onSortChanged;

  SortButton({required this.sortBySeen, required this.onSortChanged});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        sortBySeen ? Icons.sort_by_alpha : Icons.sort,
        color: Colors.black,
      ),
      onPressed: () {
        onSortChanged(!sortBySeen);
      },
    );
  }
}
