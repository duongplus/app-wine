import 'package:flutter/material.dart';
import 'package:wine_app/base/base_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'xoayxoay.dart';

class LoadingTask extends StatelessWidget {
  final Widget child;
  final BaseBloc bloc;

  LoadingTask({
    @required this.child,
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return StreamProvider<bool>.value(
      value: bloc.loadingStream,
      initialData: false,
      child: Stack(
        children: <Widget>[
          child,
          Consumer<bool>(
            builder: (context, isLoading, child) => Center(
              child: isLoading
                  ? Container(
                      width: 120,
                      height: 120,
                      decoration: new BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: ColorLoader(),
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
