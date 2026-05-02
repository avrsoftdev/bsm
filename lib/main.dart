import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

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

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _historyKey = GlobalKey();
  final GlobalKey _membersKey = GlobalKey();
  final GlobalKey _blogsKey = GlobalKey();
  final GlobalKey _videosKey = GlobalKey();

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
  Widget build(BuildContext context) {
    // Register your real YouTube videos here
    _registerYouTubeView('lXKX22WD0Ws');           // First video ID
    _registerYouTubeView('fyNm4PZMDVc'); // Second video ID

    return Scaffold(
      appBar: AppBar(
        title: Text(getText('Bhartiya Sadbhavna Manch', 'भारतीय सद्भावना मंच')),
        backgroundColor: const Color.fromARGB(255, 210, 105, 25),
        foregroundColor: Colors.white,
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
          TextButton(onPressed: () => _scrollToSection(_homeKey), child: Text(getText('Home', 'होम'), style: const TextStyle(color: Colors.white))),
          TextButton(onPressed: () => _scrollToSection(_historyKey), child: Text(getText('History', 'इतिहास'), style: const TextStyle(color: Colors.white))),
          TextButton(onPressed: () => _scrollToSection(_membersKey), child: Text(getText('Members', 'सदस्य'), style: const TextStyle(color: Colors.white))),
          TextButton(onPressed: () => _scrollToSection(_blogsKey), child: Text(getText('Blogs', 'ब्लॉग'), style: const TextStyle(color: Colors.white))),
          TextButton(onPressed: () => _scrollToSection(_videosKey), child: Text(getText('Videos', 'वीडियो'), style: const TextStyle(color: Colors.white))),
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
                color: Colors.black.withOpacity(0.6),
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
                        imageUrl: 'https://picsum.photos/id/64/300/300',
                        bioEn: 'Senior Pracharak, Rashtriya Swayamsevak Sangh',
                        bioHi: 'वरिष्ठ प्रचारक, राष्ट्रीय स्वयंसेवक संघ',
                      ),
                      _buildMemberCard(
                        nameEn: 'Sadhvi Ma Kalpana Arundhati',
                        nameHi: 'साध्वी माँ कल्पना अरुंधति',
                        positionEn: 'National Coordinator',
                        positionHi: 'राष्ट्रीय संयोजिका',
                        imageUrl: 'https://picsum.photos/id/65/300/300',
                        bioEn: 'Spiritual guide and inspiration',
                        bioHi: 'आध्यात्मिक मार्गदर्शक एवं प्रेरणा स्रोत',
                      ),
                      _buildMemberCard(
                        nameEn: 'CA Dr. Arjun Mundra',
                        nameHi: 'सी ए डॉ. अर्जुन मुंडरा',
                        positionEn: 'Chief Advisor',
                        positionHi: 'मुख्य सलाहकार',
                        imageUrl: 'https://picsum.photos/id/66/300/300',
                        bioEn: 'Leading policies and operations',
                        bioHi: 'नीतियों और कार्यप्रणाली का नेतृत्व',
                      ),
                      _buildMemberCard(
                        nameEn: 'Aakash Dodwal',
                        nameHi: 'आकाश डोडवाल',
                        positionEn: 'National Media Convener',
                        positionHi: 'राष्ट्रीय मीडिया प्रभारी',
                        imageUrl: 'https://picsum.photos/id/67/300/300',
                        bioEn: 'Managing Media and Communications',
                        bioHi: 'संचालन - मीडिया और संचार प्रबंधन',
                      ),
                      _buildMemberCard(
                        nameEn: 'Vishwajeet Singh',
                        nameHi: 'विश्वजीत सिंह',
                        positionEn: 'National Convener- Youth Cell',
                        positionHi: 'राष्ट्रीय सयोंजक - युवा प्रकोष्ठ ',
                        imageUrl: 'https://picsum.photos/id/67/300/300',
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
  Widget _buildMemberCard({
    required String nameEn,
    required String nameHi,
    required String positionEn,
    required String positionHi,
    required String imageUrl,
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
              child: Image.asset(imageUrl, height: 220, width: double.infinity, fit: BoxFit.cover),
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
}