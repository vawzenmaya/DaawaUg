import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<String> _searchHistory = [
    'Haji Mansor',
    'Lauren',
    'Dubai',
  ];

  final List<String> _youMayLike = [
    'Daawa Tok',
    'Kutuba',
    'Janah',
    'Jumah',
  ];

  List<String> _filteredResults = [];
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
              _filteredResults = _youMayLike
                  .where((like) =>
                      like.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            });
          },
          onSubmitted: (query) {
            setState(() {
              if (!_searchHistory.contains(query) && query.isNotEmpty) {
                _searchHistory.add(query);
              }
              _searchQuery = query;
              _filteredResults = _youMayLike
                  .where((like) =>
                      like.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Add settings functionality here
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Search History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ..._searchHistory.map((history) {
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(history),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        _searchHistory.remove(history);
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                  onTap: () {
                    setState(() {
                      _searchQuery = history;
                      _filteredResults = _youMayLike
                          .where((like) => like
                              .toLowerCase()
                              .contains(history.toLowerCase()))
                          .toList();
                    });
                  },
                );
              }).toList(),
              const SizedBox(height: 32),
              const Text(
                'You may like',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (_searchQuery.isEmpty)
                ..._youMayLike.map((like) {
                  return ListTile(
                    leading: const Icon(Icons.favorite),
                    title: Text(like),
                  );
                }).toList()
              else
                ..._filteredResults.map((result) {
                  return ListTile(
                    leading: const Icon(Icons.search),
                    title: Text(result),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
