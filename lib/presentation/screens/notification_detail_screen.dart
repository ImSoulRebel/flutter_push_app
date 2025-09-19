import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_push/domain/entities/entities.dart';
import 'package:flutter_push/presentation/blocs/blocs.dart';

class NotificationDetailScreen extends StatelessWidget {
  static const String routeName = 'notification-detail-screen';

  final String pushMessageId;

  const NotificationDetailScreen({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {
    final PushMessageEntity? message = context
        .read<NotificationsBloc>()
        .getMessageById(pushMessageId);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de Notificación')),
      body: message != null
          ? _NotificationDetailView(message: message)
          : const Center(child: Text('Notificación no encontrada')),
    );
  }
}

class _NotificationDetailView extends StatelessWidget {
  final PushMessageEntity message;

  const _NotificationDetailView({required this.message});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (message.imageUrl != null) Image.network(message.imageUrl!),
          const SizedBox(height: 16),
          Text(message.title, style: textStyles.titleMedium),
          Text(message.body),
          const Divider(),
          if (message.data != null && message.data!.isNotEmpty) ...[
            const Text('Datos Adicionales:'),
            ...message.data!.entries.map(
              (entry) => Text('${entry.key}: ${entry.value}'),
            ),
          ],
        ],
      ),
    );
  }
}
