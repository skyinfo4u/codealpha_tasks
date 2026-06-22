import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const QuoteApp());
}

class Quote {
  final String text;
  final String author;
  final String category;
  const Quote({required this.text, required this.author, required this.category});
  String get id => '$text|$author';
}

const List<String> kCategories = ['All','Motivation','Life','Success','Wisdom','Love','Happiness','Courage'];

const Map<String, Color> kCategoryColors = {
  'All':        Color(0xFF6C63FF),
  'Motivation': Color(0xFFFF6B9D),
  'Life':       Color(0xFF26D0CE),
  'Success':    Color(0xFF56AB2F),
  'Wisdom':     Color(0xFFF7971E),
  'Love':       Color(0xFFE91E63),
  'Happiness':  Color(0xFFFFAA00),
  'Courage':    Color(0xFFFF5722),
};

const Map<String, List<Color>> kGradients = {
  'All':        [Color(0xFF6C63FF), Color(0xFF9C88FF)],
  'Motivation': [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
  'Life':       [Color(0xFF26D0CE), Color(0xFF1A2980)],
  'Success':    [Color(0xFF56AB2F), Color(0xFFA8E063)],
  'Wisdom':     [Color(0xFFF7971E), Color(0xFFFFD200)],
  'Love':       [Color(0xFFE91E63), Color(0xFFFF6B9D)],
  'Happiness':  [Color(0xFFFFD200), Color(0xFFFF8C00)],
  'Courage':    [Color(0xFFFF5722), Color(0xFFFF9800)],
};

final List<Quote> kQuotes = const [
  Quote(text:"The only way to do great work is to love what you do.",author:"Steve Jobs",category:"Motivation"),
  Quote(text:"Believe you can and you're halfway there.",author:"Theodore Roosevelt",category:"Motivation"),
  Quote(text:"Act as if what you do makes a difference. It does.",author:"William James",category:"Motivation"),
  Quote(text:"Push yourself, because no one else is going to do it for you.",author:"Unknown",category:"Motivation"),
  Quote(text:"Great things never come from comfort zones.",author:"Unknown",category:"Motivation"),
  Quote(text:"Dream it. Wish it. Do it.",author:"Unknown",category:"Motivation"),
  Quote(text:"Don't stop when you're tired. Stop when you're done.",author:"Unknown",category:"Motivation"),
  Quote(text:"Wake up with determination. Go to bed with satisfaction.",author:"Unknown",category:"Motivation"),
  Quote(text:"Life is what happens when you're busy making other plans.",author:"John Lennon",category:"Life"),
  Quote(text:"In the end, it's not the years in your life that count. It's the life in your years.",author:"Abraham Lincoln",category:"Life"),
  Quote(text:"You only live once, but if you do it right, once is enough.",author:"Mae West",category:"Life"),
  Quote(text:"Life is really simple, but we insist on making it complicated.",author:"Confucius",category:"Life"),
  Quote(text:"The purpose of our lives is to be happy.",author:"Dalai Lama",category:"Life"),
  Quote(text:"Life is either a daring adventure or nothing at all.",author:"Helen Keller",category:"Life"),
  Quote(text:"Success is not final, failure is not fatal: it is the courage to continue that counts.",author:"Winston Churchill",category:"Success"),
  Quote(text:"Success usually comes to those who are too busy to be looking for it.",author:"Henry David Thoreau",category:"Success"),
  Quote(text:"Don't watch the clock; do what it does. Keep going.",author:"Sam Levenson",category:"Success"),
  Quote(text:"Success is walking from failure to failure with no loss of enthusiasm.",author:"Winston Churchill",category:"Success"),
  Quote(text:"Opportunities don't happen, you create them.",author:"Chris Grosser",category:"Success"),
  Quote(text:"Knowing yourself is the beginning of all wisdom.",author:"Aristotle",category:"Wisdom"),
  Quote(text:"The only true wisdom is in knowing you know nothing.",author:"Socrates",category:"Wisdom"),
  Quote(text:"What we think, we become.",author:"Buddha",category:"Wisdom"),
  Quote(text:"Turn your wounds into wisdom.",author:"Oprah Winfrey",category:"Wisdom"),
  Quote(text:"Yesterday I was clever, so I wanted to change the world. Today I am wise, so I am changing myself.",author:"Rumi",category:"Wisdom"),
  Quote(text:"The best thing to hold onto in life is each other.",author:"Audrey Hepburn",category:"Love"),
  Quote(text:"Where there is love there is life.",author:"Mahatma Gandhi",category:"Love"),
  Quote(text:"Love is composed of a single soul inhabiting two bodies.",author:"Aristotle",category:"Love"),
  Quote(text:"Being deeply loved by someone gives you strength.",author:"Lao Tzu",category:"Love"),
  Quote(text:"Happiness is not something ready made. It comes from your own actions.",author:"Dalai Lama",category:"Happiness"),
  Quote(text:"For every minute you are angry you lose sixty seconds of happiness.",author:"Ralph Waldo Emerson",category:"Happiness"),
  Quote(text:"Happiness is when what you think, what you say, and what you do are in harmony.",author:"Mahatma Gandhi",category:"Happiness"),
  Quote(text:"Courage is not the absence of fear, but the triumph over it.",author:"Nelson Mandela",category:"Courage"),
  Quote(text:"You gain strength and confidence by every experience in which you really stop to look fear in the face.",author:"Eleanor Roosevelt",category:"Courage"),
  Quote(text:"It takes courage to grow up and become who you really are.",author:"E.E. Cummings",category:"Courage"),
];

class QuoteApp extends StatefulWidget {
  const QuoteApp({super.key});
  @override
  State<QuoteApp> createState() => _QuoteAppState();
}

class _QuoteAppState extends State<QuoteApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = (prefs.getBool('isDark') ?? false) ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = _themeMode == ThemeMode.light;
    await prefs.setBool('isDark', isDark);
    setState(() { _themeMode = isDark ? ThemeMode.dark : ThemeMode.light; });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Quotes',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        scaffoldBackgroundColor: const Color(0xFFF0EFF8),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF), brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/home': (ctx) => HomePage(
          onToggleTheme: _toggleTheme,
          isDark: _themeMode == ThemeMode.dark,
        ),
      },
    );
  }
}

