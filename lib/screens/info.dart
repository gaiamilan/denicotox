
import 'package:flutter/material.dart';

class InstructionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Information"),
              backgroundColor: const Color.fromARGB(140, 76, 175, 79),
),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenuto testuale lungo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  Text('🌿 Why does the tree grow every day without smoke? ',
                      style: TextStyle(
                        fontSize:16,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                     '''

Smoking harms not only your health but also the planet.
Growing and producing tobacco pollutes the air, water, and soil, destroys forests, and contributes to climate change. Every year, the tobacco industry emits about 84 million tons of CO₂ and devastates over 3.5 million hectares of land.
Moreover, the pesticides used in plantations severely damage the health of workers, often children, causing serious illnesses such as cancer and neurological disorders.
Quitting smoking means protecting yourself and helping the environment to breathe.
Every smoke-free day is a step towards a greener world. 🌱

(Source: “Tobacco is a threat to the environment and human health,” WHO, 2022)
'''
,
style: TextStyle(fontSize: 16),),

Text('🌱 How the App works:',
 style: TextStyle(
fontSize:16,
fontWeight: FontWeight.bold, )),

Text(
'''
Track your journey to a smoke-free life and grow a tree while you're at it!

- 1 day without smoking
    🌿 You earn a leaf and watch your tree start to grow in the app.
- 15 days smoke-free
    🎁 You receive a voucher for a consultation at the Denicotox Clinic.
- 40 days smoke-free plus 15,000 steps 🚶‍♂️ in a day
    🌳 You unlock a Treedom voucher to plant a real tree and contribute to global reforestation!

The coolaboration Denicotox and Treedom
A powerful partnership for your health and the planet.

Denicotox: A private clinic dedicated to helping people quit smoking through professional support.
Treedom: A global platform that lets you plant trees and support reforestation projects around the world. 🌴

Together, they help you breathe better and make the world greener. 🌍💚      
            ''',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),


            // Immagine alla fine
            Container(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                'assets/collab.png', // o NetworkImage per URL
              ),
            ),
          ],
        ),
      ),
    );
  }
}























