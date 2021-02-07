import 'package:drag_drop_editable/drag_drop/controllers/ImageBoxController.dart';
import 'package:drag_drop_editable/drag_drop/widget/BoxWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<ImageBoxController> _boxWidgets = [];
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Container(
          width: _size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    width: _size.width / 1.1,
                    height: _size.height / 1.4,
                    decoration: BoxDecoration(
                        color: Color(0xffefefef),
                        border:
                            Border.all(width: 2.1, color: Colors.redAccent)),
                    child: ClipRect(
                        child: Stack(children: [
                      for (var box in _boxWidgets) box.widget
                    ]))),
                ElevatedButton(
                  child: Text('add new box'),
                  onPressed: () async {
                    final image =
                        await _picker.getImage(source: ImageSource.gallery);
                    if (image == null) return;

                    final imageData = await image.readAsBytes();
                    final controller = ImageBoxController.init(imageData);
                    _boxWidgets.add(controller);
                    setState(() {});
                  },
                ),
                Expanded(
                    child: ListView(children: [
                  for (var i = 0; i < _boxWidgets.length; i++) editImageBox(i)
                ]))
              ]),
        ),
      ),
    );
  }

  Widget editImageBox(int index) {
    final ImageBoxController item = _boxWidgets[index];
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(64),
            child: Image.memory(item.value.bytes,
                width: 64, height: 64, fit: BoxFit.cover),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            child: Text('change image',
                style: TextStyle(color: Colors.blueAccent)),
            onPressed: () async {
              final image = await _picker.getImage(source: ImageSource.gallery);
              if (image == null) return;

              final imageData = await image.readAsBytes();
              item.update(bytes: imageData);
              setState(() {});
            },
          ),
        ]),
        IconButton(
            icon: Icon(Icons.close, color: Colors.redAccent),
            onPressed: () {
              setState(() => _boxWidgets.removeAt(index));
            })
      ]),
    );
  }
}
