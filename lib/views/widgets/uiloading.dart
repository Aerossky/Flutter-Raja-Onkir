part of 'widgets.dart';

class Uiloading{
  static Container loadingBlock(){
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      color: Colors.black12,
      child: const SpinKitFadingCircle(
        size: 50,
        color: Colors.purple,
      ),
    );
  }
}