import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/di/providers.dart';
import '../../../core/utils/id_generator.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/site_mission.dart';

class SiteMissionFormScreen extends ConsumerStatefulWidget {
  final String? clientId;
  final String? siteId;

  const SiteMissionFormScreen({
    super.key,
    this.clientId,
    this.siteId,
  });

  @override
  ConsumerState<SiteMissionFormScreen> createState() =>
      _SiteMissionFormScreenState();
}

class _SiteMissionFormScreenState extends ConsumerState<SiteMissionFormScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  SiteMissionType _selectedType = SiteMissionType.intervention;

  bool get _isEditing => widget.siteId != null;

  String? _resolvedClientId() {
    if (widget.clientId != null) return widget.clientId;
    if (_isEditing) {
      return ref
          .read(clientsRepositoryProvider)
          .getSiteById(widget.siteId!)
          ?.clientId;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final site =
          ref.read(clientsRepositoryProvider).getSiteById(widget.siteId!);
      if (site != null) {
        _nameController.text = site.name;
        _addressController.text = site.address ?? '';
        _noteController.text = site.note ?? '';
        _selectedType = site.type;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  void _save() {
    if (!_canSave) return;
    final clientId = _resolvedClientId();
    if (clientId == null) return;

    final site = SiteMission(
      id: _isEditing ? widget.siteId! : IdGenerator.generate(),
      clientId: clientId,
      name: _nameController.text.trim(),
      type: _selectedType,
      address: _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : null,
      note: _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : null,
    );

    final repo = ref.read(clientsRepositoryProvider);
    if (_isEditing) {
      repo.updateSite(site);
    } else {
      repo.addSite(site);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final clientId = _resolvedClientId();
    final client = clientId != null
        ? ref.read(clientsRepositoryProvider).getClientById(clientId)
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          _isEditing ? l10n.editSite : l10n.newSite,
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
            // Bandeau client (lecture seule)
            if (client != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: client.color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        client.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.clientLabel} ${client.name}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Nom
            _FormLabel(l10n.siteName, required: true),
            const SizedBox(height: 6),
            _TextField(
              controller: _nameController,
              hint: l10n.siteNameHint,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),

            // Type
            _FormLabel(l10n.siteType, required: true),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: SiteMissionType.values.map((type) {
                final selected = _selectedType == type;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedType = type),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      _typeLabel(type, l10n),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),

            // Adresse
            _FormLabel(l10n.siteAddress),
            const SizedBox(height: 6),
            _TextField(
              controller: _addressController,
              hint: l10n.siteAddressHint,
            ),
            const SizedBox(height: AppSpacing.md),

            // Note
            _FormLabel(l10n.siteNote),
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
                  hintText: l10n.siteNote,
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

  String _typeLabel(SiteMissionType type, AppLocalizations l10n) =>
      switch (type) {
        SiteMissionType.intervention => l10n.siteTypeIntervention,
        SiteMissionType.maintenance => l10n.siteTypeMaintenance,
        SiteMissionType.delivery => l10n.siteTypeDelivery,
        SiteMissionType.control => l10n.siteTypeControl,
        SiteMissionType.other => l10n.siteTypeOther,
      };
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
