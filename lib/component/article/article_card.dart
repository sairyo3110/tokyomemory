import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleCard extends StatelessWidget {
  final Map<String, String?> article;

  ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _launchURL(article['href']),
        child: Row(
          children: [
            _buildImageSection(article['imageUrl']),
            _buildTextSection(article),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(String? imageUrl) {
    return Expanded(
      flex: 3,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _buildImage(imageUrl),
      ),
    );
  }

  Widget _buildTextSection(Map<String, String?> article) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildCategoryRow(article['category']),
            _buildTitle(article['title']),
            _buildDate(article['date']),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String? category) {
    return Row(
      children: [
        Icon(Icons.label, size: 10.0),
        SizedBox(width: 4.0),
        Expanded(
          child: Text(
            category ?? 'No Category',
            style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(String? title) {
    return Text(
      title ?? 'No Title',
      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDate(String? date) {
    return Text(
      date ?? 'No Date',
      style: TextStyle(fontSize: 8.0, color: Colors.grey.shade600),
    );
  }

  Widget _buildImage(String? imageUrl) {
    // Debug print statement

    if (imageUrl == null || imageUrl.isEmpty) {
      // URLがnullまたは空の場合にプレースホルダーを返します
      return const Icon(Icons.image_not_supported);
    }

    if (imageUrl.startsWith('data:image')) {
      // base64文字列です
      final base64Data = imageUrl.split('base64,')[1];
      Uint8List bytes;
      try {
        bytes = base64Decode(base64Data);
      } catch (e) {
        // Debug print statement for decode failure
        return const Icon(Icons.error);
      }
      return Image.memory(bytes, fit: BoxFit.cover);
    }

    // ネットワーク画像です
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Debug print statement for network image loading failures
        return const Icon(Icons.broken_image);
      },
    );
  }

  void _launchURL(String? url) async {
    if (url != null && await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
