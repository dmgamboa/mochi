import 'package:flutter/material.dart';
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mochi/features/auth/presentation/screens/signin_screen.dart';
import 'package:mochi/features/profile/presentation/screens/profile_creation_screen.dart';
import 'dart:developer';
import 'dart:ui' as ui;

import '../../../discover/presentation/screens/discover_screen.dart';

import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  static const String route = '/signup';

  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Layout(
        needsAuth: false,
        navBar: false,
        body: Column(children: [
          const TopSplash(),
          const Padding(
            padding: EdgeInsets.all(0.0),
            child: Text('Sign Up',
                style: TextStyle(
                  fontSize: 30,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                prefixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(10, 12, 0, 0),
                  child: FaIcon(FontAwesomeIcons.solidEnvelope),
                ),
                border: UnderlineInputBorder(),
                labelText: 'email',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                hintText: 'email',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                prefixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(10, 12, 0, 0),
                  child: FaIcon(FontAwesomeIcons.lock),
                ),
                border: UnderlineInputBorder(),
                labelText: 'password',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                hintText: 'password',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              obscureText: true,
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                prefixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(10, 12, 0, 0),
                  child: FaIcon(FontAwesomeIcons.lock),
                ),
                border: UnderlineInputBorder(),
                labelText: 'confirm password',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                hintText: 'confirm password',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          //sign up button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onPressed: () => signUpEmail(context),
              child: const Text('Sign Up'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(SigninScreen.route),
                child: const Text('Sign In',
                    style: TextStyle(
                      color: Colors.blue,
                    )),
              ),
            ],
          ),
          // GoogleRow(),
          // FacebookRow(),
          // TwitterRow(),
        ]));
  }

  signUpEmail(BuildContext context) async {
    try {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ));
        return;
      }
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
        content: Text('Account created successfully'),
        backgroundColor: Colors.green,
      ));
      var tokenId = await FirebaseAuth.instance.currentUser!.getIdToken(true);
      var url = Uri.parse('http://10.0.2.2:3000/signup');
      var _headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenId',
      };
      var response = await http.get(url, headers: _headers);
      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
        content: Text(response.body),
        backgroundColor: Colors.green,
      ));

      await Future.delayed(const Duration(seconds: 5));
      if (context.mounted) {
        Navigator.of(context).pushNamed(ProfileCreationScreen.route);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The password provided is too weak.'),
          backgroundColor: Colors.red,
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'The account already exists for the email ${emailController.text}.'),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message!),
          backgroundColor: Colors.red,
        ));
      }
    }
    // ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
    //   content: Text('Account created successfully'),
    // ));
    // Navigator.of(this.context)
    //     .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
    // if (context.mounted) Navigator.of(context).pushNamed(DiscoverScreen.route);
  }
}

class GoogleRow extends StatelessWidget {
  const GoogleRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        child: Container(
          height: 50.0,
          width: 50.0,
          // color: Colors.blue,
          decoration: BoxDecoration(
              color: Colors.yellow, borderRadius: BorderRadius.circular(10.0)),
          child: IconButton(
            color: Colors.white,
            icon: const FaIcon(FontAwesomeIcons.squareGooglePlus),
            onPressed: () {},
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Container(
          height: 50.0,
          width: 250.0,
          decoration: BoxDecoration(
              color: Colors.yellow, borderRadius: BorderRadius.circular(10.0)),
          child: TextButton(
            child: const Text(
              'GOOGLE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ),
    ]);
  }
}

class TwitterRow extends StatelessWidget {
  const TwitterRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        child: Container(
          height: 50.0,
          width: 50.0,
          // color: Colors.blue,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10.0)),
          child: IconButton(
            color: Colors.white,
            icon: const FaIcon(FontAwesomeIcons.squareTwitter),
            onPressed: () {},
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Container(
          height: 50.0,
          width: 250.0,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10.0)),
          child: TextButton(
            child: const Text(
              'TWITTER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ),
    ]);
  }
}

class FacebookRow extends StatelessWidget {
  const FacebookRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Container(
          height: 50.0,
          width: 50.0,
          // color: Colors.blue,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 36, 70, 195),
              borderRadius: BorderRadius.circular(10.0)),
          child: IconButton(
            color: Colors.white,
            icon: const FaIcon(FontAwesomeIcons.squareFacebook),
            onPressed: () {},
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Container(
          height: 50.0,
          width: 250.0,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 36, 70, 195),
              borderRadius: BorderRadius.circular(10.0)),
          child: TextButton(
            child: const Text(
              'FACEBOOK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ),
    ]);
  }
}

class TopSplash extends StatelessWidget {
  const TopSplash({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        TopBackground(),
        Positioned(
          top: 30,
          left: 45,
          child: TopBackgroundLogo(),
        ),
      ],
    );
  }
}

