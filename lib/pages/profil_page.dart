import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/academic_models.dart';
import '../theme/app_theme.dart';
import '../widgets/studylog_charts.dart';

class StudyLogProfilPage extends StatelessWidget {
  final Mahasiswa mahasiswa;
  final VoidCallback onLogout;

  const StudyLogProfilPage({
    super.key,
    required this.mahasiswa,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final rows = [
      {'label': 'Nama Lengkap', 'value': mahasiswa.namaLengkap},
      {'label': 'NIM', 'value': mahasiswa.nim},
      {
        'label': 'Program Studi',
        'value': '${mahasiswa.jurusan} (${mahasiswa.jenjang})',
      },
      {'label': 'Kelas', 'value': mahasiswa.kelas},
      {'label': 'Fakultas / Kampus', 'value': mahasiswa.fakultas},
      {'label': 'Semester Aktif', 'value': 'Semester ${mahasiswa.semester}'},
      {
        'label': 'IPK Kumulatif',
        'value': '${mahasiswa.ipkFormatted} / 4,00 (${mahasiswa.predikat})',
      },
      {'label': 'Dosen Wali', 'value': mahasiswa.dosenWali},
      {'label': 'Email Akademik', 'value': mahasiswa.email},
      {'label': 'Status', 'value': mahasiswa.statusAktif},
    ];

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'IDENTITAS MAHASISWA',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: StudyLogColors.orange,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Profil Akademik',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: StudyLogColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: StudyLogColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: StudyLogColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    const CampusLogoBadge(
                      size: 56,
                      borderRadius: 16,
                      padding: 5,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mahasiswa.namaLengkap,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: StudyLogColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: mahasiswa.nim),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('NIM berhasil disalin'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Text(
                              'NIM: ${mahasiswa.nim} · Kelas ${mahasiswa.kelas}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: StudyLogColors.orange,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: StudyLogColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: StudyLogColors.borderSubtle),
                ),
                child: Column(
                  children: rows
                      .map(
                        (r) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                r['label']!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: StudyLogColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  r['value']!,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: StudyLogColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: StudyLogColors.danger,
                    side: const BorderSide(color: StudyLogColors.danger),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text(
                    'Keluar dari Portal Mahasiswa',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
