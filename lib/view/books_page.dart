import 'package:flutter/material.dart';
import 'package:yazar/model/book.dart';
import 'package:yazar/model/local_databese.dart';

// ignore: must_be_immutable
class BooksPage extends StatefulWidget {
  BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  LocalDataBase _localDataBase = LocalDataBase();

  List<Book> _allBooks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildBookAddButton(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Books'),
    );
  }

  Widget _buildBody() {
    return FutureBuilder(future: _readAllBooks(), builder: _buildFutureBuilder);
  }

  Widget _buildFutureBuilder(
      BuildContext context, AsyncSnapshot<void> snapshot) {
    return ListView.builder(
        itemBuilder: _itemBuilder, itemCount: _allBooks.length);
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    return Dismissible(
      key: Key(_allBooks[index].id.toString()),
      onDismissed: (direction) {
        _bookDelete(index);
        _allBooks.removeAt(index);
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Text(_allBooks[index].id.toString()),
          ),
          title: Text(_allBooks[index].name),
          subtitle: Text(_allBooks[index].createdTime.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: () {
                  _bookUpdate(context, index);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookAddButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _booksAddButtonPressed(context);
      },
      child: const Icon(Icons.add),
    );
  }

  void _booksAddButtonPressed(BuildContext context) async {
    String? bookName = await _windowOpen(context);

    if (bookName != null) {
      Book newBook = Book(bookName, DateTime.now());
      int _bookId = await _localDataBase.createdBook(newBook);
      print('Book Id: $_bookId');
      setState(() {});
    }
  }

  Future<void> _readAllBooks() async {
    _allBooks = await _localDataBase.readAllBooks();
  }

  void _bookUpdate(BuildContext context, int index) async {
    String? newbookName = await _windowOpen(context);

    if (newbookName != null) {
      Book book = _allBooks[index];
      book.name = newbookName;
      int updateRowCount = await _localDataBase.updateBook(book);
      if (updateRowCount > 0) {
        setState(() {});
      }
    }
  }

  void _bookDelete(int index) async {
    int deleteRowCount = await _localDataBase.deleteBook(_allBooks[index]);
    if (deleteRowCount > 0) {
      setState(() {});
    }
  }

  Future<String?> _windowOpen(BuildContext context) {
    return showDialog<String>(
        context: context,
        builder: (context) {
          String? _values;

          return AlertDialog(
            title: const Text('Kitap Adını Giriniz'),
            content: TextField(
              autofocus: true,
              onChanged: (value) {
                _values = value;
              },
            ),
            actions: [
              TextButton(
                child: const Text(
                  'İptal',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  'Onayla',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context, _values);
                },
              ),
            ],
          );
        });
  }
}