class TopBackground extends StatelessWidget {
  const TopBackground({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return CustomPaint(
      size: Size(600, (600 * 0.3220512820512821).toDouble()),
      painter: RPSCustomPainter(),
    );
  }
}

class TopBackgroundLogo extends StatelessWidget {
  const TopBackgroundLogo({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return CustomPaint(
      size: Size(300, (300 * 0.3220512820512821).toDouble()),
      painter: RPSCustomPainter2(),
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 1.039341, size.height * 0.7455242);
    path_0.lineTo(size.width * 1.170136, size.height * 0.4148581);
    path_0.cubicTo(
        size.width * 1.173018,
        size.height * 0.4075718,
        size.width * 1.176497,
        size.height * 0.4010392,
        size.width * 1.180467,
        size.height * 0.3954630);
    path_0.cubicTo(
        size.width * 1.192828,
        size.height * 0.3780996,
        size.width * 1.200000,
        size.height * 0.3521159,
        size.width * 1.200000,
        size.height * 0.3246824);
    path_0.lineTo(size.width * 1.200000, size.height * -0.9118943);
    path_0.cubicTo(
        size.width * 1.200000,
        size.height * -1.155189,
        size.width * 1.085203,
        size.height * -1.352423,
        size.width * 0.9435897,
        size.height * -1.352423);
    path_0.lineTo(size.width * 0.1509308, size.height * -1.352423);
    path_0.cubicTo(
        size.width * 0.006484718,
        size.height * -1.352423,
        size.width * -0.1094536,
        size.height * -1.147533,
        size.width * -0.1053774,
        size.height * -0.8994626);
    path_0.lineTo(size.width * -0.08106205, size.height * 0.5803084);
    path_0.cubicTo(
        size.width * -0.07845128,
        size.height * 0.7391806,
        size.width * 0.03944897,
        size.height * 0.8030308,
        size.width * 0.09461564,
        size.height * 0.6754449);
    path_0.cubicTo(
        size.width * 0.1346144,
        size.height * 0.5829383,
        size.width * 0.2157782,
        size.height * 0.5858722,
        size.width * 0.2534782,
        size.height * 0.6811850);
    path_0.lineTo(size.width * 0.3010462, size.height * 0.8014449);
    path_0.cubicTo(
        size.width * 0.3275538,
        size.height * 0.8684581,
        size.width * 0.3830641,
        size.height * 0.8772643,
        size.width * 0.4162641,
        size.height * 0.8197269);
    path_0.lineTo(size.width * 0.4206718, size.height * 0.8120881);
    path_0.cubicTo(
        size.width * 0.4634949,
        size.height * 0.7378767,
        size.width * 0.5372667,
        size.height * 0.7826872,
        size.width * 0.5434231,
        size.height * 0.8866520);
    path_0.cubicTo(
        size.width * 0.5502256,
        size.height * 1.001529,
        size.width * 0.6368154,
        size.height * 1.039159,
        size.width * 0.6745923,
        size.height * 0.9436520);
    path_0.lineTo(size.width * 0.7581205, size.height * 0.7324758);
    path_0.cubicTo(
        size.width * 0.7923564,
        size.height * 0.6459207,
        size.width * 0.8672641,
        size.height * 0.6493965,
        size.width * 0.8987308,
        size.height * 0.7390000);
    path_0.cubicTo(
        size.width * 0.9302000,
        size.height * 0.8286035,
        size.width * 1.005105,
        size.height * 0.8320793,
        size.width * 1.039341,
        size.height * 0.7455242);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.4974359, size.height * 0.4405189),
        Offset(size.width * 0.4974359, size.height * 1.224670), [
      const Color(0xffC4858D).withOpacity(1),
      const Color(0xff7C5A5E).withOpacity(1)
    ], [
      0.458333,
      1
    ]);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RPSCustomPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.08042939, size.height * 0.3397933);
    path_0.cubicTo(
        size.width * 0.08985197,
        size.height * 0.3397933,
        size.width * 0.09908530,
        size.height * 0.3423161,
        size.width * 0.1081634,
        size.height * 0.3472987);
    path_0.cubicTo(
        size.width * 0.1172244,
        size.height * 0.3522805,
        size.width * 0.1250968,
        size.height * 0.3597544,
        size.width * 0.1317462,
        size.height * 0.3696859);
    path_0.cubicTo(
        size.width * 0.1386366,
        size.height * 0.3610805,
        size.width * 0.1464057,
        size.height * 0.3539631,
        size.width * 0.1550190,
        size.height * 0.3483664);
    path_0.cubicTo(
        size.width * 0.1636319,
        size.height * 0.3427691,
        size.width * 0.1740194,
        size.height * 0.3399872,
        size.width * 0.1861982,
        size.height * 0.3400195);
    path_0.cubicTo(
        size.width * 0.1949319,
        size.height * 0.3400195,
        size.width * 0.2034763,
        size.height * 0.3422195,
        size.width * 0.2118652,
        size.height * 0.3465544);
    path_0.cubicTo(
        size.width * 0.2202373,
        size.height * 0.3508899,
        size.width * 0.2277136,
        size.height * 0.3576839,
        size.width * 0.2342423,
        size.height * 0.3669685);
    path_0.cubicTo(
        size.width * 0.2407882,
        size.height * 0.3762537,
        size.width * 0.2459907,
        size.height * 0.3885799,
        size.width * 0.2499011,
        size.height * 0.4038826);
    path_0.cubicTo(
        size.width * 0.2537939,
        size.height * 0.4192168,
        size.width * 0.2557405,
        size.height * 0.4378517,
        size.width * 0.2557233,
        size.height * 0.4598510);
    path_0.lineTo(size.width * 0.2556029, size.height * 0.6636685);
    path_0.cubicTo(
        size.width * 0.2533118,
        size.height * 0.6649631,
        size.width * 0.2496943,
        size.height * 0.6662570,
        size.width * 0.2447502,
        size.height * 0.6675188);
    path_0.cubicTo(
        size.width * 0.2398065,
        size.height * 0.6688128,
        size.width * 0.2346903,
        size.height * 0.6694275,
        size.width * 0.2294190,
        size.height * 0.6694275);
    path_0.cubicTo(
        size.width * 0.2243717,
        size.height * 0.6694275,
        size.width * 0.2198240,
        size.height * 0.6687477,
        size.width * 0.2158100,
        size.height * 0.6674537);
    path_0.cubicTo(
        size.width * 0.2117964,
        size.height * 0.6661597,
        size.width * 0.2084029,
        size.height * 0.6635396,
        size.width * 0.2056466,
        size.height * 0.6596570);
    path_0.cubicTo(
        size.width * 0.2028907,
        size.height * 0.6557745,
        size.width * 0.2007717,
        size.height * 0.6505013,
        size.width * 0.1992903,
        size.height * 0.6438047);
    path_0.cubicTo(
        size.width * 0.1977918,
        size.height * 0.6371081,
        size.width * 0.1970681,
        size.height * 0.6283725,
        size.width * 0.1970681,
        size.height * 0.6175993);
    path_0.lineTo(size.width * 0.1971541, size.height * 0.4629570);
    path_0.cubicTo(
        size.width * 0.1971541,
        size.height * 0.4500161,
        size.width * 0.1952075,
        size.height * 0.4406342,
        size.width * 0.1913143,
        size.height * 0.4348107);
    path_0.cubicTo(
        size.width * 0.1874043,
        size.height * 0.4289872,
        size.width * 0.1821330,
        size.height * 0.4260436,
        size.width * 0.1754663,
        size.height * 0.4260436);
    path_0.cubicTo(
        size.width * 0.1722452,
        size.height * 0.4260436,
        size.width * 0.1688000,
        size.height * 0.4274342,
        size.width * 0.1651305,
        size.height * 0.4302168);
    path_0.cubicTo(
        size.width * 0.1614441,
        size.height * 0.4330315,
        size.width * 0.1586882,
        size.height * 0.4359107,
        size.width * 0.1568620,
        size.height * 0.4389195);
    path_0.cubicTo(
        size.width * 0.1570860,
        size.height * 0.4406664,
        size.width * 0.1572065,
        size.height * 0.4422839,
        size.width * 0.1572065,
        size.height * 0.4437725);
    path_0.cubicTo(
        size.width * 0.1572065,
        size.height * 0.4452926,
        size.width * 0.1572065,
        size.height * 0.4466839,
        size.width * 0.1572065,
        size.height * 0.4479779);
    path_0.lineTo(size.width * 0.1570860, size.height * 0.6634423);
    path_0.cubicTo(
        size.width * 0.1545538,
        size.height * 0.6647362,
        size.width * 0.1508330,
        size.height * 0.6660302,
        size.width * 0.1458889,
        size.height * 0.6672919);
    path_0.cubicTo(
        size.width * 0.1409452,
        size.height * 0.6685859,
        size.width * 0.1359495,
        size.height * 0.6692007,
        size.width * 0.1309022,
        size.height * 0.6692007);
    path_0.cubicTo(
        size.width * 0.1258548,
        size.height * 0.6692007,
        size.width * 0.1213072,
        size.height * 0.6685215,
        size.width * 0.1172935,
        size.height * 0.6672275);
    path_0.cubicTo(
        size.width * 0.1132796,
        size.height * 0.6659336,
        size.width * 0.1098860,
        size.height * 0.6633128,
        size.width * 0.1071297,
        size.height * 0.6594309);
    path_0.cubicTo(
        size.width * 0.1043738,
        size.height * 0.6555483,
        size.width * 0.1022548,
        size.height * 0.6502752,
        size.width * 0.1007735,
        size.height * 0.6435779);
    path_0.cubicTo(
        size.width * 0.09927491,
        size.height * 0.6368812,
        size.width * 0.09855125,
        size.height * 0.6281463,
        size.width * 0.09855125,
        size.height * 0.6173732);
    path_0.lineTo(size.width * 0.09863728, size.height * 0.4627302);
    path_0.cubicTo(
        size.width * 0.09863728,
        size.height * 0.4497899,
        size.width * 0.09651864,
        size.height * 0.4404074,
        size.width * 0.09228100,
        size.height * 0.4345846);
    path_0.cubicTo(
        size.width * 0.08802616,
        size.height * 0.4287611,
        size.width * 0.08292724,
        size.height * 0.4258168,
        size.width * 0.07694946,
        size.height * 0.4258168);
    path_0.cubicTo(
        size.width * 0.07281541,
        size.height * 0.4258168,
        size.width * 0.06924946,
        size.height * 0.4269819,
        size.width * 0.06626918,
        size.height * 0.4293430);
    path_0.cubicTo(
        size.width * 0.06327204,
        size.height * 0.4317047,
        size.width * 0.06075699,
        size.height * 0.4339698,
        size.width * 0.05868961,
        size.height * 0.4361369);
    path_0.lineTo(size.width * 0.05855197, size.height * 0.6632483);
    path_0.cubicTo(
        size.width * 0.05626093,
        size.height * 0.6645423,
        size.width * 0.05264337,
        size.height * 0.6658362,
        size.width * 0.04769928,
        size.height * 0.6670980);
    path_0.cubicTo(
        size.width * 0.04275556,
        size.height * 0.6683919,
        size.width * 0.03763943,
        size.height * 0.6690067,
        size.width * 0.03236810,
        size.height * 0.6690067);
    path_0.cubicTo(
        size.width * 0.02732079,
        size.height * 0.6690067,
        size.width * 0.02277308,
        size.height * 0.6683275,
        size.width * 0.01875935,
        size.height * 0.6670336);
    path_0.cubicTo(
        size.width * 0.01474566,
        size.height * 0.6657389,
        size.width * 0.01135208,
        size.height * 0.6631188,
        size.width * 0.008595878,
        size.height * 0.6592362);
    path_0.cubicTo(
        size.width * 0.005839677,
        size.height * 0.6553544,
        size.width * 0.003720860,
        size.height * 0.6500805,
        size.width * 0.002239409,
        size.height * 0.6433839);
    path_0.cubicTo(size.width * 0.0007235018, size.height * 0.6367517, 0,
        size.height * 0.6280168, 0, size.height * 0.6172114);
    path_0.lineTo(size.width * 0.0001205835, size.height * 0.4218054);
    path_0.cubicTo(
        size.width * 0.0001205835,
        size.height * 0.4101584,
        size.width * 0.001447004,
        size.height * 0.4009060,
        size.width * 0.004099857,
        size.height * 0.3939826);
    path_0.cubicTo(
        size.width * 0.006735448,
        size.height * 0.3870913,
        size.width * 0.01037018,
        size.height * 0.3806215,
        size.width * 0.01496961,
        size.height * 0.3746040);
    path_0.cubicTo(
        size.width * 0.02277308,
        size.height * 0.3642832,
        size.width * 0.03248867,
        size.height * 0.3558718,
        size.width * 0.04409928,
        size.height * 0.3494336);
    path_0.cubicTo(
        size.width * 0.05569247,
        size.height * 0.3429960,
        size.width * 0.06781971,
        size.height * 0.3397933,
        size.width * 0.08044659,
        size.height * 0.3397933);
    path_0.lineTo(size.width * 0.08042939, size.height * 0.3397933);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xff1A1A1A).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.6009211, size.height * 0.5278550);
    path_1.cubicTo(
        size.width * 0.6009211,
        size.height * 0.6931409,
        size.width * 0.5183907,
        size.height * 0.7300537,
        size.width * 0.4165986,
        size.height * 0.7300537);
    path_1.cubicTo(
        size.width * 0.3148097,
        size.height * 0.7300537,
        size.width * 0.2322785,
        size.height * 0.6931409,
        size.width * 0.2322785,
        size.height * 0.5278550);
    path_1.cubicTo(
        size.width * 0.2322785,
        size.height * 0.3625685,
        size.width * 0.3148097,
        size.height * 0.1315430,
        size.width * 0.4165986,
        size.height * 0.1315430);
    path_1.cubicTo(
        size.width * 0.5183907,
        size.height * 0.1315430,
        size.width * 0.6009211,
        size.height * 0.3625685,
        size.width * 0.6009211,
        size.height * 0.5278550);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = const Color(0xffFBD2D7).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.2839573, size.height * 0.5278550);
    path_2.cubicTo(
        size.width * 0.2839573,
        size.height * 0.3701711,
        size.width * 0.3485384,
        size.height * 0.1526362,
        size.width * 0.4305018,
        size.height * 0.1329987);
    path_2.cubicTo(
        size.width * 0.4259176,
        size.height * 0.1320604,
        size.width * 0.4212832,
        size.height * 0.1315430,
        size.width * 0.4165986,
        size.height * 0.1315430);
    path_2.cubicTo(
        size.width * 0.3148097,
        size.height * 0.1315430,
        size.width * 0.2322785,
        size.height * 0.3625685,
        size.width * 0.2322785,
        size.height * 0.5278550);
    path_2.cubicTo(
        size.width * 0.2322785,
        size.height * 0.6931409,
        size.width * 0.3148097,
        size.height * 0.7300537,
        size.width * 0.4165986,
        size.height * 0.7300537);
    path_2.cubicTo(
        size.width * 0.4212688,
        size.height * 0.7300537,
        size.width * 0.4259032,
        size.height * 0.7299933,
        size.width * 0.4305018,
        size.height * 0.7297987);
    path_2.cubicTo(
        size.width * 0.3485556,
        size.height * 0.7263691,
        size.width * 0.2839573,
        size.height * 0.6855369,
        size.width * 0.2839573,
        size.height * 0.5278550);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = const Color(0xffE2BDC2).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.4165986, size.height * 0.1606597);
    path_3.cubicTo(
        size.width * 0.4180968,
        size.height * 0.1606597,
        size.width * 0.4196989,
        size.height * 0.1607248,
        size.width * 0.4216452,
        size.height * 0.1609188);
    path_3.cubicTo(
        size.width * 0.4425090,
        size.height * 0.1626980,
        size.width * 0.4633333,
        size.height * 0.1754450,
        size.width * 0.4835591,
        size.height * 0.1988349);
    path_3.cubicTo(
        size.width * 0.5023513,
        size.height * 0.2205436,
        size.width * 0.5204910,
        size.height * 0.2516658,
        size.width * 0.5360287,
        size.height * 0.2888060);
    path_3.cubicTo(
        size.width * 0.5660538,
        size.height * 0.3605631,
        size.width * 0.5849498,
        size.height * 0.4511805,
        size.width * 0.5853835,
        size.height * 0.5252664);
    path_3.lineTo(size.width * 0.5853835, size.height * 0.5266899);
    path_3.cubicTo(
        size.width * 0.5853835,
        size.height * 0.5270785,
        size.width * 0.5853978,
        size.height * 0.5274664,
        size.width * 0.5853978,
        size.height * 0.5278550);
    path_3.cubicTo(
        size.width * 0.5853978,
        size.height * 0.5935617,
        size.width * 0.5710502,
        size.height * 0.6370430,
        size.width * 0.5402330,
        size.height * 0.6646389);
    path_3.cubicTo(
        size.width * 0.5129785,
        size.height * 0.6890671,
        size.width * 0.4725341,
        size.height * 0.7009396,
        size.width * 0.4165806,
        size.height * 0.7009396);
    path_3.cubicTo(
        size.width * 0.3606308,
        size.height * 0.7009396,
        size.width * 0.3201667,
        size.height * 0.6890671,
        size.width * 0.2929323,
        size.height * 0.6646389);
    path_3.cubicTo(
        size.width * 0.2621143,
        size.height * 0.6370430,
        size.width * 0.2477649,
        size.height * 0.5935617,
        size.width * 0.2477649,
        size.height * 0.5278550);
    path_3.cubicTo(
        size.width * 0.2477649,
        size.height * 0.4519893,
        size.width * 0.2671444,
        size.height * 0.3592685,
        size.width * 0.2983584,
        size.height * 0.2858946);
    path_3.cubicTo(
        size.width * 0.3144821,
        size.height * 0.2480101,
        size.width * 0.3332588,
        size.height * 0.2166933,
        size.width * 0.3526728,
        size.height * 0.1953409);
    path_3.cubicTo(
        size.width * 0.3736201,
        size.height * 0.1723067,
        size.width * 0.3951183,
        size.height * 0.1606597,
        size.width * 0.4165806,
        size.height * 0.1606597);
    path_3.moveTo(size.width * 0.4165806, size.height * 0.1315430);
    path_3.cubicTo(
        size.width * 0.3147921,
        size.height * 0.1315430,
        size.width * 0.2322613,
        size.height * 0.3625685,
        size.width * 0.2322613,
        size.height * 0.5278550);
    path_3.cubicTo(
        size.width * 0.2322613,
        size.height * 0.6931409,
        size.width * 0.3147921,
        size.height * 0.7300537,
        size.width * 0.4165806,
        size.height * 0.7300537);
    path_3.cubicTo(
        size.width * 0.5183728,
        size.height * 0.7300537,
        size.width * 0.6009032,
        size.height * 0.6931409,
        size.width * 0.6009032,
        size.height * 0.5278550);
    path_3.cubicTo(
        size.width * 0.6009032,
        size.height * 0.5268846,
        size.width * 0.6009032,
        size.height * 0.5259141,
        size.width * 0.6008853,
        size.height * 0.5249430);
    path_3.cubicTo(
        size.width * 0.5999570,
        size.height * 0.3630215,
        size.width * 0.5208853,
        size.height * 0.1402456,
        size.width * 0.4223369,
        size.height * 0.1318020);
    path_3.cubicTo(
        size.width * 0.4204229,
        size.height * 0.1316403,
        size.width * 0.4185125,
        size.height * 0.1315430,
        size.width * 0.4165806,
        size.height * 0.1315430);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = const Color(0xff1A1A1A).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(size.width * 0.5301720, size.height * 0.5289550);
    path_4.cubicTo(
        size.width * 0.5289642,
        size.height * 0.5357490,
        size.width * 0.5228674,
        size.height * 0.5311872,
        size.width * 0.5151864,
        size.height * 0.5263671);
    path_4.cubicTo(
        size.width * 0.5075018,
        size.height * 0.5215463,
        size.width * 0.5011792,
        size.height * 0.5182792,
        size.width * 0.5023871,
        size.height * 0.5115174);
    path_4.cubicTo(
        size.width * 0.5035914,
        size.height * 0.5047557,
        size.width * 0.5118781,
        size.height * 0.4970235,
        size.width * 0.5195448,
        size.height * 0.5018121);
    path_4.cubicTo(
        size.width * 0.5272079,
        size.height * 0.5066000,
        size.width * 0.5313620,
        size.height * 0.5221611,
        size.width * 0.5301541,
        size.height * 0.5289228);
    path_4.lineTo(size.width * 0.5301720, size.height * 0.5289550);
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.4276918, size.height * 0.5163376);
    path_5.cubicTo(
        size.width * 0.4293118,
        size.height * 0.5228081,
        size.width * 0.4232330,
        size.height * 0.5274342,
        size.width * 0.4159283,
        size.height * 0.5339369);
    path_5.cubicTo(
        size.width * 0.4086237,
        size.height * 0.5404396,
        size.width * 0.4028530,
        size.height * 0.5462953,
        size.width * 0.4012151,
        size.height * 0.5398577);
    path_5.cubicTo(
        size.width * 0.3995806,
        size.height * 0.5334195,
        size.width * 0.4027312,
        size.height * 0.5170497,
        size.width * 0.4100358,
        size.height * 0.5105470);
    path_5.cubicTo(
        size.width * 0.4173405,
        size.height * 0.5040436,
        size.width * 0.4260573,
        size.height * 0.5098671,
        size.width * 0.4276918,
        size.height * 0.5163376);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.4921864, size.height * 0.5684893);
    path_6.cubicTo(
        size.width * 0.4926523,
        size.height * 0.5771597,
        size.width * 0.4815090,
        size.height * 0.5993208,
        size.width * 0.4672975,
        size.height * 0.6020060);
    path_6.cubicTo(
        size.width * 0.4530860,
        size.height * 0.6046913,
        size.width * 0.4411828,
        size.height * 0.5868651,
        size.width * 0.4407168,
        size.height * 0.5781953);
    path_6.cubicTo(
        size.width * 0.4402509,
        size.height * 0.5695248,
        size.width * 0.4513978,
        size.height * 0.5732450,
        size.width * 0.4656093,
        size.height * 0.5705597);
    path_6.cubicTo(
        size.width * 0.4798208,
        size.height * 0.5678745,
        size.width * 0.4917240,
        size.height * 0.5598188,
        size.width * 0.4921864,
        size.height * 0.5684893);
    path_6.close();

    Paint paint_6_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.007168459;
    paint_6_stroke.color = const Color(0xff1A1A1A).withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_stroke);

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.4302258, size.height * 0.07955369);
    path_7.cubicTo(
        size.width * 0.4237491,
        size.height * 0.07738591,
        size.width * 0.4178566,
        size.height * 0.07625369,
        size.width * 0.4124659,
        size.height * 0.07596242);
    path_7.lineTo(size.width * 0.4091219, size.height * 0.01928181);
    path_7.cubicTo(
        size.width * 0.4086057,
        size.height * 0.01252027,
        size.width * 0.4050072,
        size.height * 0.008217450,
        size.width * 0.4015269,
        size.height * 0.01015859);
    path_7.lineTo(size.width * 0.3917599, size.height * 0.01562604);
    path_7.cubicTo(
        size.width * 0.3882796,
        size.height * 0.01756718,
        size.width * 0.3865233,
        size.height * 0.02487872,
        size.width * 0.3880394,
        size.height * 0.03105799);
    path_7.cubicTo(
        size.width * 0.3880394,
        size.height * 0.03105799,
        size.width * 0.4013369,
        size.height * 0.05114859,
        size.width * 0.4032473,
        size.height * 0.07641544);
    path_7.cubicTo(
        size.width * 0.3450932,
        size.height * 0.08537718,
        size.width * 0.3518975,
        size.height * 0.2100289,
        size.width * 0.2913129,
        size.height * 0.2055966);
    path_7.cubicTo(
        size.width * 0.2913129,
        size.height * 0.2055966,
        size.width * 0.2828032,
        size.height * 0.3066644,
        size.width * 0.3411828,
        size.height * 0.2940799);
    path_7.cubicTo(
        size.width * 0.3462301,
        size.height * 0.3818503,
        size.width * 0.4026452,
        size.height * 0.3499195,
        size.width * 0.4306559,
        size.height * 0.3133289);
    path_7.cubicTo(
        size.width * 0.4586487,
        size.height * 0.2767389,
        size.width * 0.4777168,
        size.height * 0.09553557,
        size.width * 0.4302437,
        size.height * 0.07955369);
    path_7.lineTo(size.width * 0.4302258, size.height * 0.07955369);
    path_7.close();

    Paint paint_7_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02150538;
    paint_7_stroke.color = const Color(0xff1A1A1A).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_stroke);

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = const Color(0xff556B2F).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.4157384, size.height * 0.08026577);
    path_8.cubicTo(
        size.width * 0.3864014,
        size.height * 0.1186027,
        size.width * 0.3774265,
        size.height * 0.1984799,
        size.width * 0.4191147,
        size.height * 0.2749919);
    path_8.cubicTo(
        size.width * 0.4608029,
        size.height * 0.3515047,
        size.width * 0.4936165,
        size.height * 0.3296671,
        size.width * 0.5035054,
        size.height * 0.3034295);
    path_8.cubicTo(
        size.width * 0.5133943,
        size.height * 0.2771919,
        size.width * 0.5707563,
        size.height * 0.2998060,
        size.width * 0.5625735,
        size.height * 0.1655779);
    path_8.cubicTo(
        size.width * 0.4876237,
        size.height * 0.2356523,
        size.width * 0.4450573,
        size.height * 0.04196081,
        size.width * 0.4157204,
        size.height * 0.08029799);
    path_8.lineTo(size.width * 0.4157384, size.height * 0.08026577);
    path_8.close();

    Paint paint_8_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02150538;
    paint_8_stroke.color = const Color(0xff1A1A1A).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_stroke);

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = const Color(0xff778959).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.6615914, size.height * 0.4276933);
    path_9.cubicTo(
        size.width * 0.6558530,
        size.height * 0.4276933,
        size.width * 0.6503943,
        size.height * 0.4294074,
        size.width * 0.6452258,
        size.height * 0.4328369);
    path_9.cubicTo(
        size.width * 0.6400573,
        size.height * 0.4362987,
        size.width * 0.6355806,
        size.height * 0.4413456,
        size.width * 0.6317885,
        size.height * 0.4480101);
    path_9.cubicTo(
        size.width * 0.6280000,
        size.height * 0.4547067,
        size.width * 0.6249498,
        size.height * 0.4629893,
        size.width * 0.6226416,
        size.height * 0.4728886);
    path_9.cubicTo(
        size.width * 0.6203333,
        size.height * 0.4828208,
        size.width * 0.6191792,
        size.height * 0.4944678,
        size.width * 0.6191792,
        size.height * 0.5078289);
    path_9.cubicTo(
        size.width * 0.6191792,
        size.height * 0.5345839,
        size.width * 0.6232294,
        size.height * 0.5546423,
        size.width * 0.6313763,
        size.height * 0.5680362);
    path_9.cubicTo(
        size.width * 0.6395233,
        size.height * 0.5814295,
        size.width * 0.6494444,
        size.height * 0.5881268,
        size.width * 0.6611613,
        size.height * 0.5881591);
    path_9.cubicTo(
        size.width * 0.6680502,
        size.height * 0.5881591,
        size.width * 0.6740287,
        size.height * 0.5866705,
        size.width * 0.6790753,
        size.height * 0.5836617);
    path_9.cubicTo(
        size.width * 0.6841219,
        size.height * 0.5806530,
        size.width * 0.6886022,
        size.height * 0.5774503,
        size.width * 0.6925125,
        size.height * 0.5739886);
    path_9.cubicTo(
        size.width * 0.6970932,
        size.height * 0.5800383,
        size.width * 0.7005376,
        size.height * 0.5866383,
        size.width * 0.7028315,
        size.height * 0.5937557);
    path_9.cubicTo(
        size.width * 0.7051219,
        size.height * 0.6008732,
        size.width * 0.7062581,
        size.height * 0.6094141,
        size.width * 0.7062581,
        size.height * 0.6193141);
    path_9.cubicTo(
        size.width * 0.7062581,
        size.height * 0.6370101,
        size.width * 0.7017634,
        size.height * 0.6506953,
        size.width * 0.6928029,
        size.height * 0.6603685);
    path_9.cubicTo(
        size.width * 0.6838459,
        size.height * 0.6700738,
        size.width * 0.6714265,
        size.height * 0.6748926,
        size.width * 0.6555771,
        size.height * 0.6748591);
    path_9.cubicTo(
        size.width * 0.6411075,
        size.height * 0.6748591,
        size.width * 0.6280179,
        size.height * 0.6708181,
        size.width * 0.6163011,
        size.height * 0.6628275);
    path_9.cubicTo(
        size.width * 0.6045878,
        size.height * 0.6548362,
        size.width * 0.5945448,
        size.height * 0.6435779,
        size.width * 0.5861756,
        size.height * 0.6291168);
    path_9.cubicTo(
        size.width * 0.5778029,
        size.height * 0.6146550,
        size.width * 0.5713262,
        size.height * 0.5972819,
        size.width * 0.5667419,
        size.height * 0.5769973);
    path_9.cubicTo(
        size.width * 0.5621613,
        size.height * 0.5567128,
        size.width * 0.5598710,
        size.height * 0.5342926,
        size.width * 0.5598853,
        size.height * 0.5097054);
    path_9.cubicTo(
        size.width * 0.5598853,
        size.height * 0.4812356,
        size.width * 0.5623835,
        size.height * 0.4563248,
        size.width * 0.5673477,
        size.height * 0.4349725);
    path_9.cubicTo(
        size.width * 0.5722903,
        size.height * 0.4136201,
        size.width * 0.5790251,
        size.height * 0.3960852,
        size.width * 0.5875341,
        size.height * 0.3822711);
    path_9.cubicTo(
        size.width * 0.5960466,
        size.height * 0.3684886,
        size.width * 0.6058638,
        size.height * 0.3581685,
        size.width * 0.6170108,
        size.height * 0.3512779);
    path_9.cubicTo(
        size.width * 0.6281541,
        size.height * 0.3444188,
        size.width * 0.6399211,
        size.height * 0.3409570,
        size.width * 0.6523226,
        size.height * 0.3409899);
    path_9.cubicTo(
        size.width * 0.6688602,
        size.height * 0.3410221,
        size.width * 0.6816057,
        size.height * 0.3466510,
        size.width * 0.6905484,
        size.height * 0.3578772);
    path_9.cubicTo(
        size.width * 0.6995054,
        size.height * 0.3691034,
        size.width * 0.7039677,
        size.height * 0.3835651,
        size.width * 0.7039677,
        size.height * 0.4012617);
    path_9.cubicTo(
        size.width * 0.7039677,
        size.height * 0.4094463,
        size.width * 0.7029176,
        size.height * 0.4171141,
        size.width * 0.7008495,
        size.height * 0.4242315);
    path_9.cubicTo(
        size.width * 0.6987814,
        size.height * 0.4313490,
        size.width * 0.6963692,
        size.height * 0.4374960,
        size.width * 0.6935986,
        size.height * 0.4426718);
    path_9.cubicTo(
        size.width * 0.6896882,
        size.height * 0.4392101,
        size.width * 0.6849821,
        size.height * 0.4358456,
        size.width * 0.6794731,
        size.height * 0.4326107);
    path_9.cubicTo(
        size.width * 0.6739606,
        size.height * 0.4293752,
        size.width * 0.6679821,
        size.height * 0.4277255,
        size.width * 0.6615556,
        size.height * 0.4277255);
    path_9.lineTo(size.width * 0.6615914, size.height * 0.4276933);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = const Color(0xff1A1A1A).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.9008961, size.height * 0.6649946);
    path_10.cubicTo(
        size.width * 0.8986057,
        size.height * 0.6662886,
        size.width * 0.8949713,
        size.height * 0.6675832,
        size.width * 0.8900466,
        size.height * 0.6688450);
    path_10.cubicTo(
        size.width * 0.8851004,
        size.height * 0.6701389,
        size.width * 0.8800036,
        size.height * 0.6707537,
        size.width * 0.8747133,
        size.height * 0.6707537);
    path_10.cubicTo(
        size.width * 0.8696667,
        size.height * 0.6707537,
        size.width * 0.8651183,
        size.height * 0.6700738,
        size.width * 0.8611039,
        size.height * 0.6687799);
    path_10.cubicTo(
        size.width * 0.8570896,
        size.height * 0.6674859,
        size.width * 0.8536989,
        size.height * 0.6648658,
        size.width * 0.8509427,
        size.height * 0.6609832);
    path_10.cubicTo(
        size.width * 0.8481864,
        size.height * 0.6571007,
        size.width * 0.8460681,
        size.height * 0.6518275,
        size.width * 0.8445663,
        size.height * 0.6451309);
    path_10.cubicTo(
        size.width * 0.8430681,
        size.height * 0.6384336,
        size.width * 0.8423441,
        size.height * 0.6296987,
        size.width * 0.8423441,
        size.height * 0.6189255);
    path_10.lineTo(size.width * 0.8424301, size.height * 0.4752826);
    path_10.cubicTo(
        size.width * 0.8424301,
        size.height * 0.4575859,
        size.width * 0.8400896,
        size.height * 0.4451953,
        size.width * 0.8353871,
        size.height * 0.4380779);
    path_10.cubicTo(
        size.width * 0.8306846,
        size.height * 0.4309604,
        size.width * 0.8248781,
        size.height * 0.4273698,
        size.width * 0.8179892,
        size.height * 0.4273698);
    path_10.cubicTo(
        size.width * 0.8133871,
        size.height * 0.4273698,
        size.width * 0.8090287,
        size.height * 0.4284369,
        size.width * 0.8048961,
        size.height * 0.4305725);
    path_10.cubicTo(
        size.width * 0.8007599,
        size.height * 0.4327396,
        size.width * 0.7974194,
        size.height * 0.4352960,
        size.width * 0.7949032,
        size.height * 0.4383047);
    path_10.lineTo(size.width * 0.7947670, size.height * 0.6647685);
    path_10.cubicTo(
        size.width * 0.7924767,
        size.height * 0.6660624,
        size.width * 0.7888423,
        size.height * 0.6673564,
        size.width * 0.7839140,
        size.height * 0.6686181);
    path_10.cubicTo(
        size.width * 0.7789713,
        size.height * 0.6699121,
        size.width * 0.7738710,
        size.height * 0.6705268,
        size.width * 0.7685842,
        size.height * 0.6705268);
    path_10.cubicTo(
        size.width * 0.7635341,
        size.height * 0.6705268,
        size.width * 0.7589892,
        size.height * 0.6698477,
        size.width * 0.7549749,
        size.height * 0.6685537);
    path_10.cubicTo(
        size.width * 0.7509606,
        size.height * 0.6672597,
        size.width * 0.7475663,
        size.height * 0.6646389,
        size.width * 0.7448100,
        size.height * 0.6607570);
    path_10.cubicTo(
        size.width * 0.7420538,
        size.height * 0.6568745,
        size.width * 0.7399355,
        size.height * 0.6516013,
        size.width * 0.7384373,
        size.height * 0.6449040);
    path_10.cubicTo(
        size.width * 0.7369391,
        size.height * 0.6382074,
        size.width * 0.7362151,
        size.height * 0.6294725,
        size.width * 0.7362151,
        size.height * 0.6186993);
    path_10.lineTo(size.width * 0.7364373, size.height * 0.2434161);
    path_10.cubicTo(
        size.width * 0.7389713,
        size.height * 0.2425752,
        size.width * 0.7426918,
        size.height * 0.2413779,
        size.width * 0.7476344,
        size.height * 0.2398899);
    path_10.cubicTo(
        size.width * 0.7525806,
        size.height * 0.2384013,
        size.width * 0.7575735,
        size.height * 0.2376570,
        size.width * 0.7626237,
        size.height * 0.2376570);
    path_10.cubicTo(
        size.width * 0.7676703,
        size.height * 0.2376570,
        size.width * 0.7722186,
        size.height * 0.2383369,
        size.width * 0.7762330,
        size.height * 0.2396309);
    path_10.cubicTo(
        size.width * 0.7802437,
        size.height * 0.2409248,
        size.width * 0.7836380,
        size.height * 0.2435134,
        size.width * 0.7863943,
        size.height * 0.2474275);
    path_10.cubicTo(
        size.width * 0.7891505,
        size.height * 0.2513101,
        size.width * 0.7912688,
        size.height * 0.2566154,
        size.width * 0.7927670,
        size.height * 0.2632799);
    path_10.cubicTo(
        size.width * 0.7942509,
        size.height * 0.2699772,
        size.width * 0.7949892,
        size.height * 0.2787121,
        size.width * 0.7949892,
        size.height * 0.2894852);
    path_10.lineTo(size.width * 0.7949570, size.height * 0.3528953);
    path_10.cubicTo(
        size.width * 0.7979355,
        size.height * 0.3507597,
        size.width * 0.8024839,
        size.height * 0.3482691,
        size.width * 0.8085663,
        size.height * 0.3454866);
    path_10.cubicTo(
        size.width * 0.8146452,
        size.height * 0.3427040,
        size.width * 0.8213656,
        size.height * 0.3413134,
        size.width * 0.8287204,
        size.height * 0.3413134);
    path_10.cubicTo(
        size.width * 0.8514588,
        size.height * 0.3413456,
        size.width * 0.8692007,
        size.height * 0.3520866,
        size.width * 0.8819319,
        size.height * 0.3734389);
    path_10.cubicTo(
        size.width * 0.8946631,
        size.height * 0.3948235,
        size.width * 0.9010179,
        size.height * 0.4266577,
        size.width * 0.9010000,
        size.height * 0.4689094);
    path_10.lineTo(size.width * 0.9008817, size.height * 0.6649624);
    path_10.lineTo(size.width * 0.9008961, size.height * 0.6649946);
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = const Color(0xff1A1A1A).withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.9359176, size.height * 0.2638953);
    path_11.cubicTo(
        size.width * 0.9359176,
        size.height * 0.2474926,
        size.width * 0.9388638,
        size.height * 0.2337107,
        size.width * 0.9447384,
        size.height * 0.2225168);
    path_11.cubicTo(
        size.width * 0.9505950,
        size.height * 0.2113228,
        size.width * 0.9583656,
        size.height * 0.2057262,
        size.width * 0.9680108,
        size.height * 0.2057262);
    path_11.cubicTo(
        size.width * 0.9776559,
        size.height * 0.2057262,
        size.width * 0.9854086,
        size.height * 0.2113879,
        size.width * 0.9912473,
        size.height * 0.2225819);
    path_11.cubicTo(
        size.width * 0.9971075,
        size.height * 0.2338074,
        size.width * 1.000018,
        size.height * 0.2476221,
        size.width,
        size.height * 0.2640242);
    path_11.cubicTo(
        size.width,
        size.height * 0.2804268,
        size.width * 0.9970538,
        size.height * 0.2942087,
        size.width * 0.9911971,
        size.height * 0.3054027);
    path_11.cubicTo(
        size.width * 0.9853405,
        size.height * 0.3166289,
        size.width * 0.9775699,
        size.height * 0.3221933,
        size.width * 0.9679247,
        size.height * 0.3221933);
    path_11.cubicTo(
        size.width * 0.9582796,
        size.height * 0.3221933,
        size.width * 0.9505269,
        size.height * 0.3165638,
        size.width * 0.9446882,
        size.height * 0.3053383);
    path_11.cubicTo(
        size.width * 0.9388280,
        size.height * 0.2941121,
        size.width * 0.9359176,
        size.height * 0.2802973,
        size.width * 0.9359176,
        size.height * 0.2638953);
    path_11.close();
    path_11.moveTo(size.width * 0.9359176, size.height * 0.2638953);
    path_11.cubicTo(
        size.width * 0.9359176,
        size.height * 0.2474926,
        size.width * 0.9388638,
        size.height * 0.2337107,
        size.width * 0.9447384,
        size.height * 0.2225168);
    path_11.cubicTo(
        size.width * 0.9505950,
        size.height * 0.2113228,
        size.width * 0.9583656,
        size.height * 0.2057262,
        size.width * 0.9680108,
        size.height * 0.2057262);
    path_11.cubicTo(
        size.width * 0.9776559,
        size.height * 0.2057262,
        size.width * 0.9854086,
        size.height * 0.2113879,
        size.width * 0.9912473,
        size.height * 0.2225819);
    path_11.cubicTo(
        size.width * 0.9971075,
        size.height * 0.2338074,
        size.width * 1.000018,
        size.height * 0.2476221,
        size.width,
        size.height * 0.2640242);
    path_11.cubicTo(
        size.width,
        size.height * 0.2804268,
        size.width * 0.9970538,
        size.height * 0.2942087,
        size.width * 0.9911971,
        size.height * 0.3054027);
    path_11.cubicTo(
        size.width * 0.9853405,
        size.height * 0.3166289,
        size.width * 0.9775699,
        size.height * 0.3221933,
        size.width * 0.9679247,
        size.height * 0.3221933);
    path_11.cubicTo(
        size.width * 0.9582796,
        size.height * 0.3221933,
        size.width * 0.9505269,
        size.height * 0.3165638,
        size.width * 0.9446882,
        size.height * 0.3053383);
    path_11.cubicTo(
        size.width * 0.9388280,
        size.height * 0.2941121,
        size.width * 0.9359176,
        size.height * 0.2802973,
        size.width * 0.9359176,
        size.height * 0.2638953);
    path_11.close();
    path_11.moveTo(size.width * 0.9970215, size.height * 0.6651893);
    path_11.cubicTo(
        size.width * 0.9944875,
        size.height * 0.6660302,
        size.width * 0.9907491,
        size.height * 0.6672275,
        size.width * 0.9858244,
        size.height * 0.6687154);
    path_11.cubicTo(
        size.width * 0.9808781,
        size.height * 0.6702040,
        size.width * 0.9758817,
        size.height * 0.6709477,
        size.width * 0.9708351,
        size.height * 0.6709477);
    path_11.cubicTo(
        size.width * 0.9657885,
        size.height * 0.6709477,
        size.width * 0.9612401,
        size.height * 0.6702685,
        size.width * 0.9572258,
        size.height * 0.6689745);
    path_11.cubicTo(
        size.width * 0.9532151,
        size.height * 0.6676805,
        size.width * 0.9498208,
        size.height * 0.6650919,
        size.width * 0.9470645,
        size.height * 0.6611772);
    path_11.cubicTo(
        size.width * 0.9443082,
        size.height * 0.6572953,
        size.width * 0.9421900,
        size.height * 0.6520221,
        size.width * 0.9406918,
        size.height * 0.6453248);
    path_11.cubicTo(
        size.width * 0.9391900,
        size.height * 0.6386282,
        size.width * 0.9384695,
        size.height * 0.6298933,
        size.width * 0.9384695,
        size.height * 0.6191201);
    path_11.lineTo(size.width * 0.9386237, size.height * 0.3557745);
    path_11.cubicTo(
        size.width * 0.9411541,
        size.height * 0.3549336,
        size.width * 0.9448746,
        size.height * 0.3537362,
        size.width * 0.9498208,
        size.height * 0.3522483);
    path_11.cubicTo(
        size.width * 0.9547634,
        size.height * 0.3507604,
        size.width * 0.9597599,
        size.height * 0.3500161,
        size.width * 0.9648065,
        size.height * 0.3500161);
    path_11.cubicTo(
        size.width * 0.9698530,
        size.height * 0.3500161,
        size.width * 0.9744014,
        size.height * 0.3506953,
        size.width * 0.9784158,
        size.height * 0.3519893);
    path_11.cubicTo(
        size.width * 0.9824301,
        size.height * 0.3532839,
        size.width * 0.9858244,
        size.height * 0.3558718,
        size.width * 0.9885806,
        size.height * 0.3597866);
    path_11.cubicTo(
        size.width * 0.9913369,
        size.height * 0.3637007,
        size.width * 0.9934552,
        size.height * 0.3689745,
        size.width * 0.9949534,
        size.height * 0.3756389);
    path_11.cubicTo(
        size.width * 0.9964337,
        size.height * 0.3823356,
        size.width * 0.9971756,
        size.height * 0.3910705,
        size.width * 0.9971756,
        size.height * 0.4018436);
    path_11.lineTo(size.width * 0.9970215, size.height * 0.6651893);
    path_11.close();

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = const Color(0xff1A1A1A).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.9359176, size.height * 0.2638953);
    path_12.cubicTo(
        size.width * 0.9359176,
        size.height * 0.2474926,
        size.width * 0.9388638,
        size.height * 0.2337107,
        size.width * 0.9447384,
        size.height * 0.2225168);
    path_12.cubicTo(
        size.width * 0.9505950,
        size.height * 0.2113228,
        size.width * 0.9583656,
        size.height * 0.2057262,
        size.width * 0.9680108,
        size.height * 0.2057262);
    path_12.cubicTo(
        size.width * 0.9776559,
        size.height * 0.2057262,
        size.width * 0.9854086,
        size.height * 0.2113879,
        size.width * 0.9912473,
        size.height * 0.2225819);
    path_12.cubicTo(
        size.width * 0.9971075,
        size.height * 0.2338074,
        size.width * 1.000018,
        size.height * 0.2476221,
        size.width,
        size.height * 0.2640242);
    path_12.cubicTo(
        size.width,
        size.height * 0.2804268,
        size.width * 0.9970538,
        size.height * 0.2942087,
        size.width * 0.9911971,
        size.height * 0.3054027);
    path_12.cubicTo(
        size.width * 0.9853405,
        size.height * 0.3166289,
        size.width * 0.9775699,
        size.height * 0.3221933,
        size.width * 0.9679247,
        size.height * 0.3221933);
    path_12.cubicTo(
        size.width * 0.9582796,
        size.height * 0.3221933,
        size.width * 0.9505269,
        size.height * 0.3165638,
        size.width * 0.9446882,
        size.height * 0.3053383);
    path_12.cubicTo(
        size.width * 0.9388280,
        size.height * 0.2941121,
        size.width * 0.9359176,
        size.height * 0.2802973,
        size.width * 0.9359176,
        size.height * 0.2638953);
    path_12.close();
    path_12.moveTo(size.width * 0.9359176, size.height * 0.2638953);
    path_12.cubicTo(
        size.width * 0.9359176,
        size.height * 0.2474926,
        size.width * 0.9388638,
        size.height * 0.2337107,
        size.width * 0.9447384,
        size.height * 0.2225168);
    path_12.cubicTo(
        size.width * 0.9505950,
        size.height * 0.2113228,
        size.width * 0.9583656,
        size.height * 0.2057262,
        size.width * 0.9680108,
        size.height * 0.2057262);
    path_12.cubicTo(
        size.width * 0.9776559,
        size.height * 0.2057262,
        size.width * 0.9854086,
        size.height * 0.2113879,
        size.width * 0.9912473,
        size.height * 0.2225819);
    path_12.cubicTo(
        size.width * 0.9971075,
        size.height * 0.2338074,
        size.width * 1.000018,
        size.height * 0.2476221,
        size.width,
        size.height * 0.2640242);
    path_12.cubicTo(
        size.width,
        size.height * 0.2804268,
        size.width * 0.9970538,
        size.height * 0.2942087,
        size.width * 0.9911971,
        size.height * 0.3054027);
    path_12.cubicTo(
        size.width * 0.9853405,
        size.height * 0.3166289,
        size.width * 0.9775699,
        size.height * 0.3221933,
        size.width * 0.9679247,
        size.height * 0.3221933);
    path_12.cubicTo(
        size.width * 0.9582796,
        size.height * 0.3221933,
        size.width * 0.9505269,
        size.height * 0.3165638,
        size.width * 0.9446882,
        size.height * 0.3053383);
    path_12.cubicTo(
        size.width * 0.9388280,
        size.height * 0.2941121,
        size.width * 0.9359176,
        size.height * 0.2802973,
        size.width * 0.9359176,
        size.height * 0.2638953);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = const Color(0xff556B2F).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
