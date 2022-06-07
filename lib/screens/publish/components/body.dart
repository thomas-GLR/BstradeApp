import 'package:flutter/material.dart';

import 'publish_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: <Widget>[
                PublishForm(),
              ], // Children
            ),
          ),
        ),
      ),
    );
  }
}
