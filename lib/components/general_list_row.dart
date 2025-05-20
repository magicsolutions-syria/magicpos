import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

class GeneralListRow extends StatelessWidget {
  const GeneralListRow(
      {super.key,
      required this.columns,
      required this.width,
      required this.thick,
      this.ratios});
  final List<String> columns;
  final List<double>? ratios;
  final double width;
  final double thick;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) => RowCell(
            width: width *
                (ratios == null
                    ? (ratios!.length < columns.length
                        ? 1 / columns.length
                        : ratios![index])
                    : ratios![index]),
            title: columns[index]),
        separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: 45,
              width: thick,
              child: Center(
                child: Container(
                  height: 25,
                  width: thick,
                  color: Theme.of(context).dividerSecondaryColor,
                ),
              ),
            ),
        itemCount: columns.length);
  }
}

class RowCell extends StatelessWidget {
  const RowCell({super.key, required this.title, required this.width});
  final double width;
  final String title;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: width,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
