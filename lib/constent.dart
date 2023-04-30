import 'package:flutter/material.dart';
import 'package:weather/txt.dart';

const mongoUrl =
    "mongodb+srv://surajpadhi01:test@cluster0.qegmgtk.mongodb.net/test?retryWrites=true&w=majority";
const collectionName = "users";

class fields extends StatelessWidget {
  const fields(
      {super.key, required this.maxformattedTemp, required this.index});

  final String maxformattedTemp;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index == 0) ...[
          Text3(data: 'sunday'),
          const SizedBox(
              // height: MediaQuery.of(context).size.height * 0.008,
              )
        ],
        if (index == 1) ...[
          Text3(data: 'Monday'),
          const SizedBox(
              // height: MediaQuery.of(context).size.height * 0.2,
              )
        ],
        if (index == 2) ...[
          Text3(data: 'Tuesday'),
          const SizedBox(
              // height: MediaQuery.of(context).size.height * 0.2,
              )
        ],
        if (index == 3) ...[
          Text3(data: 'wednesday'),
          const SizedBox(
              // height: MediaQuery.of(context).size.height * 0.2,
              )
        ],
        if (index == 4) ...[
          Text3(data: 'thrusday'),
          const SizedBox(
              // height: MediaQuery.of(context).size.height * 0.2,
              )
        ],
        if (index == 0) ...[
          Text3(data: '2023-04-30'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ],
        if (index == 1) ...[
          Text3(data: '2023-05-01'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ],
        if (index == 2) ...[
          Text3(data: '2023-05-02'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ],
        if (index == 3) ...[
          Text3(data: '2023-05-03'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ],
        if (index == 4) ...[
          Text3(data: '2023-05-04'),
          const SizedBox(
              // height: MediaQuery.of(context).size.height * 0.1,
              )
        ],
        Text3(
          data: '40°C/$maxformattedTemp°C',
        ),
      ],
    );
  }
}
