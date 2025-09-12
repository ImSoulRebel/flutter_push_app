import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_push/presentation/blocs/blocs.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home-screen';

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select(
          (NotificationsBloc bloc) =>
              Text("Permisos ${bloc.state.authorizationStatus.name}"),
        ),

        actions: [
          IconButton(
            onPressed: () =>
                context.read<NotificationsBloc>().requestPermission(),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return context.select((NotificationsBloc bloc) {
      final notifications = bloc.state.notifications;
      return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final message = notifications[index];
          return ListTile(
            title: Text(message.title),
            subtitle: Text(message.body),
            leading: message.imageUrl != null
                ? Image.network(message.imageUrl!)
                : null,
            trailing: message.data?.isNotEmpty == true
                ? Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () =>
                context.push('/notification-detail/${message.messageId}'),
          );
        },
      );
    });
  }
}
