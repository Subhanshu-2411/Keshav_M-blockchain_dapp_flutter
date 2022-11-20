import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Send Ether'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String rpcUrl = "HTTP://127.0.0.1:7545"; // add this url

  String wsUrl = "ws://127.0.0.1:7545/";  // convert the above to web socket

  void sendEther() async {
    Web3Client client = Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });

    String privateKey =
        "2ba80e39175d574b65bfe0bc9b959b1ea2e517732164d175e427d263d2d44e5f"; // add new one

    Credentials credentials =
        await client.credentialsFromPrivateKey(privateKey);

    EthereumAddress ownAddress = await credentials.extractAddress();
    EthereumAddress receiverAddress = EthereumAddress.fromHex("0x4422485E6E2eD908A43679D5DdcB8245EC864210"); // add new one
    client.sendTransaction(
      credentials,
      Transaction(
        from: ownAddress,
        to: receiverAddress,
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
