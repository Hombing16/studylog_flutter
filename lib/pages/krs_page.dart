import 'package:flutter/material.dart';
import '../models/academic_models.dart';
import '../theme/app_theme.dart';

class StudyLogKrsPage extends StatelessWidget {
  final Mahasiswa mahasiswa;
  final List<MataKuliah> daftarMataKuliah;
  final int totalSksDipilih;
  final void Function(int index, bool? value) onToggleMk;

  const StudyLogKrsPage({
    super.key,
    required this.mahasiswa,
    required this.daftarMataKuliah,
    required this.totalSksDipilih,
    required this.onToggleMk,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = (totalSksDipilih / mahasiswa.maxSksKrs).clamp(0.0, 1.0);

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PENGISIAN RENCANA STUDI',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: StudyLogColors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Kartu Rencana Studi (KRS)',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: StudyLogColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: StudyLogColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: StudyLogColors.borderSubtle),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${mahasiswa.namaLengkap} · ${mahasiswa.kelas}',
                                  style: const TextStyle(
                                    color: StudyLogColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$totalSksDipilih / ${mahasiswa.maxSksKrs} SKS',
                                style: const TextStyle(
                                  color: StudyLogColors.orange,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: ratio,
                              minHeight: 7,
                              backgroundColor: const Color(0xFFE5E7EB),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                StudyLogColors.orangeBright,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  itemCount: daftarMataKuliah.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final mk = daftarMataKuliah[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: StudyLogColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: mk.dipilih
                              ? StudyLogColors.orangeBright
                              : StudyLogColors.borderSubtle,
                          width: mk.dipilih ? 1.5 : 1,
                        ),
                      ),
                      child: CheckboxListTile(
                        value: mk.dipilih,
                        onChanged: (val) => onToggleMk(index, val),
                        activeColor: StudyLogColors.orangeBright,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                mk.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: StudyLogColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: StudyLogColors.orangeSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${mk.sks} SKS',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: StudyLogColors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '${mk.kode} · ${mk.jadwalLengkap} (${mk.ruang})\Dosen: ${mk.dosen}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: StudyLogColors.textSecondary,
                            ),
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: StudyLogColors.orangeBright,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: totalSksDipilih == 0
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'KRS berhasil disimpan ($totalSksDipilih SKS) & grafik Beban SKS diperbarui!',
                                ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: Text(
                      'Simpan KRS ($totalSksDipilih SKS)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
