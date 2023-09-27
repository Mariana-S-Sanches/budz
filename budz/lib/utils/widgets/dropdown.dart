// ignore_for_file: unnecessary_null_comparison

import 'dart:math' as math;
import 'package:budz/utils/color_library.dart';
import 'package:budz/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';

const double _kMenuItemHeight = kMinInteractiveDimension;
const Duration _kDropdownMenuDuration = Duration(milliseconds: 900);
const EdgeInsets _kMenuItemPadding = EdgeInsets.symmetric(horizontal: 20);
const EdgeInsetsGeometry _kUnalignedMenuMargin = EdgeInsetsDirectional.only(start: 0, end: 1);

typedef DropdownButtonBuilder = List<Widget> Function(BuildContext context);

class _DropdownMenuPainter extends CustomPainter {
  _DropdownMenuPainter({
    this.color,
    this.elevation,
    this.selectedIndex,
    this.borderRadius,
    required this.resize,
  })  : _painter = BoxDecoration(
          color: color,
          borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(2.0)),
          boxShadow: kElevationToShadow[elevation],
        ).createBoxPainter(),
        super(repaint: resize);

  final Color? color;
  final int? elevation;
  final int? selectedIndex;
  final BoxPainter _painter;
  final Animation<double> resize;
  final BorderRadius? borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final Tween<double> top = Tween<double>(
      begin: 1,
      end: 0.0,
    );

    final Tween<double> bottom = Tween<double>(
      begin: 1,
      end: size.height,
    );

    final Rect rect = Rect.fromLTRB(0.0, top.evaluate(resize), size.width, bottom.evaluate(resize));

    _painter.paint(canvas, rect.topLeft, ImageConfiguration(size: rect.size));
  }

  @override
  bool shouldRepaint(_DropdownMenuPainter oldPainter) {
    return oldPainter.color != color || oldPainter.elevation != elevation || oldPainter.selectedIndex != selectedIndex || oldPainter.borderRadius != borderRadius || oldPainter.resize != resize;
  }
}

class _DropdownMenuItemButton<T> extends StatefulWidget {
  const _DropdownMenuItemButton({
    Key? key,
    this.padding,
    required this.route,
    required this.itemIndex,
    required this.buttonRect,
    required this.constraints,
    required this.enableFeedback,
  }) : super(key: key);

  final int itemIndex;
  final Rect buttonRect;
  final bool enableFeedback;
  final EdgeInsets? padding;
  final _DropdownRoute<T> route;
  final BoxConstraints constraints;

  @override
  _DropdownMenuItemButtonState<T> createState() => _DropdownMenuItemButtonState<T>();
}

class _DropdownMenuItemButtonState<T> extends State<_DropdownMenuItemButton<T>> {
  void _handleFocusChange(bool focused) {
    final bool inTraditionalMode;
    switch (FocusManager.instance.highlightMode) {
      case FocusHighlightMode.touch:
        inTraditionalMode = false;
        break;
      case FocusHighlightMode.traditional:
        inTraditionalMode = true;
        break;
    }

    if (focused && inTraditionalMode) {
      final _MenuLimits menuLimits = widget.route.getMenuLimits(
        widget.buttonRect,
        widget.constraints.maxHeight,
        widget.itemIndex,
      );
      widget.route.scrollController!.animateTo(
        menuLimits.scrollOffset,
        curve: Curves.fastLinearToSlowEaseIn,
        duration: _kDropdownMenuDuration,
      );
    }
  }

  void _handleOnTap() {
    final CustomDropdownMenuItem<T> dropdownMenuItem = widget.route.items[widget.itemIndex].item!;

    dropdownMenuItem.onTap?.call();

    Navigator.pop(
      context,
      _DropdownRouteResult<T>(dropdownMenuItem.value),
    );
  }

