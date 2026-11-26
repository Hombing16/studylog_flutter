import 'package:flutter/material.dart';
import '../models/academic_models.dart';
import '../theme/app_theme.dart';

class StudyLogJadwalKhsPage extends StatelessWidget {
  final Mahasiswa mahasiswa;
  final List<MataKuliah> daftarMataKuliah;
  final List<RiwayatSemester> riwayatSemester;
  final List<NilaiMataKuliah> transkripTerbaru;

  const StudyLogJadwalKhsPage({
    super.key,
    required this.mahasiswa,
    required this.daftarMataKuliah,
    required this.riwayatSemester,
    required this.transkripTerbaru,
  });

  @override
  Widget build(BuildContext context) {
    final jadwalAktif = daftarMataKuliah.where((m) => m.dipilih).toList();

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AKADEMIK & HASIL STUDI',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.6,
                          color: StudyLogColors.orange,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Jadwal & KHS',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: StudyLogColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TabBar(
                    labelColor: StudyLogColors.orange,
                    unselectedLabelColor: StudyLogColors.textSecondary,
                    indicatorColor: StudyLogColors.orange,
                    tabs: [
                      Tab(text: 'Jadwal Kuliah'),
                      Tab(text: 'KHS & Transkrip'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: jadwalAktif.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final mk = jadwalAktif[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: StudyLogColors.surfaceWhite,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: StudyLogColors.borderSubtle,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: StudyLogColors.charcoal,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    mk.hari.substring(0, 3).toUpperCase(),
                                    style: const TextStyle(
                                      color: StudyLogColors.orangeBright,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mk.nama,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: StudyLogColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${mk.jam} · ${mk.ruang} · ${mk.sks} SKS',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: StudyLogColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: StudyLogColors.charcoal,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _stat('IPK', mahasiswa.ipkFormatted),
                                _stat(
                                  'SKS Lulus',
                                  '${mahasiswa.totalSksLulus}',
                                ),
                                _stat('Predikat', mahasiswa.predikat),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'RINGKASAN IPS PER SEMESTER',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                              color: StudyLogColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...riwayatSemester.map(
                            (r) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: StudyLogColors.surfaceWhite,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: StudyLogColors.borderSubtle,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Semester ${r.semester} (${r.sks} SKS)',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: StudyLogColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'IPS: ${r.ips.toStringAsFixed(2).replaceAll('.', ',')}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: StudyLogColors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'NILAI KHS SEMESTER 4',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                              color: StudyLogColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...transkripTerbaru.map(
                            (n) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: StudyLogColors.surfaceWhite,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: StudyLogColors.borderSubtle,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          n.nama,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.5,
                                          ),
                                        ),
                                        Text(
                                          '${n.kode} · ${n.sks} SKS',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: StudyLogColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: StudyLogColors.orangeSoft,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      n.nilaiHuruf,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: StudyLogColors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            color: StudyLogColors.textMuted,
          ),
        ),
      ],
    );
  }
}
