import 'package:flat_logging/core/utils/constants/sizes.dart';
import 'package:flat_logging/core/utils/media/icons_strings.dart';
import 'package:flutter/material.dart';

class HSearchBar extends StatelessWidget {
  final SearchController searchController;
  final String hintText;

  const HSearchBar({
    super.key,
    required this.searchController,
    this.hintText = 'Search',
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      backgroundColor: const WidgetStatePropertyAll(Colors.white),
      // shadowColor: const WidgetStatePropertyAll(HColors.primary),
      elevation: const WidgetStatePropertyAll(0.0),
      side: WidgetStatePropertyAll(
        BorderSide(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      controller: searchController,
      hintText: hintText,
      leading: const Padding(
          padding: EdgeInsets.all(HSizes.spacingSM),
          child: Icon(HIcons.search, color: Colors.black)),
      trailing: [
        Padding(
          padding: const EdgeInsets.all(HSizes.spacingSM),
          child: IconButton(
            onPressed: () => searchController.clear(),
            icon: const Icon(HIcons.close, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
