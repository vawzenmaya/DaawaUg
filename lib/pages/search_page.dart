import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toktok/api_config.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> videos = [];
  List<dynamic> channels = [];
  List<dynamic> filteredResults = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(_filterResults);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterResults);
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final videoResponse = await http.get(Uri.parse(ApiConfig.fetchVideosUrl));
      final channelResponse =
          await http.get(Uri.parse(ApiConfig.fetchChannelsUrl));

      if (videoResponse.statusCode == 200 &&
          channelResponse.statusCode == 200) {
        setState(() {
          videos = json.decode(videoResponse.body);
          channels = json.decode(channelResponse.body);
          filteredResults = [...videos, ...channels];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle the exception
      // ignore: avoid_print
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterResults() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredResults = [
        ...videos.where((video) {
          return (video['title']?.toLowerCase() ?? '').contains(query) ||
              (video['description']?.toLowerCase() ?? '').contains(query);
        }),
        ...channels.where((channel) {
          return (channel['channelName']?.toLowerCase() ?? '').contains(query);
        })
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search videos or channels',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        searchController.clear();
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredResults.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: filteredResults.length,
                  itemBuilder: (context, index) {
                    final result = filteredResults[index];
                    return ListTile(
                      leading: result['videoId'] != null
                          ? const Icon(Icons.video_library)
                          : const Icon(Icons.donut_small),
                      title:
                          Text(result['title'] ?? result['channelName'] ?? ''),
                      subtitle: Text(result['description'] ??
                          result['channelDescription'] ??
                          ''),
                    );
                  },
                ),
    );
  }
}