  static const Map<ShortcutActivator, Intent> _webShortcuts = <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(TraversalDirection.down),
    SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(TraversalDirection.up),
  };

  @override
  Widget build(BuildContext context) {
    final CustomDropdownMenuItem<T> dropdownMenuItem = widget.route.items[widget.itemIndex].item!;
    final CurvedAnimation opacity;
    opacity = CurvedAnimation(
      parent: widget.route.animation!,
      curve: Curves.fastOutSlowIn,
    );

    Widget child = Container(
      padding: widget.padding,
      height: widget.route.itemHeight,
      child: widget.route.items[widget.itemIndex],
    );
    // An [InkWell] is added to the item only if it is enabled
    if (dropdownMenuItem.enabled) {
      child = InkWell(
        autofocus: widget.itemIndex == widget.route.selectedIndex,
        enableFeedback: widget.enableFeedback,
        onTap: _handleOnTap,
        onFocusChange: _handleFocusChange,
        child: child,
      );
    }
    child = FadeTransition(
      opacity: opacity,
      child: child,
    );
    if (kIsWeb && dropdownMenuItem.enabled) {
      child = Shortcuts(
        shortcuts: _webShortcuts,
        child: child,
      );
    }
    return child;
  }
}

class _DropdownMenu<T> extends StatefulWidget {
  const _DropdownMenu({
    Key? key,
    this.padding,
    required this.route,
    required this.buttonRect,
    required this.constraints,
    this.dropdownColor,
    required this.enableFeedback,
    this.borderRadius,
  }) : super(key: key);

  final _DropdownRoute<T> route;
  final EdgeInsets? padding;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final Color? dropdownColor;
  final bool enableFeedback;
  final BorderRadius? borderRadius;

  @override
  _DropdownMenuState<T> createState() => _DropdownMenuState<T>();
}

class _DropdownMenuState<T> extends State<_DropdownMenu<T>> {
  late CurvedAnimation _fadeOpacity;
  late CurvedAnimation _resize;