// ─── SPLASH SCREEN ────────────────────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnim,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Image.asset('assets/codealpha_logo.png', fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 32),
            FadeTransition(
              opacity: _fadeAnim,
              child: const Text('Daily Quotes',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.2)),
            ),
            const SizedBox(height: 8),
            FadeTransition(
              opacity: _fadeAnim,
              child: const Text('Powered by CodeAlpha',
                style: TextStyle(fontSize: 14, color: Colors.white54, letterSpacing: 0.5)),
            ),
            const SizedBox(height: 60),
            FadeTransition(
              opacity: _fadeAnim,
              child: const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── HOME PAGE ────────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;
  const HomePage({super.key, required this.onToggleTheme, required this.isDark});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  String _selectedCat = 'All';
  late Quote _quote;
  Set<String> _favIds = {};
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _quote = _randomQuote();
    _animCtrl.forward();
    _loadFavs();
  }

  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  List<Quote> get _filtered => _selectedCat == 'All' ? kQuotes : kQuotes.where((q) => q.category == _selectedCat).toList();

  Quote _randomQuote() {
    final list = _filtered;
    return list[_rng.nextInt(list.length)];
  }

  Future<void> _loadFavs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() { _favIds = (prefs.getStringList('favs') ?? []).toSet(); });
  }

  Future<void> _saveFavs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favs', _favIds.toList());
  }

  void _newQuote() {
    _animCtrl.reverse().then((_) {
      Quote next;
      do { next = _randomQuote(); } while (next.id == _quote.id && _filtered.length > 1);
      setState(() { _quote = next; });
      _animCtrl.forward();
    });
  }

  void _toggleFav() {
    setState(() {
      _favIds.contains(_quote.id) ? _favIds.remove(_quote.id) : _favIds.add(_quote.id);
    });
    _saveFavs();
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: '"${_quote.text}" — ${_quote.author}'));
    _showSnack('Quote copied!', Icons.copy_rounded);
  }

  void _share() => Share.share('"${_quote.text}"\n\n— ${_quote.author}\n\n#DailyQuotes #${_quote.category}');

  void _showSnack(String msg, IconData icon) {
    final color = kCategoryColors[_quote.category] ?? const Color(0xFF6C63FF);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [Icon(icon, color: Colors.white, size: 18), const SizedBox(width: 8), Text(msg)]),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isFav = _favIds.contains(_quote.id);
    final gradColors = kGradients[_quote.category] ?? kGradients['All']!;
    final catColor = kCategoryColors[_quote.category] ?? const Color(0xFF6C63FF);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F0E17), const Color(0xFF1C1B2E)]
                : [const Color(0xFFF0EFF8), const Color(0xFFE8E7F5)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (b) => LinearGradient(colors: gradColors).createShader(b),
                      child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 10),
                    ShaderMask(
                      shaderCallback: (b) => LinearGradient(colors: gradColors).createShader(b),
                      child: const Text('Daily Quotes',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                    const Spacer(),
                    _TopBtn(icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, isDark: isDark, onTap: widget.onToggleTheme),
                    const SizedBox(width: 8),
                    _TopBtn(
                      icon: Icons.favorite_rounded,
                      isDark: isDark,
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => FavoritesPage(favIds: _favIds, onChanged: (ids) {
                          setState(() { _favIds = ids; });
                          _saveFavs();
                        }),
                      )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: kCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final cat = kCategories[i];
                    final sel = cat == _selectedCat;
                    final col = kCategoryColors[cat] ?? const Color(0xFF6C63FF);
                    return GestureDetector(
                      onTap: () { setState(() { _selectedCat = cat; }); _newQuote(); },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? col : col.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: col.withOpacity(sel ? 0 : 0.4), width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (sel) ...[const Icon(Icons.check_rounded, size: 13, color: Colors.white), const SizedBox(width: 4)],
                            Text(cat, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: sel ? Colors.white : col)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1C1B2E) : Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [BoxShadow(color: gradColors[0].withOpacity(isDark ? 0.3 : 0.2), blurRadius: 32, spreadRadius: 0, offset: const Offset(0, 12))],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: gradColors),
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: ShaderMask(
                                        shaderCallback: (b) => LinearGradient(colors: gradColors).createShader(b),
                                        child: const Text('"', style: TextStyle(fontSize: 80, height: 0.75, color: Colors.white, fontStyle: FontStyle.italic)),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(_quote.text, textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, height: 1.7, fontWeight: FontWeight.w500,
                                        color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                                    const SizedBox(height: 20),
                                    Container(height: 1.5, width: 48,
                                      decoration: BoxDecoration(gradient: LinearGradient(colors: gradColors), borderRadius: BorderRadius.circular(2))),
                                    const SizedBox(height: 16),
                                    Text('— ${_quote.author}',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: gradColors[0], letterSpacing: 0.3)),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                      decoration: BoxDecoration(color: catColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                                      child: Text(_quote.category, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: catColor)),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _ActionBtn(
                                          icon: isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                          color: isFav ? const Color(0xFFE91E63) : (isDark ? Colors.white38 : Colors.black26),
                                          bg: isFav ? const Color(0xFFE91E63).withOpacity(0.12) : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                                          onTap: _toggleFav,
                                        ),
                                        const SizedBox(width: 16),
                                        _ActionBtn(icon: Icons.copy_rounded, color: isDark ? Colors.white54 : Colors.black38, bg: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), onTap: _copy),
                                        const SizedBox(width: 16),
                                        _ActionBtn(icon: Icons.share_rounded, color: isDark ? Colors.white54 : Colors.black38, bg: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), onTap: _share),
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
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradColors),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(color: gradColors[0].withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: _newQuote,
                        child: const Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
                              SizedBox(width: 10),
                              Text('New Quote', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                            ],
                          ),
                        ),
                      ),
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

