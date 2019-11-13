import 'package:flutter_app/util/StringUtils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/util/NetUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget  {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '沓诗词（flutter）',
      home: new RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <Map>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('沓诗词（flutter）'),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        // WaterDropHeader、ClassicHeader、CustomHeader、LinkHeader、MaterialClassicHeader、WaterDropMaterialHeader
        header: ClassicHeader(
          height: 45.0,
          releaseText: '松开手刷新',
          refreshingText: '刷新中',
          completeText: '刷新完成',
          failedText: '刷新失败',
          idleText: '下拉刷新',
        ),
        // ClassicFooter、CustomFooter、LinkFooter、LoadIndicator
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            }
            else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            }
            else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            }
            else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child:ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return new Divider();
            // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
            // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
            final index = i ~/ 2;
            return _buildRow(_suggestions[index]);
          },
          itemCount: 2*_suggestions.length,
        )
      ),
    );
  }

  RefreshController _refreshController;
  String data="";
  var  page=1;

  void _onRefresh(){
    page=1;
    _onLoading();
  }

  Future _onLoading() async {
    var  reqs = 'https://xuyida.club/all/'+(page++).toString();
    var response;
    try {
      response = await NetUtils.get(reqs, {});
      print('response1-$response');
      setState(() {
        data= '$response';
        List list=response['list'];
        Iterator iterator=list.iterator;
        while(iterator.moveNext()){
          _suggestions.add(iterator.current);
        }
        if(page==2){
          _refreshController.refreshCompleted();
        }else _refreshController.loadComplete();
      });
    } catch (e) {
      print('response-$e');
    }
    return response;
  }

  void addDate(){

  }

  Widget _buildRow(Map pair) {
    return new Container(
      child: Column(
          children: [
            new Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: new Text(
                pair['name'],
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            new Text(
               pair['poet'],
              style: new TextStyle(
                color: Colors.grey[500],
              ),
            ),
//            new Text(
//              StringUtils.stripEmpty(pair['content'])
//              ,
//              style: new TextStyle(
//                color: Colors.grey[500],
//              ),
//            ),
            Html(
              data:
               StringUtils.stripEmpty(pair['content'])
              ,
            )
          ]
      )
    );
  }

  RandomWordsState(){
    _refreshController= RefreshController(initialRefresh: true);
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}