import 'package:jaspr/jaspr.dart' hide Color;

class Button extends StatelessComponent {
  const Button({
    required this.child,
    required this.onPressed,
    this.color,
    this.size,
    this.isLoading = false,
    this.isDisabled = false,
    super.key,
  });

  final Component child;
  final VoidCallback onPressed;
  final String? color;
  final String? size;
  final bool isLoading;
  final bool isDisabled;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield button(
      classes: 'button is-rounded'
          '${color != null ? ' is-$color' : ''}'
          '${size != null ? ' is-$size' : ''}'
          '${isLoading ? ' is-loading' : ''}',
      disabled: isDisabled,
      onClick: onPressed,
      [child],
    );
  }
}

class IconLabel extends StatelessComponent {
  const IconLabel({required this.icon, this.label, super.key});

  final String icon;
  final String? label;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield span(classes: 'icon', [i(classes: 'fas fa-$icon', [])]);
    if (label != null) {
      yield span([text(label!)]);
    }
  }
}