class _TopBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;
  const _TopBtn({required this.icon, required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.07), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 20, color: isDark ? Colors.white70 : Colors.black54),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.color, required this.bg, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  final Set<String> favIds;
  final ValueChanged<Set<String>> onChanged;
  const FavoritesPage({super.key, required this.favIds, required this.onChanged});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Set<String> _ids;
  @override
  void initState() { super.initState(); _ids = Set.from(widget.favIds); }

  void _remove(String id) {
    setState(() { _ids.remove(id); });
    widget.onChanged(_ids);
  }

  @override
  Widget build(BuildContext context) {
    final favs = kQuotes.where((q) => _ids.contains(q.id)).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0E17) : const Color(0xFFF0EFF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Favourites', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: favs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(color: const Color(0xFFE91E63).withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border_rounded, size: 44, color: Color(0xFFE91E63)),
                  ),
                  const SizedBox(height: 16),
                  const Text('No favourites yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text('Tap the heart icon to save quotes', style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favs.length,
              itemBuilder: (_, i) {
                final q = favs[i];
                final gradColors = kGradients[q.category] ?? kGradients['All']!;
                final catColor = kCategoryColors[q.category] ?? const Color(0xFF6C63FF);
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1C1B2E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: gradColors[0].withOpacity(0.15), blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradColors),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('"${q.text}"',
                                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, height: 1.5,
                                      color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text('— ${q.author}',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: gradColors[0])),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(color: catColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                                        child: Text(q.category, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: catColor)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite_rounded, color: Color(0xFFE91E63), size: 22),
                              onPressed: () => _remove(q.id),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
