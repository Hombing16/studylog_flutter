import 'package:flutter/material.dart';
import 'models/academic_models.dart';
import 'pages/dashboard_page.dart';
import 'pages/jadwal_page.dart';
import 'pages/krs_khs_page.dart';
import 'pages/login_page.dart';
import 'pages/profil_page.dart';
import 'pages/tugas_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const StudyLogApp());
}

class StudyLogApp extends StatefulWidget {
  const StudyLogApp({super.key});

  @override
  State<StudyLogApp> createState() => _StudyLogAppState();
}

class _StudyLogAppState extends State<StudyLogApp> {
  bool _isLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STUDYLOG - Portal Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: StudyLogTheme.lightTheme,
      home: _isLoggedIn
          ? MainPortalShell(
              onLogout: () => setState(() => _isLoggedIn = false),
            )
          : StudyLogLoginPage(
              onLoginSuccess: () => setState(() => _isLoggedIn = true),
            ),
    );
  }
}

class MainPortalShell extends StatefulWidget {
  final VoidCallback onLogout;

  const MainPortalShell({super.key, required this.onLogout});

  @override
  State<MainPortalShell> createState() => _MainPortalShellState();
}

class _MainPortalShellState extends State<MainPortalShell> {
  int _selectedIndex = 0;

  final Mahasiswa _mahasiswa = const Mahasiswa(
    namaPanggilan: 'Luis',
    namaLengkap: 'Luis Lumbantoruan',
    nim: '2411093',
    jurusan: 'Informatika',
    jenjang: 'S1',
    kelas: 'IFB5A',
    fakultas: 'FIKOM · Universitas Mulia',
    ipk: 3.65,
    semester: 5,
    totalSksLulus: 96,
    maxSksKrs: 24,
    dosenWali: 'Nasruddin Bin Idris, S.Kom., M.Kom.',
    email: '2411093@students.universitasmulia.ac.id',
    statusAktif: 'Aktif · Semester Ganjil 2026/2027',
  );

  final List<RiwayatSemester> _riwayatSemester = const [
    RiwayatSemester(semester: 1, label: 'Sem 1', ips: 3.52, sks: 22),
    RiwayatSemester(semester: 2, label: 'Sem 2', ips: 3.60, sks: 24),
    RiwayatSemester(semester: 3, label: 'Sem 3', ips: 3.71, sks: 24),
    RiwayatSemester(semester: 4, label: 'Sem 4', ips: 3.77, sks: 26),
  ];

  final List<NilaiMataKuliah> _transkripTerbaru = const [
    NilaiMataKuliah(
      kode: 'IF401',
      nama: 'Rekayasa Perangkat Lunak',
      sks: 3,
      nilaiHuruf: 'A',
      bobot: 4.0,
    ),
    NilaiMataKuliah(
      kode: 'IF402',
      nama: 'Pemrograman Web Lanjut',
      sks: 3,
      nilaiHuruf: 'A',
      bobot: 4.0,
    ),
    NilaiMataKuliah(
      kode: 'IF403',
      nama: 'Kecerdasan Buatan',
      sks: 3,
      nilaiHuruf: 'A-',
      bobot: 3.75,
    ),
    NilaiMataKuliah(
      kode: 'IF404',
      nama: 'Struktur Data & Algoritma',
      sks: 3,
      nilaiHuruf: 'B+',
      bobot: 3.5,
    ),
  ];

