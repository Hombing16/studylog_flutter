import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/academic_models.dart';
import '../theme/app_theme.dart';
import '../widgets/studylog_charts.dart';

class StudyLogDashboardPage extends StatefulWidget {
  final Mahasiswa mahasiswa;
  final List<MataKuliah> daftarMataKuliah;
  final List<TugasKuliah> daftarTugas;
  final ValueChanged<int> onNavigateTab;
  final VoidCallback onOpenTugas;
  final ValueChanged<int>? onToggleTugas;
  final VoidCallback onLogout;

  const StudyLogDashboardPage({
    super.key,
    required this.mahasiswa,
    required this.daftarMataKuliah,
    required this.daftarTugas,
    required this.onNavigateTab,
    required this.onOpenTugas,
    this.onToggleTugas,
    required this.onLogout,
  });

  @override
  State<StudyLogDashboardPage> createState() => _StudyLogDashboardPageState();
}

class _StudyLogDashboardPageState extends State<StudyLogDashboardPage> {
  // State untuk Fitur Fokus Belajar (Study Timer / Pomodoro)
  Timer? _focusTimer;
  int _selectedPresetMinutes = 25;
  int _remainingSeconds = 25 * 60;
  bool _isTimerRunning = false;
  int _totalMenitFokusHariIni = 0;
  int _sesiFokusSelesai = 0;
  String? _selectedFocusMatkul;

  @override
  void dispose() {
    _focusTimer?.cancel();
    super.dispose();
  }

  List<MataKuliah> get _matkulDipilih =>
      widget.daftarMataKuliah.where((m) => m.dipilih).toList();

  String get _activeFocusCourseName {
    final dipilih = _matkulDipilih;
    if (_selectedFocusMatkul != null &&
        dipilih.any((m) => m.nama == _selectedFocusMatkul)) {
      return _selectedFocusMatkul!;
    }
    final jadwal = _jadwalHariIni;
    if (jadwal.isNotEmpty) return jadwal.first.nama;
    if (dipilih.isNotEmpty) return dipilih.first.nama;
    return 'Belajar Mandiri';
  }

