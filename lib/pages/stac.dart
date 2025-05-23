import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

class StacJsonWidget extends StatefulWidget {
  final String jsonPath;  // To pass the JSON file path or URL

  const StacJsonWidget({required this.jsonPath});

  @override
  _StacJsonWidgetState createState() => _StacJsonWidgetState();
}

class _StacJsonWidgetState extends State<StacJsonWidget> {
  Widget? _ui;

  @override
  void initState() {
    super.initState();
    loadUI();
  }

  Future<void> loadUI() async {
    // Use the fromNetwork method to load UI directly from the URL
    final mwidget = await Stac.fromNetwork(      request: StacNetworkRequest(
      url: widget.jsonPath,
    ),
      context: context,
    );
    print(mwidget);

    setState(() {
      _ui = mwidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.black, // Center color
            Colors.transparent,             // Outer transparent
          ],
          center: Alignment.center,
          radius: 1, // Control spread of gradient
        ),
      ),
      child: Center(
        child: _ui == null
            ? const CircularProgressIndicator()
            : Container(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 350,
            height: 500,
            child: _ui,
          ),
        ),
      ),
    );
  }
}