  late final List<MataKuliah> _daftarMataKuliah = [
    MataKuliah(
      kode: '111500',
      nama: 'Sistem Manajemen Basis Data',
      sks: 3,
      hari: 'Senin',
      jam: '08:00 - 10:30',
      ruang: 'LAB D (FIKOM)',
      dosen: 'Nasruddin Bin Idris, S.Kom., M.Kom.',
      totalPertemuan: 16,
      pertemuanHadir: 15,
      statusSesi: 'Selesai',
      dipilih: true,
    ),
    MataKuliah(
      kode: '111600',
      nama: 'Teknologi Aplikasi Bergerak',
      sks: 3,
      hari: 'Senin',
      jam: '13:00 - 15:30',
      ruang: 'LAB B (FIKOM)',
      dosen: 'Istia Budi, S.T., M.M.',
      totalPertemuan: 16,
      pertemuanHadir: 14,
      statusSesi: 'Selesai',
      dipilih: true,
    ),
    MataKuliah(
      kode: '111100',
      nama: 'Penalaran Komputer',
      sks: 3,
      hari: 'Selasa',
      jam: '13:00 - 15:30',
      ruang: 'A201',
      dosen: 'Isa Rosita, S.Kom., M.Cs.',
      totalPertemuan: 16,
      pertemuanHadir: 15,
      statusSesi: 'Selesai',
      dipilih: true,
    ),
    MataKuliah(
      kode: '111300',
      nama: 'Robotika',
      sks: 3,
      hari: 'Rabu',
      jam: '10:30 - 13:00',
      ruang: 'LAB ROBOTIK (FIKOM)',
      dosen: "Muhammad Safi'i, S.Kom., M.Kom.",
      totalPertemuan: 16,
      pertemuanHadir: 14,
      statusSesi: 'Selesai',
      dipilih: true,
    ),
    MataKuliah(
      kode: '110600',
      nama: 'Jaringan Nirkabel',
      sks: 3,
      hari: 'Kamis',
      jam: '08:00 - 10:30',
      ruang: 'LAB JARINGAN (FIKOM)',
      dosen: 'Wisnu Hera Pamungkas, S.T.P., M.Eng',
      totalPertemuan: 16,
      pertemuanHadir: 14,
      statusSesi: 'Sedang Berlangsung',
      dipilih: true,
    ),
    MataKuliah(
      kode: '111000',
      nama: 'Pemrograman Aplikasi Bergerak',
      sks: 3,
      hari: 'Kamis',
      jam: '13:00 - 15:30',
      ruang: 'LAB A (FIKOM)',
      dosen: 'Pramudya Prima Insan, S.Kom., M.Kom.',
      totalPertemuan: 16,
      pertemuanHadir: 16,
      statusSesi: 'Akan Datang',
      dipilih: true,
    ),
    MataKuliah(
      kode: '000800',
      nama: 'Penulisan dan Publikasi Ilmiah',
      sks: 2,
      hari: 'Jumat',
      jam: '08:00 - 09:40',
      ruang: 'A202',
      dosen: 'Yusuf Wibisono, S.E., M.T.I.',
      totalPertemuan: 16,
      pertemuanHadir: 14,
      statusSesi: 'Akan Datang',
      dipilih: true,
    ),
    MataKuliah(
      kode: '110700',
      nama: 'Kriptografi',
      sks: 3,
      hari: 'Jumat',
      jam: '10:30 - 13:00',
      ruang: 'A202',
      dosen: 'Sumardi, S.Kom., M.Kom.',
      totalPertemuan: 16,
      pertemuanHadir: 14,
      statusSesi: 'Akan Datang',
      dipilih: true,
    ),
  ];

  late final List<TugasKuliah> _daftarTugas = [
    TugasKuliah(
      id: '1',
      judul: 'Desain UI Dashboard & KRS StudyLog (Flutter)',
      mataKuliah: 'Pemrograman Aplikasi Bergerak',
      tenggat: 'Besok, 23:59',
      prioritas: 'Tinggi',
      selesai: false,
    ),
    TugasKuliah(
      id: '2',
      judul: 'Analisis Protokol & Topologi Jaringan Nirkabel',
      mataKuliah: 'Jaringan Nirkabel',
      tenggat: 'Sabtu, 28 Nov 2026',
      prioritas: 'Sedang',
      selesai: false,
    ),
    TugasKuliah(
      id: '3',
      judul: 'Perancangan Skema & Optimasi Query Basis Data',
      mataKuliah: 'Sistem Manajemen Basis Data',
      tenggat: 'Senin, 30 Nov 2026',
      prioritas: 'Sedang',
      selesai: false,
    ),
    TugasKuliah(
      id: '4',
      judul: 'Simulasi Kontrol Servo & Sensor Ultrasonik',
      mataKuliah: 'Robotika',
      tenggat: 'Selesai',
      prioritas: 'Rendah',
      selesai: true,
    ),
  ];

