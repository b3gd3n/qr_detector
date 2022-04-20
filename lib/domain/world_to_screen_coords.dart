import 'dart:ui';

const double leftProjectionCoefficient = 2.3;
const double rightProjectionCoefficient = 2.1;
const double topProjectionCoefficient = 2;
const double bottomProjectionCoefficient = 1.9;
const double alignmentDx = 40;

List<Offset> worldToScreenCoords({required List<Offset> corners}) {
  final List<Offset> worldViewCorners = corners;

  worldViewCorners[0] = Offset(
      (worldViewCorners[0].dx / leftProjectionCoefficient) - alignmentDx,
      worldViewCorners[0].dy / topProjectionCoefficient);
  worldViewCorners[1] = Offset(
      (worldViewCorners[1].dx / rightProjectionCoefficient) - alignmentDx,
      worldViewCorners[1].dy / topProjectionCoefficient);
  worldViewCorners[2] = Offset(
      (worldViewCorners[2].dx / rightProjectionCoefficient) - alignmentDx,
      (worldViewCorners[2].dy / bottomProjectionCoefficient));
  worldViewCorners[3] = Offset(
      (worldViewCorners[3].dx / leftProjectionCoefficient) - alignmentDx,
      worldViewCorners[3].dy / bottomProjectionCoefficient);

  return worldViewCorners;
}
