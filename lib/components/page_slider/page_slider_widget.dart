import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../list_view_button.dart';
import 'page_slider_bloc/page_slider_cubit.dart';
import 'page_slider_bloc/page_slider_states.dart';

class PageSliderWidget extends StatelessWidget {
  const PageSliderWidget(
      {super.key,
      required this.pagesData,
      required this.width,
      required this.height});

  final Map<String, Widget> pagesData;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
     PageController pageController = PageController(initialPage: pagesData.length-1);
List<String>titles=List.generate(pagesData.length,(index)=>pagesData.keys.elementAt(index));
     List<Widget>widgets=List.generate(pagesData.length,(index)=>pagesData.values.elementAt(index));

    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(top: 10, bottom: 16),
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(),
          borderRadius: BorderRadius.circular(20)),
      child: BlocProvider(create: (BuildContext context) {
        return PageSliderCubit(() => InitialPageSliderState(index: titles.length-1));
      }, child: BlocBuilder<PageSliderCubit, PageSliderStates>(
        builder: (BuildContext context, PageSliderStates state) {
          if (state is InitialPageSliderState) {
            return Column(
              children: [
                SizedBox(
                  height: 250,
                  width: 1400,
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (value) {
                      context.read<PageSliderCubit>().changeIndex(value);
                    },
                    children: widgets,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: pagesData.length,
                    itemBuilder: (context, index) {
                      return ListViewButton(
                        currentIndex: state.index,
                        buttonIndex: index,
                        title:titles[index],
                        controller: pageController,
                        length: pagesData.length,
                        totalWidth: 1261.9,
                        onPressed: () {
                          context.read<PageSliderCubit>().changeIndex(index);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      )),
    );
  }
}