  int get _totalSksDipilih => _daftarMataKuliah
      .where((mk) => mk.dipilih)
      .fold(0, (sum, mk) => sum + mk.sks);

  int get _tugasAktifCount =>
      _daftarTugas.where((tugas) => !tugas.selesai).length;

  void _pindahTab(int index) {
    setState(() => _selectedIndex = index);
  }

  void _toggleMataKuliah(int index, bool? value) {
    final mk = _daftarMataKuliah[index];
    final inginPilih = value ?? false;

    if (inginPilih && (_totalSksDipilih + mk.sks > _mahasiswa.maxSksKrs)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Maksimal pengambilan adalah ${_mahasiswa.maxSksKrs} SKS!',
          ),
          backgroundColor: StudyLogColors.danger,
        ),
      );
      return;
    }

    setState(() => mk.dipilih = inginPilih);
  }

  void _handleScanAbsen(MataKuliah mk) {
    setState(() {
      mk.sudahAbsenHariIni = true;
      if (mk.pertemuanHadir < mk.totalPertemuan) {
        mk.pertemuanHadir++;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Presensi ${mk.nama} tercatat (${mk.pertemuanHadir}/${mk.totalPertemuan} pertemuan)!',
        ),
        backgroundColor: StudyLogColors.success,
      ),
    );
  }

  void _toggleTugas(int index) {
    setState(() {
      _daftarTugas[index].selesai = !_daftarTugas[index].selesai;
    });
  }

  void _tambahTugas(TugasKuliah tugasBaru) {
    setState(() {
      _daftarTugas.insert(0, tugasBaru);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      StudyLogDashboardPage(
        mahasiswa: _mahasiswa,
        daftarMataKuliah: _daftarMataKuliah,
        daftarTugas: _daftarTugas,
        onNavigateTab: _pindahTab,
        onOpenTugas: () => _pindahTab(2),
        onToggleTugas: _toggleTugas,
        onLogout: widget.onLogout,
      ),
      StudyLogJadwalPage(
        mahasiswa: _mahasiswa,
        daftarMataKuliah: _daftarMataKuliah,
        tugasAktifCount: _tugasAktifCount,
        onOpenTugas: () => _pindahTab(2),
        onScanAbsen: _handleScanAbsen,
      ),
      StudyLogTugasPage(
        daftarTugas: _daftarTugas,
        daftarMataKuliah: _daftarMataKuliah,
        onToggleTugas: _toggleTugas,
        onTambahTugas: _tambahTugas,
      ),
      StudyLogKrsKhsPage(
        mahasiswa: _mahasiswa,
        daftarMataKuliah: _daftarMataKuliah,
        totalSksDipilih: _totalSksDipilih,
        onToggleMk: _toggleMataKuliah,
        riwayatSemester: _riwayatSemester,
        transkripTerbaru: _transkripTerbaru,
      ),
      StudyLogProfilPage(
        mahasiswa: _mahasiswa,
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      backgroundColor: StudyLogColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: StudyLogColors.surfaceWhite,
          border: Border(
            top: BorderSide(color: StudyLogColors.borderSubtle, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Beranda',
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.calendar_month_outlined,
                  activeIcon: Icons.calendar_month_rounded,
                  label: 'Jadwal',
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.assignment_outlined,
                  activeIcon: Icons.assignment_rounded,
                  label: 'Tugas',
                  showBadge: _tugasAktifCount > 0,
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.menu_book_outlined,
                  activeIcon: Icons.menu_book_rounded,
                  label: 'KRS & KHS',
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    bool showBadge = false,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected
        ? StudyLogColors.orangeBright
        : StudyLogColors.textSecondary;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _pindahTab(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 24,
                  color: color,
                ),
                if (showBadge)
                  Positioned(
                    right: -2,
                    top: -1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: StudyLogColors.orangeBright,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: StudyLogColors.surfaceWhite,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
