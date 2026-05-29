import 'dart:html' as html;
import 'dart:js_util' as js_util;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web/web.dart' as web show HTMLIFrameElement;

// EmailJS Configuration
const String emailjsServiceId = 'service_xu8fwps';
const String emailjsTemplateId = 'template_y03xjwd'; // Replace with your template ID
const String emailjsPublicKey = 'ZbZZAtfauXMp4calj'; // Replace with your public key
const String emailjsRecipientEmail = 'bhartiysadbhavnamanch@gmail.com'; // Replace with recipient email

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
          bodyMedium: GoogleFonts.hind(textStyle: GoogleFonts.poppinsTextTheme().bodyMedium),
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

  const HomePage({super.key, required this.currentLocale, required this.onLanguageChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _marqueeController = ScrollController();

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _historyKey = GlobalKey();
  final GlobalKey _membersKey = GlobalKey();
  final GlobalKey _blogsKey = GlobalKey();
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
      Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
    }
  }

  String getText(String en, String hi) {
    return widget.currentLocale.languageCode == 'hi' ? hi : en;
  }

  // Register YouTube Video for Web
  void _registerYouTubeView(String videoId) {
    final viewType = 'youtube-$videoId';
    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) => web.HTMLIFrameElement()
        ..width = '100%'
        ..height = '100%'
        ..src = 'https://www.youtube.com/embed/$videoId'
        ..style.border = 'none'
        ..allowFullscreen = true,
    );
  }

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Register your real YouTube videos here
    _registerYouTubeView('lXKX22WD0Ws');           // First video ID
    _registerYouTubeView('fyNm4PZMDVc'); // Second video ID

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
        title: Text(getText('Bhartiya Sadbhavna Manch', 'भारतीय सद्भावना मंच')),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 210, 105, 25),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (lang) {
              widget.onLanguageChanged(lang == 'hi' ? const Locale('hi') : const Locale('en'));
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'en', child: Text('English')),
              const PopupMenuItem(value: 'hi', child: Text('हिंदी')),
            ],
          ),
          TextButton(onPressed: () => _scrollToSection(_homeKey), child: Text(getText('Home', 'होम'), style: const TextStyle(color: Colors.orange))),
          TextButton(onPressed: () => _scrollToSection(_historyKey), child: Text(getText('History', 'इतिहास'), style: const TextStyle(color: Colors.orange))),
          TextButton(onPressed: () => _scrollToSection(_membersKey), child: Text(getText('Members', 'सदस्य'), style: const TextStyle(color: Colors.orange))),
          TextButton(onPressed: () => _scrollToSection(_blogsKey), child: Text(getText('Blogs', 'ब्लॉग'), style: const TextStyle(color: Colors.orange))),
          TextButton(onPressed: () => _scrollToSection(_videosKey), child: Text(getText('Videos', 'वीडियो'), style: const TextStyle(color: Colors.orange))),
          TextButton(onPressed: () => _scrollToSection(_contactKey), child: Text(getText('Contact', 'संपर्क'), style: const TextStyle(color: Colors.orange))),
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://picsum.photos/id/1015/1920/1080'),
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
                          getText('Welcome to Bhartiya Sadbhavna Manch', 'भारतीय सद्भावना मंच में स्वागत है'),
                          style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          getText('Promoting Social Unity and Goodwill', 'सामाजिक एकता और सद्भावना को बढ़ावा देना'),
                          style: const TextStyle(fontSize: 22, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () => _scrollToSection(_historyKey),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                            backgroundColor: Colors.white,
                            foregroundColor: const Color.fromARGB(255, 210, 105, 25),
                          ),
                          child: Text(getText('Learn Our Story', 'हमारी कहानी जानें')),
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
                  Text(getText('Our History', 'हमारा इतिहास'), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Text(
                    getText('''Bhartiya Sadbhavna Manch is a socio-cultural organization inspired by the ideals of the Rashtriya Swayamsevak Sangh. The organization was established in 2016 under the guidance of Honorable Dr. Indresh Kumar.

The responsibility of leading the organization has been entrusted to National Convenor Sadhvi Maa Arundhati, who is actively guiding and strengthening the vision and mission of the Manch.

The advisory role is held by CA Dr. Arjun Mundra, whose expertise contributes to shaping the organization’s policies and operational excellence.

The primary objective of Bhartiya Sadbhavna Manch is to promote harmony, unity, brotherhood, and social cohesion in society. The organization actively works towards connecting people across communities and raising awareness on important social and national issues.

To ensure effective functioning, the Manch has established several dedicated cells (Prakosth), including:

🌿 Environment Cell
👩 Women Cell
👨‍🎓 Youth Cell
🐄 Cow Protection Cell

Each of these cells plays a vital role in addressing specific areas and contributing to the overall development of society.

Bhartiya Sadbhavna Manch stands as a platform committed to nation-building, social harmony, and positive transformation.''', '''भारतीय सद्भावना मंच एक सामाजिक एवं सांस्कृतिक संगठन है, जो राष्ट्रीय स्वयंसेवक संघ से प्रेरित है। इस मंच का निर्माण वर्ष 2016 में माननीय डॉ. इंद्रेश कुमार जी के मार्गदर्शन में किया गया। संगठन की महत्वपूर्ण जिम्मेदारी राष्ट्रीय संयोजिका के रूप में साध्वी मां अरुंधति जी को सौंपी गई है, जो संगठन को सशक्त दिशा प्रदान कर रही हैं। मंच के सलाहकार के रूप में सीए डॉ. अर्जुन मुंद्रा जी अपनी महत्वपूर्ण भूमिका निभा रहे हैं, जो संगठन की नीतियों और कार्यप्रणाली को सुदृढ़ बनाने में सहयोग करते हैं। भारतीय सद्भावना मंच का मुख्य उद्देश्य समाज में सद्भावना, एकता, भाईचारा और सामाजिक समरसता को बढ़ावा देना है। यह मंच विभिन्न सामाजिक और राष्ट्रीय मुद्दों पर जागरूकता फैलाने तथा समाज के हर वर्ग को जोड़ने के लिए निरंतर कार्यरत है। संगठन के कार्यों को प्रभावी ढंग से संचालित करने के लिए विभिन्न प्रकोष्ठ (Cells/Departments) का गठन किया गया है, जिनमें प्रमुख हैं:

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
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    getText('Dedicated leaders working for social harmony', 'सामाजिक सद्भावना के लिए समर्पित हमारे नेतृत्व'),
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

            // ==================== BLOGS SECTION ====================
            Container(
              key: _blogsKey,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
              child: Column(
                children: [
                  Text(
                    getText('Latest Blogs', 'नवीनतम ब्लॉग'),
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    getText('Insights and updates from Bhartiya Sadbhavna Manch', 'भारतीय सद्भावना मंच की अंतर्दृष्टि और अपडेट'),
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 50),

                  // Responsive Blog Cards
                  Wrap(
                    spacing: 25,
                    runSpacing: 30,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildBlogCard(
                        titleEn: 'Importance of Social Harmony in Modern India',
                        titleHi: 'आधुनिक भारत में सामाजिक सद्भावना का महत्व',
                        excerptEn: 'Exploring how unity and goodwill can strengthen our diverse society...',
                        excerptHi: 'यह कैसे एकता और सद्भावना हमारी विविध समाज को मजबूत बना सकती है...',
                        imageUrl: 'https://picsum.photos/id/201/400/250',
                        date: '12 April 2026',
                      ),
                      _buildBlogCard(
                        titleEn: 'Role of Youth in Nation Building',
                        titleHi: 'राष्ट्र निर्माण में युवाओं की भूमिका',
                        excerptEn: 'How young minds are leading initiatives for social unity...',
                        excerptHi: 'कैसे युवा मस्तिष्क सामाजिक एकता के लिए पहल कर रहे हैं...',
                        imageUrl: 'https://picsum.photos/id/202/400/250',
                        date: '10 April 2026',
                      ),
                      _buildBlogCard(
                        titleEn: 'Cultural Events that Promote Goodwill',
                        titleHi: 'सद्भावना को बढ़ावा देने वाले सांस्कृतिक कार्यक्रम',
                        excerptEn: 'A look at our recent successful cultural programs...',
                        excerptHi: 'हमारे हाल के सफल सांस्कृतिक कार्यक्रमों पर एक नजर...',
                        imageUrl: 'https://picsum.photos/id/203/400/250',
                        date: '08 April 2026',
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
                  Text(getText('Our YouTube Videos', 'हमारे यूट्यूब वीडियो'), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  Wrap(
                    spacing: 30,
                    runSpacing: 30,
                    children: [
                      _buildYouTubeVideo('lXKX22WD0Ws'),
                      _buildYouTubeVideo('fyNm4PZMDVc'),
                    ],
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
                    getText('© 2026 Bhartiya Sadbhavna Manch. All Rights Reserved.', '© 2026 भारतीय सद्भावना मंच। सर्वाधिकार सुरक्षित।'),
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
    'assets/images/20250407_154704.jpg',
    'assets/images/20250425_121236.jpg',
    'assets/images/IMG-20241125-WA0091.jpg',
    'assets/images/IMG-20241125-WA0097.jpg',
    'assets/images/IMG-20241125-WA0098.jpg',
    'assets/images/Screenshot_20250427_214530_WhatsApp.jpg',
    'assets/images/rss1.jpeg',
    'assets/images/rss2.jpeg',
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
        await _marqueeController.animateTo(max, duration: Duration(milliseconds: durationMs), curve: Curves.linear);
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
              child: Image.asset(items[index], height: 120, width: 220, fit: BoxFit.cover, errorBuilder: (c,e,st) => const SizedBox(width: 220, height: 120, child: ColoredBox(color: Colors.black12))),
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(imagePath, height: 220, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  Text(position, style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 210, 105, 25), fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text(bio, style: const TextStyle(fontSize: 14, height: 1.5), textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Beautiful Blog Card
  Widget _buildBlogCard({
    required String titleEn,
    required String titleHi,
    required String excerptEn,
    required String excerptHi,
    required String imageUrl,
    required String date,
  }) {
    final title = getText(titleEn, titleHi);
    final excerpt = getText(excerptEn, excerptHi);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 340,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Text(excerpt, style: const TextStyle(fontSize: 15, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(getText('Read More →', 'और पढ़ें →'), style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // YouTube Video Widget
  Widget _buildYouTubeVideo(String videoId) {
    return Container(
      width: 420,
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
          getText('We would love to hear from you. Send us a message and we\'ll respond as soon as possible.', 'हम आपसे सुनना पसंद करेंगे। हमें एक संदेश भेजें और हम जल्द से जल्द जवाब देंगे।'),
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
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: getText('Enter your full name', 'अपना पूरा नाम दर्ज करें'),
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
                      borderSide: const BorderSide(color: Color.fromARGB(255, 210, 105, 25), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 24),

                // Email Field
                Text(
                  getText('Email Address', 'ईमेल पता'),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: getText('Enter your email address', 'अपना ईमेल पता दर्ज करें'),
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
                      borderSide: const BorderSide(color: Color.fromARGB(255, 210, 105, 25), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 24),

                // Phone Number Field
                Text(
                  getText('Phone Number', 'फोन नंबर'),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: getText('Enter your phone number', 'अपना फोन नंबर दर्ज करें'),
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
                      borderSide: const BorderSide(color: Color.fromARGB(255, 210, 105, 25), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 24),

                // Message Field
                Text(
                  getText('Message', 'संदेश'),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _messageController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: getText('Tell us more about your inquiry...', 'अपनी जांच के बारे में हमें और बताएं...'),
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
                      borderSide: const BorderSide(color: Color.fromARGB(255, 210, 105, 25), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withValues(alpha: 0.8)),
                          ),
                        )
                      : Text(
                          getText('Send Message', 'संदेश भेजें'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
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
      _showSnackBar(getText('Please enter your name', 'कृपया अपना नाम दर्ज करें'));
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      _showSnackBar(getText('Please enter a valid email address', 'कृपया एक वैध ईमेल पता दर्ज करें'));
      return;
    }
    if (phone.isEmpty) {
      _showSnackBar(getText('Please enter your phone number', 'कृपया अपना फोन नंबर दर्ज करें'));
      return;
    }
    if (message.isEmpty) {
      _showSnackBar(getText('Please enter your message', 'कृपया अपना संदेश दर्ज करें'));
      return;
    }

    setState(() => _isSubmitting = true);

    // Send email via EmailJS
    _sendEmailViaEmailJS(name, email, phone, message);
  }

  // Send email using EmailJS
  Future<void> _sendEmailViaEmailJS(String name, String email, String phone, String message) async {
    final params = js_util.jsify({
      'service_id': emailjsServiceId,
      'template_id': emailjsTemplateId,
      'template_params': {
        'to_email': emailjsRecipientEmail,
        'from_name': name,
        'from_email': email,
        'phone': phone,
        'message': message,
      }
    });

    try {
      final sendFn = js_util.getProperty(html.window, 'sendEmailJS');
      if (sendFn == null) {
        throw Exception('sendEmailJS is not defined on window');
      }

      final promise = js_util.callMethod(sendFn, 'call', [html.window, params]);
      await js_util.promiseToFuture(promise);

      if (mounted) {
        setState(() => _isSubmitting = false);
        _showSnackBar(getText('Thank you! Your message has been sent successfully.', 'धन्यवाद! आपका संदेश सफलतापूर्वक भेज दिया गया है।'), isSuccess: true);
        
        // Clear form
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _messageController.clear();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        final errorMessage = e?.toString() ?? 'Unknown error';
        _showSnackBar(getText('Error sending message. Please try again.', 'संदेश भेजने में त्रुटि। कृपया पुनः प्रयास करें।') + '\n' + errorMessage);
        print('EmailJS Error: $e');
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