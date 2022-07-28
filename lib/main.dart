import 'package:flutter/material.dart';

import 'shrink_wrap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget offstage = const Offstage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      backgroundColor: Colors.grey.shade300,
      body: ListView.separated(
        itemCount: 10,
        padding: const EdgeInsets.all(8),
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (ctx, index) => const Item(),
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('images/luckin.png'),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('瑞辛咖啡',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(children: const [
                  Text('4.7分',
                      style: TextStyle(color: Colors.deepOrangeAccent)),
                  SizedBox(width: 4),
                  Text('月售7000', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 4),
                  Text('人均￥19', style: TextStyle(color: Colors.grey)),
                  Spacer(),
                  Text('某团专送',
                      style: TextStyle(color: Colors.deepOrangeAccent)),
                ]),
                Row(children: const [
                  Text('起送￥15', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 4),
                  Text('配送 约￥4', style: TextStyle(color: Colors.grey)),
                  Spacer(),
                  Text('30分钟', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 4),
                  Text('1.3km', style: TextStyle(color: Colors.grey)),
                ]),
                LabelWidget(
                  children: List.generate(tags.length, (i) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border:
                              Border.all(width: 1, color: Colors.redAccent)),
                      child: Text(tags[i],
                          style: const TextStyle(
                              color: Colors.redAccent, fontSize: 10)),
                    );
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  static List<String> tags = [
    '新客立减3元',
    '28减2',
    '50减3',
    '80减5',
    '110减8',
    '9折起',
    '收藏领2元券',
    '下单送赠品',
  ];
}

class LabelWidget extends StatefulWidget {
  final List<Widget> children;
  final double spacing, runSpacing;
  final int maxLines;

  const LabelWidget(
      {Key? key,
      required this.children,
      this.spacing = 3,
      this.runSpacing = 2,
      this.maxLines = 1})
      : super(key: key);

  @override
  State<LabelWidget> createState() => _LabelWidgetState();
}

class _LabelWidgetState extends State<LabelWidget> {
  GlobalKey wrapUniqueKey = GlobalKey();
  final ValueNotifier<int> totalRowCount = ValueNotifier(0);
  bool expand = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var renderObject = wrapUniqueKey.currentContext?.findRenderObject();
      if (renderObject == null) return;
      totalRowCount.value = (renderObject as RenderShrinkWrap).totalRowCount;
    });
  }

  @override
  void dispose() {
    totalRowCount.dispose();
    super.dispose();
  }

  static const Widget spacerButton = SizedBox(width: 14);
  static const Widget upButton =
      Icon(Icons.arrow_drop_up_rounded, color: Colors.black54, size: 14);
  static const Widget downButton =
      Icon(Icons.arrow_drop_down_rounded, color: Colors.black54, size: 14);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (totalRowCount.value <= widget.maxLines) return;
        setState(() => expand = !expand);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ShrinkWrap(
              key: wrapUniqueKey,
              spacing: widget.spacing,
              runSpacing: widget.runSpacing,
              maxLines: expand ? 0 : widget.maxLines,
              children: widget.children,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: totalRowCount,
            builder: (_, __, ___) {
              if (totalRowCount.value <= widget.maxLines) return spacerButton;
              return expand ? upButton : downButton;
            },
          )
        ],
      ),
    );
  }
}
