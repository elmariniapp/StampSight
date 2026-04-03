import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/di/providers.dart';
import '../../../core/utils/id_generator.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/client.dart';

class ClientFormScreen extends ConsumerStatefulWidget {
  final String? clientId;

  const ClientFormScreen({super.key, this.clientId});

  @override
  ConsumerState<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends ConsumerState<ClientFormScreen> {
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _noteController = TextEditingController();
  Color _selectedColor = AppColors.primary;

  bool get _isEditing => widget.clientId != null;

  static const _palette = [
    Color(0xFF0D1B2A),
    Color(0xFF2563EB),
    Color(0xFF059669),
    Color(0xFFDC2626),
    Color(0xFFD97706),
    Color(0xFF7C3AED),
    Color(0xFF0891B2),
    Color(0xFF475569),
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final client =
          ref.read(clientsRepositoryProvider).getClientById(widget.clientId!);
      if (client != null) {
        _nameController.text = client.name;
        _companyController.text = client.company ?? '';
        _noteController.text = client.note ?? '';
        _selectedColor = client.color;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  void _save() {
    if (!_canSave) return;

    final client = Client(
      id: _isEditing ? widget.clientId! : IdGenerator.generate(),
      name: _nameController.text.trim(),
      company: _companyController.text.trim().isNotEmpty
          ? _companyController.text.trim()
          : null,
      color: _selectedColor,
      note: _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : null,
    );

    final repo = ref.read(clientsRepositoryProvider);
    if (_isEditing) {
      repo.updateClient(client);
    } else {
      repo.addClient(client);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          _isEditing ? l10n.editClient : l10n.newClient,
          style: AppTextStyles.titleMedium,
        ),
        leading: TextButton(
          onPressed: () => context.pop(),
          child: Text(
            l10n.cancel,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        leadingWidth: 80,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom
            _FormLabel(l10n.clientName, required: true),
            const SizedBox(height: 6),
            _TextField(
              controller: _nameController,
              hint: l10n.clientNameHint,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),

            // Société
            _FormLabel(l10n.company),
            const SizedBox(height: 6),
            _TextField(
              controller: _companyController,
              hint: l10n.companyHint,
            ),
            const SizedBox(height: AppSpacing.md),

            // Couleur
            _FormLabel(l10n.color),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _palette.map((color) {
                final selected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              width: 3)
                          : null,
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: selected
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 16)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),

            // Note
            _FormLabel(l10n.clientNote),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: l10n.clientNote,
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(AppSpacing.md),
                ),
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary),
                maxLines: 3,
                minLines: 2,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSave ? _save : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.border,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.save,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String label;
  final bool required;

  const _FormLabel(this.label, {this.required = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  const _TextField({
    required this.controller,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 13,
            color: AppColors.textTertiary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: 14),
        ),
        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        onChanged: onChanged,
      ),
    );
  }
}
