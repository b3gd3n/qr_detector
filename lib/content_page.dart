import 'package:flutter/material.dart';

class Content extends StatelessWidget {
  final String url;
  const Content({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: Container(
        child: Center(
          child: (url != '') ? Text(url) : const Text('no content'),
        ),
      ),
    );
  }
}
