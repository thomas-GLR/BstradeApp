import 'package:flutter/material.dart';
import 'package:bstrade/services/storage_service.dart';

class ImageProduit extends StatelessWidget {
  const ImageProduit({
    Key key,
    this.product,
  }) : super(key: key);

  final Map<String, dynamic> product;

  //int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          //width: 238,
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: 1,
              child: FutureBuilder(
                  future: Storage().recupererImageURL(product['cheminImageCloudStorage'].toString()),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(snapshot.data),
                          ),
                        ),
                      );
                      /*
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.network(snapshot.data),
                            );*/
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    return Container(
                      child: Image.asset('assets/images/empty_image.png'),
                    );
                  }),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        /*Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(widget.product.images.length, (index) => buildSmallProductPreview(index)),
          ],
        )*/
      ],
    );
  }
  /*
  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.asset('assets/images/empty_image.png'),
      ),
    );*/
}