  @override
  void initState() {
    super.initState();
    _fadeOpacity = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0.0, 0.25),
      reverseCurve: const Interval(0.85, 1.0),
    );
    _resize = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0.0, 0.25),
      reverseCurve: const Interval(0.5, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final _DropdownRoute<T> route = widget.route;
    final List<Widget> children = <Widget>[
      for (int itemIndex = 0; itemIndex < route.items.length; ++itemIndex)
        _DropdownMenuItemButton<T>(
          route: widget.route,
          padding: widget.padding,
          buttonRect: widget.buttonRect,
          constraints: widget.constraints,
          itemIndex: itemIndex,
          enableFeedback: widget.enableFeedback,
        ),
    ];

    return FadeTransition(
      opacity: _fadeOpacity,
      child: CustomPaint(
        painter: _DropdownMenuPainter(
          color: widget.dropdownColor ?? Theme.of(context).canvasColor,
          elevation: route.elevation,
          selectedIndex: route.selectedIndex,
          resize: _resize,
          borderRadius: widget.borderRadius,
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: localizations.popupMenuLabel,
          child: Material(
            type: MaterialType.transparency,
            textStyle: CustomTextStyles.labelSmall,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
                overscroll: false,
                physics: const ClampingScrollPhysics(),
                platform: Theme.of(context).platform,
              ),
              child: PrimaryScrollController(
                controller: widget.route.scrollController!,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView(
                    padding: kMaterialListPadding,
                    shrinkWrap: true,
                    children: children,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownMenuRouteLayout<T> extends SingleChildLayoutDelegate {
  _DropdownMenuRouteLayout({
    required this.buttonRect,
    required this.route,
    required this.textDirection,
  });

  final Rect buttonRect;
  final _DropdownRoute<T> route;
  final TextDirection? textDirection;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = math.max(0.0, constraints.maxHeight - 2 * _kMenuItemHeight);
    if (route.menuMaxHeight != null && route.menuMaxHeight! <= maxHeight) {
      maxHeight = route.menuMaxHeight!;
    }
    final double width = math.min(constraints.maxWidth, buttonRect.width);
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final _MenuLimits menuLimits = route.getMenuLimits(buttonRect, size.height, route.selectedIndex);

    assert(() {
      final Rect container = Offset.zero & size;
      if (container.intersect(buttonRect) == buttonRect) {
        assert(menuLimits.top >= 0.0);
        assert(menuLimits.top + menuLimits.height <= size.height);
      }
      return true;
    }());
    assert(textDirection != null);
    final double left;
    switch (textDirection!) {
      case TextDirection.rtl:
        left = buttonRect.right.clamp(0.0, size.width) - childSize.width;
        break;
      case TextDirection.ltr:
        left = buttonRect.left.clamp(0.0, size.width - childSize.width);
        break;
    }

    return Offset(left, menuLimits.top);
  }

  @override
  bool shouldRelayout(_DropdownMenuRouteLayout<T> oldDelegate) {
    return buttonRect != oldDelegate.buttonRect || textDirection != oldDelegate.textDirection;
  }
}

@immutable
class _DropdownRouteResult<T> {
  const _DropdownRouteResult(this.result);

  final T? result;

  @override
  bool operator ==(Object other) {
    return other is _DropdownRouteResult<T> && other.result == result;
  }

  @override
  int get hashCode => result.hashCode;
}

class _MenuLimits {
  const _MenuLimits(this.top, this.bottom, this.height, this.scrollOffset);
  final double top;
  final double bottom;
  final double height;
  final double scrollOffset;
}

class _DropdownRoute<T> extends PopupRoute<_DropdownRouteResult<T>> {
  _DropdownRoute({
    this.itemHeight,
    this.borderRadius,
    this.barrierLabel,
    this.dropdownColor,
    this.elevation = 0,
    this.menuMaxHeight,
    required this.items,
    required this.style,
    required this.padding,
    required this.buttonRect,
    required this.selectedIndex,
    required this.capturedThemes,
    required this.enableFeedback,
  })  : assert(style != null),
        itemHeights = List<double>.filled(items.length, itemHeight ?? kMinInteractiveDimension);

  final int elevation;
  final TextStyle style;
  final Rect buttonRect;
  final int selectedIndex;
  final double? itemHeight;
  final bool enableFeedback;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final List<_MenuItem<T>> items;
  final List<double> itemHeights;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final CapturedThemes capturedThemes;

  ScrollController? scrollController;

  @override
  Duration get transitionDuration => _kDropdownMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _DropdownRoutePage<T>(
          route: this,
          style: style,
          items: items,
          padding: padding,
          elevation: elevation,
          buttonRect: buttonRect,
          constraints: constraints,
          borderRadius: borderRadius,
          selectedIndex: selectedIndex,
          dropdownColor: dropdownColor,
          capturedThemes: capturedThemes,
          enableFeedback: enableFeedback,
        );
      },
    );
  }

  void _dismiss() {
    if (isActive) {
      navigator?.removeRoute(this);
    }
  }

  double getItemOffset() {
    double offset = kMaterialListPadding.top;
    offset += itemHeights.sublist(0).reduce((double total, double height) => total + height);

    return offset;
  }

  _MenuLimits getMenuLimits(Rect buttonRect, double availableHeight, int index) {
    double computedMaxHeight = availableHeight - 2.0 * _kMenuItemHeight;
    if (menuMaxHeight != null) {
      computedMaxHeight = math.min(computedMaxHeight, menuMaxHeight!);
    }
    final double buttonTop = buttonRect.top;
    final double buttonBottom = math.min(buttonRect.bottom, availableHeight);
    const double selectedItemOffset = -50;
    final double topLimit = math.min(_kMenuItemHeight, buttonTop);
    final double bottomLimit = math.max(availableHeight - _kMenuItemHeight, buttonBottom);

    double menuTop = (buttonTop - selectedItemOffset) - (itemHeights[selectedIndex] - buttonRect.height) / 2.0;
    double preferredMenuHeight = kMaterialListPadding.vertical;
    if (items.isNotEmpty) preferredMenuHeight += itemHeights.reduce((double total, double height) => total + height);
    final double menuHeight = math.min(computedMaxHeight, preferredMenuHeight);
    double menuBottom = menuTop + menuHeight;
    if (menuTop < topLimit) {
      menuTop = math.min(buttonTop, topLimit);
      menuBottom = menuTop + menuHeight;
    }

    if (menuBottom > bottomLimit) {
      menuBottom = math.max(buttonBottom, bottomLimit);
      menuTop = menuBottom - menuHeight;
    }

    if (menuBottom - itemHeights[selectedIndex] / 2.0 < buttonBottom - buttonRect.height / 2.0) {
      menuBottom = buttonBottom - buttonRect.height / 2.0 + itemHeights[selectedIndex] / 2.0;
      menuTop = menuBottom - menuHeight;
    }

    double scrollOffset = 0;
    if (preferredMenuHeight > computedMaxHeight) {
      scrollOffset = math.max(0.0, selectedItemOffset - (buttonTop - menuTop));
      scrollOffset = math.min(scrollOffset, preferredMenuHeight - menuHeight);
    }

    assert((menuBottom - menuTop - menuHeight).abs() < precisionErrorTolerance);
    return _MenuLimits(menuTop, menuBottom, menuHeight, scrollOffset);
  }
}

class _DropdownRoutePage<T> extends StatelessWidget {
  const _DropdownRoutePage({
    Key? key,
    this.style,
    this.items,
    this.borderRadius,
    this.elevation = 0,
    required this.route,
    required this.padding,
    required this.buttonRect,
    required this.constraints,
    required this.selectedIndex,
    required this.dropdownColor,
    required this.enableFeedback,
    required this.capturedThemes,
  }) : super(key: key);

  final int elevation;
  final Rect buttonRect;
  final TextStyle? style;
  final int selectedIndex;
  final bool enableFeedback;
  final Color? dropdownColor;
  final _DropdownRoute<T> route;
  final List<_MenuItem<T>>? items;
  final BoxConstraints constraints;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final CapturedThemes capturedThemes;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    if (route.scrollController == null) {
      final _MenuLimits menuLimits = route.getMenuLimits(buttonRect, constraints.maxHeight, selectedIndex);
      route.scrollController = ScrollController(initialScrollOffset: menuLimits.scrollOffset);
    }

    final TextDirection? textDirection = Directionality.maybeOf(context);
    final Widget menu = _DropdownMenu<T>(
      route: route,
      padding: padding.resolve(textDirection),
      buttonRect: buttonRect,
      constraints: constraints,
      dropdownColor: dropdownColor,
      enableFeedback: enableFeedback,
      borderRadius: borderRadius,
    );

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _DropdownMenuRouteLayout<T>(
              buttonRect: buttonRect,
              route: route,
              textDirection: textDirection,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }
}

class _MenuItem<T> extends SingleChildRenderObjectWidget {
  const _MenuItem({
    Key? key,
    required this.onLayout,
    required this.item,
  })  : assert(onLayout != null),
        super(key: key, child: item);

  final ValueChanged<Size> onLayout;
  final CustomDropdownMenuItem<T>? item;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _RenderMenuItem renderObject) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderMenuItem extends RenderProxyBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child])
      : assert(onLayout != null),
        super(child);

  ValueChanged<Size> onLayout;

  @override
  void performLayout() {
    super.performLayout();
    onLayout(size);
  }
}

