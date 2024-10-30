import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

export 'dart:ui' show Offset;

/// {@animation 464 192 https://flutter.github.io/assets-for-api-docs/assets/animation/curve_elastic_out.mp4}
class CustomElasticOutCurve extends Curve {
  /// Creates an elastic-out curve.
  ///
  /// Rather than creating a new instance, consider using [Curves.elasticOut].
  const CustomElasticOutCurve([this.period = 0.8]);

  /// The duration of the oscillation.
  final double period;

  @override
  double transformInternal(double t) {
    final double s = period / 4.0;
    return math.pow(2.0, -10 * t) *
            math.sin((t - s) * (math.pi * 2.0) / period) +
        1.0;
  }

  @override
  String toString() {
    return '${objectRuntimeType(this, 'CustomElasticOutCurve')}($period)';
  }
}
