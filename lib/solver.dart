import 'dart:async';

import 'package:sample_bulma/math.dart' as math;

class HoursSolver {
    double _objectiveFunction(math.Matrix2D x0, List<double> hourAllocation) {
        var paramsSoftmax = math.softmaxColumns(x0);
        var sumRowsParams = math.multiply(paramsSoftmax, 7.5).map((l) => math.sumList(l)).toList();

        var wpLosses = List.filled(paramsSoftmax.length, 0.0);
        for (var i = 0; i < sumRowsParams.length; i++) {
            wpLosses[i] = sumRowsParams[i] - hourAllocation[i];
            wpLosses[i] *= wpLosses[i];
        }


        return math.sumList(wpLosses);
    }

    Future<math.Matrix2D> solve(math.Matrix2D initialPoint, List<double> hourAllocation,
                {int maxIterations = 1000, double stepSize = 1.0}) async {
        math.Matrix2D currentPoint = math.Matrix2D.from(initialPoint);
        var currentValue = _objectiveFunction(currentPoint, hourAllocation);

        var stdev = 1 / stepSize;

        for (var i = 0; i < maxIterations; i++) {
            var randomDisplacement = math.randomMatrix(currentPoint.length, currentPoint[0].length, min: -stdev, max: stdev);
            var neighborPoint = math.add(randomDisplacement, currentPoint);
            var neighborValue = _objectiveFunction(neighborPoint, hourAllocation);

            if (neighborValue < currentValue) {
                currentPoint = math.Matrix2D.from(neighborPoint);
                currentValue = neighborValue;
            }
            if (currentValue <= 1) {
                break;
            }
        }

        return currentPoint;
    }

}