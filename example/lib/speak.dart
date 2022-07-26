import 'dart:math';

import 'package:flutter/material.dart';

import 'package:tts_plugin/tts_plugin.dart';

class Speak extends StatefulWidget {
  const Speak(
      {Key? key,
      required this.voice,
      required this.ttsPlugin,
      required this.random})
      : super(key: key);

  @override
  State<Speak> createState() => _SpeakState();

  final Voice voice;
  final TtsPlugin ttsPlugin;
  final Random random;
}

class _SpeakState extends State<Speak> {
  @override
  void initState() {
    super.initState();
    _initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Speak'),
        ),
        body: Column(children: [
          Expanded(child: _messageOrError()),
          Container(
              padding: const EdgeInsets.only(bottom: _inset),
              child: ElevatedButton(
                  onPressed: _speakAgain,
                  child: Text('Repeat', style: _defaultTextStyle())))
        ]));
  }

  Widget _messageOrError() {
    Text text;
    if (_errorMessage == null) {
      text = Text(_message ?? _defaultMessage, style: _defaultTextStyle());
    } else {
      text = Text(_errorMessage ?? '', style: _defaultTextStyle());
    }

    return Center(
        child: Container(padding: const EdgeInsets.all(_inset), child: text));
  }

  _initState() async {
    _initMessages();
    _choseRandomMessage();
    _speak();
  }

  _initMessages() {
    void update(Map<String, List<String>> dict, String key, String message) {
      dict.update(key, (existing) {
        existing.add(message);
        return existing;
      }, ifAbsent: () => [message]);
    }

    final lines = _voicesText.split('\n');
    for (var line in lines) {
      if (line.isEmpty) {
        continue;
      }
      final parts = line.split(RegExp(r' +'));
      final name = parts[0];
      final lang = parts[1];
      final message = parts.sublist(3).join(' ');

      update(_messagesByName, name, message);
      update(_messagesByLang, lang, message);

      final altLang = lang.replaceFirst('_', '-');
      update(_messagesByLang, altLang, message);
    }
  }

  _choseRandomMessage() {
    final messages = _messagesByName[widget.voice.name] ??
        _messagesByLang[widget.voice.language] ??
        [_defaultMessage];
    setState(() {
      if (messages.length == 1) {
        _message = messages[0];
      } else {
        _message = messages[widget.random.nextInt(messages.length)];
      }
    });
  }

  TextStyle _defaultTextStyle() {
    return TextStyle(
        fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize ??
            _defaultMessageFontSize);
  }

  Future<bool> _setCurrentVoice() async {
    final success = await widget.ttsPlugin.setVoice(widget.voice);
    if (!success) {
      setState(() {
        _errorMessage = "Could not set the voice";
      });
    }
    return success;
  }

  _speak() async {
    final message = _message;
    if (message != null) {
      final success = await _setCurrentVoice();
      if (success) {
        await widget.ttsPlugin.cancel();
        widget.ttsPlugin.speak(message);
      } else {
        setState(() {
          _errorMessage = "Could not set the voice";
        });
      }
    }
  }

  void _speakAgain() async {
    _choseRandomMessage();
    await widget.ttsPlugin.cancel();
    _speak();
  }

  static const String _defaultMessage = "No message to speak";
  static const _inset = 10.0;
  static const _defaultMessageFontSize = 32.0;

  final _messagesByName = <String, List<String>>{};
  final _messagesByLang = <String, List<String>>{};

  String? _message;
  String? _errorMessage;

  static const _voicesText = """
Agnes               en_US    # Isn't it nice to have a computer that will talk to you?
Alex                en_US    # Most people recognize me by my voice.
Alice               it_IT    # Salve, mi chiamo Alice e sono una voce italiana.
Allison             en_US    # Hello, my name is Allison. I am an American-English voice.
Alva                sv_SE    # Hej, jag heter Alva. Jag är en svensk röst.
Amelie              fr_CA    # Bonjour, je m’appelle Amelie. Je suis une voix canadienne.
Anna                de_DE    # Hallo, ich heiße Anna und ich bin eine deutsche Stimme.
Ava                 en_US    # Hello, my name is Ava. I am an American-English voice.
Carmit              he_IL    # שלום. קוראים לי כרמית, ואני קול בשפה העברית.
Damayanti           id_ID    # Halo, nama saya Damayanti. Saya berbahasa Indonesia.
Daniel              en_GB    # Hello, my name is Daniel. I am a British-English voice.
Diego               es_AR    # Hola, me llamo Diego y soy una voz española.
Ellen               nl_BE    # Hallo, mijn naam is Ellen. Ik ben een Belgische stem.
Fiona               en-scotland # Hello, my name is Fiona. I am a Scottish-English voice.
Fred                en_US    # I sure like being inside this fancy computer
Ioana               ro_RO    # Bună, mă cheamă Ioana . Sunt o voce românească.
Joana               pt_PT    # Olá, chamo-me Joana e dou voz ao português falado em Portugal.
Jorge               es_ES    # Hola, me llamo Jorge y soy una voz española.
Juan                es_MX    # Hola, me llamo Juan y soy una voz mexicana.
Kanya               th_TH    # สวัสดีค่ะ ดิฉันชื่อKanya
Karen               en_AU    # Hello, my name is Karen. I am an Australian-English voice.
Kathy               en_US    # Isn't it nice to have a computer that will talk to you?
Kyoko               ja_JP    # こんにちは、私の名前はKyokoです。日本語の音声をお届けします。
Laura               sk_SK    # Ahoj. Volám sa Laura . Som hlas v slovenskom jazyku.
Lekha               hi_IN    # नमस्कार, मेरा नाम लेखा है. मैं हिन्दी में बोलने वाली आवाज़ हूँ.
Luca                it_IT    # Salve, mi chiamo Luca e sono una voce italiana.
Luciana             pt_BR    # Olá, o meu nome é Luciana e a minha voz corresponde ao português que é falado no Brasil
Maged               ar_SA    # مرحبًا اسمي Maged. أنا عربي من السعودية.
Mariska             hu_HU    # Üdvözlöm! Mariska vagyok. Én vagyok a magyar hang.
Mei-Jia             zh_TW    # 您好，我叫美佳。我說國語。
Melina              el_GR    # Γεια σας, ονομάζομαι Melina. Είμαι μια ελληνική φωνή.
Milena              ru_RU    # Здравствуйте, меня зовут Milena. Я – русский голос системы.
Moira               en_IE    # Hello, my name is Moira. I am an Irish-English voice.
Monica              es_ES    # Hola, me llamo Monica y soy una voz española.
Nora                nb_NO    # Hei, jeg heter Nora. Jeg er en norsk stemme.
Paulina             es_MX    # Hola, me llamo Paulina y soy una voz mexicana.
Petra               de_DE    # Hallo, ich heiße Petra und ich bin eine deutsche Stimme.
Princess            en_US    # When I grow up I'm going to be a scientist.
Rishi               en_IN    # Hello, my name is Rishi. I am an Indian-English voice.
Samantha            en_US    # Hello, my name is Samantha. I am an American-English voice.
Sara                da_DK    # Hej, jeg hedder Sara. Jeg er en dansk stemme.
Satu                fi_FI    # Hei, minun nimeni on Satu. Olen suomalainen ääni.
Sin-ji              zh_HK    # 您好，我叫 Sin-ji。我講廣東話。
Susan               en_US    # Hello, my name is Susan. I am an American-English voice.
Tessa               en_ZA    # Hello, my name is Tessa. I am a South African-English voice.
Thomas              fr_FR    # Bonjour, je m’appelle Thomas. Je suis une voix française.
Ting-Ting           zh_CN    # 您好，我叫Ting-Ting。我讲中文普通话。
Veena               en_IN    # Hello, my name is Veena. I am an Indian-English voice.
Vicki               en_US    # Isn't it nice to have a computer that will talk to you?
Victoria            en_US    # Isn't it nice to have a computer that will talk to you?
Xander              nl_NL    # Hallo, mijn naam is Xander. Ik ben een Nederlandse stem.
Yelda               tr_TR    # Merhaba, benim adım Yelda. Ben Türkçe bir sesim.
Yuna                ko_KR    # 안녕하세요. 제 이름은 Yuna입니다. 저는 한국어 음성입니다.
Yuri                ru_RU    # Здравствуйте, меня зовут Yuri. Я – русский голос системы.
Zosia               pl_PL    # Witaj. Mam na imię Zosia, jestem głosem kobiecym dla języka polskiego.
Zuzana              cs_CZ    # Dobrý den, jmenuji se Zuzana. Jsem český hlas.
""";
}
