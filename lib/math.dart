import 'dart:math';


typedef Matrix2D = List<List<double>>;

Matrix2D randomMatrix(List shape, {double mean=0, double stdev=1, int? seed}) {
    var rows = shape[0], cols = shape[1];
    return List.generate(rows, (_) => List.generate(cols, (_) => randomNormal(mean, stdev, seed: seed)));
}

double randomNormal(double mean, double stdev, {int? seed}) {
    var rng = Random(seed);
    final eps = 1e-12;
    var u1 = rng.nextDouble() + eps;
    var u2 = rng.nextDouble() + eps;
    var z0 = sqrt(-2 * log(u1)) * cos(2 * pi * u2);
    return mean + z0 * stdev;
}

Matrix2D softmaxColumns(Matrix2D x) {
    var maxColumn = [for (var colIdx = 0; colIdx < x[0].length; colIdx++) maxList(column(x, colIdx))];
    Matrix2D xStable = subtractColumn(x, maxColumn);
    Matrix2D expLogits = xStable.map((e) => e.map(exp).toList()).toList();
    var sumExpLogits = [for (var colIdx = 0; colIdx < x[0].length; colIdx++) sumList(column(expLogits, colIdx))];
    return divideColumn(expLogits, sumExpLogits);
}


List<double> softmaxList(List<double> a) {
    var max = a.reduce((a, b) => a > b ? a : b);
    var expLogits = a.map((e) => exp(e - max)).toList();
    var sumExpLogits = expLogits.reduce((a, b) => a + b);
    return expLogits.map((e) => e / sumExpLogits).toList();
}

List<double> column(Matrix2D x, int colIdx) => x.map((e) => e[colIdx]).toList();
double maxList(List<double> x) => x.reduce((a, b) => a > b ? a : b);
double sumList(List<double> x) => x.isNotEmpty ? x.reduce((a, b) => a + b) : 0;
Matrix2D multiply(Matrix2D a, double b) => a.map((e) => e.map((f) => f * b).toList()).toList();
List<int> shape(Matrix2D x) => [x.length, x[0].length];

Matrix2D subtractColumn(Matrix2D a, List<double> b) {
    Matrix2D out = List.generate(a.length, (_) => List.generate(a[0].length, (_) => 0.0));
    for (var i = 0; i < a.length; i++) {
        for (var j = 0; j < a[0].length; j++) {
            out[i][j] = a[i][j] - b[j];
        }
    }
    return out;
}

Matrix2D divideColumn(Matrix2D a, List<double> b) {
    Matrix2D out = List.generate(a.length, (_) => List.generate(a[0].length, (_) => 0.0));
    for (var i = 0; i < a.length; i++) {
        for (var j = 0; j < a[0].length; j++) {
            out[i][j] = a[i][j] / b[j];
        }
    }
    return out;
}

Matrix2D add(Matrix2D a, Matrix2D b) {
    Matrix2D out = List.generate(a.length, (_) => List.generate(a[0].length, (_) => 0.0));
    for (var i = 0; i < a.length; i++) {
        for (var j = 0; j < a[0].length; j++) {
            out[i][j] = a[i][j] + b[i][j];
        }
    }
    return out;
}

void printMatrix(Matrix2D mtrx) => mtrx.forEach(print);