import 'package:flutter/material.dart';
import 'package:about/about.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AboutPage(
        values: {
          'version': '0.1.0',
          'year': DateTime.now().year.toString(),
        },
        applicationLegalese: 'Copyright © Eliza "sech1p" Semeniuk, {{ year }}',
        applicationDescription:
            const Text('Keep and track your (detoxes from) addictions'),
        children: const <Widget>[
          MarkdownPageListTile(
            icon: Icon(Icons.list),
            title: Text('Changelog'),
            filename: 'CHANGELOG.md',
          ),
          MarkdownPageListTile(
            icon: Icon(Icons.description),
            title: Text('View License'),
            filename: 'LICENSE.md',
          ),
          MarkdownPageListTile(
            icon: Icon(Icons.share),
            title: Text('Contributing'),
            filename: 'CONTRIBUTING.md',
          ),
          MarkdownPageListTile(
            icon: Icon(Icons.sentiment_satisfied),
            title: Text('Code of conduct'),
            filename: 'CODE_OF_CONDUCT.md',
          ),
          LicensesPageListTile(
            icon: Icon(Icons.favorite),
            title: Text('Open source Licenses'),
          ),
        ],
      ),
    );
  }
}