class _DropdownMenuItemContainer extends StatelessWidget {
  const _DropdownMenuItemContainer({
    Key? key,
    this.alignment = AlignmentDirectional.centerStart,
    required this.child,
  })  : assert(child != null),
        super(key: key);

  final Widget child;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: _kMenuItemHeight),
      alignment: alignment,
      child: child,
    );
  }
}

class CustomDropdownMenuItem<T> extends _DropdownMenuItemContainer {
  const CustomDropdownMenuItem({
    Key? key,
    this.onTap,
    this.value,
    this.enabled = true,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    required Widget child,
  })  : assert(child != null),
        super(key: key, alignment: alignment, child: child);

  final VoidCallback? onTap;
  final T? value;
  final bool enabled;
}

// ignore: must_be_immutable
class CustomDropdownButton<T> extends StatefulWidget {
  CustomDropdownButton({
    Key? key,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.onTap,
    this.style,
    this.height,
    this.innerPadding,
    this.selectedItemBuilder,
    this.alignment = AlignmentDirectional.center,
  }) : super(key: key);

  final T? value;
  double? height;
  final String hint;
  final int elevation = 3;
  final TextStyle? style;
  EdgeInsets? innerPadding;
  final VoidCallback? onTap;
  final bool isDense = false;
  final bool isExpanded = false;
  final ValueChanged<T?>? onChanged;
  final AlignmentGeometry alignment;
  final List<CustomDropdownMenuItem<T>>? items;
  final DropdownButtonBuilder? selectedItemBuilder;

