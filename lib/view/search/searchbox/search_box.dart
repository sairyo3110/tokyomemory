import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/plan/plan_chategory.dart';
import 'package:mapapp/businesslogic/plan/plan_main.dart';
import 'package:mapapp/businesslogic/spot/spot_access.dart';
import 'package:mapapp/businesslogic/spot/spot_main.dart';
import 'package:mapapp/colors.dart';
import 'package:mapapp/view/search/searchbox/underscreen_cursor.dart';
import 'package:mapapp/view/search/searchbox/underscreen_fild.dart';
import 'package:mapapp/view/search/spot/spot_main.dart';
import 'package:provider/provider.dart';

class CustomSearchBox extends StatefulWidget {
  final String hintText;
  final double padding;
  final double borderRadius;
  final double iconSize;
  final bool showSearchBackButton;
  final bool showToggleButton;
  final VoidCallback? onToggleButtonPressed;
  final bool isMapView;
  final VoidCallback? onBackButtonPressed;

  CustomSearchBox({
    this.hintText = 'スポット、プラン、エリア',
    this.padding = 8.0,
    this.borderRadius = 50.0,
    this.iconSize = 24.0,
    this.showSearchBackButton = false,
    this.showToggleButton = false,
    this.onToggleButtonPressed,
    this.isMapView = false,
    this.onBackButtonPressed,
  });

  @override
  _CustomSearchBoxState createState() => _CustomSearchBoxState();
}

class _CustomSearchBoxState extends State<CustomSearchBox> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  OverlayEntry? _overlayEntry;
  bool _showCancelButton = false;

  void _showWidget() {
    if (_overlayEntry != null) {
      return;
    }
    setState(() {
      _showCancelButton = true;
    });
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeWidget() {
    _focusNode.unfocus();
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _showCancelButton = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        top: renderBox.localToGlobal(Offset.zero).dy + size.height,
        width: size.width,
        child: Material(
          elevation: 8.0,
          child: _controller.text.isEmpty
              ? SearchBoxUnderscreen(onClose: _removeWidget)
              : SearchResultsScreen(onClose: _removeWidget),
        ),
      ),
    );
  }

  void _onSubmitted(String value) {
    _removeWidget();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SpotScreen()),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _removeWidget();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Row(
        children: [
          if (widget.showSearchBackButton)
            IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  size: widget.iconSize, color: AppColors.onPrimary),
              onPressed: widget.onBackButtonPressed ??
                  () => Navigator.of(context).pop(),
            ),
          Expanded(
            child: Container(
              height: 30,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(fontSize: 14.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: AppColors.onPrimary,
                  filled: true,
                  prefixIcon: Icon(Icons.search,
                      size: widget.iconSize, color: Colors.black),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                ),
                onTap: _showWidget,
                onChanged: (text) {
                  Provider.of<SpotViewModel>(context, listen: false)
                      .filterLocations(
                          text,
                          Provider.of<PlaceAccessViewModel>(context,
                              listen: false));
                  Provider.of<PlanViewModel>(context, listen: false)
                      .filterPlans(text);
                  Provider.of<PlanCategoryModel>(context, listen: false)
                      .filterCategories(text);
                  if (_overlayEntry != null) {
                    _overlayEntry!.remove();
                    _overlayEntry = _createOverlayEntry();
                    Overlay.of(context).insert(_overlayEntry!);
                  }
                },
                onSubmitted: _onSubmitted,
              ),
            ),
          ),
          if (widget.showToggleButton)
            IconButton(
              icon: Icon(widget.isMapView ? Icons.list : Icons.map,
                  size: widget.iconSize, color: Colors.white),
              onPressed: widget.onToggleButtonPressed,
            ),
          if (_showCancelButton)
            TextButton(
              onPressed: _removeWidget,
              child:
                  Text('キャンセル', style: TextStyle(color: AppColors.onPrimary)),
            ),
        ],
      ),
    );
  }
}
