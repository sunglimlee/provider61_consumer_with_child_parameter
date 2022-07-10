import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
 Consumer

  Controlling build() cost
  Consumer widget provides more specific rebuilds that improves performance.
  Bob the builder
  child 부분은 다시 render 하지 않는다.

*

* state Management 에는 Ephemeral 과 App 이 있다.
* Ephemeral 은 local state 에 관련된거다.
* App 은 Global state 에 관련된거다.
* 1. 공유하고 싶은 클래스 생성
* 2. 이 클래스를 Provider 을 통해서 공유
* 3. Provider.of<xxx>(context) 를 통해서 값을 사용
 */
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("MyApp building");
    return ChangeNotifierProvider(
      create: (context) => ColorChangerNotifier(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    print("MyHomePage");
    //var colorChangeNotifier = Provider.of<ColorChangerNotifier>(context); // 객체 만들었고.. 그객체를 위에서 사용한다고 했고
    // 여기서 변수로 받았다. 그렇지만 여기가 있어서 build 할 때마다 계속 하위에 있는것들이 전부 다 다시 빌드가 되는거지.. 그래서 // TODO
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            MyContainer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Provider.of<ColorChangerNotifier>(context, listen: false)
                .changeColor(),
        // 괭장히 중요한 부분이다. 내가 만든 클래스의 함수를 실행시킬때 값이 변경되는건 궁금하지 않고 그냥 함수를 받아오고 싶을 때
        // listen : false 로 세팅해준다.
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyContainer extends StatelessWidget {
  const MyContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("MyContainer");
    //var _color = Provider.of<ColorChangerNotifier>(context).color;
    return Consumer<ColorChangerNotifier>(
      builder: (context, value, child) {
        print("container"); // 여기 보이지? container 는 실행된다. 그러나 밑에 봐라..
        return Container(
            color: value._color, padding: const EdgeInsets.all(10),
          child: const Text("AA"),
        );
      },
      child: const ShowText(), // 이부분 ShowText() 는 실행이 안된다.
    );
  }
}

class ShowText extends StatelessWidget {
  const ShowText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("ShowText");
    return Text(
      "ShowText",
      //Provider.of<CounterChangeNotifier>(context).counter.toString(),
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class CounterChangeNotifier with ChangeNotifier {
  // setState 대신에 사용할 수 있다.
  int _counter = 0;

  int get counter => _counter;

  increment() {
    _counter++;
    notifyListeners();
  }
}

class ColorChangerNotifier with ChangeNotifier {
  Color _color = Colors.red;

  Color get color => _color;

  changeColor() {
    if (_color == Colors.red) {
      _color = Colors.green;
    } else {
      _color = Colors.red;
    }
    notifyListeners();
  }
}
