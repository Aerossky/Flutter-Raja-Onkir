part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Province> provinceData = [];
  bool isLoading = false;

  Future<List<Province>> getProvinces() async {
    dynamic prov;
    await MasterDataService.getProvince().then((value) {
      // set false
      setState(() {
        provinceData = value;
        isLoading = false;
      });
    });
    return prov;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // set true
    setState(() {
      isLoading = true;
    });
    getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
      ),
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: provinceData.isEmpty
              ? const Align(
                  alignment: Alignment.center,
                  child: Text("Data tidak tersedia"),
                )
              : ListView.builder(
                  itemCount: provinceData.length,
                  itemBuilder: (context, index) {
                    return CardProvince(provinceData[index]);
                  },
                ),
        ),
        isLoading == true ? Uiloading.loadingBlock() : Container()
      ]),
    );
  }
}
