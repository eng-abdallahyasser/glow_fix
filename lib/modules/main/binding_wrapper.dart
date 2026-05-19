import 'package:flutter/widgets.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class BindingWrapper extends StatefulWidget {
  final Bindings binding;
  final Widget child;

  const BindingWrapper({
    super.key,
    required this.binding,
    required this.child,
  });

  @override
  State<BindingWrapper> createState() => _BindingWrapperState();
}

class _BindingWrapperState extends State<BindingWrapper> {
  @override
  void initState() {
    super.initState();
    widget.binding.dependencies(); 
  }

  @override
  Widget build(BuildContext context) => widget.child;
}