import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/svg.dart';

class HeadContainer extends StatelessWidget {
  const HeadContainer({
    Key key,
    @required this.col,
  }) : super(key: key);

  final Color col;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperOne(),
            child: Container(
              color: col,
              height: 240,
            ),
          ),
          Center(
              child: SvgPicture.asset('assets/images/add.svg',
                  height: 230)),
        ],
      ),
    );
  }
}