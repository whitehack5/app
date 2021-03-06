import 'package:flutter/material.dart';
import 'package:memorare/components/web/footer.dart';
import 'package:memorare/router/route_names.dart';
import 'package:memorare/router/router.dart';

class AppIconHeader extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final double size;

  AppIconHeader({
    this.padding = const EdgeInsets.symmetric(vertical: 80.0),
    this.size = 60.0,
  });

  @override
  _AppIconHeaderState createState() => _AppIconHeaderState();
}

class _AppIconHeaderState extends State<AppIconHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Material(
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: Ink.image(
          image: AssetImage('assets/images/app-icon-64.png'),
          fit: BoxFit.cover,
          width: widget.size,
          height: widget.size,
          child: InkWell(
            onTap: () => FluroRouter.router.navigateTo(context, RootRoute),
            onLongPress: () => showFooter(),
          ),
        ),
      ),
    );
  }

  void showFooter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Footer(closeModalOnNav: true,);
      },
    );
  }
}