  double? itemHeight = 35;
  double? menuMaxHeight = 300;

  final bool _isEmpty = false;
  final bool _isFocused = false;
  InputDecoration? _inputDecoration;

  @override
  State<CustomDropdownButton<T>> createState() => _CustomDropdownButtonState<T>();
}

class _CustomDropdownButtonState<T> extends State<CustomDropdownButton<T>> with WidgetsBindingObserver {
  int? _selectedIndex;
  Orientation? _lastOrientation;
  _DropdownRoute<T>? _dropdownRoute;
  late Map<Type, Action<Intent>> _actionMap;

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex();

    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => _handleTap(),
      ),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
        onInvoke: (ButtonActivateIntent intent) => _handleTap(),
      ),
    };
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeDropdownRoute();
    super.dispose();
  }

  void _removeDropdownRoute() {
    _dropdownRoute?._dismiss();
    _dropdownRoute = null;
    _lastOrientation = null;
  }

  @override
  void didUpdateWidget(CustomDropdownButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    if (widget.items == null || widget.items!.isEmpty || (widget.value == null && widget.items!.where((CustomDropdownMenuItem<T> item) => item.enabled && item.value == widget.value).isEmpty)) {
      _selectedIndex = null;
      return;
    }

    assert(widget.items!.where((CustomDropdownMenuItem<T> item) => item.value == widget.value).length == 1);
    for (int itemIndex = 0; itemIndex < widget.items!.length; itemIndex++) {
      if (widget.items![itemIndex].value == widget.value) {
        _selectedIndex = itemIndex;
        return;
      }
    }
  }

  void _handleTap() {
    final TextDirection? textDirection = Directionality.maybeOf(context);
    const EdgeInsetsGeometry menuMargin = _kUnalignedMenuMargin;

    final List<_MenuItem<T>> menuItems = <_MenuItem<T>>[
      for (int index = 0; index < widget.items!.length; index += 1)
        _MenuItem<T>(
          item: widget.items![index],
          onLayout: (Size size) {
            if (_dropdownRoute == null) return;

            _dropdownRoute!.itemHeights[index] = size.height;
          },
        ),
    ];

    final NavigatorState navigator = Navigator.of(context);
    assert(_dropdownRoute == null);
    final RenderBox itemBox = context.findRenderObject()! as RenderBox;
    final Rect itemRect = itemBox.localToGlobal(Offset.zero, ancestor: navigator.context.findRenderObject()) & itemBox.size;
    _dropdownRoute = _DropdownRoute<T>(
      items: menuItems,
      buttonRect: menuMargin.resolve(textDirection).inflateRect(itemRect),
      padding: _kMenuItemPadding.resolve(textDirection),
      selectedIndex: _selectedIndex ?? 0,
      elevation: widget.elevation,
      capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
      style: CustomTextStyles.labelSmall.copyWith(fontSize: 10),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      itemHeight: widget.itemHeight,
      dropdownColor: ColorLibrary.white,
      menuMaxHeight: widget.menuMaxHeight,
      enableFeedback: false,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    );

    navigator.push(_dropdownRoute!).then<void>((_DropdownRouteResult<T>? newValue) {
      _removeDropdownRoute();
      if (!mounted || newValue == null) return;
      widget.onChanged?.call(newValue.result);
    });

    widget.onTap?.call();
  }

  bool get _enabled => widget.items != null && widget.items!.isNotEmpty && widget.onChanged != null;

  Orientation _getOrientation(BuildContext context) {
    Orientation? result = MediaQuery.maybeOf(context)?.orientation;
    if (result == null) {
      // ignore: deprecated_member_use
      final Size size = WidgetsBinding.instance.window.physicalSize;
      result = size.width > size.height ? Orientation.landscape : Orientation.portrait;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final Orientation newOrientation = _getOrientation(context);
    _lastOrientation ??= newOrientation;
    if (newOrientation != _lastOrientation) {
      _removeDropdownRoute();
      _lastOrientation = newOrientation;
    }
    final List<Widget> items = widget.selectedItemBuilder == null
        ? (widget.items != null ? List<Widget>.of(widget.items!) : <Widget>[])
        : List<Widget>.of(
            widget.selectedItemBuilder!(context),
          );

    int? hintIndex;
    if (widget.hint != null) {
      Widget displayedHint = Text(
        widget.hint,
        style: CustomTextStyles.labelSmall,
      );
      if (widget.selectedItemBuilder == null) {
        displayedHint = _DropdownMenuItemContainer(
          child: displayedHint,
        );
      }

      hintIndex = items.length;
      items.add(
        DefaultTextStyle(
          style: CustomTextStyles.labelSmall,
          child: IgnorePointer(
            ignoringSemantics: false,
            child: displayedHint,
          ),
        ),
      );
    }

    final Widget innerItemsWidget;
    if (items.isEmpty) {
      innerItemsWidget = Container();
    } else {
      innerItemsWidget = IndexedStack(
        index: _selectedIndex ?? hintIndex,
        alignment: Alignment.centerLeft,
        children: widget.isDense
            ? items
            : items.map((Widget item) {
                return widget.itemHeight != null
                    ? Padding(
                        padding: widget.innerPadding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: SizedBox(
                          height: widget.itemHeight,
                          child: item,
                        ),
                      )
                    : Column(
                        children: <Widget>[item],
                      );
              }).toList(),
      );
    }

    const Icon defaultIcon = Icon(Icons.keyboard_arrow_down);

    Widget result = DefaultTextStyle(
      style: CustomTextStyles.labelSmall,
      child: Container(
        padding: EdgeInsets.zero, //padding.resolve(Directionality.of(context)),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: ColorLibrary.lightGray,
            width: 1.5,
          ),
        ),
        height: widget.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.isExpanded) Expanded(child: innerItemsWidget) else innerItemsWidget,
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconTheme(
                data: IconThemeData(
                  color: ColorLibrary.lightGray,
                  size: 20,
                ),
                child: defaultIcon,
              ),
            ),
          ],
        ),
      ),
    );

    final MouseCursor effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor>(
      MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!_enabled) MaterialState.disabled,
      },
    );

    if (widget._inputDecoration != null) {
      result = InputDecorator(
        decoration: widget._inputDecoration!,
        isEmpty: widget._isEmpty,
        isFocused: widget._isFocused,
        child: result,
      );
    }

    return Semantics(
      button: true,
      child: Actions(
        actions: _actionMap,
        child: InkWell(
          mouseCursor: effectiveMouseCursor,
          onTap: _enabled ? _handleTap : null,
          canRequestFocus: _enabled,
          focusColor: ColorLibrary.lightGray,
          enableFeedback: false,
          child: result,
        ),
      ),
    );
  }
}
