import 'package:flutter/material.dart';

import 'package:bstrade/services/storage_service.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key key,
    this.utilisateurActuelle,
  }) : super(key: key);

  final Map<String, dynamic> utilisateurActuelle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
            child: FutureBuilder(
                future: Storage().recupererImageURL(utilisateurActuelle['cheminImageCloudStorage'].toString()),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data),
                      backgroundColor: Colors.white,
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return CircleAvatar(
                    backgroundImage: AssetImage("assets/images/profile_image.png"),
                    backgroundColor: Colors.white,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
