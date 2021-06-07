import 'package:flutter/material.dart';
import 'package:pet_tracker_youtube/utils/assets.dart';

class PetCard extends StatelessWidget {
  const PetCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Positioned(
      bottom: 10,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _BuildCard(deviceSize: _deviceSize),
          const _BuildPetPhoto(),
        ],
      ),
    );
  }
}

class _BuildPetPhoto extends StatelessWidget {
  const _BuildPetPhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 25,
      top: -40,
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            Assets.miniDachsundImg,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1.0, 1.0),
            blurRadius: 6.0,
          ),
        ]),
      ),
    );
  }
}

class _BuildCard extends StatelessWidget {
  const _BuildCard({
    Key? key,
    required Size deviceSize,
  })  : _deviceSize = deviceSize,
        super(key: key);

  final Size _deviceSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _deviceSize.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 181,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tarzan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    color: Colors.orange.shade200,
                  ),
                  const Text("-33.87213, 151,209832")
                ],
              ),
              const SizedBox(height: 5),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Icon(
                    Icons.directions_walk,
                    color: Color(0xFF8ACAC0),
                  ),
                  const Text("1.0Km away"),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  PetCardButton(
                    text: 'Directions',
                    onPressed: () {},
                    color: const Color(0xFF8ACAC0),
                  ),
                  const SizedBox(width: 5),
                  PetCardButton(
                    text: "Profile",
                    onPressed: () {},
                    color: Colors.orange.shade200,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/* 
* Custom Buttons For Card
*/
class PetCardButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color color;

  const PetCardButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => color),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
      onPressed: onPressed,
    );
  }
}
