import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/module/admin/admin_bloc.dart';
import 'package:wine_app/shared/model/user_data.dart';

import 'admin_detail_user_page.dart';

class ListProfilePage extends StatefulWidget {
  @override
  _ListProfilePageState createState() => _ListProfilePageState();
}

class _ListProfilePageState extends State<ListProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Provider.value(
        value: AdminBloc.getInstance(
          wineRepo: Provider.of(context),
          orderRepo: Provider.of(context),
          userRepo: Provider.of(context),
        ),
        child: ListProfileWidget());
  }
}

class ListProfileWidget extends StatefulWidget {
  AdminBloc bloc;

  ListProfileWidget({this.bloc});

  @override
  _ListProfileWidgetState createState() => _ListProfileWidgetState();
}

class _ListProfileWidgetState extends State<ListProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách người dùng'),
      ),
      body: StreamProvider<List<UserData>>.value(
        value: widget.bloc.getListUserData(),
        initialData: List<UserData>(),
        child: Consumer<List<UserData>>(
          builder: (context, users, child) => ListView.separated(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return _buildListTile(users[index]);
            },
            separatorBuilder: (context, index) => Container(
              color: Colors.lightBlueAccent,
              height: 10,
            ),
          ),
        ),
      ),
    );
  }

  _buildListTile(UserData user) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailUserWidget(userData: user, bloc: widget.bloc)));
        },
        title: Text(
          '${user.phone}',
        ),
        subtitle: Text('${user.displayName}\nĐiểm:${user.point}'),
        leading: user.avatar == "" || user.avatar == null
            ? Image.asset(
                'assets/img/user.png',
                height: 50,
                width: 50,
              )
            : Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).scaffoldBackgroundColor),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 10))
                    ],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(
                          user.avatar == null || user.avatar == ""
                              ? "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250"
                              : "${user.avatar}",
                        ))),
              ),
      ),
    );
  }
}
