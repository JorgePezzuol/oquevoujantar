import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const categories = <Category>[
  Category(
      name: 'Lanches', code: 'lch', imageUrl: 'https://static-images.ifood.com.br/image/upload/f_auto,t_low/discoveries/19C1-lanches-v2.jpg'),
  Category(name: 'Pizza', code: 'piz', imageUrl: 'https://static-images.ifood.com.br/image/upload/f_auto,t_low/discoveries/19C1-pizza.jpg'),
  Category(name: 'Japonesa', code: 'jap', imageUrl: 'https://static-images.ifood.com.br/image/upload/f_auto,t_low/discoveries/19C1-japonesa.jpg'),
  Category(name: 'Chinesa', code: 'chi', imageUrl: 'https://static-images.ifood.com.br/image/upload/f_auto,t_low/discoveries/19C1-chinesa.jpg'),
  Category(name: 'Àrabe', code: 'ara', imageUrl: 'https://static-images.ifood.com.br/image/upload/f_auto,t_low/discoveries/19C1-arabe.jpg')
];


class Categories extends StatefulWidget {
  Categories({Key key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Categorias", style: GoogleFonts.oswald(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.deepOrange,
        ),
        body: CategoryList(categories)
    );
  }
}


class CategoryList extends StatelessWidget {
  final List<Category> _categories;

  CategoryList(this._categories);

  @override
  Widget build(BuildContext context) {

    return ListView.separated(

      separatorBuilder: (context, index) {
        return Divider();
      },
      itemBuilder: (context, index) {
        return InkWell(
              child:_CategoryListItem(_categories[index]),
              onTap: () {
                Navigator.pop(context, _categories[index].code);
              },
            );
      },
      padding: EdgeInsets.symmetric(vertical: 10.0),
      itemCount: _categories.length,
    );
  }
}

class _CategoryListItem extends ListTile {
    _CategoryListItem(Category category)
      : super(
      title: Text(category.name),
      subtitle: null,
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(category.imageUrl),
      )
    );
}

class Category {
  final String name;
  final String imageUrl;
  final String code;

  const Category({this.name, this.code, this.imageUrl});
}
