import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_hive/models/note_model.dart';
import 'package:note_hive/pages/detail_page.dart';
import 'package:note_hive/services/db_service.dart';

class HomePage extends StatefulWidget {
  static const String id = "/home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isListView = true;
  late List<Note> listNote;

  @override
  void initState() {
    super.initState();
    loadNoteList();
    print(listNote.length);
  }

  void loadNoteList() {
    setState(() {
      listNote = DBService.loadNotes();
    });
  }

  void _openDetailPage() async {
    var result = await Navigator.pushNamed(context, DetailPage.id);
    if (result != null && result == true) {
      loadNoteList();
    }
  }

  void _openDetailForEdit(Note note) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  note: note,
                )));
    if (result != null && result == true) {
      loadNoteList();
    }
  }

  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(
                Icons.menu_outlined,
                size: 30,
                color: Colors.black,
              ),
            );
          },
        ),
        title: Text(
          "All note",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search_sharp,
              size: 30,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isListView = !isListView;
              });
            },
            icon: isListView
                ? Icon(
                    CupertinoIcons.rectangle_grid_1x2,
                    size: 30,
                    color: Colors.black,
                  )
                : Icon(
                    CupertinoIcons.square_grid_2x2,
                    size: 30,
                    color: Colors.black,
                  ),
          ),
        ],
      ),
      drawer: Drawer(),
      body: listNote.isEmpty ? defaultHome(x) : nextHomeGridView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openDetailPage();
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }

  Widget defaultHome(double x) {
    return Center(
      child: Container(
        height: x / 2.7,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Container(
                  width: 140,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/img-1.jpg"),
                  )),
                ),
              ),
            ),
            SizedBox(
              height: x * 0.04,
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "You don't have any notes",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "Add a new note on the button down bellow",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nextHomeGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isListView ? 1 : 2,
        childAspectRatio: isListView ? 2.9 : 0.9,
      ),
      itemCount: listNote.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: InkWell(
            onTap: () {
              _openDetailForEdit(listNote[index]);
            },
            child: Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      listNote[index].title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        listNote[index].content,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        listNote[index].createTime.toString().substring(0,16),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
