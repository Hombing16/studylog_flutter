import 'package:flutter/material.dart';
import '../models/academic_models.dart';
import '../theme/app_theme.dart';

class StudyLogTugasPage extends StatefulWidget {
  final List<TugasKuliah> daftarTugas;
  final List<MataKuliah> daftarMataKuliah;
  final ValueChanged<int> onToggleTugas;
  final ValueChanged<TugasKuliah> onTambahTugas;

  const StudyLogTugasPage({
    super.key,
    required this.daftarTugas,
    required this.daftarMataKuliah,
    required this.onToggleTugas,
    required this.onTambahTugas,
  });

  @override
  State<StudyLogTugasPage> createState() => _StudyLogTugasPageState();
}

class _StudyLogTugasPageState extends State<StudyLogTugasPage> {
  String _filter = 'Semua';

  void _bukaFormTambahTugas() {
    final judulCtrl = TextEditingController();
    final tenggatCtrl = TextEditingController(text: 'Senin, 30 Nov 2026');
    final matkulAktif =
        widget.daftarMataKuliah.where((m) => m.dipilih).toList();
    String selectedMk = matkulAktif.isNotEmpty
        ? matkulAktif.first.nama
        : widget.daftarMataKuliah.first.nama;
    String prioritas = 'Sedang';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: StudyLogColors.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final mediaQuery = MediaQuery.of(ctx);
            final keyboardInset = mediaQuery.viewInsets.bottom;
            final navBarInset = mediaQuery.viewPadding.bottom;

            return AnimatedPadding(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    (navBarInset > 0 ? 16 : 24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: StudyLogColors.borderSubtle,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const Text(
                        'Tambah Tugas Baru',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: StudyLogColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: judulCtrl,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Judul Tugas',
                          hintText: 'Contoh: Implementasi UI Dashboard Flutter',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedMk,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Mata Kuliah',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: widget.daftarMataKuliah
                            .map(
                              (mk) => DropdownMenuItem(
                                value: mk.nama,
                                child: Text(
                                  mk.nama,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => selectedMk = val);
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: tenggatCtrl,
                              decoration: InputDecoration(
                                labelText: 'Tenggat Waktu',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          DropdownButton<String>(
                            value: prioritas,
                            items: ['Tinggi', 'Sedang', 'Rendah']
                                .map(
                                  (p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(p),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => prioritas = val);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: StudyLogColors.orangeBright,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (judulCtrl.text.trim().isEmpty) return;
                            widget.onTambahTugas(
                              TugasKuliah(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                judul: judulCtrl.text.trim(),
                                mataKuliah: selectedMk,
                                tenggat: tenggatCtrl.text.trim(),
                                prioritas: prioritas,
                              ),
                            );
                            setState(() {});
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'Simpan Tugas',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tugasAktifCount = widget.daftarTugas.where((t) => !t.selesai).length;
    final filtered = widget.daftarTugas.where((t) {
      if (_filter == 'Aktif') return !t.selesai;
      if (_filter == 'Selesai') return t.selesai;
      return true;
    }).toList();

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MANAJEMEN TUGAS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: StudyLogColors.orange,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text(
                                'Tugas Kuliah',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: StudyLogColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: tugasAktifCount > 0
                                      ? StudyLogColors.orangeSoft
                                      : StudyLogColors.successBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$tugasAktifCount Aktif',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: tugasAktifCount > 0
                                        ? StudyLogColors.orange
                                        : StudyLogColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: StudyLogColors.orangeBright,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _bukaFormTambahTugas,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text(
                        'Tugas',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 12),
                child: Wrap(
                  spacing: 8,
                  children: ['Semua', 'Aktif', 'Selesai'].map((label) {
                    final selected = _filter == label;
                    return ChoiceChip(
                      label: Text(label),
                      selected: selected,
                      selectedColor: StudyLogColors.orangeBright,
                      backgroundColor: StudyLogColors.surfaceWhite,
                      labelStyle: TextStyle(
                        color: selected
                            ? Colors.white
                            : StudyLogColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                      onSelected: (_) => setState(() => _filter = label),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada tugas pada kategori "$_filter".',
                          style: const TextStyle(
                            color: StudyLogColors.textSecondary,
                            fontSize: 13.5,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 2, 20, 20),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, idx) {
                          final tugas = filtered[idx];
                          final realIndex = widget.daftarTugas.indexOf(tugas);

                          return Container(
                            decoration: BoxDecoration(
                              color: StudyLogColors.surfaceWhite,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: StudyLogColors.borderSubtle,
                              ),
                            ),
                            child: CheckboxListTile(
                              value: tugas.selesai,
                              onChanged: (_) {
                                widget.onToggleTugas(realIndex);
                                setState(() {});
                              },
                              activeColor: StudyLogColors.orangeBright,
                              title: Text(
                                tugas.judul,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  decoration: tugas.selesai
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: tugas.selesai
                                      ? StudyLogColors.textMuted
                                      : StudyLogColors.textPrimary,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '${tugas.mataKuliah} · Tenggat: ${tugas.tenggat}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: StudyLogColors.textSecondary,
                                  ),
                                ),
                              ),
                              secondary: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: tugas.prioritas == 'Tinggi'
                                      ? StudyLogColors.orangeSoft
                                      : StudyLogColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tugas.prioritas,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: tugas.prioritas == 'Tinggi'
                                        ? StudyLogColors.orange
                                        : StudyLogColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
