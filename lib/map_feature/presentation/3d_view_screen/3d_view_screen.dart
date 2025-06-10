import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class ThreeDViewScreen extends StatefulWidget {
  const ThreeDViewScreen({super.key, required this.title});
  final String title;
  @override
  ThreeDViewScreenState createState() => ThreeDViewScreenState();
}

class ThreeDViewScreenState extends State<ThreeDViewScreen> {
  PanoramaController panoramaController = PanoramaController();
  double _latitudeDegrees = 0; // Slider value in degrees
  double _longitudeDegrees = 0; // Slider value in degrees
  double _tilt = 0;
  int _panoId = 0;

  List<Image> panoImages = [
    Image.asset('assets/panorama1.webp'),
    Image.asset('assets/panorama2.webp'),
    Image.asset('assets/panorama3.webp'),
  ];

  void _zoomIn() {
    panoramaController.setZoom(panoramaController.getZoom() + 0.5);
  }

  void _zoomOut() {
    panoramaController.setZoom(panoramaController.getZoom() - 0.5);
  }

  Widget hotspotButton(
      {String? text, IconData? icon, VoidCallback? onPressed}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(const CircleBorder()),
            backgroundColor: WidgetStateProperty.all(Colors.black38),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          onPressed: onPressed,
          child: Icon(icon),
        ),
        text != null
            ? Container(
          padding: const EdgeInsets.all(4.0),
          decoration: const BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Center(child: Text(text)),
        )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget panorama;
    switch (_panoId % panoImages.length) {
      case 0:
        panorama =  PanoramaViewer(
          animSpeed: .1,
          sensitivity: 2,
          sensorControl: SensorControl.orientation,
          panoramaController: panoramaController,
          onTap: (longitude, latitude, tilt) =>
              print('onTap: $longitude, $latitude, $tilt'),
          child: Image.asset('assets/pano_1d.webp'),
          hotspots: [
            Hotspot(
              latitude: -15.0,
              longitude: -129.0,
              width: 90,
              height: 80,
              widget: hotspotButton(
                  text: "Next scene",
                  icon: Icons.open_in_browser,
                  onPressed: () {
                  setState((){
                  _panoId = 1;
                  });
                  panoramaController.setView(2.179, -149.9);

              }),
            ),
          ],
        );
        break;
      case 1:
        panorama = PanoramaViewer(
    animSpeed: .1,
    sensorControl: SensorControl.orientation,
    panoramaController: panoramaController,
    child: Image.asset('assets/pano_2.webp'),
          onTap: (longitude, latitude, tilt) =>
              print('onTap pano 2: $longitude, $latitude, $tilt'),

          hotspots: [
    Hotspot(
    latitude: -2.6,
    longitude: 10.730794346580678,
    width: 90,
    height: 80,
    widget: hotspotButton(
    text: "Next scene",
    icon: Icons.open_in_browser,
    onPressed: () => setState(() => _panoId = 0)),
    ),
    ],
    );
        break;
      default:
        panorama = PanoramaViewer(
          animSpeed: .1,
          sensorControl: SensorControl.orientation,
          panoramaController: panoramaController,
          child: Image.asset('assets/panorama1.webp'),
          hotspots: [
            Hotspot(
              latitude: -15.0,
              longitude: -129.0,
              width: 90,
              height: 80,
              widget: hotspotButton(
                  text: "Next scene",
                  icon: Icons.open_in_browser,
                  onPressed: (){
                    panoramaController.setView(2.179, -149.9);
                    setState((){
                      _panoId = 1;
                    });

                  }),
            ),
          ],
        );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          panorama,
          Positioned(
            right: 10,
            top: 100,
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                min: -180,
                max: 180,
                value: _latitudeDegrees,
                onChanged: (value) {
                  setState(() {
                    _latitudeDegrees = value;
                  });
                  panoramaController.setView(
                    _latitudeDegrees,
                    _longitudeDegrees,
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 100,
            child: Slider(
              min: -90,
              max: 90,
              value: _longitudeDegrees,
              onChanged: (value) {
                setState(() {
                  _longitudeDegrees = value;
                });
                panoramaController.setView(
                  _latitudeDegrees,
                  _longitudeDegrees,
                );
              },
            ),
          ),
          Positioned(
            bottom: 50,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoomInBtn",
                  onPressed: _zoomIn,
                  tooltip: 'Zoom In',
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 10), // Space between buttons
                FloatingActionButton(
                  heroTag: "zoomOutBtn",
                  onPressed: _zoomOut,
                  tooltip: 'Zoom Out',
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
