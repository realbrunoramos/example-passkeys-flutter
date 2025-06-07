import 'package:corbado_auth/corbado_auth.dart';
import 'package:flutter/material.dart';

class PasskeyCard extends StatelessWidget {
  final PasskeyInfo passkey;
  final void Function(String) onDelete;

  const PasskeyCard({
    Key? key,
    required this.passkey,
    required this.onDelete,
  }) : super(key: key);

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: const Text('Eliminar'),
              onTap: () {
                Navigator.of(context).pop();
                onDelete(passkey.id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showOptions(context),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.vpn_key,
                color: Theme.of(context).colorScheme.primary,
                size: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: ${passkey.id}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Dispositivo: ${passkey.sourceOS}, ${passkey.sourceBrowser}',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Text(
                      'Criada: ${passkey.created}',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Text(
                      'Sincronizada: ${passkey.backupState}',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}