import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterglobal/Core/Constants/Enums/application_enums.dart';
import 'package:flutterglobal/Core/Extensions/context_extensions.dart';
import 'package:flutterglobal/Core/Utils/utils.dart';
import 'package:flutterglobal/Provider/cubit/app_provider_cubit.dart';
import 'package:flutterglobal/View/Guessing/guessing_view.dart';
import 'package:flutterglobal/View/GuessingGamesList/cubit/guessing_games_cubit.dart';
import 'package:flutterglobal/View/TimeLimitGuessingView/time_limit_guessing_view.dart';
import 'package:flutterglobal/Widgets/Buttons/back_button.dart';
import 'package:collection/collection.dart';

class GuessingGamesListView extends StatelessWidget {
  GuessingGamesListView({super.key});

  GuessingGamesCubit guessingGamesCubit = GuessingGamesCubit();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Utils.instance.backgroundDecoration(ImageEnums.background),
        child: BlocBuilder<GuessingGamesCubit, GuessingGamesState>(
          builder: (context, state) {
            return state.isLoading
                ? Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                    ),
                  )
                : SafeArea(
                    child: Column(
                      children: [
                        BackButtonWidget(),
                        Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: state.guessingGames?.length,
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Column(
                                      children: [
                                        buildRandomGameCard(context),
                                        buildGuessingGameCard(
                                            context, state, index),
                                      ],
                                    )
                                  : buildGuessingGameCard(
                                      context, state, index);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget buildRandomGameCard(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TimeLimitGuessingView(),
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Utils.instance.getJPGImage(ImageEnums.randomAnimes),
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Align(
              //     alignment: Alignment.topRight,
              //     child: Text(
              //       "İlerleme aşaması : %${calculateProgress(context.watch<AppProviderCubit>().state.user?.levels.firstWhereOrNull((e) => e.levelId == state.guessingGames![index].id)?.questionIndex, state.guessingGames![index].questions?.length)}",
              //       style: context.textTheme.subtitle2?.copyWith(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //           shadows: [
              //             Shadow(
              //               blurRadius: 10.0,
              //               color: Colors.black,
              //             ),
              //           ]),
              //     ),
              //   ),
              // ),
              Spacer(),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Rastgele Mod",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(5.0, 5.0),
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGuessingGameCard(
      BuildContext context, GuessingGamesState state, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuessingView(
              guessingModel: state.guessingGames![index],
            ),
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(state.guessingGames![index].mainImage ?? ""),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "İlerleme aşaması : %${calculateProgress(context.watch<AppProviderCubit>().state.user?.levels.firstWhereOrNull((e) => e.levelId == state.guessingGames![index].id)?.questionIndex, state.guessingGames![index].questions?.length)}",
                    style: context.textTheme.subtitle2?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                          ),
                        ]),
                  ),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    state.guessingGames![index].animeName ?? "",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(5.0, 5.0),
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String calculateProgress(int? questionIndex, int? length) {
    if (questionIndex == null || length == null) {
      return "0.0";
    }
    return ((questionIndex / length) * 100).toStringAsFixed(1);
  }
}
