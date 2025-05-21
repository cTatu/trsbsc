import 'package:jaspr/jaspr.dart' hide Color;
import 'package:sample_bulma/math.dart' as math;
import 'package:sample_bulma/solver.dart';
import 'package:sample_bulma/table.dart';

import 'button.dart';

void main() {
    runApp(App());
}

class App extends StatefulComponent {
    App({super.key});
    final solver = HoursSolver();

    @override
    State<App> createState() => _AppState();
}

class _AppState extends State<App> {

    int numDays = 5;
    int numWP = 4;
    late List<double> allocation = List.filled(numWP, 1/numWP);
    late math.Matrix2D solutionParams;
    bool isSolving = false;

    
    @override
    void initState() {
        super.initState();
        solutionParams = math.randomMatrix(numWP, numDays);
    }

    math.Matrix2D getTimesTable() => math.multiply(math.softmaxColumns(solutionParams), 7.5);

    void incrementDays() {
        if (numDays < 31) {
            setState(() {
                numDays++;
                solutionParams = math.randomMatrix(numWP, numDays);
            });
        }
    }

    void decrementDays() {
        if (numDays > 2) {
            setState(() {
                numDays--;
                solutionParams = math.randomMatrix(numWP, numDays);
            });
        }
    }

    void incrementWP() {
        if (numWP < 20) {
            setState(() {
                numWP++;
                solutionParams = math.randomMatrix(numWP, numDays);
                allocation = List.filled(numWP, 1/numWP);
            });
        }
    }

    void decrementWP() {
        if (numWP > 2) {
            setState(() {
                numWP--;
                solutionParams = math.randomMatrix(numWP, numDays);
                allocation = List.filled(numWP, 1/numWP);
            });
        }
    }


    @override
    Iterable<Component> build(BuildContext context) sync* {
        yield div(classes: 'fixed-grid has-11-cols', [
            div(classes: 'grid', [
                div(
                    classes: 'cell',
                    styles: Styles.raw({'position': 'absolute', 'top': '40%', 'left': '5%'}),
                    [
                    div(styles: Styles.raw({'display': 'inline-grid'}), [
                        Button(
                            child: IconLabel(icon: 'plus'), isDisabled: isSolving, onPressed: incrementWP),
                        Button(
                            child: IconLabel(icon: 'minus'), isDisabled: isSolving, onPressed: decrementWP),
                    ])
                    ]),
                div(
                    classes: 'cell is-col-span-9',
                    styles: Styles.raw({'overflow': 'auto'}),
                    [
                    Table(getTimesTable(), allocation, onAllocationChange: (double value, int idx) {
                        setState(() {
                            allocation[idx] = value;
                        });
                    }),
                    div(
                        styles: Styles.raw({
                            'display': 'inline-block',
                            'position': 'relative',
                            'left': '25%'
                        }),
                        [
                            Button(
                                child: IconLabel(icon: 'minus'),
                                isDisabled: isSolving,
                                onPressed: decrementDays),
                            Button(
                                child: IconLabel(icon: 'plus'),
                                isDisabled: isSolving,
                                onPressed: incrementDays),
                        ]),
                    ]),
                div(classes: 'cell',
                styles: Styles.raw({'display': 'flex', 'align-items': 'end'}),
                    [Button(
                        color: 'primary', 
                        size: 'large', 
                        isLoading: isSolving, 
                        isDisabled: isSolving || (math.sumList(allocation) - 1).abs() > 0.1,
                        child: IconLabel(icon: 'calculator'), 
                        onPressed: () async {
                            setState(() {
                                isSolving = true;
                            });
                            await Future.delayed(Duration(seconds: 1));
                            var hourAllocation = allocation.map((e) => e*7.5*numDays).toList();
                            var maxIter = numDays * numWP * 100;
                            var solution = await super.component.solver.solve(solutionParams, hourAllocation, maxIterations: maxIter);
                            setState(() {
                              isSolving = false;
                              solutionParams = solution;
                            });
                        }
                    )]
                )
            ])
        ]);
    }
}
