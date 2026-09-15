import 'dart:math' as math;
import 'package:flutter/material.dart';

Future<DateTime?> showDinarDatePicker(
    {required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? initialDate}) async {
  FocusManager.instance.primaryFocus?.unfocus();
  final result = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: initialDate);
  if (context.mounted) FocusManager.instance.primaryFocus?.unfocus();
  return result;
}

/// Bounded, field-anchored selectors shared by editable forms.
class DinarDropdownField<T> extends StatelessWidget {
  const DinarDropdownField(
      {super.key,
      this.initialValue,
      required this.items,
      required this.onChanged,
      this.decoration = const InputDecoration(),
      this.isExpanded = true,
      this.validator});

  final T? initialValue;
  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final InputDecoration decoration;
  final bool isExpanded;
  final FormFieldValidator<T>? validator;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final rowHeight = math.max(48.0, media.textScaler.scale(16) * 2 + 24);
    final available = math.max(
        48.0,
        media.size.height -
            media.viewInsets.bottom -
            media.padding.vertical -
            32);
    Widget label(Widget child) => DefaultTextStyle.merge(
        maxLines: 2, overflow: TextOverflow.ellipsis, child: child);
    return DropdownButtonFormField<T>(
      initialValue: initialValue,
      isExpanded: true,
      itemHeight: rowHeight,
      menuMaxHeight: math.min(math.min(320.0, available * .6),
          (items?.length ?? 0) * rowHeight + 16),
      decoration: decoration,
      validator: validator,
      borderRadius: BorderRadius.circular(14),
      dropdownColor: Theme.of(context).colorScheme.surface,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      selectedItemBuilder: items == null
          ? null
          : (_) => items!
              .map((item) => Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: label(item.child)))
              .toList(),
      items: items
          ?.map((item) => DropdownMenuItem<T>(
              value: item.value,
              enabled: item.enabled,
              onTap: item.onTap,
              child: label(item.child)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

/// The route supplies the drag handle. Insets reduce the scroll viewport;
/// fields retain their intrinsic height and Save remains in the safe content.
class DinarFormSheet extends StatelessWidget {
  const DinarFormSheet({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SizedBox(
        // Keep the route's top edge stable while the keyboard changes only
        // the scroll viewport, not the sheet's intrinsic height.
        height: MediaQuery.sizeOf(context).height * .85,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: children),
              )),
        ),
      );
}
