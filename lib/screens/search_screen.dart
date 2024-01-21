/*
 * *
 *  * Created by NullByte08 in 2024.
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wit_by_bit/utils/constants.dart';

import 'home_page_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_sharp,
          ),
        ),
        title: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            contentPadding: EdgeInsets.all(0),
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(
              Icons.search,
            ),
            hintText: "Search",
          ),
        ),
      ),
      body: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.all(10),
              children: [
                for (int i = 0; i < listOfPizzas.length; i++)
                  (_controller.text.trim().isEmpty || listOfPizzas[i].toLowerCase().contains(_controller.text.toLowerCase().trim()))
                      ? FoodItemCard(
                          id: i,
                        )
                      : const SizedBox.shrink(),
              ],
            );
          }),
    );
  }
}
