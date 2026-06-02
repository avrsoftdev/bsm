import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'web_platform.dart';

// EmailJS Configuration
const String emailjsServiceId = 'service_xu8fwps';
const String emailjsTemplateId =
    'template_y03xjwd'; // Replace with your template ID
const String emailjsPublicKey =
    'ZbZZAtfauXMp4calj'; // Replace with your public key
const String emailjsRecipientEmail =
    'bhartiysadbhavnamanch@gmail.com'; // Replace with recipient email

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('hi')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          bodyMedium: GoogleFonts.hind(
              textStyle: GoogleFonts.poppinsTextTheme().bodyMedium),
        ),
      ),
      home: HomePage(
        currentLocale: _locale,
        onLanguageChanged: _changeLanguage,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Locale currentLocale;
  final Function(Locale) onLanguageChanged;

  const HomePage(
      {super.key,
      required this.currentLocale,
      required this.onLanguageChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _marqueeController = ScrollController();
  final PageController _videoPageController = PageController();
  Timer? _videoAutoScrollTimer;
  int _currentVideoIndex = 0;

  final List<String> _youtubeVideoIds = [
    'wYHvdPT4z6w',
    'mlHb0udHId0',
    'vVfGgaa2lMk',
    'FHMmbrtnPMo',
    'ppv3ZeriLVI',
  ];

  final List<String> _mp4Videos = [
    'assets/images/bsmvid.mp4',
    'assets/images/bsmvid1.mp4',
    'assets/images/bsmvid2.mp4',
  ];

  // Get all videos (YouTube + MP4)
  List<Map<String, dynamic>> get _allVideos {
    final videos = <Map<String, dynamic>>[];
    for (final id in _youtubeVideoIds) {
      videos.add({'type': 'youtube', 'id': id});
    }
    for (final path in _mp4Videos) {
      videos.add({'type': 'mp4', 'path': path});
    }
    return videos;
  }

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _historyKey = GlobalKey();
  final GlobalKey _membersKey = GlobalKey();
  final GlobalKey _videosKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // Contact Form Fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
    }
  }

  String getText(String en, String hi) {
    return widget.currentLocale.languageCode == 'hi' ? hi : en;
  }

  Future<void> _launchDonateUrl() async {
    final uri = Uri.parse('https://jumpshare.com/share/sbn0Xer61Pfz4iGcFcxw');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getText('Could not open Donate link.', 'डोनेट लिंक खोलने में असमर्थ।'))),
      );
    }
  }

  List<Widget> _buildDesktopNavigation() {
    return [
      TextButton(
          onPressed: () => _scrollToSection(_homeKey),
          child: Text(getText('Home', 'होम'),
              style: const TextStyle(color: Colors.orange))),
      TextButton(
          onPressed: () => _scrollToSection(_historyKey),
          child: Text(getText('History', 'इतिहास'),
              style: const TextStyle(color: Colors.orange))),
      TextButton(
          onPressed: () => _scrollToSection(_membersKey),
          child: Text(getText('Members', 'सदस्य'),
              style: const TextStyle(color: Colors.orange))),
      TextButton(
          onPressed: () => _scrollToSection(_videosKey),
          child: Text(getText('Videos', 'वीडियो'),
              style: const TextStyle(color: Colors.orange))),
      TextButton(
          onPressed: () => _scrollToSection(_contactKey),
          child: Text(getText('Contact', 'संपर्क'),
              style: const TextStyle(color: Colors.orange))),
    ];
  }

  Widget _buildCompactNavigationMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu),
      tooltip: getText('Open navigation menu', 'नेविगेशन मेनू खोलें'),
      onSelected: _handleCompactMenuSelection,
      itemBuilder: (_) => [
        PopupMenuItem(value: 'home', child: Text(getText('Home', 'होम'))),
        PopupMenuItem(value: 'history', child: Text(getText('History', 'इतिहास'))),
        PopupMenuItem(value: 'members', child: Text(getText('Members', 'सदस्य'))),
        PopupMenuItem(value: 'videos', child: Text(getText('Videos', 'वीडियो'))),
        PopupMenuItem(value: 'contact', child: Text(getText('Contact', 'संपर्क'))),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'donate',
          child: Text(
            getText('Donate Now', 'अभी दान करें'),
            style: const TextStyle(color: Color.fromARGB(255, 210, 105, 25)),
          ),
        ),
      ],
    );
  }

  void _handleCompactMenuSelection(String value) {
    switch (value) {
      case 'home':
        _scrollToSection(_homeKey);
        break;
      case 'history':
        _scrollToSection(_historyKey);
        break;
      case 'members':
        _scrollToSection(_membersKey);
        break;
      case 'videos':
        _scrollToSection(_videosKey);
        break;
      case 'contact':
        _scrollToSection(_contactKey);
        break;
      case 'donate':
        _launchDonateUrl();
        break;
    }
  }

  // Register YouTube Video for Web
  void _registerYouTubeView(String videoId) {
    registerYouTubeView(videoId, onTap: _pauseVideoAutoScroll);
  }

  // Register MP4 Video for Web
  void _registerMP4View(String videoPath) {
    registerMP4View(videoPath, onTap: _pauseVideoAutoScroll);
  }

  void _pauseVideoAutoScroll() {
    if (_videoAutoScrollTimer?.isActive ?? false) {
      _videoAutoScrollTimer?.cancel();
      _videoAutoScrollTimer = null;
    }
  }

  @override
  void initState() {
    super.initState();
    for (final videoId in _youtubeVideoIds) {
      _registerYouTubeView(videoId);
    }
    for (final videoPath in _mp4Videos) {
      _registerMP4View(videoPath);
    }
    _videoAutoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_videoPageController.hasClients || !mounted) return;
      final nextIndex = (_currentVideoIndex + 1) % _allVideos.length;
      _videoPageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
    // Start the marquee after first frame so the controller has dimensions
    WidgetsBinding.instance.addPostFrameCallback((_) => _startMarquee());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    _marqueeController.dispose();
    _videoPageController.dispose();
    _videoAutoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompactNavigation = MediaQuery.sizeOf(context).width < 1024;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo.jpeg',
            width: 36,
            height: 36,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/logo.jpeg',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          getText('Bhartiya Sadbhavna Manch', 'भारतीय सद्भावना मंच'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 18,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 210, 105, 25),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (lang) {
              widget.onLanguageChanged(
                  lang == 'hi' ? const Locale('hi') : const Locale('en'));
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'en', child: Text('English')),
              const PopupMenuItem(value: 'hi', child: Text('हिंदी')),
            ],
          ),
          if (isCompactNavigation)
            _buildCompactNavigationMenu()
          else ..._buildDesktopNavigation(),
          if (!isCompactNavigation)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton(
                onPressed: _launchDonateUrl,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 210, 105, 25),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Text(getText('Donate Now', 'अभी दान करें')),
              ),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Hero Section
            Container(
              key: _homeKey,
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    MediaQuery.of(context).size.width < 768
                        ? 'assets/images/collage_mobile.png'
                        : 'assets/images/collage_laptop.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getText('Welcome to Bhartiya Sadbhavna Manch',
                              'भारतीय सद्भावना मंच में स्वागत है'),
                          style: GoogleFonts.poppins(
                              fontSize: MediaQuery.of(context).size.width < 600
                                  ? 24
                                  : MediaQuery.of(context).size.width < 900
                                      ? 32
                                      : 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          getText('Promoting Social Unity and Goodwill',
                              'सामाजिक एकता और सद्भावना को बढ़ावा देना'),
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 600
                                  ? 14
                                  : MediaQuery.of(context).size.width < 900
                                      ? 16
                                      : 22,
                              color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () => _scrollToSection(_historyKey),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 18),
                            backgroundColor: Colors.white,
                            foregroundColor:
                                const Color.fromARGB(255, 210, 105, 25),
                          ),
                          child: Text(
                              getText('Learn Our Story', 'हमारी कहानी जानें')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // History Section
            Container(
              key: _historyKey,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
              child: Column(
                children: [
                  Text(getText('Our History', 'हमारा इतिहास'),
                      style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Text(
                    getText(
                        '''Bhartiya Sadbhavna Manch is a socio-cultural organization inspired by the ideals of the Rashtriya Swayamsevak Sangh. The organization was established in 2016 under the guidance of Honorable Dr. Indresh Kumar.

The responsibility of leading the organization has been entrusted to National Convenor Sadhvi Maa Arundhati, who is actively guiding and strengthening the vision and mission of the Manch.

The advisory role is held by CA Dr. Arjun Mundra, whose expertise contributes to shaping the organization’s policies and operational excellence.

The primary objective of Bhartiya Sadbhavna Manch is to promote harmony, unity, brotherhood, and social cohesion in society. The organization actively works towards connecting people across communities and raising awareness on important social and national issues.

To ensure effective functioning, the Manch has established several dedicated cells (Prakosth), including:

🌿 Environment Cell
👩 Women Cell
👨‍🎓 Youth Cell
🐄 Cow Protection Cell

Each of these cells plays a vital role in addressing specific areas and contributing to the overall development of society.

Bhartiya Sadbhavna Manch stands as a platform committed to nation-building, social harmony, and positive transformation.''',
                        '''भारतीय सद्भावना मंच एक सामाजिक एवं सांस्कृतिक संगठन है, जो राष्ट्रीय स्वयंसेवक संघ से प्रेरित है। इस मंच का निर्माण वर्ष 2016 में माननीय डॉ. इंद्रेश कुमार जी के मार्गदर्शन में किया गया। संगठन की महत्वपूर्ण जिम्मेदारी राष्ट्रीय संयोजिका के रूप में साध्वी मां अरुंधति जी को सौंपी गई है, जो संगठन को सशक्त दिशा प्रदान कर रही हैं। मंच के सलाहकार के रूप में सीए डॉ. अर्जुन मुंद्रा जी अपनी महत्वपूर्ण भूमिका निभा रहे हैं, जो संगठन की नीतियों और कार्यप्रणाली को सुदृढ़ बनाने में सहयोग करते हैं। भारतीय सद्भावना मंच का मुख्य उद्देश्य समाज में सद्भावना, एकता, भाईचारा और सामाजिक समरसता को बढ़ावा देना है। यह मंच विभिन्न सामाजिक और राष्ट्रीय मुद्दों पर जागरूकता फैलाने तथा समाज के हर वर्ग को जोड़ने के लिए निरंतर कार्यरत है। संगठन के कार्यों को प्रभावी ढंग से संचालित करने के लिए विभिन्न प्रकोष्ठ (Cells/Departments) का गठन किया गया है, जिनमें प्रमुख हैं:

🌿 पर्यावरण प्रकोष्ठ
👩 महिला प्रकोष्ठ
👨‍🎓 युवा प्रकोष्ठ
🐄 गौ प्रकोष्ठ

ये सभी प्रकोष्ठ अपने-अपने क्षेत्र में विशेष कार्य करते हुए समाज के समग्र विकास में योगदान दे रहे हैं। भारतीय सद्भावना मंच एक ऐसा मंच है, जो राष्ट्र निर्माण, सामाजिक समरसता और सकारात्मक परिवर्तन के लिए प्रतिबद्ध है।'''),
                    style: const TextStyle(fontSize: 18, height: 1.7),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  // Scrolling images marquee (left-to-right loop)
                  _buildImageMarquee(),
                ],
              ),
            ),

            // Members Section
            Container(
              key: _membersKey,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
              color: Colors.grey.shade50,
              child: Column(
                children: [
                  Text(
                    getText('Our Team / Post Holders', 'हमारी टीम / पदाधिकारी'),
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    getText('Dedicated leaders working for social harmony',
                        'सामाजिक सद्भावना के लिए समर्पित हमारे नेतृत्व'),
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 50),
                  Wrap(
                    spacing: 25,
                    runSpacing: 30,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildMemberCard(
                        nameEn: 'Dr. Indresh Kumar Devrishi',
                        nameHi: 'डॉ. इंद्रेश कुमार देवर्षि',
                        positionEn: 'Patron',
                        positionHi: 'संरक्षक',
                        imagePath: 'assets/images/indreshi.jpg',
                        bioEn: 'Senior Pracharak, Rashtriya Swayamsevak Sangh',
                        bioHi: 'वरिष्ठ प्रचारक, राष्ट्रीय स्वयंसेवक संघ',
                      ),
                      _buildMemberCard(
                        nameEn: 'Sadhvi Ma Kalpana Arundhati',
                        nameHi: 'साध्वी माँ कल्पना अरुंधति',
                        positionEn: 'National Coordinator',
                        positionHi: 'राष्ट्रीय संयोजिका',
                        imagePath: 'assets/images/maa.png',
                        bioEn: 'Spiritual guide and inspiration',
                        bioHi: 'आध्यात्मिक मार्गदर्शक एवं प्रेरणा स्रोत',
                      ),
                      _buildMemberCard(
                        nameEn: 'CA Dr. Arjun Mundra',
                        nameHi: 'सी ए डॉ. अर्जुन मुंडरा',
                        positionEn: 'Chief Advisor',
                        positionHi: 'मुख्य सलाहकार',
                        imagePath: 'assets/images/arjun.jpg',
                        bioEn: 'Leading policies and operations',
                        bioHi: 'नीतियों और कार्यप्रणाली का नेतृत्व',
                      ),
                      _buildMemberCard(
                        nameEn: 'Aakash Dodwal',
                        nameHi: 'आकाश डोडवाल',
                        positionEn: 'National Media Convener',
                        positionHi: 'राष्ट्रीय मीडिया प्रभारी',
                        imagePath: 'assets/images/akash.png',
                        bioEn: 'Managing Media and Communications',
                        bioHi: 'संचालन - मीडिया और संचार प्रबंधन',
                      ),
                      _buildMemberCard(
                        nameEn: 'Vishwajeet Singh',
                        nameHi: 'विश्वजीत सिंह',
                        positionEn: 'National Convener- Youth Cell',
                        positionHi: 'राष्ट्रीय सयोंजक - युवा प्रकोष्ठ ',
                        imagePath: 'assets/images/vishwajeet.jpeg',
                        bioEn: 'Managing -Youth Cell and Programs',
                        bioHi: 'संचालन - युवा प्रकोष्ठ एवं कार्यक्रम प्रबंधन',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Videos Section
            Container(
              key: _videosKey,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
              color: Colors.grey.shade50,
              child: Column(
                children: [
                  Text(getText('Our Videos', 'हमारे वीडियो'),
                      style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 360,
                    width: double.infinity,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double sliderWidth =
                            min<double>(820.0, constraints.maxWidth * 0.85);
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: SizedBox(
                                width: sliderWidth,
                                child: PageView.builder(
                                  controller: _videoPageController,
                                  itemCount: _allVideos.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentVideoIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    final video = _allVideos[index];
                                    if (video['type'] == 'youtube') {
                                      return _buildYouTubeVideo(
                                        video['id'],
                                        width: sliderWidth,
                                        onTap: _pauseVideoAutoScroll,
                                      );
                                    } else {
                                      return _buildMP4Video(
                                        video['path'],
                                        width: sliderWidth,
                                        onTap: _pauseVideoAutoScroll,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              child: IconButton(
                                iconSize: 40,
                                color: Colors.black54,
                                onPressed: () {
                                  _pauseVideoAutoScroll();
                                  final previousIndex =
                                      (_currentVideoIndex - 1 +
                                              _allVideos.length) %
                                          _allVideos.length;
                                  _videoPageController.animateToPage(
                                    previousIndex,
                                    duration:
                                        const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                icon: const CircleAvatar(
                                  backgroundColor: Colors.white70,
                                  child: Icon(Icons.chevron_left,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                iconSize: 40,
                                color: Colors.black54,
                                onPressed: () {
                                  _pauseVideoAutoScroll();
                                  final nextIndex =
                                      (_currentVideoIndex + 1) %
                                          _allVideos.length;
                                  _videoPageController.animateToPage(
                                    nextIndex,
                                    duration:
                                        const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                icon: const CircleAvatar(
                                  backgroundColor: Colors.white70,
                                  child: Icon(Icons.chevron_right,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _allVideos.length,
                                  (index) => AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 250),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    width: _currentVideoIndex == index ? 18 : 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: _currentVideoIndex == index
                                          ? Colors.orange
                                          : Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
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

            // Contact Section
            Container(
              key: _contactKey,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
              child: _buildContactForm(),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(50),
              color: const Color.fromARGB(255, 210, 105, 25),
              child: Column(
                children: [
                  Text(
                    getText(
                        '© 2026 Bhartiya Sadbhavna Manch. All Rights Reserved.',
                        '© 2026 भारतीय सद्भावना मंच। सर्वाधिकार सुरक्षित।'),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Beautiful Member Card
  final List<String> _carouselImages = [
    'assets/images/20241125_144749.jpg',
    'assets/images/20241125_144811.jpg',
    'assets/images/20241125_154940.jpg',
    'assets/images/20250407_133558.jpg',
    // 'assets/images/20250407_154704.jpg',
    'assets/images/20250425_121236.jpg',
    'assets/images/IMG-20241125-WA0091.jpg',
    'assets/images/IMG-20241125-WA0097.jpg',
    // 'assets/images/IMG-20241125-WA0098.jpg',
    'assets/images/Screenshot_20250427_214530_WhatsApp.jpg',
    'assets/images/rss1.jpeg',
    'assets/images/rss2.jpeg',
    'assets/images/maaji1.jpeg',
    'assets/images/maaji2.jpeg',
    'assets/images/maaji3.jpeg',
  ];

  void _startMarquee() async {
    // Auto-scroll marquee from left to right, looping by duplicating items
    try {
      // wait a moment for layout
      await Future.delayed(const Duration(milliseconds: 200));
      while (mounted) {
        if (!_marqueeController.hasClients) {
          await Future.delayed(const Duration(milliseconds: 300));
          continue;
        }
        final max = _marqueeController.position.maxScrollExtent;
        if (max <= 0) {
          await Future.delayed(const Duration(milliseconds: 500));
          continue;
        }
        // speed: ~30 px/sec
        final durationMs = (max / 30 * 1000).toInt().clamp(1000, 60000);
        await _marqueeController.animateTo(max,
            duration: Duration(milliseconds: durationMs), curve: Curves.linear);
        if (!mounted) break;
        _marqueeController.jumpTo(0);
        await Future.delayed(const Duration(milliseconds: 300));
      }
    } catch (e) {
      // ignore - controller disposed or animation cancelled
    }
  }

  Widget _buildImageMarquee() {
    final items = [..._carouselImages, ..._carouselImages];
    return SizedBox(
      height: 140,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ListView.builder(
          controller: _marqueeController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(items[index],
                  height: 120,
                  width: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, st) => const SizedBox(
                      width: 220,
                      height: 120,
                      child: ColoredBox(color: Colors.black12))),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMemberCard({
    required String nameEn,
    required String nameHi,
    required String positionEn,
    required String positionHi,
    required String imagePath,
    required String bioEn,
    required String bioHi,
  }) {
    final name = getText(nameEn, nameHi);
    final position = getText(positionEn, positionHi);
    final bio = getText(bioEn, bioHi);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 280,
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(imagePath,
                  height: 220, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  Text(position,
                      style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 210, 105, 25),
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text(bio,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // YouTube Video Widget
  Widget _buildYouTubeVideo(String videoId,
      {double width = 420, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: HtmlElementView(viewType: 'youtube-$videoId'),
          ),
        ),
      ),
    );
  }

  String _mp4ViewType(String videoPath) {
    return 'mp4-${videoPath.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}';
  }

  // MP4 Video Widget
  Widget _buildMP4Video(String videoPath,
      {double width = 420, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: HtmlElementView(viewType: _mp4ViewType(videoPath)),
          ),
        ),
      ),
    );
  }

  // Beautiful Contact Form
  Widget _buildContactForm() {
    return Column(
      children: [
        Text(
          getText('Get In Touch', 'हमसे संपर्क करें'),
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          getText(
              'We would love to hear from you. Send us a message and we\'ll respond as soon as possible.',
              'हम आपसे सुनना पसंद करेंगे। हमें एक संदेश भेजें और हम जल्द से जल्द जवाब देंगे।'),
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 60),

        // Contact Form Container
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name Field
                Text(
                  getText('Name', 'नाम'),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: getText(
                        'Enter your full name', 'अपना पूरा नाम दर्ज करें'),
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 210, 105, 25), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 24),

                // Email Field
                Text(
                  getText('Email Address', 'ईमेल पता'),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: getText(
                        'Enter your email address', 'अपना ईमेल पता दर्ज करें'),
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 210, 105, 25), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 24),

                // Phone Number Field
                Text(
                  getText('Phone Number', 'फोन नंबर'),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: getText(
                        'Enter your phone number', 'अपना फोन नंबर दर्ज करें'),
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 210, 105, 25), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 24),

                // Message Field
                Text(
                  getText('Message', 'संदेश'),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _messageController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: getText('Tell us more about your inquiry...',
                        'अपनी जांच के बारे में हमें और बताएं...'),
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 210, 105, 25), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color.fromARGB(255, 210, 105, 25),
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withValues(alpha: 0.8)),
                          ),
                        )
                      : Text(
                          getText('Send Message', 'संदेश भेजें'),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Handle Contact Form Submission
  void _handleSubmit() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final message = _messageController.text.trim();

    // Validation
    if (name.isEmpty) {
      _showSnackBar(
          getText('Please enter your name', 'कृपया अपना नाम दर्ज करें'));
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      _showSnackBar(getText('Please enter a valid email address',
          'कृपया एक वैध ईमेल पता दर्ज करें'));
      return;
    }
    if (phone.isEmpty) {
      _showSnackBar(getText(
          'Please enter your phone number', 'कृपया अपना फोन नंबर दर्ज करें'));
      return;
    }
    if (message.isEmpty) {
      _showSnackBar(
          getText('Please enter your message', 'कृपया अपना संदेश दर्ज करें'));
      return;
    }

    setState(() => _isSubmitting = true);

    // Send email via EmailJS
    _sendEmailViaEmailJS(name, email, phone, message);
  }

  // Send email using EmailJS
  Future<void> _sendEmailViaEmailJS(
      String name, String email, String phone, String message) async {
    final params = <String, dynamic>{
      'service_id': emailjsServiceId,
      'template_id': emailjsTemplateId,
      'template_params': {
        'to_email': emailjsRecipientEmail,
        'from_name': name,
        'from_email': email,
        'phone': phone,
        'message': message,
      }
    };

    try {
      await sendEmailJS(params);

      if (mounted) {
        setState(() => _isSubmitting = false);
        _showSnackBar(
            getText('Thank you! Your message has been sent successfully.',
                'धन्यवाद! आपका संदेश सफलतापूर्वक भेज दिया गया है।'),
            isSuccess: true);

        // Clear form
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _messageController.clear();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        final errorMessage = e.toString();
        _showSnackBar(
          '${getText('Error sending message. Please try again.',
                  'संदेश भेजने में त्रुटि। कृपया पुनः प्रयास करें।')}\n$errorMessage',
        );
        debugPrint('EmailJS Error: $e');
      }
    }
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
