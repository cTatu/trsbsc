import 'package:jaspr/jaspr.dart' hide Color;
import 'package:sample_bulma/math.dart';
import 'package:sample_bulma/math.dart' as math;

class Table extends StatelessComponent {

    Table(this.hoursTable, this.allocation, {required this.onAllocationChange});

    final Matrix2D hoursTable;
    final List<double> allocation;
    final Function(double, int) onAllocationChange;

    get numRows => hoursTable.length;
    get numColumns => hoursTable[0].length;

    DomComponent _td(child) => DomComponent(tag: 'td', child: child);
    DomComponent _th(child) => DomComponent(tag: 'th', child: child);

    Component generateHeader() {
        return DomComponent(
            tag: 'thead',
            child: DomComponent(tag: 'tr', children: [
                _th(text('Work Package')),
                for (var i = 0; i < numColumns; i++) _th(text('Day ${i + 1}')),
                _th(text('WP Hours')),
                _th(text('Time Allocation (%)')),
        ]));
    }

    Component generateBody() {
        List<Component> rows = [];
        var sumRow = hoursTable.map((l) => math.sumList(l)).toList();
        for (var i = 0; i < numRows; i++) {
            var r = DomComponent(tag: 'tr', children: [
            _th(text('WP ${i + 1}')),
            for (var j = 0; j < numColumns; j++) _td(text(hoursTable[i][j].toStringAsFixed(1))),
            _td(
                div(
                    classes: 'columns',
                    [
                        div(classes: 'column', [
                            p(styles: Styles.raw({'margin-bottom': '0', 'text-align': 'center'}), [text(sumRow[i].toStringAsFixed(1))]),
                            hr(styles: Styles.raw({'margin-top': '5px', 'margin-bottom': '5px', 'border': 'none', 'height': '2px', 'background-color': 'blue' }),),
                            p(styles: Styles.raw({'margin-bottom': '0', 'text-align': 'center'}), [text((7.5*numColumns * allocation[i]).toStringAsFixed(1))])
                        ])
                    ]
                )
            ),
            _th(input(
                        classes: 'input', 
                        value: (allocation[i] * 100.0).toStringAsFixed(1),
                        attributes: {'min': '0', 'max': '100'},
                        type: InputType.number,
                        onChange: (value) => onAllocationChange((value as double) / 100, i),
                        []
                    ))
            ]);
            rows.add(r);

        }
        return DomComponent(
            tag: 'tbody',
            children: rows
        );
    }

    Component generateFoot() {
        var columnSum = [for (var colIdx = 0; colIdx < hoursTable[0].length; colIdx++) sumList(column(hoursTable, colIdx))];
        return DomComponent(
            tag: 'tfoot',
            child: DomComponent(tag: 'tr', children: [
            _th(text('Hours')),
            for (var i = 0; i < numColumns; i++) _th(text(columnSum[i].toStringAsFixed(1))),
            ]));
    }

    @override
    Iterable<Component> build(BuildContext context) sync* {
        yield DomComponent(tag: 'table', classes: 'table', children: [
            generateHeader(),
            generateBody(),
            generateFoot()
        ]);
    }
}