  void _toggleFocusTimer() {
    if (_isTimerRunning) {
      _focusTimer?.cancel();
      setState(() => _isTimerRunning = false);
      return;
    }

    setState(() => _isTimerRunning = true);
    _focusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds > 1) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
        setState(() {
          _isTimerRunning = false;
          _sesiFokusSelesai++;
          _totalMenitFokusHariIni += _selectedPresetMinutes;
          _remainingSeconds = _selectedPresetMinutes * 60;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sesi fokus $_selectedPresetMinutes menit untuk $_activeFocusCourseName selesai dicatat di StudyLog!',
            ),
            backgroundColor: StudyLogColors.success,
          ),
        );
      }
    });
  }

  void _resetFocusTimer() {
    _focusTimer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingSeconds = _selectedPresetMinutes * 60;
    });
  }

  void _pilihDurasiFokus(int menit) {
    _focusTimer?.cancel();
    setState(() {
      _selectedPresetMinutes = menit;
      _remainingSeconds = menit * 60;
      _isTimerRunning = false;
    });
  }

  String get _formattedTimer {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Map<String, int> get _bebanSksPerHari {
    final map = <String, int>{
      'Senin': 0,
      'Selasa': 0,
      'Rabu': 0,
      'Kamis': 0,
      'Jumat': 0,
    };
    for (final mk in _matkulDipilih) {
      if (map.containsKey(mk.hari)) {
        map[mk.hari] = (map[mk.hari] ?? 0) + mk.sks;
      }
    }
    return map;
  }

  int get _totalSksAktif =>
      _matkulDipilih.fold(0, (sum, mk) => sum + mk.sks);

  // Rata-rata persentase kehadiran dari seluruh matkul yang diambil (16 pertemuan/matkul)
  int get _rataRataKehadiran {
    final aktif = _matkulDipilih;
    if (aktif.isEmpty) return 0;
    final totalHadir = aktif.fold(0, (sum, mk) => sum + mk.pertemuanHadir);
    final totalSesi = aktif.fold(0, (sum, mk) => sum + mk.totalPertemuan);
    if (totalSesi == 0) return 0;
    return ((totalHadir / totalSesi) * 100).round();
  }

  int get _totalPertemuanHadir =>
      _matkulDipilih.fold(0, (sum, mk) => sum + mk.pertemuanHadir);

  int get _totalPertemuanSemua =>
      _matkulDipilih.fold(0, (sum, mk) => sum + mk.totalPertemuan);

  String get _hariAktifLabel {
    switch (DateTime.now().weekday) {
      case DateTime.monday:
        return 'Senin';
      case DateTime.tuesday:
        return 'Selasa';
      case DateTime.wednesday:
        return 'Rabu';
      case DateTime.thursday:
        return 'Kamis';
      case DateTime.friday:
        return 'Jumat';
      default:
        return 'Kamis';
    }
  }

  bool get _isAkhirPekan =>
      DateTime.now().weekday == DateTime.saturday ||
      DateTime.now().weekday == DateTime.sunday;

  List<MataKuliah> get _jadwalHariIni {
    final hari = _hariAktifLabel;
    final list =
        _matkulDipilih.where((m) => m.hari == hari).toList();
    if (list.isNotEmpty) return list;
    return _matkulDipilih.take(2).toList();
  }

  void _tampilkanDetailKehadiran(BuildContext context) {
    final aktif = _matkulDipilih;
    showModalBottomSheet(
      context: context,
      backgroundColor: StudyLogColors.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
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
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Rekap Kehadiran Kuliah',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: StudyLogColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: StudyLogColors.orangeSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$_rataRataKehadiran% ($_totalPertemuanHadir/$_totalPertemuanSemua)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: StudyLogColors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Persentase dihitung dari akumulasi kehadiran pada 16 pertemuan setiap mata kuliah aktif (syarat minimal UAS: 75%).',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: StudyLogColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: aktif.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, idx) {
                      final mk = aktif[idx];
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              mk.nama,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: StudyLogColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${mk.pertemuanHadir}/${mk.totalPertemuan} (${mk.persentaseKehadiran}%)',
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: StudyLogColors.orange,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _bukaPengaturanFokus() {
    final matkulList = _matkulDipilih;
    showModalBottomSheet(
      context: context,
      backgroundColor: StudyLogColors.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
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
                      'Pengaturan Fokus Belajar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: StudyLogColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Durasi Sesi',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: StudyLogColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        {'label': '15 Menit', 'min': 15},
                        {'label': '25 Menit (Pomodoro)', 'min': 25},
                        {'label': '45 Menit (Deep Focus)', 'min': 45},
                      ].map((preset) {
                        final min = preset['min'] as int;
                        final selected = _selectedPresetMinutes == min;
                        return ChoiceChip(
                          label: Text(preset['label'] as String),
                          selected: selected,
                          selectedColor: StudyLogColors.orangeBright,
                          backgroundColor: StudyLogColors.background,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : StudyLogColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          onSelected: (_) {
                            _pilihDurasiFokus(min);
                            setModalState(() {});
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Mata Kuliah Fokus',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: StudyLogColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _activeFocusCourseName,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: matkulList
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
                        if (val != null) {
                          setState(() => _selectedFocusMatkul = val);
                          setModalState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: StudyLogColors.orangeSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: StudyLogColors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Catatan StudyLog Hari Ini: $_sesiFokusSelesai sesi ($_totalMenitFokusHariIni menit fokus)',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: StudyLogColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
    final topPadding = MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCampusHeroHeader(context, topPadding, tugasAktifCount),
              Transform.translate(
                offset: const Offset(0, -18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildIpkAndAttendanceCard(context),
                      const SizedBox(height: 14),
                      _buildJadwalHariIniCard(),
                      const SizedBox(height: 14),
                      _buildFokusBelajarCard(),
                      const SizedBox(height: 14),
                      _buildBebanSksCard(),
                      const SizedBox(height: 14),
                      _buildTugasUrgenCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampusHeroHeader(
    BuildContext context,
    double topPadding,
    int tugasAktifCount,
  ) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/campus_bg.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xDC1C1816),
                  Color(0xBA231E1B),
                  Color(0x9E26201D),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(18, topPadding + 12, 14, 38),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const CampusLogoBadge(
                    size: 40,
                    borderRadius: 11,
                    padding: 4,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STUDYLOG',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Portal Mahasiswa',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFE7E5E4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: widget.onOpenTugas,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                          if (tugasAktifCount > 0)
                            Positioned(
                              right: 1,
                              top: 1,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: StudyLogColors.orangeBright,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF1C1816),
                                    width: 1.4,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => widget.onNavigateTab(4),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: StudyLogColors.orangeAvatarBg,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.mahasiswa.inisial,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: StudyLogColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  IconButton(
                    tooltip: 'Keluar',
                    onPressed: widget.onLogout,
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Selamat datang, ${widget.mahasiswa.namaPanggilan}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.mahasiswa.jurusan} (${widget.mahasiswa.jenjang}) · Kelas ${widget.mahasiswa.kelas} · ${widget.mahasiswa.fakultas}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFFF3F4F6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.mahasiswa.nim));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'NIM ${widget.mahasiswa.nim} berhasil disalin',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDFBF7),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'NIM: ${widget.mahasiswa.nim}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: StudyLogColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.copy_rounded,
                        size: 14,
                        color: StudyLogColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIpkAndAttendanceCard(BuildContext context) {
    final kehadiranPct = _rataRataKehadiran;
    final progress = (kehadiranPct / 100.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Indeks Prestasi Kumulatif',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: StudyLogColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      widget.mahasiswa.ipkFormatted,
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: StudyLogColors.textPrimary,
                        height: 1.0,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '/ 4,00',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: StudyLogColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '▲ ${widget.mahasiswa.predikat}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: StudyLogColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${widget.mahasiswa.totalSksLulus} SKS lulus · Semester ${widget.mahasiswa.semester}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: StudyLogColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Lingkaran 91% Kehadiran dengan penjelasan jelas di dalamnya + bisa diketuk untuk rincian
          InkWell(
            onTap: () => _tampilkanDetailKehadiran(context),
            borderRadius: BorderRadius.circular(46),
            child: SizedBox(
              width: 90,
              height: 90,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6.5,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      StudyLogColors.orangeBright,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$kehadiranPct%',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: StudyLogColors.textPrimary,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Kehadiran',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: StudyLogColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalHariIniCard() {
    final jadwal = _jadwalHariIni;
    final labelHari = _isAkhirPekan ? 'Kamis' : _hariAktifLabel;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Jadwal Kuliah Hari Ini',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: StudyLogColors.textPrimary,
                  ),
                ),
              ),
              InkWell(
                onTap: () => widget.onNavigateTab(1),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: StudyLogColors.orangeSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    labelHari,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: StudyLogColors.orange,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...jadwal.map((mk) {
            final isBerlangsung =
                mk.statusSesi == 'Sedang Berlangsung' && !mk.sudahAbsenHariIni;
            final badgeText = mk.sudahAbsenHariIni
                ? 'Hadir'
                : (isBerlangsung ? 'Berlangsung' : mk.statusSesi);
            final badgeBg = mk.sudahAbsenHariIni
                ? StudyLogColors.successBg
                : (isBerlangsung
                    ? StudyLogColors.orangeSoft
                    : const Color(0xFFF4F4F5));
            final badgeFg = mk.sudahAbsenHariIni
                ? StudyLogColors.success
                : (isBerlangsung
                    ? StudyLogColors.orange
                    : StudyLogColors.textSecondary);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => widget.onNavigateTab(1),
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 13.5,
                                height: 1.3,
                                color: StudyLogColors.textPrimary,
                              ),
                              children: [
                                TextSpan(
                                  text: mk.jam,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: ' · ${mk.nama}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            mk.ruang,
                            style: const TextStyle(
                              fontSize: 12,
                              color: StudyLogColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            badgeText,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: badgeFg,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 15,
                            color: badgeFg,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFokusBelajarCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: StudyLogColors.surfaceWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: StudyLogColors.orangeBright.withOpacity(0.55),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: StudyLogColors.orangeBright.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _bukaPengaturanFokus,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Flexible(
                        child: Text(
                          'Fokus Belajar (Study Timer)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: StudyLogColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.tune_rounded,
                        size: 16,
                        color: StudyLogColors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _formattedTimer,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: StudyLogColors.textPrimary,
                          height: 1.05,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (_sesiFokusSelesai > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: StudyLogColors.successBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$_sesiFokusSelesai sesi',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: StudyLogColors.success,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sesi Pomodoro · $_activeFocusCourseName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: StudyLogColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: _isTimerRunning
                      ? StudyLogColors.charcoal
                      : StudyLogColors.orangeBright,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                onPressed: _toggleFocusTimer,
                icon: Icon(
                  _isTimerRunning
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 20,
                ),
                label: Text(
                  _isTimerRunning ? 'Jeda' : 'Mulai',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (_isTimerRunning ||
                  _remainingSeconds != _selectedPresetMinutes * 60)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: GestureDetector(
                    onTap: _resetFocusTimer,
                    child: const Text(
                      'Reset timer',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: StudyLogColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBebanSksCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Beban SKS ($_totalSksAktif/${widget.mahasiswa.maxSksKrs} SKS)',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: StudyLogColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          BebanSksBarChart(sksPerHari: _bebanSksPerHari),
        ],
      ),
    );
  }

  Widget _buildTugasUrgenCard() {
    // Hanya menampilkan tugas BELUM SELESAI yang PALING URGEN
    final belumSelesai =
        widget.daftarTugas.where((t) => !t.selesai).toList()
          ..sort((a, b) => a.urgencyRank.compareTo(b.urgencyRank));

    final List<TugasKuliah> tugasUrgen;
    if (belumSelesai.isEmpty) {
      tugasUrgen = [];
    } else {
      final highestRank = belumSelesai.first.urgencyRank;
      tugasUrgen = belumSelesai
          .where((t) => t.urgencyRank == highestRank)
          .take(2)
          .toList();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tugas Kuliah Urgen',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: StudyLogColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: tugasUrgen.isNotEmpty
                      ? const Color(0xFFFEE2E2)
                      : StudyLogColors.successBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tugasUrgen.isNotEmpty
                      ? '${tugasUrgen.length} Paling Urgen'
                      : 'Semua Selesai',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: tugasUrgen.isNotEmpty
                        ? StudyLogColors.danger
                        : StudyLogColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (tugasUrgen.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                'Tidak ada tugas urgen yang belum selesai saat ini.',
                style: TextStyle(
                  fontSize: 13,
                  color: StudyLogColors.textSecondary,
                ),
              ),
            )
          else
            ...tugasUrgen.map((tugas) {
              final realIndex = widget.daftarTugas.indexOf(tugas);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    if (widget.onToggleTugas != null && realIndex != -1) {
                      widget.onToggleTugas!(realIndex);
                    } else {
                      widget.onOpenTugas();
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: StudyLogColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: StudyLogColors.orangeBright.withOpacity(0.45),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.radio_button_unchecked_rounded,
                          size: 20,
                          color: StudyLogColors.orangeBright,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tugas.judul,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: StudyLogColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${tugas.mataKuliah} · Tenggat: ${tugas.tenggat}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: StudyLogColors.textSecondary,
                                ),
                              ),
                            ],
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
                            tugas.prioritas,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: StudyLogColors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: 2),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: StudyLogColors.orange,
                side: const BorderSide(color: StudyLogColors.orangeBright),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: widget.onOpenTugas,
              icon: const Icon(Icons.assignment_outlined, size: 18),
              label: Text(
                'Lihat Semua Tugas (${belumSelesai.length} Belum Selesai)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: StudyLogColors.surfaceWhite,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: StudyLogColors.borderSubtle),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
